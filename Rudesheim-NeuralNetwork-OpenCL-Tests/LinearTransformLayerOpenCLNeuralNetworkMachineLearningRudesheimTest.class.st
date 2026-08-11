Class {
	#name : 'LinearTransformLayerOpenCLNeuralNetworkMachineLearningRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-NeuralNetwork-OpenCL-Tests-Layer',
	#package : 'Rudesheim-NeuralNetwork-OpenCL-Tests',
	#tag : 'Layer'
}

{ #category : 'accessing' }
LinearTransformLayerOpenCLNeuralNetworkMachineLearningRudesheimTest class >> targetClass [

	^ LinearTransformLayerOpenCLNeuralNetworkMachineLearningRudesheim
]

{ #category : 'accessing' }
LinearTransformLayerOpenCLNeuralNetworkMachineLearningRudesheimTest >> defaultBasicTarget [

	^ self targetClass
		weightsRows:	#( #( 0.5 0.3 -0.2 ) #( -0.1 0.4 0.6 ) )
		biases:			#( 0.1 -0.2 )
]

{ #category : 'accessing' }
LinearTransformLayerOpenCLNeuralNetworkMachineLearningRudesheimTest >> pureTarget [

	^ Rudesheim MachineLearning NeuralNetwork Pure Layer LinearTransform
		weightsRows:	#( #( 0.5 0.3 -0.2 ) #( -0.1 0.4 0.6 ) )
		biases:			#( 0.1 -0.2 )
]

{ #category : 'tests' }
LinearTransformLayerOpenCLNeuralNetworkMachineLearningRudesheimTest >> testBackwardMatchesPure [

	|
		context
		oclResult
		pureResult
	|

	context :=
		Rudesheim MachineLearning NeuralNetwork Predictions
			inputPredictions:	#( 1.0 2.0 0.5 )
			outputPredictions:	#( 0.7 0.6 ).

	oclResult :=
		self basicTarget
			backward:	( context backwardContextWithGradient: #( 0.2 -0.1 ) ).
	pureResult :=
		self pureTarget
			backward:	( context backwardContextWithGradient: #( 0.2 -0.1 ) ).

	oclResult first
		with: pureResult first
		do: [ :left :right | self assert: left closeTo: right precision: 0.0001 ].

	oclResult last weightsRows
		with: pureResult last weightsRows
		do:
		[ :oclRow :pureRow |
			oclRow
				with: pureRow
				do: [ :left :right | self assert: left closeTo: right precision: 0.0001 ]
		].

	oclResult last biases
		with: pureResult last biases
		do: [ :left :right | self assert: left closeTo: right precision: 0.0001 ]
]

{ #category : 'tests' }
LinearTransformLayerOpenCLNeuralNetworkMachineLearningRudesheimTest >> testForwardMatchesPure [
	"The OpenCL backend's forward: returns a live buffer (not an Array) so an
	adjacent OpenCL Layer can consume it directly -- see
	note/opencl-layer-buffer-passthrough-design.md -- so asArray it here to
	compare against the Pure backend's plain Array result."

	|
		oclOutput
		pureOutput
	|

	oclOutput := (self basicTarget forward: #( 1.0 2.0 0.5 )) asArray.
	pureOutput := self pureTarget forward: #( 1.0 2.0 0.5 ).

	self assert: oclOutput size equals: pureOutput size.
	oclOutput
		with: pureOutput
		do: [ :left :right | self assert: left closeTo: right precision: 0.0001 ]
]

{ #category : 'tests' }
LinearTransformLayerOpenCLNeuralNetworkMachineLearningRudesheimTest >> testWithUpdatedWeightsRowsMatchesPure [

	|
		gradientLayer
		oclUpdated
		pureUpdated
	|

	gradientLayer :=
		self targetClass
			weightsRows:	#( #( 0.01 -0.02 0.03 ) #( 0.04 0.05 -0.06 ) )
			biases:			#( 0.01 -0.02 ).

	oclUpdated :=
		self basicTarget
			withUpdatedWeightsRows:	gradientLayer
			learningRate:				0.1.
	pureUpdated :=
		self pureTarget
			withUpdatedWeightsRows:
			(
				Rudesheim MachineLearning NeuralNetwork Pure Layer LinearTransform
					weightsRows:	#( #( 0.01 -0.02 0.03 ) #( 0.04 0.05 -0.06 ) )
					biases:			#( 0.01 -0.02 )
			)
			learningRate:				0.1.

	oclUpdated weightsRows
		with: pureUpdated weightsRows
		do:
		[ :oclRow :pureRow |
			oclRow
				with: pureRow
				do: [ :left :right | self assert: left closeTo: right precision: 0.0001 ]
		].

	oclUpdated biases
		with: pureUpdated biases
		do: [ :left :right | self assert: left closeTo: right precision: 0.0001 ]
]
