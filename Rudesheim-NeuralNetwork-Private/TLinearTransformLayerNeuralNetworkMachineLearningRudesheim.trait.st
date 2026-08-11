Trait {
	#name : 'TLinearTransformLayerNeuralNetworkMachineLearningRudesheim',
	#traits : 'TLayerNeuralNetworkMachineLearningRudesheim',
	#classTraits : 'TLayerNeuralNetworkMachineLearningRudesheim classTrait',
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'accessing' }
TLinearTransformLayerNeuralNetworkMachineLearningRudesheim classSide >> species [

	^ self subclassResponsibility.
]

{ #category : 'instance creation' }
TLinearTransformLayerNeuralNetworkMachineLearningRudesheim classSide >> weightsRows:	aWeightRowsSequencialCollection
biases:		aBiasesSequencialCollection [

	^ super new
		setWeightsRows:	aWeightRowsSequencialCollection
		biases:			aBiasesSequencialCollection.
]

{ #category : 'instance creation' }
TLinearTransformLayerNeuralNetworkMachineLearningRudesheim classSide >> weightsSource: aTWeightsSourceNeuralNetworkMachineLearningRudesheim [

	^ self
		weightsRows:	aTWeightsSourceNeuralNetworkMachineLearningRudesheim weightsRows
		biases:			aTWeightsSourceNeuralNetworkMachineLearningRudesheim biases
]

{ #category : 'accessing' }
TLinearTransformLayerNeuralNetworkMachineLearningRudesheim >> biases [

	^ self subclassResponsibility.
]

{ #category : 'initialization' }
TLinearTransformLayerNeuralNetworkMachineLearningRudesheim >> setWeightsRows:	aWeightRowsSequencialCollection
biases:			aBiasesSequencialCollection [

	self subclassResponsibility.
]

{ #category : 'accessing' }
TLinearTransformLayerNeuralNetworkMachineLearningRudesheim >> species [

	^ self class species.
]

{ #category : 'accessing' }
TLinearTransformLayerNeuralNetworkMachineLearningRudesheim >> weightsRows [

	^ self subclassResponsibility.
]
