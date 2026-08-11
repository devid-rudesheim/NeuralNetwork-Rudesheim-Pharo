"
TensorDescriptorSoilNeuralNetworkMachineLearningRudesheim will describe tensor metadata in the Soil-backed internal model store, such as shape, element representation, and payload location.
"
Class {
	#name : 'TensorDescriptorSoilNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#instVars : [
		'tensorKindClass',
		'shape',
		'payload'
	],
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'instance creation' }
TensorDescriptorSoilNeuralNetworkMachineLearningRudesheim class >> tensorKindClass:	aClass
shape:	aShapeSequenceableCollection
payload:	anObject [

	^ super new
		setTensorKindClass:	aClass
		shape:				aShapeSequenceableCollection
		payload:			anObject;
		yourself
]

{ #category : 'accessing' }
TensorDescriptorSoilNeuralNetworkMachineLearningRudesheim >> payload [

	^ payload
]

{ #category : 'initialization' }
TensorDescriptorSoilNeuralNetworkMachineLearningRudesheim >> setTensorKindClass:	aClass
shape:	aShapeSequenceableCollection
payload:	anObject [

	tensorKindClass	:=	aClass.
	shape			:=	aShapeSequenceableCollection.
	payload			:=	anObject
]

{ #category : 'accessing' }
TensorDescriptorSoilNeuralNetworkMachineLearningRudesheim >> shape [

	^ shape
]

{ #category : 'accessing' }
TensorDescriptorSoilNeuralNetworkMachineLearningRudesheim >> tensorKindClass [

	^ tensorKindClass
]
