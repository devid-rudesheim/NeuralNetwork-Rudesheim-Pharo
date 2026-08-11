"
ModelRecordSoilNeuralNetworkMachineLearningRudesheim stores the internal Soil representation of one neural network model.
"
Class {
	#name : 'ModelRecordSoilNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#instVars : [
		'formatClass',
		'externalFileReference',
		'externalPayload',
		'graphNodeRecords',
		'tensorDescriptorRecords',
		'outputGraphNodeRecord',
		'metadata'
	],
	#traits : 'TModelSourceNeuralNetworkMachineLearningRudesheim',
	#classTraits : 'TModelSourceNeuralNetworkMachineLearningRudesheim classTrait',
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'adding' }
ModelRecordSoilNeuralNetworkMachineLearningRudesheim >> addGraphNodeRecord: aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim [

	self graphNodeRecords add: aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim.
	^ aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim
]

{ #category : 'adding' }
ModelRecordSoilNeuralNetworkMachineLearningRudesheim >> addTensorDescriptorRecord: aTensorDescriptorSoilNeuralNetworkMachineLearningRudesheim [

	self tensorDescriptorRecords add: aTensorDescriptorSoilNeuralNetworkMachineLearningRudesheim.
	^ aTensorDescriptorSoilNeuralNetworkMachineLearningRudesheim
]

{ #category : 'accessing' }
ModelRecordSoilNeuralNetworkMachineLearningRudesheim >> externalFileReference [

	^ externalFileReference
]

{ #category : 'accessing' }
ModelRecordSoilNeuralNetworkMachineLearningRudesheim >> externalFileReference: aFileReference [

	externalFileReference := aFileReference
]

{ #category : 'accessing' }
ModelRecordSoilNeuralNetworkMachineLearningRudesheim >> externalPayload [

	^ externalPayload
]

{ #category : 'accessing' }
ModelRecordSoilNeuralNetworkMachineLearningRudesheim >> externalPayload: aByteArray [

	externalPayload := aByteArray
]

{ #category : 'accessing' }
ModelRecordSoilNeuralNetworkMachineLearningRudesheim >> formatClass [

	^ formatClass
]

{ #category : 'accessing' }
ModelRecordSoilNeuralNetworkMachineLearningRudesheim >> formatClass: aClass [

	formatClass := aClass
]

{ #category : 'accessing' }
ModelRecordSoilNeuralNetworkMachineLearningRudesheim >> graphNodeRecords [

	^ graphNodeRecords
		ifNil: [ graphNodeRecords := OrderedCollection new ]
]

{ #category : 'accessing' }
ModelRecordSoilNeuralNetworkMachineLearningRudesheim >> metadata [

	^ metadata
		ifNil: [ metadata := Dictionary new ]
]

{ #category : 'private' }
ModelRecordSoilNeuralNetworkMachineLearningRudesheim >> nodeForGraphNodeRecord:	aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim
cache:	anIdentityDictionary [

	^ anIdentityDictionary
		at:	aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim
		ifAbsentPut:
		[
			Rudesheim MachineLearning NeuralNetwork Node
				layer:
					(
						aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim layerClass
							fromSoilGraphNodeRecord:	aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim
					)
				predecessors:
					(
						aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim predecessorRecords
							collect:
							[ :eachPredecessorRecord |
								self
									nodeForGraphNodeRecord:	eachPredecessorRecord
									cache:					anIdentityDictionary
							]
					)
		]
]

{ #category : 'reading' }
ModelRecordSoilNeuralNetworkMachineLearningRudesheim >> nextModelAs:	aClass [

	^ aClass outputNode:
		(
			self
				nodeForGraphNodeRecord:	self outputGraphNodeRecord
				cache:					IdentityDictionary new
		)
]

{ #category : 'accessing' }
ModelRecordSoilNeuralNetworkMachineLearningRudesheim >> outputGraphNodeRecord [

	^ outputGraphNodeRecord
]

{ #category : 'accessing' }
ModelRecordSoilNeuralNetworkMachineLearningRudesheim >> outputGraphNodeRecord: aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim [

	(self graphNodeRecords includes: aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim)
		ifFalse: [ self error: 'Output graph node must belong to the model record' ].
	outputGraphNodeRecord := aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim
]

{ #category : 'accessing' }
ModelRecordSoilNeuralNetworkMachineLearningRudesheim >> tensorDescriptorRecords [

	^ tensorDescriptorRecords
		ifNil: [ tensorDescriptorRecords := OrderedCollection new ]
]
