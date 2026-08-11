Trait {
	#name : 'TModuleNeuralNetworkMachineLearningRudesheim',
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'evaluating' }
TModuleNeuralNetworkMachineLearningRudesheim classSide >> forward:	anInputNumbersSequencialCollection [
	
	^ self subclassResponsibility.
]

{ #category : 'converting' }
TModuleNeuralNetworkMachineLearningRudesheim classSide >> withUpdatedWeightsRows:	aTLinearTransformLayerNeuralNetworkMachineLearningRudesheim
learningRate:				aRateFloat [
	
	^ self subclassResponsibility.
]

{ #category : 'evaluating' }
TModuleNeuralNetworkMachineLearningRudesheim >> forward:	anInputNumbersSequencialCollection [
	
	^ self class
		forward:	anInputNumbersSequencialCollection
]

{ #category : 'converting' }
TModuleNeuralNetworkMachineLearningRudesheim >> withUpdatedWeightsRows:	aTLinearTransformLayerNeuralNetworkMachineLearningRudesheim
learningRate:				aRateFloat [
	
	^ self class
		withUpdatedWeightsRows:	aTLinearTransformLayerNeuralNetworkMachineLearningRudesheim
		learningRate:				aRateFloat

]
