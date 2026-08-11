Class {
	#name : 'BatchNormalizationLayerBackendNeuralNetworkMachineLearningRudesheimTest',
	#superclass : 'ParametrizedTestCase',
	#instVars : [
		'backend'
	],
	#category : 'Rudesheim-NeuralNetwork-Tests-Layer',
	#package : 'Rudesheim-NeuralNetwork-Tests',
	#tag : 'Layer'
}

{ #category : 'as yet unclassified' }
BatchNormalizationLayerBackendNeuralNetworkMachineLearningRudesheimTest class >> testParameters [
	^ ParametrizedTestMatrix new
		addCase:	{(#backend -> PureNeuralNetworkMachineLearningRudesheim)};
		addCase:	{(#backend -> OpenCLNeuralNetworkMachineLearningRudesheim)};
		yourself.
]

{ #category : 'as yet unclassified' }
BatchNormalizationLayerBackendNeuralNetworkMachineLearningRudesheimTest >> backend [
	^ backend.
]

{ #category : 'as yet unclassified' }
BatchNormalizationLayerBackendNeuralNetworkMachineLearningRudesheimTest >> backend: aTBackendNeuralNetworkMachineLearningRudesheim [
	backend := aTBackendNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'as yet unclassified' }
BatchNormalizationLayerBackendNeuralNetworkMachineLearningRudesheimTest >> testForwardMatchesHandComputedPerChannelAffine [
	|
		window
		layer
		output
	|

	window :=
		WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim
			inputChannels:	2
			inputRows:	1
			inputColumns:	2
			kernelRows:	1
			kernelColumns:	1
			strideRows:	1
			strideColumns:	1
			paddingTopRows:	0
			paddingBottomRows:	0
			paddingLeftColumns:	0
			paddingRightColumns:	0.

	layer :=
		self
			backend
			Layer
			BatchNormalization
			scale:	#(2.0 0.5)
			shift:	#(1.0 -1.0)
			window:	window.

	output := (layer forward: #(1.0 2.0 4.0 8.0)) asArray.

	self
		assert:	output
		equals:	#(3.0 5.0 1.0 3.0).
]
