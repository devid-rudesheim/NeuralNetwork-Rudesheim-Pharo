"
WeightsSourceSoilNeuralNetworkMachineLearningRudesheim will lazily read layer weights from the Soil-backed internal model store. It keeps large tensor payload handling out of model construction. The underlying Weights tensor's payload is a flat sequence (Soil never persists a nested/row-based view, to avoid the object-identity bookkeeping cost of many small Arrays -- see note/resnet50-onnx-support-plan.md 2026-08-09追記(4)); weightsRows reshapes it into nested rows using the tensor's shape, once per call, matching what both LinearTransformLayer backends expect.
"
Class {
	#name : 'WeightsSourceSoilNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#traits : 'TWeightsSourceNeuralNetworkMachineLearningRudesheim',
	#classTraits : 'TWeightsSourceNeuralNetworkMachineLearningRudesheim classTrait',
	#instVars : [
		'tensorDescriptorRecords'
	],
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'instance creation' }
WeightsSourceSoilNeuralNetworkMachineLearningRudesheim class >> tensorDescriptorRecords:	aTensorDescriptorRecordsSequenceableCollection [

	^ super new
		setTensorDescriptorRecords:	aTensorDescriptorRecordsSequenceableCollection;
		yourself
]

{ #category : 'accessing' }
WeightsSourceSoilNeuralNetworkMachineLearningRudesheim >> biases [

	^ self payloadForTensorKindClass: Rudesheim MachineLearning NeuralNetwork Soil Tensor Biases
]

{ #category : 'private' }
WeightsSourceSoilNeuralNetworkMachineLearningRudesheim >> descriptorForTensorKindClass:	aClass [

	^ tensorDescriptorRecords
		detect: [ :eachTensorDescriptorRecord | eachTensorDescriptorRecord tensorKindClass == aClass ]
]

{ #category : 'private' }
WeightsSourceSoilNeuralNetworkMachineLearningRudesheim >> payloadForTensorKindClass:	aClass [

	^ ( self descriptorForTensorKindClass: aClass ) payload
]

{ #category : 'initialization' }
WeightsSourceSoilNeuralNetworkMachineLearningRudesheim >> setTensorDescriptorRecords:	aTensorDescriptorRecordsSequenceableCollection [

	tensorDescriptorRecords := aTensorDescriptorRecordsSequenceableCollection
]

{ #category : 'accessing' }
WeightsSourceSoilNeuralNetworkMachineLearningRudesheim >> tensorDescriptorRecords [

	^ tensorDescriptorRecords
]

{ #category : 'accessing' }
WeightsSourceSoilNeuralNetworkMachineLearningRudesheim >> weightsRows [

	|
		weightsDescriptor
		flatWeights
		rows
		columns
	|

	weightsDescriptor := self descriptorForTensorKindClass: Rudesheim MachineLearning NeuralNetwork Soil Tensor Weights.
	flatWeights := weightsDescriptor payload.
	rows := weightsDescriptor shape first.
	columns := weightsDescriptor shape second.

	^ ( 1 to: rows )
		collect:
		[ :eachRowIndex |
			flatWeights
				copyFrom:	( eachRowIndex - 1 ) * columns + 1
				to:			eachRowIndex * columns
		]
]
