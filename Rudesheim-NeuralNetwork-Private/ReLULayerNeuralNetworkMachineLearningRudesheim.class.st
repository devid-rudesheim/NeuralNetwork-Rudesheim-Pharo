Class {
	#name : 'ReLULayerNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#traits : 'TReLULayerNeuralNetworkMachineLearningRudesheim',
	#classTraits : 'TReLULayerNeuralNetworkMachineLearningRudesheim classTrait',
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'instance creation' }
ReLULayerNeuralNetworkMachineLearningRudesheim class >> fromSoilGraphNodeRecord:	aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim [

	^ self
]

{ #category : 'evaluating' }
ReLULayerNeuralNetworkMachineLearningRudesheim class >> backward:		aTBackwardContextNeuralNetworkMachineLearningRudesheim [

	^
	{
		aTBackwardContextNeuralNetworkMachineLearningRudesheim inputPredictions
			with: aTBackwardContextNeuralNetworkMachineLearningRudesheim gradient
			collect:
			[ :input :gradient |
				0 < input
					ifTrue:
					[
						gradient
					]
					ifFalse:
					[
						0
					]
  			].
	}
]

{ #category : 'evaluating' }
ReLULayerNeuralNetworkMachineLearningRudesheim class >> forward:	anInputNumbersSequencialCollection [
	
	^ anInputNumbersSequencialCollection
		collect:
		[ :each |
			each
				max:	0
		]
]
