Class {
	#name : 'MSECriterionNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#traits : 'TMSECriterionNeuralNetworkMachineLearningRudesheim',
	#classTraits : 'TMSECriterionNeuralNetworkMachineLearningRudesheim classTrait',
	#instVars : [
		'errorValues'
	],
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'accessing' }
MSECriterionNeuralNetworkMachineLearningRudesheim >> errorValues [

	^ errorValues
]

{ #category : 'accessing' }
MSECriterionNeuralNetworkMachineLearningRudesheim >> gradient [

	^ ( 2.0 / self errorValues size ) * self errorValues
]

{ #category : 'accessing' }
MSECriterionNeuralNetworkMachineLearningRudesheim >> loss [
	|
		squaredErrors
	|

	squaredErrors := 
		self errorValues
			collect:	#squared.

	^ squaredErrors sum / squaredErrors size.
]

{ #category : 'initialization' }
MSECriterionNeuralNetworkMachineLearningRudesheim >> setPredictions:		aPredictionsSequencialCollection
targets:				aTargetSequencialCollection [

	errorValues :=
		aPredictionsSequencialCollection
			with: aTargetSequencialCollection 
			collect:
			[ :prediction :target | 
				prediction - target
			].
]
