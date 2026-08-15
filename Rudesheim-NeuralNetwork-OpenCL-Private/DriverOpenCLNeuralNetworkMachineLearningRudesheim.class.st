Class {
	#name : 'DriverOpenCLNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#instVars : [
		'devices',
		'context',
		'commandQueue'
	],
	#category : 'Rudesheim-NeuralNetwork-OpenCL-Private',
	#package : 'Rudesheim-NeuralNetwork-OpenCL-Private'
}

{ #category : 'accessing' }
DriverOpenCLNeuralNetworkMachineLearningRudesheim >> commandQueue [
	^ commandQueue
		ifNil:
		[
			commandQueue := self defaultCommandQueue.
		].
]

{ #category : 'accessing' }
DriverOpenCLNeuralNetworkMachineLearningRudesheim >> context [
	^ context
		ifNil:
		[
			context := self defaultContext.
		].
]

{ #category : 'accessing' }
DriverOpenCLNeuralNetworkMachineLearningRudesheim >> defaultCommandQueue [
	^ self context
		newCLCommandQueueFor:	self device.
]

{ #category : 'accessing' }
DriverOpenCLNeuralNetworkMachineLearningRudesheim >> defaultContext [
	^ Rudesheim
		OpenCL
		Context
		clContextFor:	self devices.
]

{ #category : 'accessing' }
DriverOpenCLNeuralNetworkMachineLearningRudesheim >> defaultDevices [
	^ Rudesheim OpenCL Platform clPlatforms first clDevices.
]

{ #category : 'accessing' }
DriverOpenCLNeuralNetworkMachineLearningRudesheim >> device [
	^ self
		devices
		first.
]

{ #category : 'accessing' }
DriverOpenCLNeuralNetworkMachineLearningRudesheim >> devices [
	^ devices
		ifNil:
		[
			devices := self defaultDevices.
		].
]
