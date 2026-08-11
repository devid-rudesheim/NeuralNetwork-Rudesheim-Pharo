Class {
	#name : 'MLPNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#traits : 'TArchitectureNeuralNetworkMachineLearningRudesheim',
	#classTraits : 'TArchitectureNeuralNetworkMachineLearningRudesheim classTrait',
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'accessing' }
MLPNeuralNetworkMachineLearningRudesheim class >> criterion [

	^ self criterion: TBackendNeuralNetworkMachineLearningRudesheim default.
]

{ #category : 'accessing' }
MLPNeuralNetworkMachineLearningRudesheim class >> criterion: aTBackendNeuralNetworkMachineLearningRudesheim [

	^ aTBackendNeuralNetworkMachineLearningRudesheim Criterion MSE.
]

{ #category : 'accessing' }
MLPNeuralNetworkMachineLearningRudesheim class >> layerSpecifications: aTBackendNeuralNetworkMachineLearningRudesheim [

	|
		nn
		layer
		weightsSource
	|

	nn := Rudesheim MachineLearning NeuralNetwork.
	layer := aTBackendNeuralNetworkMachineLearningRudesheim Layer.
	weightsSource := nn WeightsSource Random.

	^ {
		[ layer LinearTransform weightsSource: ( weightsSource rows: 4 columns: 2 ) ].
		[ layer ReLU ].
		[ layer LinearTransform weightsSource: ( weightsSource rows: 2 columns: 4 ) ].
	}
]
