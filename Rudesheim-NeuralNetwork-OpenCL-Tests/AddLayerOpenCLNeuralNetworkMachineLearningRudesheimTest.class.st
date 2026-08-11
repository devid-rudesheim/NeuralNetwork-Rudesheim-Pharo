Class {
	#name : 'AddLayerOpenCLNeuralNetworkMachineLearningRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-NeuralNetwork-OpenCL-Tests-Layer',
	#package : 'Rudesheim-NeuralNetwork-OpenCL-Tests',
	#tag : 'Layer'
}

{ #category : 'accessing' }
AddLayerOpenCLNeuralNetworkMachineLearningRudesheimTest class >> targetClass [

	^ AddLayerOpenCLNeuralNetworkMachineLearningRudesheim
]

{ #category : 'tests' }
AddLayerOpenCLNeuralNetworkMachineLearningRudesheimTest >> testBackwardDuplicatesGradientToBothInputHalves [

	|
		context
		inputGradient
	|

	context :=
		( Rudesheim MachineLearning NeuralNetwork Predictions
			inputPredictions:	#( 1.0 2.0 3.0 4.0 10.0 20.0 30.0 40.0 )
			outputPredictions:	#( 11.0 22.0 33.0 44.0 ) )
			backwardContextWithGradient:	#( 0.5 -0.25 1.0 2.0 ).

	inputGradient := ( self targetClass backward: context ) first.

	"d(output)/d(x1) = d(output)/d(x2) = 1, so the incoming gradient is
	duplicated unchanged into both halves of the input gradient."
	self assert: inputGradient equals: #( 0.5 -0.25 1.0 2.0 0.5 -0.25 1.0 2.0 )
]

{ #category : 'tests' }
AddLayerOpenCLNeuralNetworkMachineLearningRudesheimTest >> testWithUpdatedWeightsRowsIsNoOpForParameterlessLayer [

	self
		assert: ( self targetClass withUpdatedWeightsRows: nil learningRate: 0.01 )
		equals: self targetClass
]

{ #category : 'tests' }
AddLayerOpenCLNeuralNetworkMachineLearningRudesheimTest >> testForwardAddsConcatenatedPredecessorHalvesElementWise [

	|
		output
	|

	output :=
		(
			self targetClass forward:
				#(
					1.0 2.0 3.0 4.0
					10.0 20.0 30.0 40.0
				)
		) asArray.

	self assert: output equals: #(11.0 22.0 33.0 44.0)
]
