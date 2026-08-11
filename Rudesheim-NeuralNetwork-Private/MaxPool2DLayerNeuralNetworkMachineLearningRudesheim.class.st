"
MaxPool2DLayerNeuralNetworkMachineLearningRudesheim is the Pure (plain Smalltalk, no FFI/GPU) counterpart of MaxPool2DLayerOpenCLNeuralNetworkMachineLearningRudesheim: a 2D max-pooling layer. It receives/returns flat number sequences -- the window is baked in at construction time. It has no learned parameters and does not support backward (forward-only, inference scope).
"
Class {
	#name : 'MaxPool2DLayerNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#instVars : [
		'window'
	],
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'as yet unclassified' }
MaxPool2DLayerNeuralNetworkMachineLearningRudesheim class >> fromSoilGraphNodeRecord: aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim [
	^ self
		window:	
		aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim
			layerAttributesRecords
			first.
]

{ #category : 'as yet unclassified' }
MaxPool2DLayerNeuralNetworkMachineLearningRudesheim class >> nameForONNX [
	^ 'MaxPool'.
]

{ #category : 'as yet unclassified' }
MaxPool2DLayerNeuralNetworkMachineLearningRudesheim class >> species [
	^ MaxPool2DLayerNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'as yet unclassified' }
MaxPool2DLayerNeuralNetworkMachineLearningRudesheim class >> window: aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim [
	^ super new
		setWindow:	aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim;
		yourself.
]

{ #category : 'as yet unclassified' }
MaxPool2DLayerNeuralNetworkMachineLearningRudesheim >> forward: anInputNumbersSequencialCollection [
	|
		inputChannels
		inputRows
		inputColumns
		outputRows
		outputColumns
		kernelRows
		kernelColumns
		strideRows
		strideColumns
		paddingTopRows
		paddingLeftColumns
		output
		best
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
			inputChannels
				* outputRows
				* outputColumns.

	0
		to:	inputChannels - 1
		do:
		[ :c |
			0
				to:	outputRows - 1
				do:
				[ :oy |
					0
						to:	outputColumns - 1
						do:
						[ :ox |
							best := nil.

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
															value :=
																anInputNumbersSequencialCollection
																	at:	
																	c
																		* inputRows
																		+ iy
																		* inputColumns
																		+ ix
																		+ 1.

															(
																best isNil
																	or:
																	[
																		value > best.
																	]
															)
																ifTrue:
																[
																	best := value.
																].
														].
												].
										].
								].

							flatOutputIndex := (c * outputRows + oy) * outputColumns + ox + 1.

							output
								at:	flatOutputIndex
								put:	best.
						].
				].
		].

	^ output.
]

{ #category : 'as yet unclassified' }
MaxPool2DLayerNeuralNetworkMachineLearningRudesheim >> setWindow: aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim [
	window := aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim.
]
