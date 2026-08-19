Class {
	#name : 'BatchNormalizationLayerNeuralNetworkMachineLearningRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-NeuralNetwork-Private-Tests-Layer',
	#package : 'Rudesheim-NeuralNetwork-Private-Tests',
	#tag : 'Layer'
}

{ #category : 'as yet unclassified' }
BatchNormalizationLayerNeuralNetworkMachineLearningRudesheimTest class >> targetClass [
	^ BatchNormalizationLayerNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'accessing' }
BatchNormalizationLayerNeuralNetworkMachineLearningRudesheimTest >> defaultBasicTarget [

	|
		extentClass
	|

	extentClass := Rudesheim Utility Extent.

	^ self targetClass
		scale:	#(1.0)
		shift:	#(0.0)
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
BatchNormalizationLayerNeuralNetworkMachineLearningRudesheimTest >> testForwardMatchesHandComputedPerChannelAffine [
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
		self targetClass
			scale:	#(2.0 0.5)
			shift:	#(1.0 -1.0)
			window:	window.

	output := (layer forward: #(1.0 2.0 4.0 8.0)) asArray.

	self
		assert:	output
		equals:	#(3.0 5.0 1.0 3.0).
]
