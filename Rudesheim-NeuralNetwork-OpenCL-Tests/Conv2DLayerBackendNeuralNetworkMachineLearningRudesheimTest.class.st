Class {
	#name : 'Conv2DLayerBackendNeuralNetworkMachineLearningRudesheimTest',
	#superclass : 'ParametrizedTestCase',
	#instVars : [
		'backend'
	],
	#category : 'Rudesheim-NeuralNetwork-OpenCL-Tests-Layer',
	#package : 'Rudesheim-NeuralNetwork-OpenCL-Tests',
	#tag : 'Layer'
}

{ #category : 'as yet unclassified' }
Conv2DLayerBackendNeuralNetworkMachineLearningRudesheimTest class >> testParameters [
	^ ParametrizedTestMatrix new
		addCase:	{(#backend -> PureNeuralNetworkMachineLearningRudesheim)};
		addCase:	{(#backend -> OpenCLNeuralNetworkMachineLearningRudesheim)};
		yourself.
]

{ #category : 'as yet unclassified' }
Conv2DLayerBackendNeuralNetworkMachineLearningRudesheimTest >> backend [
	^ backend.
]

{ #category : 'as yet unclassified' }
Conv2DLayerBackendNeuralNetworkMachineLearningRudesheimTest >> backend: aTBackendNeuralNetworkMachineLearningRudesheim [
	backend := aTBackendNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'as yet unclassified' }
Conv2DLayerBackendNeuralNetworkMachineLearningRudesheimTest >> testForwardMatchesHandComputedSumKernel [
	|
		window
		layer
		output
	|

	window :=
		WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim
			inputChannels:	1
			inputRows:	4
			inputColumns:	4
			kernelRows:	3
			kernelColumns:	3
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
			Conv2D
			weights:	#(1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0)
			biases:	#(0.0)
			window:	window.

	output := (layer forward: #(1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 11.0 12.0 13.0 14.0 15.0 16.0)) asArray.

	self
		assert:	output
		equals:	#(54.0 63.0 90.0 99.0).
]
