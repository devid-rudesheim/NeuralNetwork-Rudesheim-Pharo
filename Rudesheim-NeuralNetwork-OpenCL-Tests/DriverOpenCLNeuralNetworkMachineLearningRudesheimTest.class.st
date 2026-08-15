Class {
	#name : 'DriverOpenCLNeuralNetworkMachineLearningRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-NeuralNetwork-OpenCL-Tests',
	#package : 'Rudesheim-NeuralNetwork-OpenCL-Tests'
}

{ #category : 'accessing' }
DriverOpenCLNeuralNetworkMachineLearningRudesheimTest class >> targetClass [

	^ DriverOpenCLNeuralNetworkMachineLearningRudesheim
]

{ #category : 'tests' }
DriverOpenCLNeuralNetworkMachineLearningRudesheimTest >> testCommandQueueIsMemoized [

	self
		assert:	self basicTarget commandQueue
		equals:	self basicTarget commandQueue.
]

{ #category : 'tests' }
DriverOpenCLNeuralNetworkMachineLearningRudesheimTest >> testContextIsMemoized [

	self
		assert:	self basicTarget context
		equals:	self basicTarget context.
]

{ #category : 'tests' }
DriverOpenCLNeuralNetworkMachineLearningRudesheimTest >> testDeviceIsFirstOfDevices [

	self
		assert:	self basicTarget device
		equals:	self basicTarget devices first.
]

{ #category : 'tests' }
DriverOpenCLNeuralNetworkMachineLearningRudesheimTest >> testDevicesIsMemoized [

	self
		deny:	self basicTarget devices isEmpty.

	self
		assert:	( self basicTarget devices == self basicTarget devices ).
]
