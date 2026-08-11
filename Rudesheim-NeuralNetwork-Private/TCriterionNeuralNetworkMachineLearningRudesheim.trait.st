Trait {
	#name : 'TCriterionNeuralNetworkMachineLearningRudesheim',
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'instance creation' }
TCriterionNeuralNetworkMachineLearningRudesheim classSide >> predictions:		aPredictionsSequencialCollection
targets:			aTargetSequencialCollection [

	^ super new
		setPredictions:		aPredictionsSequencialCollection
		targets:				aTargetSequencialCollection
]

{ #category : 'accessing' }
TCriterionNeuralNetworkMachineLearningRudesheim >> gradient [

	^ self subclassResponsibility.
]

{ #category : 'accessing' }
TCriterionNeuralNetworkMachineLearningRudesheim >> loss [

	^ self subclassResponsibility.
]

{ #category : 'initialization' }
TCriterionNeuralNetworkMachineLearningRudesheim >> setPredictions:		aPredictionsSequencialCollection
targets:				aTargetSequencialCollection [

	^ self subclassResponsibility.
]
