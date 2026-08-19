"
Conv2DLayerNeuralNetworkMachineLearningRudesheim is the Pure (plain Smalltalk, no FFI/GPU) counterpart of Conv2DLayerOpenCLNeuralNetworkMachineLearningRudesheim: a 2D convolution layer with fused bias. It receives/returns flat number sequences like every other Layer -- the window (input channels/rows/columns, kernel, stride, padding) is baked into the instance at construction time. Forward-only (no backward), matching the OpenCL sibling's inference-only scope. Its weights: constructor argument is a flat sequence (out_channels * in_channels * kernel_rows * kernel_columns, row-major), matching the OpenCL sibling and the underlying Soil tensor payload; setWeights:biases:window: reshapes it into the nested out_channels/in_channels/kernel_rows/[kernel_columns] Array that forward:'s per-element indexing needs, once at construction time rather than persisting that nesting in Soil (see note/resnet50-onnx-support-plan.md 2026-08-09追記(4)).
"
Class {
	#name : 'Conv2DLayerNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#traits : 'TShouldntNewRudesheim',
	#classTraits : 'TShouldntNewRudesheim classTrait',
	#instVars : [
		'weights',
		'biases',
		'window',
		'outChannels'
	],
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'as yet unclassified' }
Conv2DLayerNeuralNetworkMachineLearningRudesheim class >> fromSoilGraphNodeRecord: aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim [
	|
		weightsDescriptor
		biasesDescriptor
	|

	weightsDescriptor :=
		aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim tensorDescriptorRecords
			detect:
			[ :each |
				each
					tensorKindClass
					= WeightsTensorSoilNeuralNetworkMachineLearningRudesheim.
			].

	biasesDescriptor :=
		aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim tensorDescriptorRecords
			detect:
			[ :each |
				each
					tensorKindClass
					= BiasesTensorSoilNeuralNetworkMachineLearningRudesheim.
			].

	^ self
		weights:	weightsDescriptor payload
		biases:	biasesDescriptor payload
		window:	
		aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim
			layerAttributesRecords
			first.
]

{ #category : 'as yet unclassified' }
Conv2DLayerNeuralNetworkMachineLearningRudesheim class >> nameForONNX [
	^ 'Conv'.
]

{ #category : 'as yet unclassified' }
Conv2DLayerNeuralNetworkMachineLearningRudesheim class >> species [
	^ Conv2DLayerNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'as yet unclassified' }
Conv2DLayerNeuralNetworkMachineLearningRudesheim class >> weights: aWeightsSequenceableCollection
biases: aBiasesSequenceableCollection
window: aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim [
	^ super new
		setWeights:	aWeightsSequenceableCollection
		biases:	aBiasesSequenceableCollection
		window:	aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim;
		yourself.
]

{ #category : 'evaluating' }
Conv2DLayerNeuralNetworkMachineLearningRudesheim >> forward: anInputNumbersSequencialCollection [
	|
		inputLayout
		outputLayout
		ranges
		validKernelPositionsByOutputPositionFor
		validKernelRowPositionsByOutputRow
		validKernelColumnPositionsByOutputColumn
		output
		weight
		value
	|

	inputLayout := window inputLayout.
	outputLayout := window outputLayout.

	validKernelPositionsByOutputPositionFor :=
		[ :anOutputRange :anExtentSelector :aPaddingSelector |
			|
				kernelSize
				stride
				paddingOffset
				inputBound
			|
			kernelSize := anExtentSelector value: window kernel.
			stride := anExtentSelector value: window stride.
			paddingOffset := aPaddingSelector value: window padding.
			inputBound := anExtentSelector value: window input.

			anOutputRange
				collect:
				[ :anOutputPosition |
					(0 to: kernelSize - 1)
						collect:
						[ :eachKernelOffset |
							Point
								x:	eachKernelOffset
								y:	anOutputPosition * stride + eachKernelOffset - paddingOffset.
						]
						thenSelect:
						[ :eachKernelPosition |
							(eachKernelPosition y >= 0) and: [ eachKernelPosition y < inputBound ].
						].
				].
		].

	ranges :=
		{
			outputLayout extent rows.
			outputLayout extent columns.
			outChannels.
			window inputChannels.
		}
			collect:
			[ :each |
				0
					to:	each - 1.
			].

	validKernelRowPositionsByOutputRow :=
		validKernelPositionsByOutputPositionFor
			value:	(ranges at: 1)
			value:	#rows
			value:	#top.

	validKernelColumnPositionsByOutputColumn :=
		validKernelPositionsByOutputPositionFor
			value:	(ranges at: 2)
			value:	#columns
			value:	#left.

	output := Array new: outChannels * outputLayout channelStride.

	(ranges at: 1)
		with:	validKernelRowPositionsByOutputRow
		do:
		[ :oy :validKernelRowPositions |
			(ranges at: 2)
				with:	validKernelColumnPositionsByOutputColumn
				do:
				[ :ox :validKernelColumnPositions |
					(ranges at: 3) do:
					[ :oc |
						|
							total
							flatOutputIndex
						|

						flatOutputIndex :=
							outputLayout
								flatIndexForChannel:	oc
								position:	(oy @ ox).

						total :=
							(ranges at: 4)
								inject:	0
								into:
								[ :channelTotal :ic |
									channelTotal +
									(
										validKernelRowPositions
											inject:	0
											into:
											[ :rowTotal :eachKernelRowPosition |
												rowTotal +
												(
													validKernelColumnPositions
														inject:	0
														into:
														[ :columnTotal :eachKernelColumnPosition |
															value :=
																anInputNumbersSequencialCollection
																	at:
																	(
																		inputLayout
																			flatIndexForChannel:	ic
																			position:	(eachKernelRowPosition y @ eachKernelColumnPosition y)
																	).

															weight :=
																(
																	(
																		(weights at: oc + 1)
																			at: ic + 1
																	)
																		at: eachKernelRowPosition x + 1
																)
																	at: eachKernelColumnPosition x + 1.

															columnTotal + (weight * value)
														]
												)
											]
									)
								].

						output
							at:	flatOutputIndex
							put:	total + (biases at: oc + 1).
					].
				].
		].

	^ output.
]

{ #category : 'as yet unclassified' }
Conv2DLayerNeuralNetworkMachineLearningRudesheim >> setWeights: aWeightsSequenceableCollection
biases: aBiasesSequenceableCollection
window: aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim [
	|
		inChannels
		kernelRows
		kernelColumns
		position
	|

	window := aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim.
	inChannels := window inputChannels.
	kernelRows := window kernel rows.
	kernelColumns := window kernel columns.
	outChannels := aWeightsSequenceableCollection size / (inChannels * kernelRows * kernelColumns).

	position := 1.
	weights :=
		(1 to: outChannels) collect:
		[ :eachOutChannelIndex |
			(1 to: inChannels) collect:
			[ :eachInChannelIndex |
				(1 to: kernelRows) collect:
				[ :eachKernelRowIndex |
					| row |
					row := aWeightsSequenceableCollection copyFrom: position to: position + kernelColumns - 1.
					position := position + kernelColumns.
					row
				]
			]
		].

	biases := aBiasesSequenceableCollection.
]
