Class {
	#name : 'LinearTransformLayerBackendNeuralNetworkMachineLearningRudesheimTest',
	#superclass : 'ParametrizedTestCase',
	#instVars : [
		'backend'
	],
	#category : 'Rudesheim-NeuralNetwork-OpenCL-Tests-Layer',
	#package : 'Rudesheim-NeuralNetwork-OpenCL-Tests',
	#tag : 'Layer'
}

{ #category : 'accessing' }
LinearTransformLayerBackendNeuralNetworkMachineLearningRudesheimTest class >> testParameters [

	^ ParametrizedTestMatrix new
		addCase:	{ ( #backend -> PureNeuralNetworkMachineLearningRudesheim ) };
		addCase:	{ ( #backend -> OpenCLNeuralNetworkMachineLearningRudesheim ) };
		yourself
]

{ #category : 'accessing' }
LinearTransformLayerBackendNeuralNetworkMachineLearningRudesheimTest >> backend [

	^ backend
]

{ #category : 'accessing' }
LinearTransformLayerBackendNeuralNetworkMachineLearningRudesheimTest >> backend: aTBackendNeuralNetworkMachineLearningRudesheim [

	backend := aTBackendNeuralNetworkMachineLearningRudesheim
]

{ #category : 'accessing' }
LinearTransformLayerBackendNeuralNetworkMachineLearningRudesheimTest >> layer [

	^ self backend Layer LinearTransform
		weightsRows:	#( #( 0.5 0.3 -0.2 ) #( -0.1 0.4 0.6 ) )
		biases:			#( 0.1 -0.2 )
]

{ #category : 'tests' }
LinearTransformLayerBackendNeuralNetworkMachineLearningRudesheimTest >> testBackwardReturnsInputGradientAndGradientCarrier [

	|
		context
		result
	|

	context :=
		Rudesheim MachineLearning NeuralNetwork Predictions
			inputPredictions:	#( 1.0 2.0 0.5 )
			outputPredictions:	#( 0.7 0.6 ).

	result :=
		self layer
			backward:	( context backwardContextWithGradient: #( 0.2 -0.1 ) ).

	self assert: result first size equals: 3.
	self assert: ( result last isKindOf: self backend Layer LinearTransform )
]

{ #category : 'tests' }
LinearTransformLayerBackendNeuralNetworkMachineLearningRudesheimTest >> testForwardMatchesHandComputedValue [

	|
		output
	|

	output := ( self layer forward: #( 1.0 2.0 0.5 ) ) asArray.

	"row 1: 0.5*1.0 + 0.3*2.0 + -0.2*0.5 + 0.1 = 0.5 + 0.6 - 0.1 + 0.1 = 1.1"
	"row 2: -0.1*1.0 + 0.4*2.0 + 0.6*0.5 + -0.2 = -0.1 + 0.8 + 0.3 - 0.2 = 0.8"
	self assert: output size equals: 2.
	self assert: ( output at: 1 ) closeTo: 1.1 precision: 0.0001.
	self assert: ( output at: 2 ) closeTo: 0.8 precision: 0.0001
]

{ #category : 'tests' }
LinearTransformLayerBackendNeuralNetworkMachineLearningRudesheimTest >> testWithUpdatedWeightsRowsShrinksTowardZeroForPositiveGradient [

	|
		gradientLayer
		updated
	|

	gradientLayer :=
		self backend Layer LinearTransform
			weightsRows:	#( #( 0.01 0.01 0.01 ) #( 0.01 0.01 0.01 ) )
			biases:			#( 0.01 0.01 ).

	updated :=
		self layer
			withUpdatedWeightsRows:	gradientLayer
			learningRate:				0.1.

	updated weightsRows
		with: self layer weightsRows
		do:
		[ :updatedRow :originalRow |
			updatedRow
				with: originalRow
				do: [ :updatedValue :originalValue | self assert: updatedValue < originalValue ]
		]
]
