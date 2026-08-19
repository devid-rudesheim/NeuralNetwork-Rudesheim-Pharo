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
		extentClass
		window
		layer
		output
	|

	extentClass := Rudesheim Utility Extent.

	window :=
		Rudesheim MachineLearning NeuralNetwork Soil WindowSpecification
			inputChannels:	2
			inputExtent:	(extentClass width: 2 height: 2)
			kernelExtent:	(extentClass width: 2 height: 2)
			strideExtent:	(extentClass width: 2 height: 2)
			padding:	(Margin top: 0 left: 0 bottom: 0 right: 0).

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
