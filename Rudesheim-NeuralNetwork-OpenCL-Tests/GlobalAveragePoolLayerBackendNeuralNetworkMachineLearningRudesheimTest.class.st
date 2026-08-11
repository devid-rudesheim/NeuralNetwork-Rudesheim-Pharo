Class {
	#name : 'GlobalAveragePoolLayerBackendNeuralNetworkMachineLearningRudesheimTest',
	#superclass : 'ParametrizedTestCase',
	#instVars : [
		'backend'
	],
	#category : 'Rudesheim-NeuralNetwork-OpenCL-Tests-Layer',
	#package : 'Rudesheim-NeuralNetwork-OpenCL-Tests',
	#tag : 'Layer'
}

{ #category : 'as yet unclassified' }
GlobalAveragePoolLayerBackendNeuralNetworkMachineLearningRudesheimTest class >> testParameters [
	^ ParametrizedTestMatrix new
		addCase:	{(#backend -> PureNeuralNetworkMachineLearningRudesheim)};
		addCase:	{(#backend -> OpenCLNeuralNetworkMachineLearningRudesheim)};
		yourself.
]

{ #category : 'as yet unclassified' }
GlobalAveragePoolLayerBackendNeuralNetworkMachineLearningRudesheimTest >> backend [
	^ backend.
]

{ #category : 'as yet unclassified' }
GlobalAveragePoolLayerBackendNeuralNetworkMachineLearningRudesheimTest >> backend: aTBackendNeuralNetworkMachineLearningRudesheim [
	backend := aTBackendNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'as yet unclassified' }
GlobalAveragePoolLayerBackendNeuralNetworkMachineLearningRudesheimTest >> testForwardMatchesHandComputedPerChannelAverage [
	|
		window
		layer
		output
	|

	window :=
		WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim
			inputChannels:	2
			inputRows:	2
			inputColumns:	2
			kernelRows:	2
			kernelColumns:	2
			strideRows:	2
			strideColumns:	2
			paddingTopRows:	0
			paddingBottomRows:	0
			paddingLeftColumns:	0
			paddingRightColumns:	0.

	layer :=
		self
			backend
			Layer
			GlobalAveragePool
			window:	window.

	output := (layer forward: #(1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0)) asArray.

	self
		assert:	output
		equals:	#(2.5 6.5).
]
