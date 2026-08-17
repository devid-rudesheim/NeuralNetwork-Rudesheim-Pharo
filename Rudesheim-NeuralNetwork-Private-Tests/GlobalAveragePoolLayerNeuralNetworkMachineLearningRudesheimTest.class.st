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

	^ self targetClass
		window:
		(
			Rudesheim MachineLearning NeuralNetwork Soil WindowSpecification
				inputChannels:	1
				inputRows:	1
				inputColumns:	1
				kernelRows:	1
				kernelColumns:	1
				strideRows:	1
				strideColumns:	1
				paddingTopRows:	0
				paddingBottomRows:	0
				paddingLeftColumns:	0
				paddingRightColumns:	0
		)
]

{ #category : 'as yet unclassified' }
GlobalAveragePoolLayerNeuralNetworkMachineLearningRudesheimTest >> testForwardMatchesHandComputedPerChannelAverage [
	|
		window
		layer
		output
	|

	window :=
		Rudesheim MachineLearning NeuralNetwork Soil WindowSpecification
			inputChannels:	2
			inputRows:	2
			inputColumns:	2
			kernelRows:	2
			kernelColumns:	2
			strideRows:	2
			strideColumns:	2
			paddingTopRows:	0
			paddingBottomRows:	0
			paddingLeftColumns:	0
			paddingRightColumns:	0.

	layer :=
		self targetClass
			window:	window.

	output := (layer forward: #(1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0)) asArray.

	self
		assert:	output
		equals:	#(2.5 6.5).
]
