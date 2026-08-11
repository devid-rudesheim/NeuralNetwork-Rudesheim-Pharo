"
BatchNormalizationLayerOpenCLNeuralNetworkMachineLearningRudesheim is a per-channel affine (scale/shift) layer that runs on the OpenCL backend, implementing ONNX BatchNormalization at inference time. scale/shift are precomputed from gamma/beta/mean/var/epsilon by tool/onnx_to_ston.py (scale = gamma / sqrt(var + epsilon), shift = beta - gamma * mean / sqrt(var + epsilon)) and carried as the existing Weights/Biases tensor kinds, one value per channel. It is implemented as its own Layer rather than folded into a neighboring Conv2D: real resnet50-v2-7.onnx BatchNorm nodes are not always Conv-adjacent (some directly follow MaxPool2D or a residual Add, which cannot always absorb a per-channel affine transform), and some carry negative gamma, which makes algebraic Conv-folding unsafe in general (see note/resnet50-onnx-support-plan.md and note/decisions.md). It reuses WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim purely to carry (channels, rows, columns) -- kernel/stride/padding fields are inert placeholders, unused by forward:. backward: treats scale/shift as directly-learned affine parameters (this layer is used at inference time, not as a batch-statistics-recomputing training-mode BatchNorm): input_gradient = gradient * scale (per channel), scale_gradient[c] = sum over spatial positions of gradient[c,p] * input[c,p], shift_gradient[c] = sum over spatial positions of gradient[c,p].
"
Class {
	#name : 'BatchNormalizationLayerOpenCLNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#traits : 'TLayerNeuralNetworkMachineLearningRudesheim',
	#classTraits : 'TLayerNeuralNetworkMachineLearningRudesheim classTrait',
	#instVars : [
		'scaleBuffer',
		'shiftBuffer',
		'window'
	],
	#category : 'Rudesheim-NeuralNetwork-OpenCL-Private',
	#package : 'Rudesheim-NeuralNetwork-OpenCL-Private'
}

{ #category : 'releasing' }
BatchNormalizationLayerOpenCLNeuralNetworkMachineLearningRudesheim >> releaseRudesheim [
	"See LinearTransformLayerOpenCL>>releaseRudesheim for why this exists."

	scaleBuffer releaseRudesheim.
	shiftBuffer releaseRudesheim.
]

{ #category : 'evaluating' }
BatchNormalizationLayerOpenCLNeuralNetworkMachineLearningRudesheim >> backward:	aTBackwardContextNeuralNetworkMachineLearningRudesheim [

	|
		queue
		channels
		spatialCount
		inputBuffer
		gradientBuffer
		inputGradientBuffer
		scaleGradientBuffer
		shiftGradientBuffer
		inputGradientKernel
		paramGradientKernel
	|

	channels := window inputChannels.
	spatialCount := window inputRows * window inputColumns.
	queue := OpenCLNeuralNetworkMachineLearningRudesheim commandQueue.
	inputBuffer := OpenCLNeuralNetworkMachineLearningRudesheim context newCLBufferWithFloats: aTBackwardContextNeuralNetworkMachineLearningRudesheim inputPredictions asArray.
	gradientBuffer := OpenCLNeuralNetworkMachineLearningRudesheim context newCLBufferWithFloats: aTBackwardContextNeuralNetworkMachineLearningRudesheim gradient asArray.
	inputGradientBuffer := OpenCLNeuralNetworkMachineLearningRudesheim context newCLBufferForSize: channels * spatialCount * TFBasicType float byteSize.
	scaleGradientBuffer := OpenCLNeuralNetworkMachineLearningRudesheim context newCLBufferForSize: channels * TFBasicType float byteSize.
	shiftGradientBuffer := OpenCLNeuralNetworkMachineLearningRudesheim context newCLBufferForSize: channels * TFBasicType float byteSize.
	inputGradientKernel :=
		OpenCLNeuralNetworkMachineLearningRudesheim
			kernelAt:				'BatchNormalizationInputGradient'
			parameterTypes:
			{
				TFBasicType pointer.
				TFBasicType pointer.
				TFBasicType pointer.
				TFBasicType uint.
				TFBasicType uint.
			}.
	paramGradientKernel :=
		OpenCLNeuralNetworkMachineLearningRudesheim
			kernelAt:				'BatchNormalizationParamGradient'
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
		queue
			enqueueKernelAndWait:	inputGradientKernel
			forNDRange:				{ { channels. spatialCount } }
			withArguments:			{ scaleBuffer. gradientBuffer. inputGradientBuffer. channels. spatialCount }.
		queue
			enqueueKernelAndWait:	paramGradientKernel
			forNDRange:				{ { channels } }
			withArguments:			{ inputBuffer. gradientBuffer. scaleGradientBuffer. shiftGradientBuffer. channels. spatialCount }.

		{
			queue readFloatsFrom: inputGradientBuffer count: channels * spatialCount.
			BatchNormalizationLayerOpenCLNeuralNetworkMachineLearningRudesheim
				scale:	( queue readFloatsFrom: scaleGradientBuffer count: channels )
				shift:	( queue readFloatsFrom: shiftGradientBuffer count: channels )
				window:	window.
		}
	]
		ensure:
		[
			inputBuffer release.
			gradientBuffer release.
			inputGradientBuffer release.
			scaleGradientBuffer release.
			shiftGradientBuffer release.
		].
]

{ #category : 'instance creation' }
BatchNormalizationLayerOpenCLNeuralNetworkMachineLearningRudesheim class >> fromSoilGraphNodeRecord:	aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim [

	|
		scaleDescriptor
		shiftDescriptor
	|

	scaleDescriptor :=
		aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim tensorDescriptorRecords
			detect: [ :each | each tensorKindClass = WeightsTensorSoilNeuralNetworkMachineLearningRudesheim ].
	shiftDescriptor :=
		aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim tensorDescriptorRecords
			detect: [ :each | each tensorKindClass = BiasesTensorSoilNeuralNetworkMachineLearningRudesheim ].

	^ self
		scale:	scaleDescriptor payload
		shift:	shiftDescriptor payload
		window:	aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim layerAttributesRecords first
]

{ #category : 'accessing' }
BatchNormalizationLayerOpenCLNeuralNetworkMachineLearningRudesheim class >> scale:	aScaleSequenceableCollection
shift:	aShiftSequenceableCollection
window:	aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim [

	^ super new
		setScale:	aScaleSequenceableCollection
		shift:		aShiftSequenceableCollection
		window:		aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim;
		yourself
]

{ #category : 'accessing' }
BatchNormalizationLayerOpenCLNeuralNetworkMachineLearningRudesheim class >> species [

	^ BatchNormalizationLayerOpenCLNeuralNetworkMachineLearningRudesheim
]

{ #category : 'evaluating' }
BatchNormalizationLayerOpenCLNeuralNetworkMachineLearningRudesheim >> forward:	anInputNumbersSequencialCollection [

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
	outputCount := window inputChannels * window inputRows * window inputColumns.
	outputBuffer := OpenCLNeuralNetworkMachineLearningRudesheim context newCLBufferForSize: outputCount * TFBasicType float byteSize.
	outputBuffer
		count:		outputCount;
		queue:		queue;
		context:	OpenCLNeuralNetworkMachineLearningRudesheim context.
	kernel :=
		OpenCLNeuralNetworkMachineLearningRudesheim
			kernelAt:				'BatchNormalizationForward'
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
		"Not enqueueKernelAndWait: -- see AddLayerOpenCL>>forward: for the
		in-order-queue rationale and why kernelEvent is only waited on in
		the ensure: block below."
		kernelEvent :=
			queue
				enqueueKernel:	kernel
				forNDRange:				{ { window inputChannels. window inputRows * window inputColumns } }
				withArguments:
				{
					scaleBuffer.
					shiftBuffer.
					inputBuffer.
					outputBuffer.
					window inputChannels.
					window inputRows * window inputColumns.
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

{ #category : 'accessing' }
BatchNormalizationLayerOpenCLNeuralNetworkMachineLearningRudesheim >> scale [

	^ OpenCLNeuralNetworkMachineLearningRudesheim commandQueue
		readFloatsFrom:	scaleBuffer
		count:				window inputChannels
]

{ #category : 'initialization' }
BatchNormalizationLayerOpenCLNeuralNetworkMachineLearningRudesheim >> setScale:	aScaleSequenceableCollection
shift:	aShiftSequenceableCollection
window:	aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim [

	window := aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim.
	scaleBuffer := OpenCLNeuralNetworkMachineLearningRudesheim context newCLBufferWithFloats: aScaleSequenceableCollection asArray.
	shiftBuffer := OpenCLNeuralNetworkMachineLearningRudesheim context newCLBufferWithFloats: aShiftSequenceableCollection asArray
]

{ #category : 'accessing' }
BatchNormalizationLayerOpenCLNeuralNetworkMachineLearningRudesheim >> shift [

	^ OpenCLNeuralNetworkMachineLearningRudesheim commandQueue
		readFloatsFrom:	shiftBuffer
		count:				window inputChannels
]

{ #category : 'converting' }
BatchNormalizationLayerOpenCLNeuralNetworkMachineLearningRudesheim >> withUpdatedWeightsRows:	aTBatchNormalizationLayerNeuralNetworkMachineLearningRudesheim
learningRate:				aRateFloat [

	|
		adjust
	|

	adjust :=
	[ :left :right |
		left - ( aRateFloat * right )
	].

	^ self species
		scale:
		(
			self scale
				with:		aTBatchNormalizationLayerNeuralNetworkMachineLearningRudesheim scale
				collect:	adjust
		)
		shift:
		(
			self shift
				with:		aTBatchNormalizationLayerNeuralNetworkMachineLearningRudesheim shift
				collect:	adjust
		)
		window:	window
]
