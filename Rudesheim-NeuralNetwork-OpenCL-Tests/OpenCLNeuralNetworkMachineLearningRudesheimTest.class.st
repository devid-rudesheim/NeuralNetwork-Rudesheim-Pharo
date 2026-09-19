Class {
	#name : 'OpenCLNeuralNetworkMachineLearningRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-NeuralNetwork-OpenCL-Tests',
	#package : 'Rudesheim-NeuralNetwork-OpenCL-Tests'
}

{ #category : 'accessing' }
OpenCLNeuralNetworkMachineLearningRudesheimTest class >> targetClass [
	^ OpenCLNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'running' }
OpenCLNeuralNetworkMachineLearningRudesheimTest >> tearDown [
	self basicTarget class
		startUp:	false.

	super tearDown.
]

{ #category : 'tests' }
OpenCLNeuralNetworkMachineLearningRudesheimTest >> testCommandQueueDelegatesToDriver [
	self
		assert:	self basicTarget class commandQueue
		equals:	self basicTarget class driver commandQueue.
]

{ #category : 'tests' }
OpenCLNeuralNetworkMachineLearningRudesheimTest >> testContextDelegatesToDriver [
	self
		assert:	self basicTarget class context
		equals:	self basicTarget class driver context.
]

{ #category : 'tests' }
OpenCLNeuralNetworkMachineLearningRudesheimTest >> testStartUpResetsDriver [
	|
		firstContext
	|

	firstContext := self basicTarget class context.

	self basicTarget class
		startUp:	false.

	self
		deny:	self basicTarget class context
		equals:	firstContext.
]
