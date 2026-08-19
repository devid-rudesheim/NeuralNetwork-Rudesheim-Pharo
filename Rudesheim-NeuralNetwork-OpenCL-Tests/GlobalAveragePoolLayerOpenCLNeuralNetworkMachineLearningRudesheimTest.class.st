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

	|
		extentClass
	|

	extentClass := Rudesheim Utility Extent.

	^ Rudesheim MachineLearning NeuralNetwork Soil WindowSpecification
		inputChannels:	2
		inputExtent:	(extentClass width: 2 height: 2)
		kernelExtent:	(extentClass width: 2 height: 2)
		strideExtent:	(extentClass width: 2 height: 2)
		padding:	(Margin top: 0 left: 0 bottom: 0 right: 0)
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
