"
MaxPool2DLayerOpenCLNeuralNetworkMachineLearningRudesheim is a 2D max-pooling layer that runs on the OpenCL backend. Like Conv2DLayerOpenCLNeuralNetworkMachineLearningRudesheim, it receives/returns flat number sequences -- the window is baked in at construction time. It has no learned parameters, so withUpdatedWeightsRows:learningRate: is a no-op. backward: routes each output cell's incoming gradient to only the input position that was its arg-max in the forward pass (all other input positions in that window receive no gradient from it); ties are broken the same way Pool2dForward does (first occurrence under strict '>'). To avoid a scatter/atomics, Pool2dBackward is expressed as a gather over input cells: for each input position it re-derives the (small) set of output cells whose window could have covered it, replays that output cell's arg-max scan, and accumulates the gradient only when this input position is the winner.
"
Class {
	#name : 'MaxPool2DLayerOpenCLNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#traits : 'TLayerNeuralNetworkMachineLearningRudesheim',
	#classTraits : 'TLayerNeuralNetworkMachineLearningRudesheim classTrait',
	#instVars : [
		'window'
	],
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'evaluating' }
MaxPool2DLayerOpenCLNeuralNetworkMachineLearningRudesheim >> backward:	aTBackwardContextNeuralNetworkMachineLearningRudesheim [

	|
		queue
		inputCount
		inputBuffer
		gradientBuffer
		inputGradientBuffer
		kernel
	|

	queue := OpenCLNeuralNetworkMachineLearningRudesheim commandQueue.
	inputCount := window inputChannels * window inputRows * window inputColumns.
	inputBuffer := OpenCLNeuralNetworkMachineLearningRudesheim context newCLBufferWithFloats: aTBackwardContextNeuralNetworkMachineLearningRudesheim inputPredictions asArray.
	gradientBuffer := OpenCLNeuralNetworkMachineLearningRudesheim context newCLBufferWithFloats: aTBackwardContextNeuralNetworkMachineLearningRudesheim gradient asArray.
	inputGradientBuffer := OpenCLNeuralNetworkMachineLearningRudesheim context newCLBufferForSize: inputCount * TFBasicType float byteSize.
	kernel :=
		OpenCLNeuralNetworkMachineLearningRudesheim
			kernelAt:				'Pool2dBackward'
			parameterTypes:
			{
				TFBasicType pointer.
				TFBasicType pointer.
				TFBasicType pointer.
				TFBasicType uint.
				TFBasicType uint.
				TFBasicType uint.
				TFBasicType uint.
				TFBasicType uint.
				TFBasicType uint.
				TFBasicType uint.
				TFBasicType uint.
				TFBasicType sint.
				TFBasicType sint.
			}.

	^
	[
		queue
			enqueueKernelAndWait:	kernel
			forNDRange:				{ { window inputChannels. window inputRows. window inputColumns } }
			withArguments:
			{
				inputBuffer.
				gradientBuffer.
				inputGradientBuffer.
				window inputRows.
				window inputColumns.
				window outputRows.
				window outputColumns.
				window kernelRows.
				window kernelColumns.
				window strideRows.
				window strideColumns.
				window paddingTopRows.
				window paddingLeftColumns.
			}.

		{ queue readFloatsFrom: inputGradientBuffer count: inputCount }
	]
		ensure:
		[
			inputBuffer release.
			gradientBuffer release.
			inputGradientBuffer release.
		].
]

{ #category : 'as yet unclassified' }
MaxPool2DLayerOpenCLNeuralNetworkMachineLearningRudesheim class >> fromSoilGraphNodeRecord: aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim [
	^ self
		window:	
		aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim
			layerAttributesRecords
			first.
]

{ #category : 'as yet unclassified' }
MaxPool2DLayerOpenCLNeuralNetworkMachineLearningRudesheim class >> nameForONNX [
	^ 'MaxPool'.
]

{ #category : 'as yet unclassified' }
MaxPool2DLayerOpenCLNeuralNetworkMachineLearningRudesheim class >> species [
	^ MaxPool2DLayerOpenCLNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'as yet unclassified' }
MaxPool2DLayerOpenCLNeuralNetworkMachineLearningRudesheim class >> window: aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim [
	^ super new
		setWindow:	aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim;
		yourself.
]

{ #category : 'as yet unclassified' }
MaxPool2DLayerOpenCLNeuralNetworkMachineLearningRudesheim >> forward: anInputNumbersSequencialCollection [
	|
		queue
		inputBuffer
		outputBuffer
		kernel
		outputCount
		kernelEvent
	|

	queue := OpenCLNeuralNetworkMachineLearningRudesheim commandQueue.

	inputBuffer :=
		anInputNumbersSequencialCollection
			asOpenCLBufferRudesheim:	OpenCLNeuralNetworkMachineLearningRudesheim context.

	outputCount := window inputChannels * window outputRows * window outputColumns.

	outputBuffer :=
		OpenCLNeuralNetworkMachineLearningRudesheim context
			newCLBufferForSize:	outputCount * TFBasicType float byteSize.

	outputBuffer
		count:		outputCount;
		queue:		queue;
		context:	OpenCLNeuralNetworkMachineLearningRudesheim context.

	kernel :=
		OpenCLNeuralNetworkMachineLearningRudesheim
			kernelAt:	'Pool2dForward'
			parameterTypes:	{TFBasicType pointer .  TFBasicType pointer .  TFBasicType uint .  TFBasicType uint .  TFBasicType uint .  TFBasicType uint .  TFBasicType uint .  TFBasicType uint .  TFBasicType uint .  TFBasicType uint .  TFBasicType sint .  TFBasicType sint}.

	^
	[
		"Not enqueueKernelAndWait: -- see AddLayerOpenCL>>forward: for the
		in-order-queue rationale and why kernelEvent is only waited on in
		the ensure: block below."
		kernelEvent :=
			queue
				enqueueKernel:	kernel
				forNDRange:	{{window inputChannels .  window outputRows .  window outputColumns}}
				withArguments:	{inputBuffer .  outputBuffer .  window inputRows .  window inputColumns .  window outputRows .  window outputColumns .  window kernelRows .  window kernelColumns .  window strideRows .  window strideColumns .  window paddingTopRows .  window paddingLeftColumns}.

		outputBuffer.
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

{ #category : 'as yet unclassified' }
MaxPool2DLayerOpenCLNeuralNetworkMachineLearningRudesheim >> setWindow: aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim [
	window := aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'converting' }
MaxPool2DLayerOpenCLNeuralNetworkMachineLearningRudesheim >> withUpdatedWeightsRows:	aTLinearTransformLayerNeuralNetworkMachineLearningRudesheim
learningRate:				aRateFloat [

	^ self
]
