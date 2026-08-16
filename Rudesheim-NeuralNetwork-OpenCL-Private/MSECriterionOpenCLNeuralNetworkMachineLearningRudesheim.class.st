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
		queue
		count
		predictionsBuffer
		targetsBuffer
		gradientBuffer
		kernel
	|

	count := predictions size.
	queue := OpenCLNeuralNetworkMachineLearningRudesheim commandQueue.
	predictionsBuffer :=
		OpenCLNeuralNetworkMachineLearningRudesheim context
			newCLBufferWith:	predictions asArray
			elementType:	TFBasicType float.
	targetsBuffer :=
		OpenCLNeuralNetworkMachineLearningRudesheim context
			newCLBufferWith:	targets asArray
			elementType:	TFBasicType float.
	gradientBuffer :=
		OpenCLNeuralNetworkMachineLearningRudesheim context
			newCLBufferForElementCount:	count
			elementType:	TFBasicType float.
	kernel :=
		OpenCLNeuralNetworkMachineLearningRudesheim
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

		queue readFloatsFrom: gradientBuffer count: count
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
