Class {
	#name : 'Conv2DLayerNeuralNetworkMachineLearningRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-NeuralNetwork-Private-Tests-Layer',
	#package : 'Rudesheim-NeuralNetwork-Private-Tests',
	#tag : 'Layer'
}

{ #category : 'as yet unclassified' }
Conv2DLayerNeuralNetworkMachineLearningRudesheimTest class >> targetClass [
	^ Conv2DLayerNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'accessing' }
Conv2DLayerNeuralNetworkMachineLearningRudesheimTest >> defaultBasicTarget [

	|
		extentClass
	|

	extentClass := Rudesheim Utility Extent.

	^ self targetClass
		weights:	#(1.0)
		biases:	#(0.0)
		window:
		(
			Rudesheim MachineLearning NeuralNetwork Soil WindowSpecification
				inputChannels:	1
				inputExtent:	(extentClass width: 1 height: 1)
				kernelExtent:	(extentClass width: 1 height: 1)
				strideExtent:	(extentClass width: 1 height: 1)
				padding:	(Margin top: 0 left: 0 bottom: 0 right: 0)
		)
]

{ #category : 'as yet unclassified' }
Conv2DLayerNeuralNetworkMachineLearningRudesheimTest >> testForwardMatchesHandComputedSumKernel [
	|
		extentClass
		window
		layer
		input
		output
	|

	extentClass := Rudesheim Utility Extent.

	window :=
		Rudesheim MachineLearning NeuralNetwork Soil WindowSpecification
			inputChannels:	1
			inputExtent:	(extentClass width: 4 height: 4)
			kernelExtent:	(extentClass width: 3 height: 3)
			strideExtent:	(extentClass width: 1 height: 1)
			padding:	(Margin top: 0 left: 0 bottom: 0 right: 0).

	layer :=
		self targetClass
			weights:	#(1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0)
			biases:	#(0.0)
			window:	window.

	input := #(1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 11.0 12.0 13.0 14.0 15.0 16.0).
	output := (layer forward: input) asArray.

	self
		assert:	output
		equals:	#(54.0 63.0 90.0 99.0).
]

{ #category : 'as yet unclassified' }
Conv2DLayerNeuralNetworkMachineLearningRudesheimTest >> testForwardWithSamePaddingIncludesBias [
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
			inputExtent:	(extentClass width: 2 height: 2)
			kernelExtent:	(extentClass width: 3 height: 3)
			strideExtent:	(extentClass width: 1 height: 1)
			padding:	(Margin top: 1 left: 1 bottom: 1 right: 1).

	layer :=
		self targetClass
			weights:	#(1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0)
			biases:	#(0.5)
			window:	window.

	output := (layer forward: #(1.0 2.0 3.0 4.0)) asArray.

	self
		assert:	output
		equals:	#(10.5 10.5 10.5 10.5).
]
