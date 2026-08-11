"
AddLayerNeuralNetworkMachineLearningRudesheim is the Pure (plain Smalltalk, no FFI/GPU) counterpart of AddLayerOpenCLNeuralNetworkMachineLearningRudesheim: an element-wise addition layer used for residual/skip connections. It is stateless, so fromSoilGraphNodeRecord:/forward: are class-side and the class itself is used as the Node's layer object. TNodeNeuralNetworkMachineLearningRudesheim>>valueFromPredecessorValues:givenInput: concatenates a 2-predecessor node's two branch outputs into one flat array before calling forward: -- forward: only needs to split that concatenated array in half and add the halves element-wise.
"
Class {
	#name : 'AddLayerNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'as yet unclassified' }
AddLayerNeuralNetworkMachineLearningRudesheim class >> forward: anInputNumbersSequencialCollection [
	|
		half
		output
	|

	half := anInputNumbersSequencialCollection size // 2.

	output :=
		Array
			new:	half.

	1
		to:	half
		do:
		[ :i |
			output
				at:	i
				put:	
				(
					anInputNumbersSequencialCollection
						at:	i
				)
					+ (anInputNumbersSequencialCollection at: half + i).
		].

	^ output.
]

{ #category : 'as yet unclassified' }
AddLayerNeuralNetworkMachineLearningRudesheim class >> fromSoilGraphNodeRecord: aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim [
	^ self.
]

{ #category : 'as yet unclassified' }
AddLayerNeuralNetworkMachineLearningRudesheim class >> nameForONNX [
	^ 'Add'.
]
