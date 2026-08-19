Class {
	#name : 'MaxPool2DLayerBackendNeuralNetworkMachineLearningRudesheimTest',
	#superclass : 'ParametrizedTestCase',
	#instVars : [
		'backend'
	],
	#category : 'Rudesheim-NeuralNetwork-OpenCL-Tests-Layer',
	#package : 'Rudesheim-NeuralNetwork-OpenCL-Tests',
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
		extentClass
		window
		layer
		output
	|

	extentClass := Rudesheim Utility Extent.

	window :=
		Rudesheim MachineLearning NeuralNetwork Soil WindowSpecification
			inputChannels:	1
			inputExtent:	(extentClass width: 4 height: 4)
			kernelExtent:	(extentClass width: 2 height: 2)
			strideExtent:	(extentClass width: 2 height: 2)
			padding:	(Margin top: 0 left: 0 bottom: 0 right: 0).

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
