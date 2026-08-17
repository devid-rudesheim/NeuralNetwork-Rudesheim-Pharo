Class {
	#name : 'Conv2DLayerOpenCLNeuralNetworkMachineLearningRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-NeuralNetwork-OpenCL-Tests-Layer',
	#package : 'Rudesheim-NeuralNetwork-OpenCL-Tests',
	#tag : 'Layer'
}

{ #category : 'accessing' }
Conv2DLayerOpenCLNeuralNetworkMachineLearningRudesheimTest class >> targetClass [

	^ Conv2DLayerOpenCLNeuralNetworkMachineLearningRudesheim
]

{ #category : 'accessing' }
Conv2DLayerOpenCLNeuralNetworkMachineLearningRudesheimTest >> defaultWindow [

	^ Rudesheim MachineLearning NeuralNetwork Soil WindowSpecification
		inputChannels:	1
		inputRows:	4
		inputColumns:	4
		kernelRows:	3
		kernelColumns:	3
		strideRows:	1
		strideColumns:	1
		paddingTopRows:	0
		paddingBottomRows:	0
		paddingLeftColumns:	0
		paddingRightColumns:	0
]

{ #category : 'tests' }
Conv2DLayerOpenCLNeuralNetworkMachineLearningRudesheimTest >> testBackwardMatchesFiniteDifferenceGradient [
	"No Pure counterpart exists to diff backward: against (unlike LinearTransform/ReLU),
	so correctness is checked via central-difference gradient checking: perturb each
	input/weight/bias element by epsilon, rerun forward:, and compare the numeric slope
	of the scalar loss (output . gradient) against the analytic gradient returned by
	backward:. Conv2D's forward: is exactly linear in each single perturbed variable
	(weights, biases, or input) when every other variable is held fixed, so there is no
	truncation-error tradeoff from a large epsilon here.

	The perturbed loss samples are taken via the Pure (plain Smalltalk, no OpenCL
	buffers) Conv2D forward: rather than the OpenCL one under test: this method
	needs dozens of forward: calls to sample every perturbation, and doing that
	many through the OpenCL backend was found to intermittently return a wildly
	wrong value (reproduced directly: one run out of ~45 came back as 1.86e21) --
	a real, pre-existing race in the OpenCL buffer release/reuse path that is out
	of scope to fix here. Using Pure avoids GPU buffers entirely for the sampling
	side, while the analytic gradient under test still comes from the OpenCL
	backward: exactly once."

	|
		window
		weights
		biases
		input
		gradient
		epsilon
		lossFor
		layer
		context
		result
	|

	window := self defaultWindow.
	weights := #( 0.1 0.2 -0.1 0.05 0.3 -0.2 0.15 -0.05 0.25 ).
	biases := #( 0.1 ).
	input := #( 1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 11.0 12.0 13.0 14.0 15.0 16.0 ).
	gradient := #( 0.5 -0.25 1.0 -0.5 ).
	epsilon := 1.0.

	"Rudesheim MachineLearning NeuralNetwork Pure Layer Conv2D>>weights:biases:window:
	takes the same flat weight layout as the OpenCL constructor -- it reshapes to a
	nested Array internally for its own forward:, so no conversion is needed here."
	lossFor :=
	[ :aWeightsSequenceableCollection :aBiasesSequenceableCollection :anInputSequenceableCollection |
		|
			pureLayer
			output
		|
		pureLayer :=
			Rudesheim MachineLearning NeuralNetwork Pure Layer Conv2D
				weights:	aWeightsSequenceableCollection
				biases:		aBiasesSequenceableCollection
				window:		window.
		output := pureLayer forward: anInputSequenceableCollection.
		( output with: gradient collect: [ :each :eachGradient | each * eachGradient ] )
			inject:	0
			into:		[ :total :each | total + each ]
	].

	layer := self targetClass weights: weights biases: biases window: window.
	context :=
		( Rudesheim MachineLearning NeuralNetwork Predictions
			inputPredictions:	input
			outputPredictions:	( layer forward: input ) asArray )
			backwardContextWithGradient:	gradient.
	result := layer backward: context.

	1
		to:	input size
		do:
		[ :index |
			|
				perturbedPlus
				perturbedMinus
				numericGradient
			|
			perturbedPlus := input copy.
			perturbedPlus at: index put: ( input at: index ) + epsilon.
			perturbedMinus := input copy.
			perturbedMinus at: index put: ( input at: index ) - epsilon.
			numericGradient :=
				( ( lossFor value: weights value: biases value: perturbedPlus )
					- ( lossFor value: weights value: biases value: perturbedMinus ) )
					/ ( 2 * epsilon ).
			self
				assert:	( result first at: index )
				closeTo:	numericGradient
				precision:	0.05.
		].

	1
		to:	weights size
		do:
		[ :index |
			|
				perturbedPlus
				perturbedMinus
				numericGradient
			|
			perturbedPlus := weights copy.
			perturbedPlus at: index put: ( weights at: index ) + epsilon.
			perturbedMinus := weights copy.
			perturbedMinus at: index put: ( weights at: index ) - epsilon.
			numericGradient :=
				( ( lossFor value: perturbedPlus value: biases value: input )
					- ( lossFor value: perturbedMinus value: biases value: input ) )
					/ ( 2 * epsilon ).
			self
				assert:	( result last weights at: index )
				closeTo:	numericGradient
				precision:	0.05.
		].

	1
		to:	biases size
		do:
		[ :index |
			|
				perturbedPlus
				perturbedMinus
				numericGradient
			|
			perturbedPlus := biases copy.
			perturbedPlus at: index put: ( biases at: index ) + epsilon.
			perturbedMinus := biases copy.
			perturbedMinus at: index put: ( biases at: index ) - epsilon.
			numericGradient :=
				( ( lossFor value: weights value: perturbedPlus value: input )
					- ( lossFor value: weights value: perturbedMinus value: input ) )
					/ ( 2 * epsilon ).
			self
				assert:	( result last biases at: index )
				closeTo:	numericGradient
				precision:	0.05.
		].

	( layer instVarNamed: 'weightsBuffer' ) release.
	( layer instVarNamed: 'biasesBuffer' ) release.
	( result last instVarNamed: 'weightsBuffer' ) release.
	( result last instVarNamed: 'biasesBuffer' ) release
]

{ #category : 'tests' }
Conv2DLayerOpenCLNeuralNetworkMachineLearningRudesheimTest >> testWithUpdatedWeightsRowsMatchesHandComputedSGDStep [

	|
		window
		layer
		gradientLayer
		updated
	|

	window := self defaultWindow.
	layer :=
		self targetClass
			weights:	#( 0.1 0.2 -0.1 0.05 0.3 -0.2 0.15 -0.05 0.25 )
			biases:		#( 0.1 )
			window:		window.
	gradientLayer :=
		self targetClass
			weights:	#( 1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 )
			biases:		#( 0.5 )
			window:		window.

	updated := layer withUpdatedWeightsRows: gradientLayer learningRate: 0.1.

	"left - rate*right, same SGD shape as LinearTransformLayerOpenCL"
	updated weights
		with:	#( 0.0 0.0 -0.4 -0.35 -0.2 -0.8 -0.55 -0.85 -0.65 )
		do:		[ :left :right | self assert: left closeTo: right precision: 0.0001 ].
	updated biases
		with:	#( 0.05 )
		do:		[ :left :right | self assert: left closeTo: right precision: 0.0001 ]
]

{ #category : 'tests' }
Conv2DLayerOpenCLNeuralNetworkMachineLearningRudesheimTest >> testForwardMatchesHandComputedSumKernel [

	|
		window
		layer
		input
		output
	|

	window :=
		Rudesheim MachineLearning NeuralNetwork Soil WindowSpecification
			inputChannels:	1
			inputRows:	4
			inputColumns:	4
			kernelRows:	3
			kernelColumns:	3
			strideRows:	1
			strideColumns:	1
			paddingTopRows:	0
			paddingBottomRows:	0
			paddingLeftColumns:	0
			paddingRightColumns:	0.

	layer :=
		self targetClass
			weights: #(1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0)
			biases: #(0.0)
			window: window.

	input := #(1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 11.0 12.0 13.0 14.0 15.0 16.0).
	output := (layer forward: input) asArray.

	self assert: output equals: #(54.0 63.0 90.0 99.0)
]

{ #category : 'tests' }
Conv2DLayerOpenCLNeuralNetworkMachineLearningRudesheimTest >> testForwardWithSamePaddingIncludesBias [

	|
		window
		layer
		output
	|

	window :=
		Rudesheim MachineLearning NeuralNetwork Soil WindowSpecification
			inputChannels:	1
			inputRows:	2
			inputColumns:	2
			kernelRows:	3
			kernelColumns:	3
			strideRows:	1
			strideColumns:	1
			paddingTopRows:	1
			paddingBottomRows:	1
			paddingLeftColumns:	1
			paddingRightColumns:	1.

	layer :=
		self targetClass
			weights: #(1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0)
			biases: #(0.5)
			window: window.

	output := (layer forward: #(1.0 2.0 3.0 4.0)) asArray.

	self assert: output equals: #(10.5 10.5 10.5 10.5)
]
