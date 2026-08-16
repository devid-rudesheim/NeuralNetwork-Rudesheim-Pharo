Class {
	#name : 'LinearTransformLayerOpenCLNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#traits : 'TLinearTransformLayerNeuralNetworkMachineLearningRudesheim + TReleasableOpenCLRudesheim',
	#classTraits : 'TLinearTransformLayerNeuralNetworkMachineLearningRudesheim classTrait',
	#instVars : [
		'rows',
		'columns',
		'weightsBuffer',
		'biasesBuffer'
	],
	#category : 'Rudesheim-NeuralNetwork-OpenCL-Private',
	#package : 'Rudesheim-NeuralNetwork-OpenCL-Private'
}

{ #category : 'instance creation' }
LinearTransformLayerOpenCLNeuralNetworkMachineLearningRudesheim class >> fromSoilGraphNodeRecord:	aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim [

	^ self weightsSource:
		(
			Rudesheim MachineLearning NeuralNetwork Soil WeightsSource
				tensorDescriptorRecords:	aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim tensorDescriptorRecords
		)
]

{ #category : 'accessing' }
LinearTransformLayerOpenCLNeuralNetworkMachineLearningRudesheim class >> species [

	^ LinearTransformLayerOpenCLNeuralNetworkMachineLearningRudesheim
]

{ #category : 'accessing' }
LinearTransformLayerOpenCLNeuralNetworkMachineLearningRudesheim >> backward: aBackwordContextNeuralNetworkMachineLearningRudesheim [

	|
		queue
		gradient
		inputs
		gradientBuffer
		inputsBuffer
		inputGradientBuffer
		weightGradientBuffer
		kernel1
		kernel2
		flatWeightGradient
	|

	gradient := aBackwordContextNeuralNetworkMachineLearningRudesheim gradient.
	inputs := aBackwordContextNeuralNetworkMachineLearningRudesheim inputPredictions.
	queue := OpenCLNeuralNetworkMachineLearningRudesheim commandQueue.

	gradientBuffer :=
		OpenCLNeuralNetworkMachineLearningRudesheim context
			newCLBufferWith:	gradient asArray
			elementType:	TFBasicType float.
	inputsBuffer :=
		OpenCLNeuralNetworkMachineLearningRudesheim context
			newCLBufferWith:	inputs asArray
			elementType:	TFBasicType float.
	inputGradientBuffer :=
		OpenCLNeuralNetworkMachineLearningRudesheim context
			newCLBufferForElementCount:	columns
			elementType:	TFBasicType float.

	kernel1 :=
		OpenCLNeuralNetworkMachineLearningRudesheim
			kernelAt:				'GemvTransposeBackward'
			parameterTypes:
			{
				TFBasicType pointer.
				TFBasicType pointer.
				TFBasicType pointer.
				TFBasicType uint.
				TFBasicType uint.
			}.

	queue
		enqueueKernelAndWait:	kernel1
		forNDRange:				{ { columns } }
		withArguments:			{ weightsBuffer. gradientBuffer. inputGradientBuffer. rows. columns }.

	weightGradientBuffer :=
		OpenCLNeuralNetworkMachineLearningRudesheim context
			newCLBufferForElementCount:	rows * columns
			elementType:	TFBasicType float.
	kernel2 :=
		OpenCLNeuralNetworkMachineLearningRudesheim
			kernelAt:				'OuterProduct'
			parameterTypes:
			{
				TFBasicType pointer.
				TFBasicType pointer.
				TFBasicType pointer.
				TFBasicType uint.
			}.

	queue
		enqueueKernelAndWait:	kernel2
		forNDRange:				{ { rows. columns } }
		withArguments:			{ inputsBuffer. gradientBuffer. weightGradientBuffer. columns }.

	flatWeightGradient :=
		queue
			readFrom:	weightGradientBuffer
			count:	rows * columns
			elementType:	TFBasicType float.

	^
	[
		{
			queue
				readFrom:	inputGradientBuffer
				count:	columns
				elementType:	TFBasicType float.
			self species
				weightsRows:
				(
					( 1 to: rows )
						collect:
						[ :rowIndex |
							flatWeightGradient
								copyFrom:	( rowIndex - 1 ) * columns + 1
								to:			rowIndex * columns
						]
				)
				biases:
				(
					queue
						readFrom:	gradientBuffer
						count:	rows
						elementType:	TFBasicType float
				).
		}
	]
		ensure:
		[
			gradientBuffer release.
			inputsBuffer release.
			inputGradientBuffer release.
			weightGradientBuffer release.
		].
]

{ #category : 'accessing' }
LinearTransformLayerOpenCLNeuralNetworkMachineLearningRudesheim >> biases [

	^ OpenCLNeuralNetworkMachineLearningRudesheim commandQueue
		readFrom:	biasesBuffer
		count:	rows
		elementType:	TFBasicType float
]

{ #category : 'evaluating' }
LinearTransformLayerOpenCLNeuralNetworkMachineLearningRudesheim >> forward: anInputNumbersSequencialCollection [

	|
		queue
		inputBuffer
		outputBuffer
		kernel
		kernelEvent
	|

	queue := OpenCLNeuralNetworkMachineLearningRudesheim commandQueue.
	inputBuffer := anInputNumbersSequencialCollection asOpenCLBufferRudesheim: OpenCLNeuralNetworkMachineLearningRudesheim context.
	outputBuffer :=
		OpenCLNeuralNetworkMachineLearningRudesheim context
			newCLBufferForElementCount:	rows
			elementType:	TFBasicType float.
	outputBuffer
		count:		rows;
		queue:		queue;
		context:	OpenCLNeuralNetworkMachineLearningRudesheim context.
	kernel :=
		OpenCLNeuralNetworkMachineLearningRudesheim
			kernelAt:				'GemvForward'
			parameterTypes:
			{
				TFBasicType pointer.
				TFBasicType pointer.
				TFBasicType pointer.
				TFBasicType pointer.
				TFBasicType uint.
				TFBasicType uint.
			}.

	^
	[
		"Not enqueueKernelAndWait:: the command queue is in-order, so this
		kernel is guaranteed to run after everything already enqueued on it
		and before anything enqueued next, with no host-side wait needed
		here. The first point that actually needs the result host-side (an
		Add merge's rudesheimConcatenatedWith: or the model's final asArray)
		blocks there, which -- by the same in-order guarantee -- also waits
		for every kernel enqueued before it, this one included. kernelEvent
		itself is only waited on below, and only when this method uploaded a
		private inputBuffer it is about to release -- see the comment on the
		ensure: block. See note/opencl-layer-buffer-passthrough-design.md,
		'2026-08-10追記(4)/(7)/(8)'."
		kernelEvent :=
			queue
				enqueueKernel:	kernel
				forNDRange:				{ { rows } }
				withArguments:			{ weightsBuffer. biasesBuffer. inputBuffer. outputBuffer. rows. columns }.

		"outputBuffer is returned live (not downloaded here) so an adjacent
		OpenCL Layer can consume it without a round-trip -- see
		note/opencl-layer-buffer-passthrough-design.md. Its release is owned
		by whoever ends up materializing/discarding it (TModel>>forward:'s
		cache cleanup, or asArray callers)."
		outputBuffer
	]
		ensure:
		[
			"Only release inputBuffer if this method uploaded it itself just now
			(anInputNumbersSequencialCollection was a plain Array/Buffer from a
			different context). If it's the very same object we were handed,
			it's a passed-through OpenCL buffer someone else owns -- e.g. a
			node value shared by more than one downstream consumer -- and must
			not be released here. When it does need releasing, kernelEvent is
			waited on first -- see ReLULayerOpenCL>>forward: for why that wait
			is scoped to just this kernel rather than a queue finish. Either
			way kernelEvent is released unconditionally below -- waiting on
			it does not release its native handle (see
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

{ #category : 'releasing' }
LinearTransformLayerOpenCLNeuralNetworkMachineLearningRudesheim >> releaseRudesheim [
	"withUpdatedWeightsRows:learningRate: builds a whole new instance (with its
	own new weightsBuffer/biasesBuffer) rather than mutating this one in place
	-- release this instance's own buffers once it has been superseded, so
	repeated training steps (Node>>rebuiltUsingParameterDeltas:learningRate:cache:)
	don't leak one weightsBuffer/biasesBuffer pair per step."

	weightsBuffer releaseRudesheim.
	biasesBuffer releaseRudesheim.
]

{ #category : 'initialization' }
LinearTransformLayerOpenCLNeuralNetworkMachineLearningRudesheim >> setWeightsRows:	aWeightRowsSequencialCollection
biases:				aBiasesSequencialCollection [

	|
		flatWeights
	|

	rows := aWeightRowsSequencialCollection size.
	columns := rows = 0 ifTrue: [ 0 ] ifFalse: [ aWeightRowsSequencialCollection first size ].
	flatWeights :=
		aWeightRowsSequencialCollection
			inject:	OrderedCollection new
			into:	[ :flat :row | flat addAll: row asArray; yourself ].

	weightsBuffer :=
		OpenCLNeuralNetworkMachineLearningRudesheim context
			newCLBufferWith:	flatWeights asArray
			elementType:	TFBasicType float.
	biasesBuffer :=
		OpenCLNeuralNetworkMachineLearningRudesheim context
			newCLBufferWith:	aBiasesSequencialCollection asArray
			elementType:	TFBasicType float
]

{ #category : 'accessing' }
LinearTransformLayerOpenCLNeuralNetworkMachineLearningRudesheim >> weightsRows [

	|
		queue
		flat
	|

	queue := OpenCLNeuralNetworkMachineLearningRudesheim commandQueue.
	flat :=
		queue
			readFrom:	weightsBuffer
			count:	rows * columns
			elementType:	TFBasicType float.

	^ ( 1 to: rows )
		collect:
		[ :rowIndex |
			flat
				copyFrom:	( rowIndex - 1 ) * columns + 1
				to:			rowIndex * columns
		]
]

{ #category : 'converting' }
LinearTransformLayerOpenCLNeuralNetworkMachineLearningRudesheim >> withUpdatedWeightsRows:	aTLinearTransformLayerNeuralNetworkMachineLearningRudesheim
learningRate:				aRateFloat [

	|
		adjust
	|

	adjust :=
	[ :left :right |
		left - ( aRateFloat * right )
	].

	^ self species
		weightsRows:
		(
			self weightsRows
				with:		aTLinearTransformLayerNeuralNetworkMachineLearningRudesheim weightsRows
				collect:	adjust
		)
		biases:
		(
			adjust
				value:	self biases
				value:	aTLinearTransformLayerNeuralNetworkMachineLearningRudesheim biases
		)
]
