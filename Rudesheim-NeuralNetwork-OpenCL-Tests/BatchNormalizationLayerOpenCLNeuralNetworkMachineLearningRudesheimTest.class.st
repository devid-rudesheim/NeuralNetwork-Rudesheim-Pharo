Class {
	#name : 'BatchNormalizationLayerOpenCLNeuralNetworkMachineLearningRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-NeuralNetwork-OpenCL-Tests-Layer',
	#package : 'Rudesheim-NeuralNetwork-OpenCL-Tests',
	#tag : 'Layer'
}

{ #category : 'accessing' }
BatchNormalizationLayerOpenCLNeuralNetworkMachineLearningRudesheimTest class >> targetClass [

	^ BatchNormalizationLayerOpenCLNeuralNetworkMachineLearningRudesheim
]

{ #category : 'accessing' }
BatchNormalizationLayerOpenCLNeuralNetworkMachineLearningRudesheimTest >> defaultWindow [

	^ WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim
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
		paddingRightColumns:	0
]

{ #category : 'accessing' }
BatchNormalizationLayerOpenCLNeuralNetworkMachineLearningRudesheimTest >> defaultLayer [

	^ self targetClass
		scale:	#( 2.0 0.5 )
		shift:	#( 1.0 -1.0 )
		window:	self defaultWindow
]

{ #category : 'tests' }
BatchNormalizationLayerOpenCLNeuralNetworkMachineLearningRudesheimTest >> testBackwardMatchesHandComputedAffineGradients [

	|
		context
		result
	|

	context :=
		( Rudesheim MachineLearning NeuralNetwork Predictions
			inputPredictions:	#( 1.0 2.0 4.0 8.0 )
			outputPredictions:	#( 3.0 5.0 1.0 3.0 ) )
			backwardContextWithGradient:	#( 1.0 2.0 0.5 -1.0 ).

	result := self defaultLayer backward: context.

	"input_gradient[i] = gradient[i] * scale[channel(i)]"
	self assert: result first equals: #( 2.0 4.0 0.25 -0.5 ).

	"scale_gradient[c] = sum over p of gradient[c,p] * input[c,p];
	shift_gradient[c] = sum over p of gradient[c,p]"
	self assert: result last scale equals: #( 5.0 -6.0 ).
	self assert: result last shift equals: #( 3.0 -0.5 )
]

{ #category : 'tests' }
BatchNormalizationLayerOpenCLNeuralNetworkMachineLearningRudesheimTest >> testWithUpdatedWeightsRowsMatchesHandComputedSGDStep [

	|
		gradientLayer
		updated
	|

	gradientLayer :=
		self targetClass
			scale:	#( 5.0 -6.0 )
			shift:	#( 3.0 -0.5 )
			window:	self defaultWindow.

	updated :=
		self defaultLayer
			withUpdatedWeightsRows:	gradientLayer
			learningRate:				0.1.

	"left - rate*right, same SGD shape as LinearTransformLayerOpenCL. Compared
	with closeTo:precision: rather than equals: since the OpenCL kernel
	computes in single-precision float, e.g. 1.1 comes back as
	1.100000023841858."
	updated scale
		with:	#( 1.5 1.1 )
		do:		[ :left :right | self assert: left closeTo: right precision: 0.0001 ].
	updated shift
		with:	#( 0.7 -0.95 )
		do:		[ :left :right | self assert: left closeTo: right precision: 0.0001 ]
]

{ #category : 'tests' }
BatchNormalizationLayerOpenCLNeuralNetworkMachineLearningRudesheimTest >> testForwardMatchesHandComputedPerChannelAffine [

	|
		layer
		output
	|

	layer := self defaultLayer.

	output :=
		(
			layer forward:
				#(
					1.0 2.0
					4.0 8.0
				)
		) asArray.

	self assert: output equals: #(3.0 5.0 1.0 3.0)
]
