"
AddLayerOpenCLNeuralNetworkMachineLearningRudesheim is an element-wise addition layer that runs on the OpenCL backend, used for residual/skip connections (e.g. resnet50-v2-7.onnx). It is stateless like ReLULayerOpenCLNeuralNetworkMachineLearningRudesheim, so fromSoilGraphNodeRecord:/forward:/backward: are class-side and the class itself is used as the Node's layer object. TNodeNeuralNetworkMachineLearningRudesheim>>valueFromPredecessorValues:givenInput: concatenates a 2-predecessor node's two branch outputs into one flat array before calling forward: -- since both branches always have equal length for a well-formed residual connection, forward: only needs to split that concatenated array in half and add the halves element-wise, with no separate shape/window state required. backward: is the exact inverse: d(output)/d(x1) = d(output)/d(x2) = 1, so the incoming gradient is duplicated into both halves of the returned input gradient (the graph-level backward traversal is responsible for routing each half to its own predecessor). It has no learned parameters, so withUpdatedWeightsRows:learningRate: is a no-op.
"
Class {
	#name : 'AddLayerOpenCLNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#traits : 'TLayerNeuralNetworkMachineLearningRudesheim',
	#classTraits : 'TLayerNeuralNetworkMachineLearningRudesheim classTrait',
	#category : 'Rudesheim-NeuralNetwork-OpenCL-Private',
	#package : 'Rudesheim-NeuralNetwork-OpenCL-Private'
}

{ #category : 'evaluating' }
AddLayerOpenCLNeuralNetworkMachineLearningRudesheim class >> backward:	aTBackwardContextNeuralNetworkMachineLearningRudesheim [

	|
		queue
		halfCount
		gradientBuffer
		inputGradientBuffer
		kernel
	|

	halfCount := aTBackwardContextNeuralNetworkMachineLearningRudesheim gradient size.
	queue := OpenCLNeuralNetworkMachineLearningRudesheim commandQueue.
	gradientBuffer :=
		OpenCLNeuralNetworkMachineLearningRudesheim context
			newCLBufferWith:	aTBackwardContextNeuralNetworkMachineLearningRudesheim gradient asArray
			elementType:	TFBasicType float.
	inputGradientBuffer :=
		OpenCLNeuralNetworkMachineLearningRudesheim context
			newCLBufferForElementCount:	halfCount * 2
			elementType:	TFBasicType float.
	kernel :=
		OpenCLNeuralNetworkMachineLearningRudesheim
			kernelAt:				'AddBackward'
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
			forNDRange:				{ { halfCount } }
			withArguments:			{ gradientBuffer. inputGradientBuffer. halfCount }.

		"The graph-level backward traversal (TNode>>distributeGradient:toPredecessorGradients:)
		splits this doubled-length input gradient back into the two predecessors' own
		lengths -- the exact inverse of how valueFromPredecessorValues:givenInput: concatenated
		them going forward."
		{ queue readFloatsFrom: inputGradientBuffer count: halfCount * 2 }
	]
		ensure:
		[
			gradientBuffer release.
			inputGradientBuffer release.
		].
]

{ #category : 'evaluating' }
AddLayerOpenCLNeuralNetworkMachineLearningRudesheim class >> forward:	anInputNumbersSequencialCollection [

	|
		queue
		inputBuffer
		outputBuffer
		kernel
		outputCount
		kernelEvent
	|

	queue := OpenCLNeuralNetworkMachineLearningRudesheim commandQueue.
	"anInputNumbersSequencialCollection may already be an OpenCL buffer --
	see the comment on this same pattern in ReLULayerOpenCL>>forward:."
	inputBuffer := anInputNumbersSequencialCollection asOpenCLBufferRudesheim: OpenCLNeuralNetworkMachineLearningRudesheim context.
	outputCount := inputBuffer count // 2.
	outputBuffer :=
		OpenCLNeuralNetworkMachineLearningRudesheim context
			newCLBufferForElementCount:	outputCount
			elementType:	TFBasicType float.
	outputBuffer
		count:		outputCount;
		queue:		queue;
		context:	OpenCLNeuralNetworkMachineLearningRudesheim context.
	kernel :=
		OpenCLNeuralNetworkMachineLearningRudesheim
			kernelAt:				'AddForward'
			parameterTypes:
			{
				TFBasicType pointer.
				TFBasicType pointer.
				TFBasicType uint.
			}.

	^
	[
		"Not enqueueKernelAndWait: -- the command queue is in-order, so this
		kernel is guaranteed to run after everything already enqueued on it
		and before anything enqueued next, with no host-side wait needed
		here. The first point that actually needs the result host-side (an
		Add merge's rudesheimConcatenatedWith: or the model's final asArray)
		blocks there, which -- by the same in-order guarantee -- also waits
		for every kernel enqueued before it, this one included. kernelEvent
		itself is only waited on below, and only when this method uploaded a
		private inputBuffer it is about to release -- see the comment on the
		ensure: block. See note/opencl-layer-buffer-passthrough-design.md
		2026-08-10追記(4)/(7)/(8)."
		kernelEvent :=
			queue
				enqueueKernel:	kernel
				forNDRange:				{ { outputCount } }
				withArguments:
				{
					inputBuffer.
					outputBuffer.
					outputCount.
				}.

		"See LinearTransformLayerOpenCL>>forward: for why outputBuffer is
		returned live and inputBuffer's release is conditional. anInputNumbersSequencialCollection
		here is the value TNode>>valueFromPredecessorValues:givenInput: built
		via rudesheimConcatenatedWith: -- a live OpenCL buffer when both
		branches were already on the GPU (the common case), or a plain Array
		when one or both weren't (see note/opencl-layer-buffer-passthrough-design.md,
		'AddLayerの分岐合流')."
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

{ #category : 'instance creation' }
AddLayerOpenCLNeuralNetworkMachineLearningRudesheim class >> fromSoilGraphNodeRecord:	aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim [

	^ self
]

{ #category : 'converting' }
AddLayerOpenCLNeuralNetworkMachineLearningRudesheim class >> withUpdatedWeightsRows:	aTLinearTransformLayerNeuralNetworkMachineLearningRudesheim
learningRate:				aRateFloat [

	^ self
]
