Class {
	#name : 'LinearTransformLayerNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#traits : 'TLinearTransformLayerNeuralNetworkMachineLearningRudesheim',
	#classTraits : 'TLinearTransformLayerNeuralNetworkMachineLearningRudesheim classTrait',
	#instVars : [
		'biases',
		'weightsRows'
	],
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'accessing' }
LinearTransformLayerNeuralNetworkMachineLearningRudesheim class >> defaultBiases [

	^ OrderedCollection new
]

{ #category : 'accessing' }
LinearTransformLayerNeuralNetworkMachineLearningRudesheim class >> defaultWeightsRows [

	^ OrderedCollection new
]

{ #category : 'accessing' }
LinearTransformLayerNeuralNetworkMachineLearningRudesheim class >> species [

	^ LinearTransformLayerNeuralNetworkMachineLearningRudesheim
]

{ #category : 'instance creation' }
LinearTransformLayerNeuralNetworkMachineLearningRudesheim class >> fromSoilGraphNodeRecord:	aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim [

	^ self weightsSource:
		(
			Rudesheim MachineLearning NeuralNetwork Soil WeightsSource
				tensorDescriptorRecords:	aGraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim tensorDescriptorRecords
		)
]

{ #category : 'evaluating' }
LinearTransformLayerNeuralNetworkMachineLearningRudesheim >> backward:		aBackwordContextNeuralNetworkMachineLearningRudesheim [
	|
		gradient
		inputs
	|

	gradient	:= aBackwordContextNeuralNetworkMachineLearningRudesheim gradient.
	inputs		:= aBackwordContextNeuralNetworkMachineLearningRudesheim inputPredictions.

	^
	{
		"delta inputs"
		inputs
			withIndexCollect:
			[ :unused :inputsIndex |
				(
					gradient
						withIndexCollect:
						[ :each :gradientIndex |
							(
								(
									self weightsRows
										at:	gradientIndex
								)
									at:	inputsIndex
							) * each
						]
				) sum
			].
		self species
			weightsRows:
			(
				"delta weights"
				gradient
					collect:
					[ :each0 |
						inputs * each0
					]
			)
			biases:			gradient.
	}
]

{ #category : 'accessing' }
LinearTransformLayerNeuralNetworkMachineLearningRudesheim >> biases [

	^ biases
		ifNil:
		[
			biases := self defaultBiases.
		].

]

{ #category : 'accessing' }
LinearTransformLayerNeuralNetworkMachineLearningRudesheim >> defaultBiases [

	^ self class defaultBiases.
]

{ #category : 'accessing' }
LinearTransformLayerNeuralNetworkMachineLearningRudesheim >> defaultWeightsRows [

	^ self class defaultWeightsRows.
]

{ #category : 'evaluating' }
LinearTransformLayerNeuralNetworkMachineLearningRudesheim >> forward:	anInputNumbersSequencialCollection [

	"Affine transform"

	^
	(
		self weightsRows
			collect:
			[ :weightRow |
				( weightRow * anInputNumbersSequencialCollection ) sum
			]
	) + self biases
]

{ #category : 'initialization' }
LinearTransformLayerNeuralNetworkMachineLearningRudesheim >> setWeightsRows:	aWeightRowsSequencialCollection
biases:			aBiasesSequencialCollection [

	weightsRows	:= aWeightRowsSequencialCollection.
	biases			:=aBiasesSequencialCollection.

]

{ #category : 'accessing' }
LinearTransformLayerNeuralNetworkMachineLearningRudesheim >> weightsRows [

	^ weightsRows
		ifNil:
		[
			weightsRows := self defaultWeightsRows.
		].

]

{ #category : 'converting' }
LinearTransformLayerNeuralNetworkMachineLearningRudesheim >> withUpdatedWeightsRows:	aTLinearTransformLayerNeuralNetworkMachineLearningRudesheim
learningRate:				aRateFloat [
	|
		adjust
	|

	adjust :=
	[ :left :right |
		left - ( aRateFloat * right )
	].

	^ self species
		weightsRows:
		(
			self weightsRows
				with:		aTLinearTransformLayerNeuralNetworkMachineLearningRudesheim weightsRows
				collect:	adjust
		)
		biases:
		(
			adjust
				value:	self biases
				value:	aTLinearTransformLayerNeuralNetworkMachineLearningRudesheim biases
		).
]
