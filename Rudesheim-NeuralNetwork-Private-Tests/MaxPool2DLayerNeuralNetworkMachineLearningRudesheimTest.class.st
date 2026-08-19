Class {
	#name : 'MaxPool2DLayerNeuralNetworkMachineLearningRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-NeuralNetwork-Private-Tests-Layer',
	#package : 'Rudesheim-NeuralNetwork-Private-Tests',
	#tag : 'Layer'
}

{ #category : 'as yet unclassified' }
MaxPool2DLayerNeuralNetworkMachineLearningRudesheimTest class >> targetClass [
	^ MaxPool2DLayerNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'accessing' }
MaxPool2DLayerNeuralNetworkMachineLearningRudesheimTest >> defaultBasicTarget [

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
MaxPool2DLayerNeuralNetworkMachineLearningRudesheimTest >> testForwardMatchesHandComputedMax [
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
		self targetClass
			window:	window.

	output := (layer forward: #(1.0 3.0 2.0 4.0 5.0 2.0 8.0 1.0 9.0 0.0 1.0 2.0 3.0 4.0 5.0 6.0)) asArray.

	self
		assert:	output
		equals:	#(5.0 8.0 9.0 6.0).
]
