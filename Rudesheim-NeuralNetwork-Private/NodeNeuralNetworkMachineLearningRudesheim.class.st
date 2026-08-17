Class {
	#name : 'NodeNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#traits : 'TNodeNeuralNetworkMachineLearningRudesheim + TShouldntNewRudesheim',
	#classTraits : 'TNodeNeuralNetworkMachineLearningRudesheim classTrait + TShouldntNewRudesheim classTrait',
	#instVars : [
		'layer',
		'predecessors'
	],
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'accessing' }
NodeNeuralNetworkMachineLearningRudesheim class >> defaultPredecessors [

	^ #()
]

{ #category : 'accessing' }
NodeNeuralNetworkMachineLearningRudesheim >> defaultPredecessors [

	^ self class defaultPredecessors
]

{ #category : 'accessing' }
NodeNeuralNetworkMachineLearningRudesheim >> layer [

	^ layer
]

{ #category : 'accessing' }
NodeNeuralNetworkMachineLearningRudesheim >> predecessors [

	^ predecessors
		ifNil: [ predecessors := self defaultPredecessors ]
]

{ #category : 'initialization' }
NodeNeuralNetworkMachineLearningRudesheim >> setLayer: aTLayerNeuralNetworkMachineLearningRudesheim predecessors: aPredecessorsSequenceableCollection [

	layer := aTLayerNeuralNetworkMachineLearningRudesheim.
	predecessors := aPredecessorsSequenceableCollection
]
