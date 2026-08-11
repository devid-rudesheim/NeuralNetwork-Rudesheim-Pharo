Class {
	#name : 'TrainerNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#traits : 'TTrainerNeuralNetworkMachineLearningRudesheim',
	#classTraits : 'TTrainerNeuralNetworkMachineLearningRudesheim classTrait',
	#instVars : [
		'criterion',
		'learningRate',
		'epochs'
	],
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'accessing' }
TrainerNeuralNetworkMachineLearningRudesheim class >> defaultCriterion [

	^ Rudesheim MachineLearning NeuralNetwork Criterion MSE
]

{ #category : 'accessing' }
TrainerNeuralNetworkMachineLearningRudesheim class >> defaultEpochs [

	^ 1000
]

{ #category : 'accessing' }
TrainerNeuralNetworkMachineLearningRudesheim class >> defaultLearningRate [

	^ 0.01
]

{ #category : 'accessing' }
TrainerNeuralNetworkMachineLearningRudesheim >> criterion [

	^ criterion
		ifNil:
		[
			criterion := self defaultCriterion.
		].

]

{ #category : 'accessing' }
TrainerNeuralNetworkMachineLearningRudesheim >> defaultCriterion [

	^ self class defaultCriterion.
]

{ #category : 'accessing' }
TrainerNeuralNetworkMachineLearningRudesheim >> defaultEpochs [

	^ self class defaultEpochs.
]

{ #category : 'accessing' }
TrainerNeuralNetworkMachineLearningRudesheim >> defaultLearningRate [

	^ self class defaultLearningRate.
]

{ #category : 'accessing' }
TrainerNeuralNetworkMachineLearningRudesheim >> epochs [

	^ epochs
		ifNil:
		[
			epochs := self defaultEpochs.
		].

]

{ #category : 'accessing' }
TrainerNeuralNetworkMachineLearningRudesheim >> epochs: anEpochCountInteger [

	epochs := anEpochCountInteger
]

{ #category : 'accessing' }
TrainerNeuralNetworkMachineLearningRudesheim >> learningRate [

	^ learningRate
		ifNil:
		[
			learningRate := self defaultLearningRate.
		].

]

{ #category : 'accessing' }
TrainerNeuralNetworkMachineLearningRudesheim >> learningRate: aRateFloat [

	learningRate := aRateFloat
]

{ #category : 'initialization' }
TrainerNeuralNetworkMachineLearningRudesheim >> setCriterion: aTCriterionNeuralNetworkMachineLearningRudesheim [

	criterion := aTCriterionNeuralNetworkMachineLearningRudesheim
]
