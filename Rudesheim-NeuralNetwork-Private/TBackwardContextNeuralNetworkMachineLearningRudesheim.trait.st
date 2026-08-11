Trait {
	#name : 'TBackwardContextNeuralNetworkMachineLearningRudesheim',
	#traits : 'TPredictionsNeuralNetworkMachineLearningRudesheim',
	#classTraits : 'TPredictionsNeuralNetworkMachineLearningRudesheim classTrait',
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'instance creation' }
TBackwardContextNeuralNetworkMachineLearningRudesheim classSide >> gradient:		aGradientSequencialCollection
predictions:	aTPredictionsNeuralNetworkMachineLearningRudesheim [

	^ super new 
		setGradient:	aGradientSequencialCollection
		predictions:	aTPredictionsNeuralNetworkMachineLearningRudesheim

]

{ #category : 'accessing' }
TBackwardContextNeuralNetworkMachineLearningRudesheim >> gradient [

	^ self subclassResponsibility.
]

{ #category : 'initialization' }
TBackwardContextNeuralNetworkMachineLearningRudesheim >> setGradient:	aGradientSequencialCollection
predictions:	aTPredictionsNeuralNetworkMachineLearningRudesheim [

	self subclassResponsibility.
]
