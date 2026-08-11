Class {
	#name : 'WindowSpecificationSoilNeuralNetworkMachineLearningRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-NeuralNetwork-Tests-IO',
	#package : 'Rudesheim-NeuralNetwork-Private-Tests',
	#tag : 'IO'
}

{ #category : 'accessing' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheimTest class >> targetClass [

	^ WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim
]

{ #category : 'tests' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheimTest >> testAccessorsRoundTrip [

	|
		window
	|

	window :=
		self targetClass
			inputChannels:	3
			inputRows:	28
			inputColumns:	28
			kernelRows:	5
			kernelColumns:	5
			strideRows:	1
			strideColumns:	1
			paddingTopRows:	2
			paddingBottomRows:	2
			paddingLeftColumns:	2
			paddingRightColumns:	2.

	self assert: window inputChannels equals: 3.
	self assert: window inputRows equals: 28.
	self assert: window inputColumns equals: 28.
	self assert: window kernelRows equals: 5.
	self assert: window kernelColumns equals: 5.
	self assert: window strideRows equals: 1.
	self assert: window strideColumns equals: 1.
	self assert: window paddingTopRows equals: 2.
	self assert: window paddingBottomRows equals: 2.
	self assert: window paddingLeftColumns equals: 2.
	self assert: window paddingRightColumns equals: 2
]

{ #category : 'tests' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheimTest >> testOutputSizeWithNoPaddingShrinksByKernelStride [

	|
		window
	|

	window :=
		self targetClass
			inputChannels:	16
			inputRows:	14
			inputColumns:	14
			kernelRows:	3
			kernelColumns:	3
			strideRows:	3
			strideColumns:	3
			paddingTopRows:	0
			paddingBottomRows:	0
			paddingLeftColumns:	0
			paddingRightColumns:	0.

	self assert: window outputRows equals: 4.
	self assert: window outputColumns equals: 4
]

{ #category : 'tests' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheimTest >> testOutputSizeWithSamePaddingMatchesInputSize [

	|
		window
	|

	window :=
		self targetClass
			inputChannels:	1
			inputRows:	28
			inputColumns:	28
			kernelRows:	5
			kernelColumns:	5
			strideRows:	1
			strideColumns:	1
			paddingTopRows:	2
			paddingBottomRows:	2
			paddingLeftColumns:	2
			paddingRightColumns:	2.

	self assert: window outputRows equals: 28.
	self assert: window outputColumns equals: 28
]
