Class {
	#name : 'OpenCLNeuralNetworkMachineLearningRudesheimTest',
	#superclass : 'TestCase',
	#category : 'Rudesheim-NeuralNetwork-OpenCL-Tests',
	#package : 'Rudesheim-NeuralNetwork-OpenCL-Tests'
}

{ #category : 'running' }
OpenCLNeuralNetworkMachineLearningRudesheimTest >> tearDown [

	OpenCLNeuralNetworkMachineLearningRudesheim
		startUp:	false.

	super tearDown.
]

{ #category : 'tests' }
OpenCLNeuralNetworkMachineLearningRudesheimTest >> testCommandQueueDelegatesToDriver [

	self
		assert:
		(
			OpenCLNeuralNetworkMachineLearningRudesheim commandQueue
				== OpenCLNeuralNetworkMachineLearningRudesheim driver commandQueue
		).
]

{ #category : 'tests' }
OpenCLNeuralNetworkMachineLearningRudesheimTest >> testContextDelegatesToDriver [

	self
		assert:
		(
			OpenCLNeuralNetworkMachineLearningRudesheim context
				== OpenCLNeuralNetworkMachineLearningRudesheim driver context
		).
]

{ #category : 'tests' }
OpenCLNeuralNetworkMachineLearningRudesheimTest >> testStartUpResetsDriver [

	| firstContext |

	firstContext := OpenCLNeuralNetworkMachineLearningRudesheim context.

	OpenCLNeuralNetworkMachineLearningRudesheim
		startUp:	false.

	self
		deny:	( OpenCLNeuralNetworkMachineLearningRudesheim context == firstContext ).
]
