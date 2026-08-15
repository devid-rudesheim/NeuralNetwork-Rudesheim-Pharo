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
			commandQueue :=
				self context
					newCLCommandQueueFor:	self device.
		].
]

{ #category : 'accessing' }
DriverOpenCLNeuralNetworkMachineLearningRudesheim >> context [
	^ context
		ifNil:
		[
			context :=
				Rudesheim
					OpenCL
					Context
					clContextFor:	self devices.
		].
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
			devices := Rudesheim OpenCL Platform clPlatforms first clDevices.
		].
]
