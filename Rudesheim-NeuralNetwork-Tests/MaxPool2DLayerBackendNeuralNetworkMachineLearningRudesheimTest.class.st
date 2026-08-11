Class {
	#name : 'MaxPool2DLayerBackendNeuralNetworkMachineLearningRudesheimTest',
	#superclass : 'ParametrizedTestCase',
	#instVars : [
		'backend'
	],
	#category : 'Rudesheim-NeuralNetwork-Tests-Layer',
	#package : 'Rudesheim-NeuralNetwork-Tests',
	#tag : 'Layer'
}

{ #category : 'as yet unclassified' }
MaxPool2DLayerBackendNeuralNetworkMachineLearningRudesheimTest class >> testParameters [
	^ ParametrizedTestMatrix new
		addCase:	{(#backend -> PureNeuralNetworkMachineLearningRudesheim)};
		addCase:	{(#backend -> OpenCLNeuralNetworkMachineLearningRudesheim)};
		yourself.
]

{ #category : 'as yet unclassified' }
MaxPool2DLayerBackendNeuralNetworkMachineLearningRudesheimTest >> backend [
	^ backend.
]

{ #category : 'as yet unclassified' }
MaxPool2DLayerBackendNeuralNetworkMachineLearningRudesheimTest >> backend: aTBackendNeuralNetworkMachineLearningRudesheim [
	backend := aTBackendNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'as yet unclassified' }
MaxPool2DLayerBackendNeuralNetworkMachineLearningRudesheimTest >> testForwardMatchesHandComputedMax [
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
			MaxPool2D
			window:	window.

	output := (layer forward: #(1.0 3.0 2.0 4.0 5.0 2.0 8.0 1.0 9.0 0.0 1.0 2.0 3.0 4.0 5.0 6.0)) asArray.

	self
		assert:	output
		equals:	#(5.0 8.0 9.0 6.0).
]
