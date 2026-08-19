"
GlobalAveragePoolLayerOpenCLNeuralNetworkMachineLearningRudesheim is a spatial global-average-pooling layer that runs on the OpenCL backend: it averages every element of a channel's whole (rows x columns) extent down to a single value per channel. It reuses WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim (kernel = stride = the full input rows/columns, no padding) the same way MaxPool2DLayerOpenCLNeuralNetworkMachineLearningRudesheim does, but averages instead of taking the max -- kept as its own class rather than a mode flag on MaxPool2D per note/oop-guideline.md (no switch/if branching by kind). It has no learned parameters, so withUpdatedWeightsRows:learningRate: is a no-op. backward: is the exact inverse of the forward average: since every spatial position in a channel contributed equally to that channel's averaged output, the channel's incoming gradient is divided evenly back across all (rows x columns) positions of that channel.
"
Class {
	#name : 'GlobalAveragePoolLayerOpenCLNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#traits : 'TLayerNeuralNetworkMachineLearningRudesheim + TShouldntNewRudesheim',
	#classTraits : 'TLayerNeuralNetworkMachineLearningRudesheim classTrait + TShouldntNewRudesheim classTrait',
	#instVars : [
		'window'
	],
	#category : 'Rudesheim-NeuralNetwork-OpenCL-Private',
	#package : 'Rudesheim-NeuralNetwork-OpenCL-Private'
}

{ #category : 'instance creation' }
GlobalAveragePoolLayerOpenCLNeuralNetworkMachineLearningRudesheim class >> fromSoilGraphNodeRecord:	aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim [

	^ self window: aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim layerAttributesRecords first
]

{ #category : 'accessing' }
GlobalAveragePoolLayerOpenCLNeuralNetworkMachineLearningRudesheim class >> species [

	^ GlobalAveragePoolLayerOpenCLNeuralNetworkMachineLearningRudesheim
]

{ #category : 'instance creation' }
GlobalAveragePoolLayerOpenCLNeuralNetworkMachineLearningRudesheim class >> window:	aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim [

	^ super new
		setWindow:	aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim;
		yourself
]

{ #category : 'evaluating' }
GlobalAveragePoolLayerOpenCLNeuralNetworkMachineLearningRudesheim >> backward:	aTBackwardContextNeuralNetworkMachineLearningRudesheim [

	|
		cl
		queue
		spatialCount
		channels
		gradientBuffer
		inputGradientBuffer
		kernel
	|

	cl := Rudesheim MachineLearning NeuralNetwork OpenCL.
	channels := window inputChannels.
	spatialCount := window input rows * window input columns.
	queue := cl commandQueue.
	gradientBuffer :=
		cl context
			newCLBufferWith:	aTBackwardContextNeuralNetworkMachineLearningRudesheim gradient asArray
			elementType:		TFBasicType float.
	inputGradientBuffer :=
		cl context
			newCLBufferForElementCount:	channels * spatialCount
			elementType:				TFBasicType float.
	kernel :=
		cl
			kernelAt:				'GlobalAvgPoolBackward'
			parameterTypes:
			{
				TFBasicType pointer.
				TFBasicType pointer.
				TFBasicType uint.
			}.

	^
	[
		queue
			enqueueKernelAndWait:	kernel
			forNDRange:				{ { channels. spatialCount } }
			withArguments:			{ gradientBuffer. inputGradientBuffer. spatialCount }.

		{
			queue
				readFrom:		inputGradientBuffer
				count:			channels * spatialCount
				elementType:	TFBasicType float
		}
	]
		ensure:
		[
			gradientBuffer release.
			inputGradientBuffer release.
		].
]

{ #category : 'evaluating' }
GlobalAveragePoolLayerOpenCLNeuralNetworkMachineLearningRudesheim >> forward:	anInputNumbersSequencialCollection [

	|
		cl
		queue
		inputBuffer
		outputBuffer
		kernel
		outputCount
		kernelEvent
	|

	cl := Rudesheim MachineLearning NeuralNetwork OpenCL.
	queue := cl commandQueue.
	inputBuffer :=
		anInputNumbersSequencialCollection
			asOpenCLBufferRudesheim:	cl context.
	outputCount := window inputChannels.
	outputBuffer :=
		cl context
			newCLBufferForElementCount:	outputCount
			elementType:				TFBasicType float.
	outputBuffer
		count:		outputCount;
		queue:		queue;
		context:	cl context.
	kernel :=
		cl
			kernelAt:				'GlobalAvgPoolForward'
			parameterTypes:
			{
				TFBasicType pointer.
				TFBasicType pointer.
				TFBasicType uint.
				TFBasicType uint.
			}.

	^
	[
		"Not enqueueKernelAndWait: -- see AddLayerOpenCL>>forward: for the
		in-order-queue rationale and why kernelEvent is only waited on in
		the ensure: block below."
		kernelEvent :=
			queue
				enqueueKernel:	kernel
				forNDRange:		{ { outputCount } }
				withArguments:
				{
					inputBuffer.
					outputBuffer.
					window input rows.
					window input columns.
				}.

		"See LinearTransformLayerOpenCL>>forward: for why outputBuffer is
		returned live and inputBuffer's release is conditional."
		outputBuffer
	]
		ensure:
		[
			"See ReLULayerOpenCL>>forward: for why this waits on kernelEvent
			specifically (not queue finish) before releasing a private
			inputBuffer, and why kernelEvent is released unconditionally
			regardless of which branch runs."
			inputBuffer == anInputNumbersSequencialCollection
				ifFalse:
				[
					kernelEvent wait.
					inputBuffer release.
				].
			kernelEvent release.
		].
]

{ #category : 'initialization' }
GlobalAveragePoolLayerOpenCLNeuralNetworkMachineLearningRudesheim >> setWindow:	aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim [

	window := aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim
]

{ #category : 'converting' }
GlobalAveragePoolLayerOpenCLNeuralNetworkMachineLearningRudesheim >> withUpdatedWeightsRows:	aTLinearTransformLayerNeuralNetworkMachineLearningRudesheim
learningRate:				aRateFloat [

	^ self
]
