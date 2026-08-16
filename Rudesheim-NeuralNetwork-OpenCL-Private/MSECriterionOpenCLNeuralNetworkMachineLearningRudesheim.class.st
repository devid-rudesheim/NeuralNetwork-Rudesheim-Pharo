Class {
	#name : 'MSECriterionOpenCLNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#traits : 'TMSECriterionNeuralNetworkMachineLearningRudesheim',
	#classTraits : 'TMSECriterionNeuralNetworkMachineLearningRudesheim classTrait',
	#instVars : [
		'predictions',
		'targets'
	],
	#category : 'Rudesheim-NeuralNetwork-OpenCL-Private',
	#package : 'Rudesheim-NeuralNetwork-OpenCL-Private'
}

{ #category : 'accessing' }
MSECriterionOpenCLNeuralNetworkMachineLearningRudesheim >> gradient [

	|
		cl
		queue
		count
		predictionsBuffer
		targetsBuffer
		gradientBuffer
		kernel
	|

	cl := Rudesheim MachineLearning NeuralNetwork OpenCL.
	count := predictions size.
	queue := cl commandQueue.
	predictionsBuffer :=
		cl context
			newCLBufferWith:	predictions asArray
			elementType:		TFBasicType float.
	targetsBuffer :=
		cl context
			newCLBufferWith:	targets asArray
			elementType:		TFBasicType float.
	gradientBuffer :=
		cl context
			newCLBufferForElementCount:	count
			elementType:				TFBasicType float.
	kernel :=
		cl
			kernelAt:				'CriterionGradientScale'
			parameterTypes:
			{
				TFBasicType pointer.
				TFBasicType pointer.
				TFBasicType pointer.
				TFBasicType float.
				TFBasicType uint.
			}.

	^
	[
		queue
			enqueueKernelAndWait:	kernel
			forNDRange:				{ { count } }
			withArguments:			{ predictionsBuffer. targetsBuffer. gradientBuffer. ( 2.0 / count ). count }.

		queue
			readFrom:		gradientBuffer
			count:			count
			elementType:	TFBasicType float
	]
		ensure:
		[
			predictionsBuffer release.
			targetsBuffer release.
			gradientBuffer release.
		].
]

{ #category : 'accessing' }
MSECriterionOpenCLNeuralNetworkMachineLearningRudesheim >> loss [

	|
		squaredErrors
	|

	squaredErrors :=
		predictions
			with:		targets
			collect:	[ :prediction :target | ( prediction - target ) squared ].

	^ squaredErrors sum / squaredErrors size
]

{ #category : 'initialization' }
MSECriterionOpenCLNeuralNetworkMachineLearningRudesheim >> setPredictions: aPredictionsSequencialCollection targets: aTargetSequencialCollection [

	predictions := aPredictionsSequencialCollection.
	targets := aTargetSequencialCollection
]
