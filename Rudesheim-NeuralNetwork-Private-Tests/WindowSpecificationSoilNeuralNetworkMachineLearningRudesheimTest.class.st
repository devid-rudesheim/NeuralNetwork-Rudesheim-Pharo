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

{ #category : 'accessing' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheimTest >> defaultBasicTarget [

	|
		extentClass
	|

	extentClass := Rudesheim Utility Extent.

	^ self targetClass
		inputChannels:	1
		inputExtent:	(extentClass width: 1 height: 1)
		kernelExtent:	(extentClass width: 1 height: 1)
		strideExtent:	(extentClass width: 1 height: 1)
		padding:	(Margin top: 0 left: 0 bottom: 0 right: 0).
]

{ #category : 'tests' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheimTest >> testAccessorsRoundTrip [

	|
		extentClass
		window
	|

	extentClass := Rudesheim Utility Extent.

	window :=
		self targetClass
			inputChannels:	3
			inputExtent:	(extentClass width: 28 height: 28)
			kernelExtent:	(extentClass width: 5 height: 5)
			strideExtent:	(extentClass width: 1 height: 1)
			padding:	(Margin top: 2 left: 2 bottom: 2 right: 2).

	self
		assert:	window inputChannels
		equals:	3.

	self
		assert:	window input rows
		equals:	28.

	self
		assert:	window input columns
		equals:	28.

	self
		assert:	window kernel rows
		equals:	5.

	self
		assert:	window kernel columns
		equals:	5.

	self
		assert:	window stride rows
		equals:	1.

	self
		assert:	window stride columns
		equals:	1.

	self
		assert:	window padding top
		equals:	2.

	self
		assert:	window padding bottom
		equals:	2.

	self
		assert:	window padding left
		equals:	2.

	self
		assert:	window padding right
		equals:	2
]

{ #category : 'tests' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheimTest >> testOutputSizeWithNoPaddingShrinksByKernelStride [

	|
		extentClass
		window
	|

	extentClass := Rudesheim Utility Extent.

	window :=
		self targetClass
			inputChannels:	16
			inputExtent:	(extentClass width: 14 height: 14)
			kernelExtent:	(extentClass width: 3 height: 3)
			strideExtent:	(extentClass width: 3 height: 3)
			padding:	(Margin top: 0 left: 0 bottom: 0 right: 0).

	self
		assert:	window output rows
		equals:	4.

	self
		assert:	window output columns
		equals:	4
]

{ #category : 'tests' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheimTest >> testOutputSizeWithSamePaddingMatchesInputSize [

	|
		extentClass
		window
	|

	extentClass := Rudesheim Utility Extent.

	window :=
		self targetClass
			inputChannels:	1
			inputExtent:	(extentClass width: 28 height: 28)
			kernelExtent:	(extentClass width: 5 height: 5)
			strideExtent:	(extentClass width: 1 height: 1)
			padding:	(Margin top: 2 left: 2 bottom: 2 right: 2).

	self
		assert:	window output rows
		equals:	28.

	self
		assert:	window output columns
		equals:	28
]
