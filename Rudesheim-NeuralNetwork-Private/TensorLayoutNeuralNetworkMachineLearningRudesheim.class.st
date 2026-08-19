"
TensorLayoutNeuralNetworkMachineLearningRudesheim describes how a flat [channel][row][column] tensor sequence maps to a 1-based flat index: columnCount (row stride within one channel) and channelStride (columnCount * rowCount, the offset between channels). Built from an ExtentUtilityRudesheim (see #forInput:/#forOutput:) and cached by WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim so Conv2DLayerNeuralNetworkMachineLearningRudesheim>>forward: can flatten both the input tensor and the output tensor through the same #flatIndexForChannel:position: message, sent to whichever layout (input or output) applies at that call site.
"
Class {
	#name : 'TensorLayoutNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#instVars : [
		'extent',
		'columnCount',
		'channelStride'
	],
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'instance creation' }
TensorLayoutNeuralNetworkMachineLearningRudesheim class >> extent: anExtentUtilityRudesheim [
	^ super new
		setExtent:	anExtentUtilityRudesheim
		columnCount:	anExtentUtilityRudesheim columns
		channelStride:	anExtentUtilityRudesheim rows * anExtentUtilityRudesheim columns;
		yourself.
]

{ #category : 'instance creation' }
TensorLayoutNeuralNetworkMachineLearningRudesheim class >> forInput: anInputExtentUtilityRudesheim [
	^ self
		extent:	anInputExtentUtilityRudesheim.
]

{ #category : 'instance creation' }
TensorLayoutNeuralNetworkMachineLearningRudesheim class >> forOutput: anOutputExtentUtilityRudesheim [
	^ self
		extent:	anOutputExtentUtilityRudesheim.
]

{ #category : 'accessing' }
TensorLayoutNeuralNetworkMachineLearningRudesheim >> channelStride [
	^ channelStride.
]

{ #category : 'accessing' }
TensorLayoutNeuralNetworkMachineLearningRudesheim >> columnCount [
	^ columnCount.
]

{ #category : 'accessing' }
TensorLayoutNeuralNetworkMachineLearningRudesheim >> extent [
	^ extent.
]

{ #category : 'flattening' }
TensorLayoutNeuralNetworkMachineLearningRudesheim >> flatIndexForChannel: aChannelIndexInteger
position: aPositionPoint [
	^ aChannelIndexInteger * self channelStride + (aPositionPoint x * self columnCount) + aPositionPoint y + 1.
]

{ #category : 'initialization' }
TensorLayoutNeuralNetworkMachineLearningRudesheim >> setExtent: anExtentUtilityRudesheim
columnCount: aColumnCountInteger
channelStride: aChannelStrideInteger [
	extent := anExtentUtilityRudesheim.
	columnCount := aColumnCountInteger.
	channelStride := aChannelStrideInteger.
]
