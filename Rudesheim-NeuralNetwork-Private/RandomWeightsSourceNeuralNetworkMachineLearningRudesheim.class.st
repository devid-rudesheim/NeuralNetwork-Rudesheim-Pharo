Class {
	#name : 'RandomWeightsSourceNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#traits : 'TWeightsSourceNeuralNetworkMachineLearningRudesheim',
	#classTraits : 'TWeightsSourceNeuralNetworkMachineLearningRudesheim classTrait',
	#instVars : [
		'rows',
		'columns',
		'weightsRows',
		'biases'
	],
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'instance creation' }
RandomWeightsSourceNeuralNetworkMachineLearningRudesheim class >> rows: aRowsInteger columns: aColumnsInteger [

	^ super new
		setRows:	aRowsInteger
		columns:	aColumnsInteger;
		yourself
]

{ #category : 'accessing' }
RandomWeightsSourceNeuralNetworkMachineLearningRudesheim >> biases [

	^ biases
		ifNil:
		[
			biases := Array new: rows withAll: 0.0.
		].
]

{ #category : 'initialization' }
RandomWeightsSourceNeuralNetworkMachineLearningRudesheim >> setRows: aRowsInteger columns: aColumnsInteger [

	rows := aRowsInteger.
	columns := aColumnsInteger.
]

{ #category : 'accessing' }
RandomWeightsSourceNeuralNetworkMachineLearningRudesheim >> weightsRows [

	^ weightsRows
		ifNil:
		[
			|
				random
			|

			random := Random new.
			weightsRows :=
				( 1 to: rows )
					collect:
					[ :unusedRow |
						( 1 to: columns )
							collect:
							[ :unusedColumn |
								( random next * 2.0 ) - 1.0
							]
					].
		].
]
