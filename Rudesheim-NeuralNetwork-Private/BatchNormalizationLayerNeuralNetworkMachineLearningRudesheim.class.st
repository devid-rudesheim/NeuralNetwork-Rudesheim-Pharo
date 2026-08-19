"
BatchNormalizationLayerNeuralNetworkMachineLearningRudesheim is the Pure (plain Smalltalk, no FFI/GPU) counterpart of BatchNormalizationLayerOpenCLNeuralNetworkMachineLearningRudesheim: a per-channel affine (scale/shift) layer implementing ONNX BatchNormalization at inference time. scale/shift are precomputed from gamma/beta/mean/var/epsilon by tool/onnx_to_ston.py and carried as the existing Weights/Biases tensor kinds, one value per channel. It reuses WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim purely to carry (channels, rows, columns) -- kernel/stride/padding fields are inert placeholders, unused by forward:. It has no backward (forward-only, inference scope).
"
Class {
	#name : 'BatchNormalizationLayerNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#traits : 'TShouldntNewRudesheim',
	#classTraits : 'TShouldntNewRudesheim classTrait',
	#instVars : [
		'scale',
		'shift',
		'window'
	],
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'as yet unclassified' }
BatchNormalizationLayerNeuralNetworkMachineLearningRudesheim class >> fromSoilGraphNodeRecord: aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim [
	|
		scaleDescriptor
		shiftDescriptor
	|

	scaleDescriptor :=
		aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim tensorDescriptorRecords
			detect:
			[ :each |
				each
					tensorKindClass
					= WeightsTensorSoilNeuralNetworkMachineLearningRudesheim.
			].

	shiftDescriptor :=
		aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim tensorDescriptorRecords
			detect:
			[ :each |
				each
					tensorKindClass
					= BiasesTensorSoilNeuralNetworkMachineLearningRudesheim.
			].

	^ self
		scale:	scaleDescriptor payload
		shift:	shiftDescriptor payload
		window:	
		aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim
			layerAttributesRecords
			first.
]

{ #category : 'as yet unclassified' }
BatchNormalizationLayerNeuralNetworkMachineLearningRudesheim class >> nameForONNX [
	^ 'BatchNormalization'.
]

{ #category : 'as yet unclassified' }
BatchNormalizationLayerNeuralNetworkMachineLearningRudesheim class >> scale: aScaleSequenceableCollection
shift: aShiftSequenceableCollection
window: aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim [
	^ super new
		setScale:	aScaleSequenceableCollection
		shift:	aShiftSequenceableCollection
		window:	aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim;
		yourself.
]

{ #category : 'as yet unclassified' }
BatchNormalizationLayerNeuralNetworkMachineLearningRudesheim class >> species [
	^ BatchNormalizationLayerNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'as yet unclassified' }
BatchNormalizationLayerNeuralNetworkMachineLearningRudesheim >> forward: anInputNumbersSequencialCollection [
	|
		channels
		spatialCount
		output
		i
	|

	channels := window inputChannels.
	spatialCount := window input rows * window input columns.

	output :=
		Array
			new:	channels * spatialCount.

	1
		to:	channels
		do:
		[ :c |
			1
				to:	spatialCount
				do:
				[ :p |
					i := (c - 1) * spatialCount + p.

					output
						at:	i
						put:	
						(
							anInputNumbersSequencialCollection
								at:	i
						)
							* (scale at: c)
							+ (shift at: c).
				].
		].

	^ output.
]

{ #category : 'as yet unclassified' }
BatchNormalizationLayerNeuralNetworkMachineLearningRudesheim >> setScale: aScaleSequenceableCollection
shift: aShiftSequenceableCollection
window: aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim [
	window := aWindowSpecificationSoilNeuralNetworkMachineLearningRudesheim.
	scale := aScaleSequenceableCollection.
	shift := aShiftSequenceableCollection.
]
