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

{ #category : 'as yet unclassified' }
Conv2DLayerNeuralNetworkMachineLearningRudesheim >> forward: anInputNumbersSequencialCollection [
	|
		inputRows
		inputColumns
		inputChannels
		outputRows
		outputColumns
		kernelRows
		kernelColumns
		strideRows
		strideColumns
		paddingTopRows
		paddingLeftColumns
		output
		total
		weight
		value
		iy
		ix
		flatOutputIndex
	|

	inputChannels := window inputChannels.
	inputRows := window inputRows.
	inputColumns := window inputColumns.
	outputRows := window outputRows.
	outputColumns := window outputColumns.
	kernelRows := window kernelRows.
	kernelColumns := window kernelColumns.
	strideRows := window strideRows.
	strideColumns := window strideColumns.
	paddingTopRows := window paddingTopRows.
	paddingLeftColumns := window paddingLeftColumns.

	output :=
		Array
			new:	
			outChannels
				* outputRows
				* outputColumns.

	0
		to:	outChannels - 1
		do:
		[ :oc |
			0
				to:	outputRows - 1
				do:
				[ :oy |
					0
						to:	outputColumns - 1
						do:
						[ :ox |
							total := 0.

							0
								to:	inputChannels - 1
								do:
								[ :ic |
									0
										to:	kernelRows - 1
										do:
										[ :ky |
											iy := oy * strideRows + ky - paddingTopRows.

											(
												iy >= 0
													and:
													[
														iy < inputRows.
													]
											)
												ifTrue:
												[
													0
														to:	kernelColumns - 1
														do:
														[ :kx |
															ix := ox * strideColumns + kx - paddingLeftColumns.

															(
																ix >= 0
																	and:
																	[
																		ix < inputColumns.
																	]
															)
																ifTrue:
																[
																	weight :=
																		(
																			(
																				(
																					weights
																						at:	oc + 1
																				)
																					at:	ic + 1
																			)
																				at:	ky + 1
																		)
																			at:	kx + 1.

																	value :=
																		anInputNumbersSequencialCollection
																			at:	
																			ic
																				* inputRows
																				+ iy
																				* inputColumns
																				+ ix
																				+ 1.

																	total := total + (weight * value).
																].
														].
												].
										].
								].

							flatOutputIndex := (oc * outputRows + oy) * outputColumns + ox + 1.

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
	kernelRows := window kernelRows.
	kernelColumns := window kernelColumns.
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
