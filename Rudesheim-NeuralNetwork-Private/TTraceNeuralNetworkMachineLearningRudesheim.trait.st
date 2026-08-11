Trait {
	#name : 'TTraceNeuralNetworkMachineLearningRudesheim',
	#traits : 'TPredictionsNeuralNetworkMachineLearningRudesheim',
	#classTraits : 'TPredictionsNeuralNetworkMachineLearningRudesheim classTrait',
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'instance creation' }
TTraceNeuralNetworkMachineLearningRudesheim classSide >> neuralNetworkLayer:	aTLayerNeuralNetworkMachineLearningRudesheim
predictions:				aTPredictionsNeuralNetworkMachineLearningRudesheim [

	^ super new
		setNeuralNetworkLayer:	aTLayerNeuralNetworkMachineLearningRudesheim
		predictions:					aTPredictionsNeuralNetworkMachineLearningRudesheim

]

{ #category : 'accessing' }
TTraceNeuralNetworkMachineLearningRudesheim >> neuralNetworkLayer [

	^ self subclassResponsibility.
]

{ #category : 'initialization' }
TTraceNeuralNetworkMachineLearningRudesheim >> setNeuralNetworkLayer:	aTLayerNeuralNetworkMachineLearningRudesheim
predictions:					aTPredictionsNeuralNetworkMachineLearningRudesheim [

	self subclassResponsibility.
]
