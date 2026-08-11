"
ModelSymbolSoilNeuralNetworkMachineLearningRudesheim identifies one model inside a Soil neural network store. It is deliberately distinct from Smalltalk Symbol so store roots can validate model keys.
"
Class {
	#name : 'ModelSymbolSoilNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#instVars : [
		'name'
	],
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'instance creation' }
ModelSymbolSoilNeuralNetworkMachineLearningRudesheim class >> name: aString [

	^ super new
		setName: aString;
		yourself
]

{ #category : 'comparing' }
ModelSymbolSoilNeuralNetworkMachineLearningRudesheim >> = anObject [

	^ self class = anObject class
		and: [ self name = anObject name ]
]

{ #category : 'comparing' }
ModelSymbolSoilNeuralNetworkMachineLearningRudesheim >> hash [

	^ self class hash bitXor: self name hash
]

{ #category : 'accessing' }
ModelSymbolSoilNeuralNetworkMachineLearningRudesheim >> name [

	^ name
]

{ #category : 'printing' }
ModelSymbolSoilNeuralNetworkMachineLearningRudesheim >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: '(';
		nextPutAll: self name;
		nextPutAll: ')'
]

{ #category : 'initialization' }
ModelSymbolSoilNeuralNetworkMachineLearningRudesheim >> setName: aString [

	aString isString
		ifFalse: [ self error: 'Model name must be a String' ].
	aString isEmpty
		ifTrue: [ self error: 'Model name must not be empty' ].
	name := aString
]
