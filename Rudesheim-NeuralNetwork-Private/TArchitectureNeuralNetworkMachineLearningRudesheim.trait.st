Trait {
	#name : 'TArchitectureNeuralNetworkMachineLearningRudesheim',
	#traits : 'TModelReaderNeuralNetworkMachineLearningRudesheim',
	#classTraits : 'TModelReaderNeuralNetworkMachineLearningRudesheim classTrait',
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'accessing' }
TArchitectureNeuralNetworkMachineLearningRudesheim classSide >> criterion [

	^ self criterion: TBackendNeuralNetworkMachineLearningRudesheim default.
]

{ #category : 'accessing' }
TArchitectureNeuralNetworkMachineLearningRudesheim classSide >> criterion: aTBackendNeuralNetworkMachineLearningRudesheim [

	^ self subclassResponsibility.
]

{ #category : 'accessing' }
TArchitectureNeuralNetworkMachineLearningRudesheim classSide >> layerSpecifications: aTBackendNeuralNetworkMachineLearningRudesheim [

	^ self subclassResponsibility.
]

{ #category : 'reading' }
TArchitectureNeuralNetworkMachineLearningRudesheim classSide >> nextModelAs: aClass [

	^ self
		nextModelAs:	aClass
		backend:		TBackendNeuralNetworkMachineLearningRudesheim default
]

{ #category : 'reading' }
TArchitectureNeuralNetworkMachineLearningRudesheim classSide >> nextModelAs: aClass
backend: aTBackendNeuralNetworkMachineLearningRudesheim [

	^ aClass
		neuralNetworkLayers:	( ( self layerSpecifications: aTBackendNeuralNetworkMachineLearningRudesheim ) collect: #value )
		backend:				aTBackendNeuralNetworkMachineLearningRudesheim
]

{ #category : 'accessing' }
TArchitectureNeuralNetworkMachineLearningRudesheim >> criterion [

	^ self class criterion.
]

{ #category : 'accessing' }
TArchitectureNeuralNetworkMachineLearningRudesheim >> criterion: aTBackendNeuralNetworkMachineLearningRudesheim [

	^ self class criterion: aTBackendNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'accessing' }
TArchitectureNeuralNetworkMachineLearningRudesheim >> layerSpecifications: aTBackendNeuralNetworkMachineLearningRudesheim [

	^ self class layerSpecifications: aTBackendNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'reading' }
TArchitectureNeuralNetworkMachineLearningRudesheim >> nextModelAs: aClass [

	^ self class nextModelAs: aClass
]

{ #category : 'reading' }
TArchitectureNeuralNetworkMachineLearningRudesheim >> nextModelAs: aClass
backend: aTBackendNeuralNetworkMachineLearningRudesheim [

	^ self class
		nextModelAs:	aClass
		backend:		aTBackendNeuralNetworkMachineLearningRudesheim
]
