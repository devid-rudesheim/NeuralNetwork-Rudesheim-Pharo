"
ONNXNeuralNetworkMachineLearningRudesheim is the ONNX-specific namespace below Rudesheim MachineLearning NeuralNetwork. It exposes conversion objects that translate between ONNX files and the Soil-backed internal neural network store.
"
Class {
	#name : 'ONNXNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'as yet unclassified' }
ONNXNeuralNetworkMachineLearningRudesheim class >> Converter [
	^ self Convertor.
]

{ #category : 'as yet unclassified' }
ONNXNeuralNetworkMachineLearningRudesheim class >> Convertor [
	^ ConvertorONNXNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'as yet unclassified' }
ONNXNeuralNetworkMachineLearningRudesheim class >> knownLayerClasses [
	^ self
		knownLayerClassesForBackend:	OpenCLNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'as yet unclassified' }
ONNXNeuralNetworkMachineLearningRudesheim class >> knownLayerClassesForBackend: aTBackendNeuralNetworkMachineLearningRudesheimClass [
	^ self knownLayerKindSelectors
		collect:
		[ :eachKindSelector |
			aTBackendNeuralNetworkMachineLearningRudesheimClass Layer
				perform:	eachKindSelector.
		].
]

{ #category : 'as yet unclassified' }
ONNXNeuralNetworkMachineLearningRudesheim class >> knownLayerKindSelectors [
	^ #(#LinearTransform #ReLU #Conv2D #MaxPool2D #Add #BatchNormalization #GlobalAveragePool).
]

{ #category : 'as yet unclassified' }
ONNXNeuralNetworkMachineLearningRudesheim class >> layerClassForName: aNameString [
	^ self
		layerClassForName:	aNameString
		backend:	OpenCLNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'as yet unclassified' }
ONNXNeuralNetworkMachineLearningRudesheim class >> layerClassForName: aNameString
backend: aTBackendNeuralNetworkMachineLearningRudesheimClass [
	^
	(
		self
			knownLayerClassesForBackend:	aTBackendNeuralNetworkMachineLearningRudesheimClass
	)
		detect:
		[ :eachLayerClass |
			eachLayerClass
				nameForONNX
				= aNameString.
		]
		ifNone:
		[
			self
				error:	'unsupported ONNX layer name: ' , aNameString.
		].
]
