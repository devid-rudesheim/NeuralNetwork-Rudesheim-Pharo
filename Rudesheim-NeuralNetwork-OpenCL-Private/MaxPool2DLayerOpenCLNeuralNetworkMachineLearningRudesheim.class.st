"
MaxPool2DLayerOpenCLNeuralNetworkMachineLearningRudesheim is a 2D max-pooling layer that runs on the OpenCL backend. Like Conv2DLayerOpenCLNeuralNetworkMachineLearningRudesheim, it receives/returns flat number sequences -- the window is baked in at construction time. It has no learned parameters, so withUpdatedWeightsRows:learningRate: is a no-op. backward: routes each output cell's incoming gradient to only the input position that was its arg-max in the forward pass (all other input positions in that window receive no gradient from it); ties are broken the same way Pool2dForward does (first occurrence under strict '>'). To avoid a scatter/atomics, Pool2dBackward is expressed as a gather over input cells: for each input position it re-derives the (small) set of output cells whose window could have covered it, replays that output cell's arg-max scan, and accumulates the gradient only when this input position is the winner.
"
Class {
	#name : 'MaxPool2DLayerOpenCLNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#traits : 'TLayerNeuralNetworkMachineLearningRudesheim + TShouldntNewRudesheim',
	#classTraits : 'TLayerNeuralNetworkMachineLearningRudesheim classTrait + TShouldntNewRudesheim classTrait',
	#instVars : [
		'window'
	],
	#category : 'Rudesheim-NeuralNetwork-OpenCL-Private',
	#package : 'Rudesheim-NeuralNetwork-OpenCL-Private'
}

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

{ #category : 'evaluating' }
MaxPool2DLayerOpenCLNeuralNetworkMachineLearningRudesheim >> backward:	aTBackwardContextNeuralNetworkMachineLearningRudesheim [

	|
		cl
		queue
		inputCount
		inputBuffer
		gradientBuffer
		inputGradientBuffer
		kernel
	|

	cl := Rudesheim MachineLearning NeuralNetwork OpenCL.
	queue := cl commandQueue.
	inputCount := window inputChannels * window input rows * window input columns.
	inputBuffer :=
		cl context
			newCLBufferWith:	aTBackwardContextNeuralNetworkMachineLearningRudesheim inputPredictions asArray
			elementType:		TFBasicType float.
	gradientBuffer :=
		cl context
			newCLBufferWith:	aTBackwardContextNeuralNetworkMachineLearningRudesheim gradient asArray
			elementType:		TFBasicType float.
	inputGradientBuffer :=
		cl context
			newCLBufferForElementCount:	inputCount
			elementType:				TFBasicType float.
	kernel :=
		cl
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
			forNDRange:				{ { window inputChannels. window input rows. window input columns } }
			withArguments:
			{
				inputBuffer.
				gradientBuffer.
				inputGradientBuffer.
				window input rows.
				window input columns.
				window output rows.
				window output columns.
				window kernel rows.
				window kernel columns.
				window stride rows.
				window stride columns.
				window padding top.
				window padding left.
			}.

		{
			queue
				readFrom:		inputGradientBuffer
				count:			inputCount
				elementType:	TFBasicType float
		}
	]
		ensure:
		[
			inputBuffer release.
			gradientBuffer release.
			inputGradientBuffer release.
		].
]

{ #category : 'as yet unclassified' }
MaxPool2DLayerOpenCLNeuralNetworkMachineLearningRudesheim >> forward: anInputNumbersSequencialCollection [
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

	outputCount := window inputChannels * window output rows * window output columns.

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
			kernelAt:		'Pool2dForward'
			parameterTypes:	{TFBasicType pointer .  TFBasicType pointer .  TFBasicType uint .  TFBasicType uint .  TFBasicType uint .  TFBasicType uint .  TFBasicType uint .  TFBasicType uint .  TFBasicType uint .  TFBasicType uint .  TFBasicType sint .  TFBasicType sint}.

	^
	[
		"Not enqueueKernelAndWait: -- see AddLayerOpenCL>>forward: for the
		in-order-queue rationale and why kernelEvent is only waited on in
		the ensure: block below."
		kernelEvent :=
			queue
				enqueueKernel:	kernel
				forNDRange:		{{window inputChannels .  window output rows .  window output columns}}
				withArguments:	{inputBuffer .  outputBuffer .  window input rows .  window input columns .  window output rows .  window output columns .  window kernel rows .  window kernel columns .  window stride rows .  window stride columns .  window padding top .  window padding left}.

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
