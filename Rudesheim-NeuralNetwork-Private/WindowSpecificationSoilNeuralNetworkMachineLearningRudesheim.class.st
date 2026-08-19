"
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim describes the spatial-window parameters (input shape, kernel, stride, padding) a Soil-stored graph node needs to reconstruct a Conv2D/MaxPool2D layer, since GraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim's tensorDescriptorRecords only carry learned weight/bias tensors, not structural parameters.
"
Class {
	#name : 'WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#traits : 'TShouldntNewRudesheim',
	#classTraits : 'TShouldntNewRudesheim classTrait',
	#instVars : [
		'inputChannels',
		'input',
		'kernel',
		'stride',
		'padding',
		'inputLayout',
		'outputLayout'
	],
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'instance creation' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim class >> inputChannels:	anInputChannelsInteger
inputExtent:	anInputExtentUtilityRudesheim
kernelExtent:	aKernelExtentUtilityRudesheim
strideExtent:	aStrideExtentUtilityRudesheim
padding:	aPaddingMargin [

	^ super new
		setInputChannels:	anInputChannelsInteger
		inputExtent:		anInputExtentUtilityRudesheim
		kernelExtent:		aKernelExtentUtilityRudesheim
		strideExtent:		aStrideExtentUtilityRudesheim
		padding:			aPaddingMargin;
		yourself
]

{ #category : 'accessing' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim >> inputChannels [

	^ inputChannels
]

{ #category : 'accessing' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim >> input [

	^ input
]

{ #category : 'accessing' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim >> inputLayout [

	^ inputLayout ifNil: [ inputLayout := self defaultInputLayout ]
]

{ #category : 'accessing' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim >> kernel [

	^ kernel
]

{ #category : 'accessing' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim >> stride [

	^ stride
]

{ #category : 'accessing' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim >> padding [

	^ padding
]

{ #category : 'accessing' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim >> padded [

	^ Rudesheim Utility Extent
		width:	self input columns + self padding left + self padding right
		height:	self input rows + self padding top + self padding bottom
]

{ #category : 'accessing' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim >> output [

	^ Rudesheim Utility Extent
		width:	( self padded columns - self kernel columns ) // self stride columns + 1
		height:	( self padded rows - self kernel rows ) // self stride rows + 1
]

{ #category : 'accessing' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim >> outputLayout [

	^ outputLayout ifNil: [ outputLayout := self defaultOutputLayout ]
]

{ #category : 'private' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim >> defaultInputLayout [

	^ Rudesheim MachineLearning NeuralNetwork TensorLayout forInput: self input
]

{ #category : 'private' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim >> defaultOutputLayout [

	^ Rudesheim MachineLearning NeuralNetwork TensorLayout forOutput: self output
]

{ #category : 'initialization' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim >> setInputChannels:	anInputChannelsInteger
inputExtent:	anInputExtentUtilityRudesheim
kernelExtent:	aKernelExtentUtilityRudesheim
strideExtent:	aStrideExtentUtilityRudesheim
padding:	aPaddingMargin [

	inputChannels	:= anInputChannelsInteger.
	input			:= anInputExtentUtilityRudesheim.
	kernel			:= aKernelExtentUtilityRudesheim.
	stride			:= aStrideExtentUtilityRudesheim.
	padding			:= aPaddingMargin
]
