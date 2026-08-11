Class {
	#name : 'TraceNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#traits : 'TTraceNeuralNetworkMachineLearningRudesheim',
	#classTraits : 'TTraceNeuralNetworkMachineLearningRudesheim classTrait',
	#instVars : [
		'neuralNetworkLayer',
		'predictions',
		'inputPredictions',
		'outputPredictions'
	],
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'accessing' }
TraceNeuralNetworkMachineLearningRudesheim class >> defaultNeuralNetworkLayer [

	^ 0
]

{ #category : 'accessing' }
TraceNeuralNetworkMachineLearningRudesheim >> defaultNeuralNetworkLayer [

	^ self class defaultNeuralNetworkLayer.
]

{ #category : 'accessing' }
TraceNeuralNetworkMachineLearningRudesheim >> inputPredictions [

	^ predictions inputPredictions
]

{ #category : 'accessing' }
TraceNeuralNetworkMachineLearningRudesheim >> neuralNetworkLayer [

	^ neuralNetworkLayer
		ifNil:
		[
			neuralNetworkLayer := self defaultNeuralNetworkLayer.
		].

]

{ #category : 'accessing' }
TraceNeuralNetworkMachineLearningRudesheim >> outputPredictions [

	^ predictions outputPredictions
]

{ #category : 'initialization' }
TraceNeuralNetworkMachineLearningRudesheim >> setNeuralNetworkLayer:	aTLayerNeuralNetworkMachineLearningRudesheim
predictions:					aTPredictionsNeuralNetworkMachineLearningRudesheim [

	neuralNetworkLayer	:=	aTLayerNeuralNetworkMachineLearningRudesheim.
	predictions			:= aTPredictionsNeuralNetworkMachineLearningRudesheim.
]
