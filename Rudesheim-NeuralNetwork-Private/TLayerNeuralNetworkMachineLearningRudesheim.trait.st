Trait {
	#name : 'TLayerNeuralNetworkMachineLearningRudesheim',
	#traits : 'TModuleNeuralNetworkMachineLearningRudesheim',
	#classTraits : 'TModuleNeuralNetworkMachineLearningRudesheim classTrait',
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'evaluating' }
TLayerNeuralNetworkMachineLearningRudesheim classSide >> backward:		aTBackwardContextNeuralNetworkMachineLearningRudesheim [
	
	^ self subclassResponsibility.
]

{ #category : 'evaluating' }
TLayerNeuralNetworkMachineLearningRudesheim >> backward:		aBackwardContextNeuralNetworkMachineLearningRudesheim [

	^ self class
		backward:		aBackwardContextNeuralNetworkMachineLearningRudesheim
]
