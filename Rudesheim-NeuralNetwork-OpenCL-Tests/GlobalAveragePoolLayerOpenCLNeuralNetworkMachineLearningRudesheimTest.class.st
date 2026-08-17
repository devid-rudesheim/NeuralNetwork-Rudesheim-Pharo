Class {
	#name : 'GlobalAveragePoolLayerOpenCLNeuralNetworkMachineLearningRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-NeuralNetwork-OpenCL-Tests-Layer',
	#package : 'Rudesheim-NeuralNetwork-OpenCL-Tests',
	#tag : 'Layer'
}

{ #category : 'accessing' }
GlobalAveragePoolLayerOpenCLNeuralNetworkMachineLearningRudesheimTest class >> targetClass [

	^ GlobalAveragePoolLayerOpenCLNeuralNetworkMachineLearningRudesheim
]

{ #category : 'accessing' }
GlobalAveragePoolLayerOpenCLNeuralNetworkMachineLearningRudesheimTest >> defaultWindow [

	^ Rudesheim MachineLearning NeuralNetwork Soil WindowSpecification
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
		paddingRightColumns:	0
]

{ #category : 'tests' }
GlobalAveragePoolLayerOpenCLNeuralNetworkMachineLearningRudesheimTest >> testBackwardDividesGradientEvenlyAcrossChannelPositions [

	|
		layer
		context
		inputGradient
	|

	layer := self targetClass window: self defaultWindow.
	context :=
		( Rudesheim MachineLearning NeuralNetwork Predictions
			inputPredictions:	#( 1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 )
			outputPredictions:	#( 2.5 6.5 ) )
			backwardContextWithGradient:	#( 1.0 2.0 ).

	inputGradient := ( layer backward: context ) first.

	self
		assert:	inputGradient
		equals:	#( 0.25 0.25 0.25 0.25 0.5 0.5 0.5 0.5 )
]

{ #category : 'tests' }
GlobalAveragePoolLayerOpenCLNeuralNetworkMachineLearningRudesheimTest >> testWithUpdatedWeightsRowsIsNoOpForParameterlessLayer [

	|
		layer
	|

	layer := self targetClass window: self defaultWindow.

	self
		assert:	( layer withUpdatedWeightsRows: nil learningRate: 0.01 )
		equals:	layer
]

{ #category : 'tests' }
GlobalAveragePoolLayerOpenCLNeuralNetworkMachineLearningRudesheimTest >> testForwardMatchesHandComputedPerChannelAverage [

	|
		layer
		output
	|

	layer := self targetClass window: self defaultWindow.

	output :=
		(
			layer forward:
				#(
					1.0 2.0 3.0 4.0
					5.0 6.0 7.0 8.0
				)
		) asArray.

	self assert: output equals: #(2.5 6.5)
]
