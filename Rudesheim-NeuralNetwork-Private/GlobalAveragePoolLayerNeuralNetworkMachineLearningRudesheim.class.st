"
GlobalAveragePoolLayerNeuralNetworkMachineLearningRudesheim is the Pure (plain Smalltalk, no FFI/GPU) counterpart of GlobalAveragePoolLayerOpenCLNeuralNetworkMachineLearningRudesheim: it averages every element of a channel's whole (rows x columns) extent down to a single value per channel. It reuses WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim (kernel = stride = the full input rows/columns, no padding) the same way MaxPool2DLayerNeuralNetworkMachineLearningRudesheim does, but averages instead of taking the max -- kept as its own class rather than a mode flag on MaxPool2D per note/oop-guideline.md (no switch/if branching by kind). It has no learned parameters and does not support backward (forward-only, inference scope).
"
Class {
	#name : 'GlobalAveragePoolLayerNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#instVars : [
		'window'
	],
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'as yet unclassified' }
GlobalAveragePoolLayerNeuralNetworkMachineLearningRudesheim class >> fromSoilGraphNodeRecord: aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim [
	^ self
		window:	
		aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim
			layerAttributesRecords
			first.
]

{ #category : 'as yet unclassified' }
GlobalAveragePoolLayerNeuralNetworkMachineLearningRudesheim class >> nameForONNX [
	^ 'GlobalAveragePool'.
]

{ #category : 'as yet unclassified' }
GlobalAveragePoolLayerNeuralNetworkMachineLearningRudesheim class >> species [
	^ GlobalAveragePoolLayerNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'as yet unclassified' }
GlobalAveragePoolLayerNeuralNetworkMachineLearningRudesheim class >> window: aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim [
	^ super new
		setWindow:	aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim;
		yourself.
]

{ #category : 'as yet unclassified' }
GlobalAveragePoolLayerNeuralNetworkMachineLearningRudesheim >> forward: anInputNumbersSequencialCollection [
	|
		channels
		count
		output
		total
	|

	channels := window inputChannels.
	count := window inputRows * window inputColumns.

	output :=
		Array
			new:	channels.

	1
		to:	channels
		do:
		[ :c |
			total := 0.

			1
				to:	count
				do:
				[ :p |
					total := total + (anInputNumbersSequencialCollection at: (c - 1) * count + p).
				].

			output
				at:	c
				put:	total / count.
		].

	^ output.
]

{ #category : 'as yet unclassified' }
GlobalAveragePoolLayerNeuralNetworkMachineLearningRudesheim >> setWindow: aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim [
	window := aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim.
]
