Class {
	#name : 'RandomWeightsSourceNeuralNetworkMachineLearningRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-NeuralNetwork-Tests-Layer',
	#package : 'Rudesheim-NeuralNetwork-Private-Tests',
	#tag : 'Layer'
}

{ #category : 'accessing' }
RandomWeightsSourceNeuralNetworkMachineLearningRudesheimTest class >> targetClass [

	^ RandomWeightsSourceNeuralNetworkMachineLearningRudesheim
]

{ #category : 'accessing' }
RandomWeightsSourceNeuralNetworkMachineLearningRudesheimTest >> defaultBasicTarget [

	^ self targetClass rows: 3 columns: 2
]

{ #category : 'tests' }
RandomWeightsSourceNeuralNetworkMachineLearningRudesheimTest >> testBiasesCount [

	self assert: self basicTarget biases size equals: 3
]

{ #category : 'tests' }
RandomWeightsSourceNeuralNetworkMachineLearningRudesheimTest >> testLinearTransformLayerFromWeightsSource [

	|
		layer
		source
	|

	source := self basicTarget.
	layer := Rudesheim MachineLearning NeuralNetwork Layer LinearTransform weightsSource: source.

	self assert: layer weightsRows equals: source weightsRows.
	self assert: layer biases equals: source biases
]

{ #category : 'tests' }
RandomWeightsSourceNeuralNetworkMachineLearningRudesheimTest >> testWeightsRowsColumnCount [

	self assert: (self basicTarget weightsRows allSatisfy: [ :row | row size = 2 ])
]

{ #category : 'tests' }
RandomWeightsSourceNeuralNetworkMachineLearningRudesheimTest >> testWeightsRowsRowCount [

	self assert: self basicTarget weightsRows size equals: 3
]

{ #category : 'tests' }
RandomWeightsSourceNeuralNetworkMachineLearningRudesheimTest >> testWeightsRowsVaryBetweenInstances [

	|
		left
		right
	|

	left := self targetClass rows: 3 columns: 2.
	right := self targetClass rows: 3 columns: 2.

	self deny: left weightsRows equals: right weightsRows
]
