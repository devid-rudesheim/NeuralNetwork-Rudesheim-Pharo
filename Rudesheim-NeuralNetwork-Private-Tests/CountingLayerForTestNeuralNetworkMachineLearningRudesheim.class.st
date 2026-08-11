Class {
	#name : 'CountingLayerForTestNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#instVars : [
		'forwardCallCount',
		'backwardCallCount',
		'lastBackwardGradient'
	],
	#category : 'Rudesheim-NeuralNetwork-Tests-Layer',
	#package : 'Rudesheim-NeuralNetwork-Private-Tests',
	#tag : 'Layer'
}

{ #category : 'accessing' }
CountingLayerForTestNeuralNetworkMachineLearningRudesheim class >> defaultBackwardCallCount [

	^ 0
]

{ #category : 'accessing' }
CountingLayerForTestNeuralNetworkMachineLearningRudesheim class >> defaultForwardCallCount [

	^ 0
]

{ #category : 'evaluating' }
CountingLayerForTestNeuralNetworkMachineLearningRudesheim >> backward:	aTBackwardContextNeuralNetworkMachineLearningRudesheim [
	"Identity backward: (no learned parameters, gradient passes straight through
	unchanged) -- enough to exercise Node/Model's traversal wiring without needing
	a real Layer's math."

	backwardCallCount := self backwardCallCount + 1.
	lastBackwardGradient := aTBackwardContextNeuralNetworkMachineLearningRudesheim gradient.
	^ { lastBackwardGradient }
]

{ #category : 'accessing' }
CountingLayerForTestNeuralNetworkMachineLearningRudesheim >> backwardCallCount [

	^ backwardCallCount
		ifNil: [ backwardCallCount := self defaultBackwardCallCount ]
]

{ #category : 'accessing' }
CountingLayerForTestNeuralNetworkMachineLearningRudesheim >> lastBackwardGradient [

	^ lastBackwardGradient
]

{ #category : 'accessing' }
CountingLayerForTestNeuralNetworkMachineLearningRudesheim >> defaultBackwardCallCount [

	^ self class defaultBackwardCallCount
]

{ #category : 'accessing' }
CountingLayerForTestNeuralNetworkMachineLearningRudesheim >> defaultForwardCallCount [

	^ self class defaultForwardCallCount
]

{ #category : 'evaluating' }
CountingLayerForTestNeuralNetworkMachineLearningRudesheim >> forward: anInputNumbersSequenceableCollection [

	forwardCallCount := self forwardCallCount + 1.
	^ anInputNumbersSequenceableCollection
]

{ #category : 'accessing' }
CountingLayerForTestNeuralNetworkMachineLearningRudesheim >> forwardCallCount [

	^ forwardCallCount
		ifNil: [ forwardCallCount := self defaultForwardCallCount ]
]

{ #category : 'converting' }
CountingLayerForTestNeuralNetworkMachineLearningRudesheim >> withUpdatedWeightsRows:	aCountingLayerForTestNeuralNetworkMachineLearningRudesheim
learningRate:				aRateFloat [

	^ self
]
