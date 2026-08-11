Class {
	#name : 'AddLayerNeuralNetworkMachineLearningRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-NeuralNetwork-Private-Tests-Layer',
	#package : 'Rudesheim-NeuralNetwork-Private-Tests',
	#tag : 'Layer'
}

{ #category : 'as yet unclassified' }
AddLayerNeuralNetworkMachineLearningRudesheimTest class >> targetClass [
	^ AddLayerNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'as yet unclassified' }
AddLayerNeuralNetworkMachineLearningRudesheimTest >> testForwardAddsConcatenatedPredecessorHalvesElementWise [
	|
		output
	|

	output := (self targetClass forward: #(1.0 2.0 3.0 4.0 10.0 20.0 30.0 40.0)) asArray.

	self
		assert:	output
		equals:	#(11.0 22.0 33.0 44.0).
]
