Class {
	#name : 'BatchNormalizationLayerBackendNeuralNetworkMachineLearningRudesheimTest',
	#superclass : 'ParametrizedTestCase',
	#instVars : [
		'backend'
	],
	#category : 'Rudesheim-NeuralNetwork-OpenCL-Tests-Layer',
	#package : 'Rudesheim-NeuralNetwork-OpenCL-Tests',
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
		extentClass
		window
		layer
		output
	|

	extentClass := Rudesheim Utility Extent.

	window :=
		Rudesheim MachineLearning NeuralNetwork Soil WindowSpecification
			inputChannels:	2
			inputExtent:	(extentClass width: 2 height: 1)
			kernelExtent:	(extentClass width: 1 height: 1)
			strideExtent:	(extentClass width: 1 height: 1)
			padding:	(Margin top: 0 left: 0 bottom: 0 right: 0).

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
