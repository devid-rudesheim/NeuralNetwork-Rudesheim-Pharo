Class {
	#name : 'ReLULayerOpenCLNeuralNetworkMachineLearningRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-NeuralNetwork-OpenCL-Tests-Layer',
	#package : 'Rudesheim-NeuralNetwork-OpenCL-Tests',
	#tag : 'Layer'
}

{ #category : 'accessing' }
ReLULayerOpenCLNeuralNetworkMachineLearningRudesheimTest class >> targetClass [

	^ ReLULayerOpenCLNeuralNetworkMachineLearningRudesheim
]

{ #category : 'tests' }
ReLULayerOpenCLNeuralNetworkMachineLearningRudesheimTest >> testBackwardMatchesPure [

	|
		context
		oclResult
		pureResult
	|

	context :=
		Rudesheim MachineLearning NeuralNetwork Predictions
			inputPredictions:	#( -1.0 2.0 -3.0 4.0 )
			outputPredictions:	#( 0.0 2.0 0.0 4.0 ).

	oclResult :=
		self targetClass
			backward:	( context backwardContextWithGradient: #( 0.5 -0.25 1.0 -0.5 ) ).
	pureResult :=
		Rudesheim MachineLearning NeuralNetwork Pure Layer ReLU
			backward:	( context backwardContextWithGradient: #( 0.5 -0.25 1.0 -0.5 ) ).

	oclResult first
		with:	pureResult first
		do:		[ :left :right | self assert: left closeTo: right precision: 0.0001 ]
]

{ #category : 'tests' }
ReLULayerOpenCLNeuralNetworkMachineLearningRudesheimTest >> testForwardMatchesPure [
	"The OpenCL backend's forward: returns a live buffer (not an Array) so an
	adjacent OpenCL Layer can consume it directly -- see
	note/opencl-layer-buffer-passthrough-design.md -- so asArray it here to
	compare against the Pure backend's plain Array result."

	self
		assert:	( ( self targetClass forward: #( -1.0 2.0 -3.0 4.0 ) ) asArray )
		equals:	( Rudesheim MachineLearning NeuralNetwork Pure Layer ReLU forward: #( -1.0 2.0 -3.0 4.0 ) )
]
