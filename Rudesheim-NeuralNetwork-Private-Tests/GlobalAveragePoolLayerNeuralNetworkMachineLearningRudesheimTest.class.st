Class {
	#name : 'GlobalAveragePoolLayerNeuralNetworkMachineLearningRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-NeuralNetwork-Private-Tests-Layer',
	#package : 'Rudesheim-NeuralNetwork-Private-Tests',
	#tag : 'Layer'
}

{ #category : 'as yet unclassified' }
GlobalAveragePoolLayerNeuralNetworkMachineLearningRudesheimTest class >> targetClass [
	^ GlobalAveragePoolLayerNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'accessing' }
GlobalAveragePoolLayerNeuralNetworkMachineLearningRudesheimTest >> defaultBasicTarget [

	|
		extentClass
	|

	extentClass := Rudesheim Utility Extent.

	^ self targetClass
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
GlobalAveragePoolLayerNeuralNetworkMachineLearningRudesheimTest >> testForwardMatchesHandComputedPerChannelAverage [
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
		self targetClass
			window:	window.

	output := (layer forward: #(1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0)) asArray.

	self
		assert:	output
		equals:	#(2.5 6.5).
]
