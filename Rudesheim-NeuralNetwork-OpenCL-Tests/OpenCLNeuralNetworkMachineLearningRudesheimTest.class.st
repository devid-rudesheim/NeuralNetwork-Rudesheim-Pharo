Class {
	#name : 'OpenCLNeuralNetworkMachineLearningRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-NeuralNetwork-OpenCL-Tests',
	#package : 'Rudesheim-NeuralNetwork-OpenCL-Tests'
}

{ #category : 'accessing' }
OpenCLNeuralNetworkMachineLearningRudesheimTest class >> targetClass [
	^ Rudesheim MachineLearning NeuralNetwork OpenCL.
]

{ #category : 'running' }
OpenCLNeuralNetworkMachineLearningRudesheimTest >> tearDown [
	self targetClass
		startUp:	false.

	super tearDown.
]

{ #category : 'tests' }
OpenCLNeuralNetworkMachineLearningRudesheimTest >> testCommandQueueDelegatesToDriver [
	self
		assert:	self targetClass commandQueue
		equals:	self targetClass driver commandQueue.
]

{ #category : 'tests' }
OpenCLNeuralNetworkMachineLearningRudesheimTest >> testContextDelegatesToDriver [
	self
		assert:	self targetClass context
		equals:	self targetClass driver context.
]

{ #category : 'tests' }
OpenCLNeuralNetworkMachineLearningRudesheimTest >> testStartUpResetsDriver [
	|
		firstContext
	|

	firstContext := self targetClass context.

	self targetClass
		startUp:	false.

	self
		deny:	self targetClass context
		equals:	firstContext.
]
