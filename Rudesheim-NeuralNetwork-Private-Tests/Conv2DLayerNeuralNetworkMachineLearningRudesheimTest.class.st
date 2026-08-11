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

{ #category : 'as yet unclassified' }
Conv2DLayerNeuralNetworkMachineLearningRudesheimTest >> testForwardMatchesHandComputedSumKernel [
	|
		window
		layer
		input
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
		window
		layer
		output
	|

	window :=
		WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim
			inputChannels:	1
			inputRows:	2
			inputColumns:	2
			kernelRows:	3
			kernelColumns:	3
			strideRows:	1
			strideColumns:	1
			paddingTopRows:	1
			paddingBottomRows:	1
			paddingLeftColumns:	1
			paddingRightColumns:	1.

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
