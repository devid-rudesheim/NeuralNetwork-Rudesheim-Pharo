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

	^ self targetClass
		scale:	#(1.0)
		shift:	#(0.0)
		window:
		(
			WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim
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
				paddingRightColumns:	0.
		)
]

{ #category : 'as yet unclassified' }
BatchNormalizationLayerNeuralNetworkMachineLearningRudesheimTest >> testForwardMatchesHandComputedPerChannelAffine [
	|
		window
		layer
		output
	|

	window :=
		WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim
			inputChannels:	2
			inputRows:	1
			inputColumns:	2
			kernelRows:	1
			kernelColumns:	1
			strideRows:	1
			strideColumns:	1
			paddingTopRows:	0
			paddingBottomRows:	0
			paddingLeftColumns:	0
			paddingRightColumns:	0.

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
