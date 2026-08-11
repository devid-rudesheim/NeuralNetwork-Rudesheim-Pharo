"
StoreRootSoilNeuralNetworkMachineLearningRudesheim is the root object of a Soil-backed neural network store. It behaves like a dictionary for model records while enforcing dedicated model key objects.
"
Class {
	#name : 'StoreRootSoilNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#instVars : [
		'models'
	],
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'accessing' }
StoreRootSoilNeuralNetworkMachineLearningRudesheim >> associationsDo: aBlock [

	^ self models associationsDo: aBlock
]

{ #category : 'accessing' }
StoreRootSoilNeuralNetworkMachineLearningRudesheim >> at: aModelSymbolSoilNeuralNetworkMachineLearningRudesheim [

	self validateModelSymbol: aModelSymbolSoilNeuralNetworkMachineLearningRudesheim.
	^ self models at: aModelSymbolSoilNeuralNetworkMachineLearningRudesheim
]

{ #category : 'accessing' }
StoreRootSoilNeuralNetworkMachineLearningRudesheim >> at: aModelSymbolSoilNeuralNetworkMachineLearningRudesheim put: aModelRecordSoilNeuralNetworkMachineLearningRudesheim [

	self validateModelSymbol: aModelSymbolSoilNeuralNetworkMachineLearningRudesheim.
	self validateModelRecord: aModelRecordSoilNeuralNetworkMachineLearningRudesheim.
	^ self models
		at: aModelSymbolSoilNeuralNetworkMachineLearningRudesheim
		put: aModelRecordSoilNeuralNetworkMachineLearningRudesheim
]

{ #category : 'accessing' }
StoreRootSoilNeuralNetworkMachineLearningRudesheim >> at: aModelSymbolSoilNeuralNetworkMachineLearningRudesheim ifAbsentPut: aBlock [

	self validateModelSymbol: aModelSymbolSoilNeuralNetworkMachineLearningRudesheim.
	^ self models
		at: aModelSymbolSoilNeuralNetworkMachineLearningRudesheim
		ifAbsentPut:
		[
			| modelRecord |
			modelRecord := aBlock value.
			self validateModelRecord: modelRecord.
			modelRecord
		]
]

{ #category : 'accessing' }
StoreRootSoilNeuralNetworkMachineLearningRudesheim >> includesKey: aModelSymbolSoilNeuralNetworkMachineLearningRudesheim [

	self validateModelSymbol: aModelSymbolSoilNeuralNetworkMachineLearningRudesheim.
	^ self models includesKey: aModelSymbolSoilNeuralNetworkMachineLearningRudesheim
]

{ #category : 'accessing' }
StoreRootSoilNeuralNetworkMachineLearningRudesheim >> keys [

	^ self models keys
]

{ #category : 'accessing' }
StoreRootSoilNeuralNetworkMachineLearningRudesheim >> modelNames [

	^ self keys collect: [ :eachModelSymbol | eachModelSymbol name ]
]

{ #category : 'private' }
StoreRootSoilNeuralNetworkMachineLearningRudesheim >> models [

	^ models
		ifNil: [ models := Dictionary new ]
]

{ #category : 'removing' }
StoreRootSoilNeuralNetworkMachineLearningRudesheim >> removeKey: aModelSymbolSoilNeuralNetworkMachineLearningRudesheim [

	self validateModelSymbol: aModelSymbolSoilNeuralNetworkMachineLearningRudesheim.
	^ self models removeKey: aModelSymbolSoilNeuralNetworkMachineLearningRudesheim
]

{ #category : 'accessing' }
StoreRootSoilNeuralNetworkMachineLearningRudesheim >> symbolByName: aString [

	^ ModelSymbolSoilNeuralNetworkMachineLearningRudesheim name: aString
]

{ #category : 'private' }
StoreRootSoilNeuralNetworkMachineLearningRudesheim >> validateModelRecord: anObject [

	anObject class = ModelRecordSoilNeuralNetworkMachineLearningRudesheim
		ifFalse: [ self error: 'Model record must be a ModelRecordSoilNeuralNetworkMachineLearningRudesheim' ].
	^ anObject
]

{ #category : 'private' }
StoreRootSoilNeuralNetworkMachineLearningRudesheim >> validateModelSymbol: anObject [

	anObject class = ModelSymbolSoilNeuralNetworkMachineLearningRudesheim
		ifFalse: [ self error: 'Model key must be a ModelSymbolSoilNeuralNetworkMachineLearningRudesheim' ].
	^ anObject
]

{ #category : 'accessing' }
StoreRootSoilNeuralNetworkMachineLearningRudesheim >> values [

	^ self models values
]
