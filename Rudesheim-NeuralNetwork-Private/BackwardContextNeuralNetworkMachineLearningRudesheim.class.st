Class {
	#name : 'BackwardContextNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#traits : 'TBackwardContextNeuralNetworkMachineLearningRudesheim',
	#classTraits : 'TBackwardContextNeuralNetworkMachineLearningRudesheim classTrait',
	#instVars : [
		'gradient',
		'predictions',
		'inputPredictions',
		'outputPredictions'
	],
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'accessing' }
BackwardContextNeuralNetworkMachineLearningRudesheim class >> defaultGradient [

	^ #()
]

{ #category : 'accessing' }
BackwardContextNeuralNetworkMachineLearningRudesheim >> defaultGradient [

	^ self class defaultGradient.
]

{ #category : 'accessing' }
BackwardContextNeuralNetworkMachineLearningRudesheim >> gradient [

	^ gradient
		ifNil:
		[
			gradient := self defaultGradient.
		].

]

{ #category : 'accessing' }
BackwardContextNeuralNetworkMachineLearningRudesheim >> inputPredictions [

	^ predictions inputPredictions
]

{ #category : 'accessing' }
BackwardContextNeuralNetworkMachineLearningRudesheim >> outputPredictions [

	^ predictions outputPredictions

]

{ #category : 'initialization' }
BackwardContextNeuralNetworkMachineLearningRudesheim >> setGradient:	aGradientSequencialCollection
predictions:	aTPredictionsNeuralNetworkMachineLearningRudesheim [

	gradient		:= aGradientSequencialCollection.
	predictions	:= aTPredictionsNeuralNetworkMachineLearningRudesheim.

]
