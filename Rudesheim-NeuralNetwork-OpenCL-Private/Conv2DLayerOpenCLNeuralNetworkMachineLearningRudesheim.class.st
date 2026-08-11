"
Conv2DLayerOpenCLNeuralNetworkMachineLearningRudesheim is a 2D convolution layer (with fused bias) that runs on the OpenCL backend. It receives/returns flat number sequences like every other Layer -- the window (input channels/rows/columns, kernel, stride, padding) is baked into the instance at construction time, so forward: reshapes its flat input internally and flattens its output back before returning, keeping Node/Model's forward: contract unchanged. Its weights are also a flat sequence (out_channels * in_channels * kernel_rows * kernel_columns, row-major), matching what it needs for its OpenCL buffer -- unlike the Pure counterpart, it has no use for a nested per-kernel-element view. backward: computes 3 gradients: bias_gradient (sum of the output gradient over spatial positions per output channel), weight_gradient (correlation of the forward input with the output gradient, same loop shape as Conv2dForward but accumulating over output positions), and input_gradient (a full/transposed convolution -- for each input position, sum contributions from every output position whose receptive field covered it, inverting Conv2dForward's oy/ox -> iy/ix mapping).
"
Class {
	#name : 'Conv2DLayerOpenCLNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#traits : 'TLayerNeuralNetworkMachineLearningRudesheim',
	#classTraits : 'TLayerNeuralNetworkMachineLearningRudesheim classTrait',
	#instVars : [
		'weightsBuffer',
		'biasesBuffer',
		'window',
		'outChannels'
	],
	#category : 'Rudesheim-NeuralNetwork-OpenCL-Private',
	#package : 'Rudesheim-NeuralNetwork-OpenCL-Private'
}

{ #category : 'accessing' }
Conv2DLayerOpenCLNeuralNetworkMachineLearningRudesheim >> biases [

	^ OpenCLNeuralNetworkMachineLearningRudesheim commandQueue
		readFloatsFrom:	biasesBuffer
		count:				outChannels
]

{ #category : 'evaluating' }
Conv2DLayerOpenCLNeuralNetworkMachineLearningRudesheim >> backward:	aTBackwardContextNeuralNetworkMachineLearningRudesheim [

	|
		queue
		inChannels
		inRows
		inColumns
		outRows
		outColumns
		kernelRows
		kernelColumns
		inputCount
		weightCount
		inputBuffer
		gradientBuffer
		inputGradientBuffer
		biasGradientBuffer
		weightGradientBuffer
		biasGradientKernel
		weightGradientKernel
		inputGradientKernel
	|

	inChannels := window inputChannels.
	inRows := window inputRows.
	inColumns := window inputColumns.
	outRows := window outputRows.
	outColumns := window outputColumns.
	kernelRows := window kernelRows.
	kernelColumns := window kernelColumns.
	inputCount := inChannels * inRows * inColumns.
	weightCount := outChannels * inChannels * kernelRows * kernelColumns.

	queue := OpenCLNeuralNetworkMachineLearningRudesheim commandQueue.
	inputBuffer := OpenCLNeuralNetworkMachineLearningRudesheim context newCLBufferWithFloats: aTBackwardContextNeuralNetworkMachineLearningRudesheim inputPredictions asArray.
	gradientBuffer := OpenCLNeuralNetworkMachineLearningRudesheim context newCLBufferWithFloats: aTBackwardContextNeuralNetworkMachineLearningRudesheim gradient asArray.
	inputGradientBuffer := OpenCLNeuralNetworkMachineLearningRudesheim context newCLBufferForSize: inputCount * TFBasicType float byteSize.
	biasGradientBuffer := OpenCLNeuralNetworkMachineLearningRudesheim context newCLBufferForSize: outChannels * TFBasicType float byteSize.
	weightGradientBuffer := OpenCLNeuralNetworkMachineLearningRudesheim context newCLBufferForSize: weightCount * TFBasicType float byteSize.

	biasGradientKernel :=
		OpenCLNeuralNetworkMachineLearningRudesheim
			kernelAt:				'Conv2dBiasGradient'
			parameterTypes:
			{
				TFBasicType pointer.
				TFBasicType pointer.
				TFBasicType uint.
				TFBasicType uint.
				TFBasicType uint.
			}.
	weightGradientKernel :=
		OpenCLNeuralNetworkMachineLearningRudesheim
			kernelAt:				'Conv2dWeightGradient'
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
				TFBasicType uint.
				TFBasicType uint.
				TFBasicType sint.
				TFBasicType sint.
			}.
	inputGradientKernel :=
		OpenCLNeuralNetworkMachineLearningRudesheim
			kernelAt:				'Conv2dInputGradient'
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
				TFBasicType uint.
				TFBasicType uint.
				TFBasicType sint.
				TFBasicType sint.
			}.

	^
	[
		queue
			enqueueKernelAndWait:	biasGradientKernel
			forNDRange:				{ { outChannels } }
			withArguments:			{ gradientBuffer. biasGradientBuffer. outChannels. outRows. outColumns }.

		queue
			enqueueKernelAndWait:	weightGradientKernel
			forNDRange:				{ { outChannels. inChannels } }
			withArguments:
			{
				inputBuffer.
				gradientBuffer.
				weightGradientBuffer.
				inChannels.
				inRows.
				inColumns.
				outChannels.
				outRows.
				outColumns.
				kernelRows.
				kernelColumns.
				window strideRows.
				window strideColumns.
				window paddingTopRows.
				window paddingLeftColumns.
			}.

		queue
			enqueueKernelAndWait:	inputGradientKernel
			forNDRange:				{ { inChannels. inRows. inColumns } }
			withArguments:
			{
				weightsBuffer.
				gradientBuffer.
				inputGradientBuffer.
				inChannels.
				inRows.
				inColumns.
				outChannels.
				outRows.
				outColumns.
				kernelRows.
				kernelColumns.
				window strideRows.
				window strideColumns.
				window paddingTopRows.
				window paddingLeftColumns.
			}.

		{
			queue readFloatsFrom: inputGradientBuffer count: inputCount.
			Conv2DLayerOpenCLNeuralNetworkMachineLearningRudesheim
				weights:	( queue readFloatsFrom: weightGradientBuffer count: weightCount )
				biases:		( queue readFloatsFrom: biasGradientBuffer count: outChannels )
				window:		window.
		}
	]
		ensure:
		[
			inputBuffer release.
			gradientBuffer release.
			inputGradientBuffer release.
			biasGradientBuffer release.
			weightGradientBuffer release.
		].
]

{ #category : 'instance creation' }
Conv2DLayerOpenCLNeuralNetworkMachineLearningRudesheim class >> fromSoilGraphNodeRecord:	aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim [

	|
		weightsDescriptor
		biasesDescriptor
	|

	weightsDescriptor :=
		aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim tensorDescriptorRecords
			detect: [ :each | each tensorKindClass = WeightsTensorSoilNeuralNetworkMachineLearningRudesheim ].
	biasesDescriptor :=
		aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim tensorDescriptorRecords
			detect: [ :each | each tensorKindClass = BiasesTensorSoilNeuralNetworkMachineLearningRudesheim ].

	^ self
		weights:	weightsDescriptor payload
		biases:		biasesDescriptor payload
		window:		aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim layerAttributesRecords first
]

{ #category : 'accessing' }
Conv2DLayerOpenCLNeuralNetworkMachineLearningRudesheim class >> species [

	^ Conv2DLayerOpenCLNeuralNetworkMachineLearningRudesheim
]

{ #category : 'instance creation' }
Conv2DLayerOpenCLNeuralNetworkMachineLearningRudesheim class >> weights:	aWeightsSequenceableCollection
biases:	aBiasesSequenceableCollection
window:	aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim [

	^ super new
		setWeights:	aWeightsSequenceableCollection
		biases:		aBiasesSequenceableCollection
		window:		aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim;
		yourself
]

{ #category : 'evaluating' }
Conv2DLayerOpenCLNeuralNetworkMachineLearningRudesheim >> forward:	anInputNumbersSequencialCollection [

	|
		queue
		inputBuffer
		outputBuffer
		kernel
		outputCount
		kernelEvent
	|

	queue := OpenCLNeuralNetworkMachineLearningRudesheim commandQueue.
	inputBuffer := anInputNumbersSequencialCollection asOpenCLBufferRudesheim: OpenCLNeuralNetworkMachineLearningRudesheim context.
	outputCount := outChannels * window outputRows * window outputColumns.
	outputBuffer := OpenCLNeuralNetworkMachineLearningRudesheim context newCLBufferForSize: outputCount * TFBasicType float byteSize.
	outputBuffer
		count:		outputCount;
		queue:		queue;
		context:	OpenCLNeuralNetworkMachineLearningRudesheim context.
	kernel :=
		OpenCLNeuralNetworkMachineLearningRudesheim
			kernelAt:				'Conv2dForward'
			parameterTypes:
			{
				TFBasicType pointer.
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
				TFBasicType uint.
				TFBasicType uint.
				TFBasicType sint.
				TFBasicType sint.
			}.

	^
	[
		"Not enqueueKernelAndWait: -- see AddLayerOpenCL>>forward: for the
		in-order-queue rationale and why kernelEvent is only waited on in
		the ensure: block below."
		kernelEvent :=
			queue
				enqueueKernel:	kernel
				forNDRange:				{ { outChannels. window outputRows. window outputColumns } }
				withArguments:
				{
					weightsBuffer.
					biasesBuffer.
					inputBuffer.
					outputBuffer.
					window inputChannels.
					window inputRows.
					window inputColumns.
					outChannels.
					window outputRows.
					window outputColumns.
					window kernelRows.
					window kernelColumns.
					window strideRows.
					window strideColumns.
					window paddingTopRows.
					window paddingLeftColumns.
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
Conv2DLayerOpenCLNeuralNetworkMachineLearningRudesheim >> setWeights:	aWeightsSequenceableCollection
biases:	aBiasesSequenceableCollection
window:	aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim [

	window := aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim.
	outChannels :=
		aWeightsSequenceableCollection size
			/ ( window inputChannels * window kernelRows * window kernelColumns ).

	weightsBuffer := OpenCLNeuralNetworkMachineLearningRudesheim context newCLBufferWithFloats: aWeightsSequenceableCollection asArray.
	biasesBuffer := OpenCLNeuralNetworkMachineLearningRudesheim context newCLBufferWithFloats: aBiasesSequenceableCollection asArray
]

{ #category : 'converting' }
Conv2DLayerOpenCLNeuralNetworkMachineLearningRudesheim >> withUpdatedWeightsRows:	aConv2DLayerOpenCLNeuralNetworkMachineLearningRudesheim
learningRate:				aRateFloat [

	|
		adjust
	|

	adjust :=
	[ :left :right |
		left - ( aRateFloat * right )
	].

	^ self species
		weights:
		(
			self weights
				with:		aConv2DLayerOpenCLNeuralNetworkMachineLearningRudesheim weights
				collect:	adjust
		)
		biases:
		(
			adjust
				value:	self biases
				value:	aConv2DLayerOpenCLNeuralNetworkMachineLearningRudesheim biases
		)
		window:	window
]

{ #category : 'releasing' }
Conv2DLayerOpenCLNeuralNetworkMachineLearningRudesheim >> releaseRudesheim [
	"See LinearTransformLayerOpenCL>>releaseRudesheim for why this exists."

	weightsBuffer releaseRudesheim.
	biasesBuffer releaseRudesheim.
]

{ #category : 'accessing' }
Conv2DLayerOpenCLNeuralNetworkMachineLearningRudesheim >> weights [

	^ OpenCLNeuralNetworkMachineLearningRudesheim commandQueue
		readFloatsFrom:	weightsBuffer
		count:				outChannels * window inputChannels * window kernelRows * window kernelColumns
]
