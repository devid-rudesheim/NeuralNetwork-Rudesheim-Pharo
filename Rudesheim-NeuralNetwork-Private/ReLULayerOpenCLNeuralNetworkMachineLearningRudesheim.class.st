Class {
	#name : 'ReLULayerOpenCLNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#traits : 'TReLULayerNeuralNetworkMachineLearningRudesheim',
	#classTraits : 'TReLULayerNeuralNetworkMachineLearningRudesheim classTrait',
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'instance creation' }
ReLULayerOpenCLNeuralNetworkMachineLearningRudesheim class >> fromSoilGraphNodeRecord:	aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim [

	^ self
]

{ #category : 'evaluating' }
ReLULayerOpenCLNeuralNetworkMachineLearningRudesheim class >> backward: aTBackwardContextNeuralNetworkMachineLearningRudesheim [

	|
		queue
		count
		inputBuffer
		gradientBuffer
		inputGradientBuffer
		kernel
	|

	"inputPredictions may be a live OpenCL buffer passed through from an upstream
	Layer (see note/opencl-layer-buffer-passthrough-design.md), which is not
	indexable/does not understand #size directly, so asArray it first (a no-op
	for a value that's already a plain Array) before ever asking its size."
	count := aTBackwardContextNeuralNetworkMachineLearningRudesheim inputPredictions asArray size.
	queue := OpenCLNeuralNetworkMachineLearningRudesheim commandQueue.
	inputBuffer := OpenCLNeuralNetworkMachineLearningRudesheim context newCLBufferWithFloats: aTBackwardContextNeuralNetworkMachineLearningRudesheim inputPredictions asArray.
	gradientBuffer := OpenCLNeuralNetworkMachineLearningRudesheim context newCLBufferWithFloats: aTBackwardContextNeuralNetworkMachineLearningRudesheim gradient asArray.
	inputGradientBuffer := OpenCLNeuralNetworkMachineLearningRudesheim context newCLBufferForSize: count * TFBasicType float byteSize.
	kernel :=
		OpenCLNeuralNetworkMachineLearningRudesheim
			kernelAt:				'ReluBackward'
			parameterTypes:
			{
				TFBasicType pointer.
				TFBasicType pointer.
				TFBasicType pointer.
				TFBasicType uint.
			}.

	^
	[
		queue
			enqueueKernelAndWait:	kernel
			forNDRange:				{ { count } }
			withArguments:			{ inputBuffer. gradientBuffer. inputGradientBuffer. count }.

		{ queue readFloatsFrom: inputGradientBuffer count: count }
	]
		ensure:
		[
			inputBuffer release.
			gradientBuffer release.
			inputGradientBuffer release.
		].
]

{ #category : 'evaluating' }
ReLULayerOpenCLNeuralNetworkMachineLearningRudesheim class >> forward: anInputNumbersSequencialCollection [

	|
		queue
		count
		inputBuffer
		outputBuffer
		kernel
		kernelEvent
	|

	queue := OpenCLNeuralNetworkMachineLearningRudesheim commandQueue.
	"anInputNumbersSequencialCollection may already be an OpenCL buffer
	passed through from an upstream Layer, which doesn't understand #size --
	read the element count off inputBuffer (an Array upload tags itself with
	its own size; see SequenceableCollection>>asOpenCLBufferRudesheim:)."
	inputBuffer := anInputNumbersSequencialCollection asOpenCLBufferRudesheim: OpenCLNeuralNetworkMachineLearningRudesheim context.
	count := inputBuffer count.
	outputBuffer := OpenCLNeuralNetworkMachineLearningRudesheim context newCLBufferForSize: count * TFBasicType float byteSize.
	outputBuffer
		count:		count;
		queue:		queue;
		context:	OpenCLNeuralNetworkMachineLearningRudesheim context.
	kernel :=
		OpenCLNeuralNetworkMachineLearningRudesheim
			kernelAt:				'ReluForward'
			parameterTypes:
			{
				TFBasicType pointer.
				TFBasicType pointer.
				TFBasicType uint.
			}.

	^
	[
		"Not enqueueKernelAndWait: -- see AddLayerOpenCL>>forward: for the
		in-order-queue rationale. kernelEvent is only waited on below, and
		only when this method itself uploaded a private inputBuffer that it
		is about to release -- see the comment on the ensure: block."
		kernelEvent :=
			queue
				enqueueKernel:	kernel
				forNDRange:				{ { count } }
				withArguments:			{ inputBuffer. outputBuffer. count }.

		"See LinearTransformLayerOpenCL>>forward: for why outputBuffer is
		returned live and inputBuffer's release is conditional."
		outputBuffer
	]
		ensure:
		[
			"Releasing inputBuffer here does not wait for kernelEvent by
			itself -- unlike the shared/passed-through case (no release at
			all), this branch actually frees the buffer, so it must first be
			sure the kernel that reads it has finished. This wait is scoped
			to just this one kernel (not queue finish), so it never
			re-serializes the rest of an in-flight enqueue batch -- see
			note/opencl-layer-buffer-passthrough-design.md 2026-08-10追記(8).
			kernelEvent itself is released unconditionally below (waiting on
			it does not release its native handle -- see
			CommandQueueOpenCLRudesheim>>enqueueKernelAndWait:forNDRange:
			withArguments:), so this branch not running (the common
			buffer-passthrough case) doesn't leak it either."
			inputBuffer == anInputNumbersSequencialCollection
				ifFalse:
				[
					kernelEvent wait.
					inputBuffer release.
				].
			kernelEvent release.
		].
]
