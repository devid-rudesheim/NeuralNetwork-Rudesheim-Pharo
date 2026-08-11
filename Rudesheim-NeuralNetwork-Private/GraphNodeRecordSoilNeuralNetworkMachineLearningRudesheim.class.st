"
GraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim is the internal Soil-store graph record for one neural network node. It stores class objects directly so loading from Soil to a Rudesheim Model does not need external-format name conversion.
"
Class {
	#name : 'GraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#instVars : [
		'layerClass',
		'predecessorRecords',
		'tensorDescriptorRecords',
		'layerAttributesRecords'
	],
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'instance creation' }
GraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim class >> layerClass:	aClass
predecessorRecords:	aPredecessorRecordsSequenceableCollection
tensorDescriptorRecords:	aTensorDescriptorRecordsSequenceableCollection [

	^ super new
		setLayerClass:				aClass
		predecessorRecords:		aPredecessorRecordsSequenceableCollection
		tensorDescriptorRecords:	aTensorDescriptorRecordsSequenceableCollection;
		yourself
]

{ #category : 'accessing' }
GraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim >> layerAttributesRecords [

	^ layerAttributesRecords
		ifNil: [ layerAttributesRecords := OrderedCollection new ]
]

{ #category : 'accessing' }
GraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim >> layerAttributesRecords: aLayerAttributesRecordsSequenceableCollection [

	layerAttributesRecords := aLayerAttributesRecordsSequenceableCollection
]

{ #category : 'accessing' }
GraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim >> layerClass [

	^ layerClass
]

{ #category : 'accessing' }
GraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim >> predecessorRecords [

	^ predecessorRecords
]

{ #category : 'initialization' }
GraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim >> setLayerClass:	aClass
predecessorRecords:	aPredecessorRecordsSequenceableCollection
tensorDescriptorRecords:	aTensorDescriptorRecordsSequenceableCollection [

	layerClass				:=	aClass.
	predecessorRecords		:=	aPredecessorRecordsSequenceableCollection.
	tensorDescriptorRecords	:=	aTensorDescriptorRecordsSequenceableCollection
]

{ #category : 'accessing' }
GraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim >> tensorDescriptorRecords [

	^ tensorDescriptorRecords
]
