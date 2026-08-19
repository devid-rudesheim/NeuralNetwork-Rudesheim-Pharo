Class {
	#name : 'MLPNeuralNetworkMachineLearningRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-NeuralNetwork-OpenCL-Tests-Architecture',
	#package : 'Rudesheim-NeuralNetwork-OpenCL-Tests',
	#tag : 'Architecture'
}

{ #category : 'accessing' }
MLPNeuralNetworkMachineLearningRudesheimTest class >> targetClass [

	^ MLPNeuralNetworkMachineLearningRudesheim
]

{ #category : 'tests' }
MLPNeuralNetworkMachineLearningRudesheimTest >> testArchitectureModelForwardShape [

	|
		model
		output
	|

	model :=
		self targetClass
			nextModelAs:	Rudesheim MachineLearning NeuralNetwork Pure Model.

	output :=
		model
			forward:	#( 1.0 0.0 ).

	self
		assert:	output size
		equals:	2.
]

{ #category : 'tests' }
MLPNeuralNetworkMachineLearningRudesheimTest >> testArchitectureModelValueIsAliasForForward [

	|
		model
		input
	|

	model :=
		self targetClass
			nextModelAs:	Rudesheim MachineLearning NeuralNetwork Pure Model.

	input := #( 1.0 0.0 ).

	self
		assert:
		(
			model
				value:	input
		)
		equals:
		(
			model
				forward:	input
		).
]

{ #category : 'tests' }
MLPNeuralNetworkMachineLearningRudesheimTest >> testArchitectureModelLayerCount [

	|
		model
	|

	model := self targetClass nextModelAs: Rudesheim MachineLearning NeuralNetwork Pure Model.

	self assert: model neuralNetworkLayers size equals: 3
]

{ #category : 'tests' }
MLPNeuralNetworkMachineLearningRudesheimTest >> testArchitectureModelUsesGivenBackend [

	|
		model
	|

	model :=
		self targetClass
			nextModelAs:	Rudesheim MachineLearning NeuralNetwork Model
			backend:		OpenCLNeuralNetworkMachineLearningRudesheim.

	self assert: model backend equals: OpenCLNeuralNetworkMachineLearningRudesheim.
	self assert: ( model neuralNetworkLayers first isKindOf: LinearTransformLayerOpenCLNeuralNetworkMachineLearningRudesheim )
]

{ #category : 'tests' }
MLPNeuralNetworkMachineLearningRudesheimTest >> testArchitectureModelRequiresBackendModelClass [

	self
		should:
		[
			self targetClass nextModelAs: Rudesheim MachineLearning NeuralNetwork Model.
		]
		raise:	Error
]

{ #category : 'tests' }
MLPNeuralNetworkMachineLearningRudesheimTest >> testArchitectureModelUsesBackendModelClass [

	|
		model
		nn
	|

	nn := Rudesheim MachineLearning NeuralNetwork.
	model :=
		self targetClass
			nextModelAs:	
			nn
				OpenCL
				Model.

	self assert: model backend equals: OpenCLNeuralNetworkMachineLearningRudesheim.
	self assert: ( model neuralNetworkLayers first isKindOf: LinearTransformLayerOpenCLNeuralNetworkMachineLearningRudesheim )
]

{ #category : 'tests' }
MLPNeuralNetworkMachineLearningRudesheimTest >> testArchitectureProducesFreshModelEachCall [

	|
		left
		right
	|

	left := self targetClass nextModelAs: Rudesheim MachineLearning NeuralNetwork Pure Model.
	right := self targetClass nextModelAs: Rudesheim MachineLearning NeuralNetwork Pure Model.

	self deny: left neuralNetworkLayers first weightsRows equals: right neuralNetworkLayers first weightsRows
]

{ #category : 'tests' }
MLPNeuralNetworkMachineLearningRudesheimTest >> testLayerSpecificationsCount [

	self assert: (self targetClass layerSpecifications: PureNeuralNetworkMachineLearningRudesheim) size equals: 3
]

{ #category : 'tests' }
MLPNeuralNetworkMachineLearningRudesheimTest >> testCriterionUsesGivenBackend [

	self assert: ( self targetClass criterion: PureNeuralNetworkMachineLearningRudesheim ) equals: MSECriterionNeuralNetworkMachineLearningRudesheim.
	self assert: ( self targetClass criterion: OpenCLNeuralNetworkMachineLearningRudesheim ) equals: MSECriterionOpenCLNeuralNetworkMachineLearningRudesheim
]

{ #category : 'tests' }
MLPNeuralNetworkMachineLearningRudesheimTest >> testLayerSpecificationsUsesGivenBackend [

	|
		pureLayers
		openCLLayers
	|

	pureLayers := (self targetClass layerSpecifications: PureNeuralNetworkMachineLearningRudesheim) collect: #value.
	openCLLayers := (self targetClass layerSpecifications: OpenCLNeuralNetworkMachineLearningRudesheim) collect: #value.

	self assert: (pureLayers first isKindOf: LinearTransformLayerNeuralNetworkMachineLearningRudesheim).
	self assert: (openCLLayers first isKindOf: LinearTransformLayerOpenCLNeuralNetworkMachineLearningRudesheim).
	self assert: pureLayers second == ReLULayerNeuralNetworkMachineLearningRudesheim.
	self assert: openCLLayers second == ReLULayerOpenCLNeuralNetworkMachineLearningRudesheim
]
