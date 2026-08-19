Class {
	#name : 'MaxPool2DLayerOpenCLNeuralNetworkMachineLearningRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-NeuralNetwork-OpenCL-Tests-Layer',
	#package : 'Rudesheim-NeuralNetwork-OpenCL-Tests',
	#tag : 'Layer'
}

{ #category : 'accessing' }
MaxPool2DLayerOpenCLNeuralNetworkMachineLearningRudesheimTest class >> targetClass [

	^ MaxPool2DLayerOpenCLNeuralNetworkMachineLearningRudesheim
]

{ #category : 'accessing' }
MaxPool2DLayerOpenCLNeuralNetworkMachineLearningRudesheimTest >> defaultWindow [

	|
		extentClass
	|

	extentClass := Rudesheim Utility Extent.

	^ Rudesheim MachineLearning NeuralNetwork Soil WindowSpecification
		inputChannels:	1
		inputExtent:	(extentClass width: 4 height: 4)
		kernelExtent:	(extentClass width: 2 height: 2)
		strideExtent:	(extentClass width: 2 height: 2)
		padding:	(Margin top: 0 left: 0 bottom: 0 right: 0)
]

{ #category : 'tests' }
MaxPool2DLayerOpenCLNeuralNetworkMachineLearningRudesheimTest >> testBackwardRoutesGradientToArgMaxPositionsOnly [

	|
		layer
		context
		inputGradient
	|

	layer := self targetClass window: self defaultWindow.
	context :=
		( Rudesheim MachineLearning NeuralNetwork Predictions
			inputPredictions:
				#(
					1.0 3.0 2.0 4.0
					5.0 2.0 8.0 1.0
					9.0 0.0 1.0 2.0
					3.0 4.0 5.0 6.0
				)
			outputPredictions:	#( 5.0 8.0 9.0 6.0 ) )
			backwardContextWithGradient:	#( 1.0 2.0 3.0 4.0 ).

	inputGradient := ( layer backward: context ) first.

	"Each output cell's gradient is routed only to the input position that
	was its arg-max in the forward pass -- row1col0=5.0 (winner of the
	top-left window), row1col2=8.0 (top-right), row2col0=9.0 (bottom-left),
	row3col3=6.0 (bottom-right); every other position receives 0."
	self
		assert:	inputGradient
		equals:
			#(
				0.0 0.0 0.0 0.0
				1.0 0.0 2.0 0.0
				3.0 0.0 0.0 0.0
				0.0 0.0 0.0 4.0
			)
]

{ #category : 'tests' }
MaxPool2DLayerOpenCLNeuralNetworkMachineLearningRudesheimTest >> testWithUpdatedWeightsRowsIsNoOpForParameterlessLayer [

	|
		layer
	|

	layer := self targetClass window: self defaultWindow.

	self
		assert:	( layer withUpdatedWeightsRows: nil learningRate: 0.01 )
		equals:	layer
]

{ #category : 'tests' }
MaxPool2DLayerOpenCLNeuralNetworkMachineLearningRudesheimTest >> testForwardMatchesHandComputedMax [

	|
		layer
		output
	|

	layer := self targetClass window: self defaultWindow.

	output :=
		(
			layer forward:
				#(
					1.0 3.0 2.0 4.0
					5.0 2.0 8.0 1.0
					9.0 0.0 1.0 2.0
					3.0 4.0 5.0 6.0
				)
		) asArray.

	self assert: output equals: #(5.0 8.0 9.0 6.0)
]
