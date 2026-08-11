Trait {
	#name : 'TBackendNeuralNetworkMachineLearningRudesheim',
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'namespace' }
TBackendNeuralNetworkMachineLearningRudesheim classSide >> Criterion [

	^ self subclassResponsibility
]

{ #category : 'namespace' }
TBackendNeuralNetworkMachineLearningRudesheim classSide >> Layer [

	^ self subclassResponsibility
]

{ #category : 'namespace' }
TBackendNeuralNetworkMachineLearningRudesheim classSide >> Model [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
TBackendNeuralNetworkMachineLearningRudesheim classSide >> default [

	^ PureNeuralNetworkMachineLearningRudesheim
]
