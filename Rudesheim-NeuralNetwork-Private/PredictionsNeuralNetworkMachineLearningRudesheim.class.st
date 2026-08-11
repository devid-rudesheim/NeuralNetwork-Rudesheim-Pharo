Class {
	#name : 'PredictionsNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#traits : 'TPredictionsNeuralNetworkMachineLearningRudesheim',
	#classTraits : 'TPredictionsNeuralNetworkMachineLearningRudesheim classTrait',
	#instVars : [
		'inputPredictions',
		'outputPredictions'
	],
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'accessing' }
PredictionsNeuralNetworkMachineLearningRudesheim class >> defaultInputPredictions [

	^ #()
]

{ #category : 'accessing' }
PredictionsNeuralNetworkMachineLearningRudesheim class >> defaultOutputPredictions [

	^ #()
]

{ #category : 'accessing' }
PredictionsNeuralNetworkMachineLearningRudesheim >> defaultInputPredictions [

	^ self class defaultInputPredictions.
]

{ #category : 'accessing' }
PredictionsNeuralNetworkMachineLearningRudesheim >> defaultOutputPredictions [

	^ self class defaultOutputPredictions.
]

{ #category : 'accessing' }
PredictionsNeuralNetworkMachineLearningRudesheim >> inputPredictions [

	^ inputPredictions
		ifNil:
		[
			inputPredictions := self defaultInputPredictions.
		].

]

{ #category : 'accessing' }
PredictionsNeuralNetworkMachineLearningRudesheim >> outputPredictions [

	^ outputPredictions
		ifNil:
		[
			outputPredictions := self defaultOutputPredictions.
		].

]

{ #category : 'initialization' }
PredictionsNeuralNetworkMachineLearningRudesheim >> setInputPredictions:	anInputsSequencialCollection
outputPredictions:		anOutputsSequencialCollection [

	inputPredictions	:= anInputsSequencialCollection.
	outputPredictions	:= anOutputsSequencialCollection.
]
