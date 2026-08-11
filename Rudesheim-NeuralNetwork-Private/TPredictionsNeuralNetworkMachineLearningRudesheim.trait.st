Trait {
	#name : 'TPredictionsNeuralNetworkMachineLearningRudesheim',
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'instance creation' }
TPredictionsNeuralNetworkMachineLearningRudesheim classSide >> inputPredictions:	anInputsSequencialCollection
outputPredictions:	anOutputsSequencialCollection [

	^ super new 
		setInputPredictions:	anInputsSequencialCollection
		outputPredictions:		anOutputsSequencialCollection
]

{ #category : 'accessing' }
TPredictionsNeuralNetworkMachineLearningRudesheim >> backwardContextWithGradient:	aGradientSequencialCollection [

	^ Rudesheim MachineLearning NeuralNetwork BackwardContext
		gradient: 		aGradientSequencialCollection
		predictions:		self
]

{ #category : 'accessing' }
TPredictionsNeuralNetworkMachineLearningRudesheim >> inputPredictions [

	^ self subclassResponsibility.
]

{ #category : 'accessing' }
TPredictionsNeuralNetworkMachineLearningRudesheim >> outputPredictions [

	^ self subclassResponsibility.
]

{ #category : 'initialization' }
TPredictionsNeuralNetworkMachineLearningRudesheim >> setInputPredictions:	anInputsSequencialCollection
outputPredictions:		anOutputsSequencialCollection [

	self subclassResponsibility.
]

{ #category : 'accessing' }
TPredictionsNeuralNetworkMachineLearningRudesheim >> traceNeuralNetworkLayer:		aTTraceNeuralNetworkMachineLearningRudesheim [

	^ Rudesheim MachineLearning NeuralNetwork Trace
		neuralNetworkLayer:	aTTraceNeuralNetworkMachineLearningRudesheim
		predictions:				self.
]
