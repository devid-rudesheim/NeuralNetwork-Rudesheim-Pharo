Class {
	#name : 'ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-NeuralNetwork-OpenCL-Tests-IO',
	#package : 'Rudesheim-NeuralNetwork-OpenCL-Tests',
	#tag : 'IO'
}

{ #category : 'as yet unclassified' }
ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest class >> mnistOnnxFileReference [
	^
	(
		IceRepository registry
			detect:
			[ :each |
				each
					name
					= 'rudesheim'.
			]
	)
		location
		parent
		parent
		parent
		parent
		parent
		parent
		parent
		/ 'llm-model'
		/ 'mnist-8.onnx'.
]

{ #category : 'as yet unclassified' }
ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest class >> mnistPureSoilFileReference [
	|
		soilFileReference
	|

	soilFileReference := self mnistOnnxFileReference parent / 'mnist-8-pure.soil'.

	soilFileReference exists
		ifFalse:
		[
			self
				targetClass
				ONNX
				Convertor
				file:	self mnistOnnxFileReference
				toSoil:	soilFileReference
				backend:	PureNeuralNetworkMachineLearningRudesheim.
		].

	^ soilFileReference.
]

{ #category : 'as yet unclassified' }
ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest class >> mnistSoilFileReference [
	|
		soilFileReference
	|

	soilFileReference :=
		self mnistOnnxFileReference
			withExtension:	'soil'.

	soilFileReference exists
		ifFalse:
		[
			self
				targetClass
				ONNX
				Convertor
				file:	self mnistOnnxFileReference
				toSoil:	soilFileReference
				progress:
				[ :event :object |
				].
		].

	^ soilFileReference.
]

{ #category : 'as yet unclassified' }
ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest class >> resnet50OnnxFileReference [
	^
	(
		IceRepository registry
			detect:
			[ :each |
				each
					name
					= 'rudesheim'.
			]
	)
		location
		parent
		parent
		parent
		parent
		parent
		parent
		parent
		/ 'llm-model'
		/ 'resnet50-v2-7.onnx'.
]

{ #category : 'as yet unclassified' }
ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest class >> resnet50PureSoilFileReference [
	|
		soilFileReference
	|

	soilFileReference := self resnet50OnnxFileReference parent / 'resnet50-v2-7-pure.soil'.

	soilFileReference exists
		ifFalse:
		[
			self
				targetClass
				ONNX
				Convertor
				file:	self resnet50OnnxFileReference
				toSoil:	soilFileReference
				backend:	PureNeuralNetworkMachineLearningRudesheim.
		].

	^ soilFileReference.
]

{ #category : 'as yet unclassified' }
ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest class >> resnet50SoilFileReference [
	|
		soilFileReference
	|

	soilFileReference :=
		self resnet50OnnxFileReference
			withExtension:	'soil'.

	soilFileReference exists
		ifFalse:
		[
			self
				targetClass
				ONNX
				Convertor
				file:	self resnet50OnnxFileReference
				toSoil:	soilFileReference
				progress:
				[ :event :object |
				].
		].

	^ soilFileReference.
]

{ #category : 'as yet unclassified' }
ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest class >> selectorsWithExtendedForwardTimeLimit [
	^ #(#testResNet50ForwardsToThousandLogits #testResNet50ForwardsToThousandLogitsWithPureBackend).
]

{ #category : 'as yet unclassified' }
ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest class >> selectorsWithExternalConversionTimeLimit [
	^ #(#testMNISTOnnxConvertsThroughSoil #testResNet50OnnxConvertsThroughSoil #testResNet50OnnxConvertsThroughSoilWithPureBackend).
]

{ #category : 'as yet unclassified' }
ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest class >> targetClass [
	^ NeuralNetworkMachineLearningRudesheim.
]

{ #category : 'as yet unclassified' }
ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest >> defaultTimeLimit [
	(
		self
			class
			selectorsWithExternalConversionTimeLimit
			includes:	self selector
	)
		ifTrue:
		[
			^ 30 minutes.
		].

	(
		self
			class
			selectorsWithExtendedForwardTimeLimit
			includes:	self selector
	)
		ifTrue:
		[
			^ 5 minutes.
		].

	^ super defaultTimeLimit.
]

{ #category : 'as yet unclassified' }
ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest >> testBackendModelAccessorsReturnSharedModelClass [
	|
		nn
	|

	nn := self targetClass.

	self
		assert:	
		nn
			Pure
			Model
		equals:	ModelNeuralNetworkMachineLearningRudesheim.

	self
		assert:	
		nn
			OpenCL
			Model
		equals:	ModelNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'as yet unclassified' }
ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest >> testLayerClassForNameResolvesKnownONNXOpNames [
	|
		nn
	|

	nn := self targetClass.

	self
		assert:	
		(
			nn ONNX
				layerClassForName:	'Gemm'
		)
		equals:	LinearTransformLayerNeuralNetworkMachineLearningRudesheim.

	self
		assert:	
		(
			nn ONNX
				layerClassForName:	'Relu'
		)
		equals:	ReLULayerNeuralNetworkMachineLearningRudesheim.

	self
		assert:	
		(
			nn ONNX
				layerClassForName:	'Conv'
		)
		equals:	Conv2DLayerNeuralNetworkMachineLearningRudesheim.

	self
		assert:	
		(
			nn ONNX
				layerClassForName:	'MaxPool'
		)
		equals:	MaxPool2DLayerNeuralNetworkMachineLearningRudesheim.

	self
		assert:	
		(
			nn ONNX
				layerClassForName:	'Add'
		)
		equals:	AddLayerNeuralNetworkMachineLearningRudesheim.

	self
		assert:	
		(
			nn ONNX
				layerClassForName:	'BatchNormalization'
		)
		equals:	BatchNormalizationLayerNeuralNetworkMachineLearningRudesheim.

	self
		assert:	
		(
			nn ONNX
				layerClassForName:	'GlobalAveragePool'
		)
		equals:	GlobalAveragePoolLayerNeuralNetworkMachineLearningRudesheim.

	self
		should:
		[
			nn ONNX
				layerClassForName:	'Softmax'.
		]
		raise:	Error.
]

{ #category : 'as yet unclassified' }
ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest >> testMNISTForwardsToTenLogits [
	|
		nn
		prediction
	|

	nn := self targetClass.

	self
		class
		mnistOnnxFileReference
		exists
		ifFalse:
		[
			^ self skip.
		].

	(
		Soil
			openOnPath:	
			self
				class
				mnistSoilFileReference
	)
		intoRHScope
		do:
		[ :soil |
			|
				root
				modelRecord
				model
				input
			|

			root := soil newTransaction root.

			modelRecord :=
				root
					at:	
					(
						root
							symbolByName:	'default'
					).

			model :=
				modelRecord
					nextModelAs:	
					nn
						OpenCL
						Model.

			input :=
				Array
					new:	784
					withAll:	0.1.

			prediction :=
				(
					model
						forward:	input
				) asArray.
		].

	self
		assert:	prediction size
		equals:	10.

	self
		assert:	
		(
			prediction
				allSatisfy:
				[ :each |
					each isNumber.
				]
		).
]

{ #category : 'as yet unclassified' }
ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest >> testMNISTForwardsToTenLogitsWithPureBackend [
	|
		nn
		prediction
	|

	nn := self targetClass.

	self
		class
		mnistOnnxFileReference
		exists
		ifFalse:
		[
			^ self skip.
		].

	(
		Soil
			openOnPath:	
			self
				class
				mnistPureSoilFileReference
	)
		intoRHScope
		do:
		[ :soil |
			|
				root
				modelRecord
				model
				input
			|

			root := soil newTransaction root.

			modelRecord :=
				root
					at:	
					(
						root
							symbolByName:	'default'
					).

			self
				assert:	modelRecord notNil.

			self
				assert:	
				(
					modelRecord metadata
						includesKey:	#graphPopulationError
				)
					not.

			self
				deny:	
				modelRecord
					graphNodeRecords
					isEmpty.

			self
				assert:	
				modelRecord
					outputGraphNodeRecord
					notNil.

			model :=
				modelRecord
					nextModelAs:	
					nn
						Pure
						Model.

			input :=
				Array
					new:	784
					withAll:	0.1.

			prediction := (model forward: input) asArray.
		].

	self
		assert:	prediction size
		equals:	10.

	prediction
		do:
		[ :each |
			self
				assert:	each isNumber.
		].
]

{ #category : 'as yet unclassified' }
ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest >> testMNISTOnnxConvertsThroughSoil [
	|
		soilFileReference
	|

	self
		class
		mnistOnnxFileReference
		exists
		ifFalse:
		[
			^ self skip.
		].

	soilFileReference := self class mnistSoilFileReference.

	self
		assert:	soilFileReference exists.

	(
		Soil
			openOnPath:	soilFileReference
	)
		intoRHScope
		do:
		[ :soil |
			|
				root
				modelRecord
			|

			root := soil newTransaction root.

			modelRecord :=
				root
					at:	
					(
						root
							symbolByName:	'default'
					).

			self
				assert:	modelRecord notNil.

			self
				assert:	
				(
					modelRecord metadata
						includesKey:	#graphPopulationError
				)
					not.

			self
				deny:	
				modelRecord
					graphNodeRecords
					isEmpty.

			self
				assert:	
				modelRecord
					outputGraphNodeRecord
					notNil.
		].
]

{ #category : 'as yet unclassified' }
ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest >> testModelRecordNextModelAsBuildsForwardableModelFromBranchingGraphNodeRecords [
	|
		nn
		modelRecord
		branchAWeights
		branchABiases
		branchANode
		branchBWeights
		branchBBiases
		branchBNode
		mergeNode
		model
		output
	|

	nn := self targetClass.
	modelRecord := nn Soil ModelRecord new.

	branchAWeights :=
		nn
			Soil
			TensorDescriptor
			tensorKindClass:	
			nn
				Soil
				Tensor
				Weights
			shape:	#(2 2)
			payload:	#(1.0 0.0 0.0 1.0).

	branchABiases :=
		nn
			Soil
			TensorDescriptor
			tensorKindClass:	
			nn
				Soil
				Tensor
				Biases
			shape:	#(2)
			payload:	#(0.0 0.0).

	branchANode :=
		nn
			Soil
			GraphNodeRecord
			layerClass:	LinearTransformLayerOpenCLNeuralNetworkMachineLearningRudesheim
			predecessorRecords:	#()
			tensorDescriptorRecords:	{branchAWeights .  branchABiases}.

	branchBWeights :=
		nn
			Soil
			TensorDescriptor
			tensorKindClass:	
			nn
				Soil
				Tensor
				Weights
			shape:	#(2 2)
			payload:	#(2.0 0.0 0.0 2.0).

	branchBBiases :=
		nn
			Soil
			TensorDescriptor
			tensorKindClass:	
			nn
				Soil
				Tensor
				Biases
			shape:	#(2)
			payload:	#(1.0 1.0).

	branchBNode :=
		nn
			Soil
			GraphNodeRecord
			layerClass:	LinearTransformLayerOpenCLNeuralNetworkMachineLearningRudesheim
			predecessorRecords:	#()
			tensorDescriptorRecords:	{branchBWeights .  branchBBiases}.

	mergeNode :=
		nn
			Soil
			GraphNodeRecord
			layerClass:	AddLayerOpenCLNeuralNetworkMachineLearningRudesheim
			predecessorRecords:	{branchANode .  branchBNode}
			tensorDescriptorRecords:	#().

	modelRecord
		addGraphNodeRecord:	branchANode.

	modelRecord
		addGraphNodeRecord:	branchBNode.

	modelRecord
		addGraphNodeRecord:	mergeNode.

	modelRecord
		outputGraphNodeRecord:	mergeNode.

	model :=
		modelRecord
			nextModelAs:	
			nn
				OpenCL
				Model.

	output :=
		(
			model
				forward:	#(3.0 4.0)
		) asArray.

	self
		assert:	output
		equals:	#(10.0 13.0).
]

{ #category : 'as yet unclassified' }
ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest >> testModelRecordNextModelAsBuildsForwardableModelFromGraphNodeRecords [
	|
		nn
		modelRecord
		weightsDescriptor
		biasesDescriptor
		node
		model
		output
	|

	nn := self targetClass.
	modelRecord := nn Soil ModelRecord new.

	weightsDescriptor :=
		nn
			Soil
			TensorDescriptor
			tensorKindClass:	
			nn
				Soil
				Tensor
				Weights
			shape:	#(2 2)
			payload:	#(1.0 0.0 0.0 1.0).

	biasesDescriptor :=
		nn
			Soil
			TensorDescriptor
			tensorKindClass:	
			nn
				Soil
				Tensor
				Biases
			shape:	#(2)
			payload:	#(0.5 -0.5).

	node :=
		nn
			Soil
			GraphNodeRecord
			layerClass:	LinearTransformLayerOpenCLNeuralNetworkMachineLearningRudesheim
			predecessorRecords:	#()
			tensorDescriptorRecords:	{weightsDescriptor .  biasesDescriptor}.

	modelRecord
		addGraphNodeRecord:	node.

	modelRecord
		outputGraphNodeRecord:	node.

	model :=
		modelRecord
			nextModelAs:	
			nn
				OpenCL
				Model.

	output :=
		(
			model
				forward:	#(1.0 2.0)
		) asArray.

	self
		assert:	output
		equals:	#(1.5 1.5).
]

{ #category : 'as yet unclassified' }
ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest >> testONNXConvertorNamespace [
	self
		assert:	
		self
			targetClass
			ONNX
			Convertor
		equals:	ConvertorONNXNeuralNetworkMachineLearningRudesheim.

	self
		assert:	
		self
			targetClass
			ONNX
			Converter
		equals:	ConvertorONNXNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'as yet unclassified' }
ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest >> testONNXFileInterfaceConvertsArgumentsToFileReferences [
	|
		events
		fileReference
		nn
		outputFileReference
		soilFileReference
	|

	nn := self targetClass.
	events := OrderedCollection new.

	fileReference :=
		FileReference
			newTempFilePrefix:	'rudesheim-onnx'
			suffix:	'.onnx'.

	fileReference
		binaryWriteStreamDo:
		[ :stream |
			stream
				nextPutAll:	#[9 8 7].
		].

	outputFileReference :=
		FileReference
			newTempFilePrefix:	'rudesheim-onnx-output'
			suffix:	'.onnx'.

	outputFileReference exists
		ifTrue:
		[
			outputFileReference delete.
		].

	soilFileReference :=
		fileReference
			withExtension:	'soil'.

	soilFileReference exists
		ifTrue:
		[
			soilFileReference delete.
		].

	nn
		ONNX
		Convertor
		file:	fileReference fullName
		toSoil:	soilFileReference fullName
		progress:
		[ :event :object |
			events
				add:	event -> object.
		].

	nn
		ONNX
		Convertor
		soil:	soilFileReference fullName
		toFile:	outputFileReference fullName
		progress:
		[ :event :object |
			events
				add:	event -> object.
		].

	self
		assert:	
		outputFileReference
			binaryReadStream
			contents
		equals:	#[9 8 7].

	self
		assert:	
		(
			events
				collect:
				[ :each |
					each key.
				]
		)
			asArray
		equals:	#(started readStream wroteSoil done started readSoil wroteStream done).
]

{ #category : 'as yet unclassified' }
ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest >> testONNXFileInterfacePersistsPayload [
	|
		fileReference
		modelRecord
		nn
		root
		soil
		soilFileReference
	|

	nn := self targetClass.

	fileReference :=
		FileReference
			newTempFilePrefix:	'rudesheim-onnx'
			suffix:	'.onnx'.

	fileReference
		binaryWriteStreamDo:
		[ :stream |
			stream
				nextPutAll:	#[1 3 5].
		].

	soilFileReference :=
		fileReference
			withExtension:	'soil'.

	soilFileReference exists
		ifTrue:
		[
			soilFileReference delete.
		].

	nn
		ONNX
		Convertor
		file:	fileReference
		toSoil:	soilFileReference.

	soil :=
		Soil
			openOnPath:	soilFileReference.
	[
		root := soil newTransaction root.

		modelRecord :=
			root
				at:	
				(
					root
						symbolByName:	'default'
				).

		self
			assert:	modelRecord formatClass
			equals:	nn ONNX.

		self
			assert:	modelRecord externalFileReference
			equals:	fileReference.

		self
			assert:	modelRecord externalPayload
			equals:	#[1 3 5].
	]
		ensure:
		[
			soil close.
		].
]

{ #category : 'as yet unclassified' }
ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest >> testONNXNamesLiveOnLayerClasses [
	self
		assert:	
		self
			targetClass
			Layer
			LinearTransform
			nameForONNX
		equals:	'Gemm'.

	self
		assert:	
		self
			targetClass
			Layer
			ReLU
			nameForONNX
		equals:	'Relu'.

	self
		assert:	
		self
			targetClass
			OpenCL
			Layer
			LinearTransform
			nameForONNX
		equals:	'Gemm'.

	self
		assert:	
		self
			targetClass
			OpenCL
			Layer
			ReLU
			nameForONNX
		equals:	'Relu'.
]

{ #category : 'as yet unclassified' }
ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest >> testONNXStreamInterfaceUsesOpenSoil [
	|
		events
		nn
		outputStream
		readStream
		soil
		soilFileReference
	|

	nn := self targetClass.
	events := OrderedCollection new.

	soilFileReference :=
		FileReference
			newTempFilePrefix:	'rudesheim-onnx'
			suffix:	'.soil'.

	soilFileReference exists
		ifTrue:
		[
			soilFileReference delete.
		].

	soil :=
		Soil
			ensureOnPath:	soilFileReference.

	readStream :=
		ReadStream
			on:	#[1 2 3 4 5].
	[
		nn
			ONNX
			Convertor
			readStream:	readStream
			toSoil:	soil
			progress:
			[ :event :object |
				events
					add:	event -> object.
			].

		outputStream :=
			WriteStream
				on:	ByteArray new.

		nn
			ONNX
			Convertor
			soil:	soil
			toWriteStream:	outputStream
			progress:
			[ :event :object |
				events
					add:	event -> object.
			].

		self
			assert:	outputStream contents
			equals:	#[1 2 3 4 5].

		self
			assert:	
			(
				events
					collect:
					[ :each |
						each key.
					]
			)
				asArray
			equals:	#(started readStream wroteSoil done started readSoil wroteStream done).
	]
		ensure:
		[
			soil close.
		].
]

{ #category : 'as yet unclassified' }
ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest >> testResNet50ForwardsToThousandLogits [
	|
		nn
		prediction
	|

	nn := self targetClass.

	self
		class
		resnet50OnnxFileReference
		exists
		ifFalse:
		[
			^ self skip.
		].

	(
		Soil
			openOnPath:	
			self
				class
				resnet50SoilFileReference
	)
		intoRHScope
		do:
		[ :soil |
			|
				root
				modelRecord
				model
				input
			|

			root := soil newTransaction root.

			modelRecord :=
				root
					at:	
					(
						root
							symbolByName:	'default'
					).

			model :=
				modelRecord
					nextModelAs:	
					nn
						OpenCL
						Model.

			input :=
				Array
					new:	
					3
						* 224
						* 224
					withAll:	0.1.

			prediction :=
				(
					model
						forward:	input
				) asArray.
		].

	self
		assert:	prediction size
		equals:	1000.

	self
		assert:	
		(
			prediction
				allSatisfy:
				[ :each |
					each isNumber.
				]
		).
]

{ #category : 'as yet unclassified' }
ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest >> testResNet50ForwardsToThousandLogitsWithPureBackend [
	|
		nn
		prediction
	|

	nn := self targetClass.

	self
		class
		resnet50OnnxFileReference
		exists
		ifFalse:
		[
			^ self skip.
		].

	(
		Soil
			openOnPath:	
			self
				class
				resnet50PureSoilFileReference
	)
		intoRHScope
		do:
		[ :soil |
			|
				root
				modelRecord
				model
				input
			|

			root := soil newTransaction root.

			modelRecord :=
				root
					at:	
					(
						root
							symbolByName:	'default'
					).

			model :=
				modelRecord
					nextModelAs:	
					nn
						Pure
						Model.

			input :=
				Array
					new:	
					3
						* 224
						* 224
					withAll:	0.1.

			prediction := (model forward: input) asArray.
		].

	self
		assert:	prediction size
		equals:	1000.

	prediction
		do:
		[ :each |
			self
				assert:	each isNumber.
		].
]

{ #category : 'as yet unclassified' }
ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest >> testResNet50OnnxConvertsThroughSoil [
	|
		soilFileReference
	|

	self
		class
		resnet50OnnxFileReference
		exists
		ifFalse:
		[
			^ self skip.
		].

	soilFileReference := self class resnet50SoilFileReference.

	self
		assert:	soilFileReference exists.

	(
		Soil
			openOnPath:	soilFileReference
	)
		intoRHScope
		do:
		[ :soil |
			|
				root
				modelRecord
			|

			root := soil newTransaction root.

			modelRecord :=
				root
					at:	
					(
						root
							symbolByName:	'default'
					).

			self
				assert:	modelRecord notNil.

			self
				assert:	
				(
					modelRecord metadata
						includesKey:	#graphPopulationError
				)
					not.

			self
				deny:	
				modelRecord
					graphNodeRecords
					isEmpty.

			self
				assert:	
				modelRecord
					outputGraphNodeRecord
					notNil.
		].
]

{ #category : 'as yet unclassified' }
ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest >> testResNet50OnnxConvertsThroughSoilWithPureBackend [
	|
		soilFileReference
	|

	self
		class
		resnet50OnnxFileReference
		exists
		ifFalse:
		[
			^ self skip.
		].

	soilFileReference := self class resnet50PureSoilFileReference.

	self
		assert:	soilFileReference exists.

	(
		Soil
			openOnPath:	soilFileReference
	)
		intoRHScope
		do:
		[ :soil |
			|
				root
				modelRecord
			|

			root := soil newTransaction root.

			modelRecord :=
				root
					at:	
					(
						root
							symbolByName:	'default'
					).

			self
				assert:	modelRecord notNil.

			self
				assert:	
				(
					modelRecord metadata
						includesKey:	#graphPopulationError
				)
					not.

			self
				deny:	
				modelRecord
					graphNodeRecords
					isEmpty.

			self
				assert:	
				modelRecord
					outputGraphNodeRecord
					notNil.
		].
]

{ #category : 'as yet unclassified' }
ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest >> testSoilNamespace [
	self
		assert:	
		self
			targetClass
			Soil
			GraphNodeRecord
		equals:	GraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim.

	self
		assert:	
		self
			targetClass
			Soil
			ModelRecord
		equals:	ModelRecordSoilNeuralNetworkMachineLearningRudesheim.

	self
		assert:	
		self
			targetClass
			Soil
			ModelSymbol
		equals:	ModelSymbolSoilNeuralNetworkMachineLearningRudesheim.

	self
		assert:	
		self
			targetClass
			Soil
			Root
		equals:	StoreRootSoilNeuralNetworkMachineLearningRudesheim.

	self
		assert:	
		self
			targetClass
			Soil
			Tensor
		equals:	TensorSoilNeuralNetworkMachineLearningRudesheim.

	self
		assert:	
		self
			targetClass
			Soil
			TensorDescriptor
		equals:	TensorDescriptorSoilNeuralNetworkMachineLearningRudesheim.

	self
		assert:	
		self
			targetClass
			Soil
			WeightsSource
		equals:	WeightsSourceSoilNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'as yet unclassified' }
ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest >> testSoilStoreRootDictionaryCompatibleModelSymbols [
	|
		modelRecord
		modelSymbol
		nn
		root
	|

	nn := self targetClass.
	root := nn Soil Root new.
	modelRecord := nn Soil ModelRecord new.

	modelSymbol :=
		root
			symbolByName:	'mnist-8'.

	root
		at:	modelSymbol
		put:	modelRecord.

	self
		deny:	
		modelSymbol
			class
			= Symbol.

	self
		assert:	modelSymbol
		equals:	
		(
			root
				symbolByName:	'mnist-8'
		).

	self
		assert:	modelSymbol hash
		equals:	
		(
			root
				symbolByName:	'mnist-8'
		)
			hash.

	self
		assert:	
		(
			root
				at:	modelSymbol
		)
		equals:	modelRecord.

	self
		assert:	
		(
			root
				includesKey:	
				(
					root
						symbolByName:	'mnist-8'
				)
		).

	self
		assert:	
		root
			keys
			asArray
		equals:	{modelSymbol}.

	self
		assert:	
		root
			values
			asArray
		equals:	{modelRecord}.

	self
		assert:	
		root
			modelNames
			asArray
		equals:	#('mnist-8').
]

{ #category : 'as yet unclassified' }
ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest >> testSoilStoreRootRejectsStringKeys [
	|
		modelRecord
		root
	|

	root := self targetClass Soil Root new.
	modelRecord := self targetClass Soil ModelRecord new.

	self
		should:
		[
			root
				at:	'mnist-8'
				put:	modelRecord.
		]
		raise:	Error.
]

{ #category : 'as yet unclassified' }
ExternalFormatNamespaceNeuralNetworkMachineLearningRudesheimTest >> testTensorDescriptorStoresClassObject [
	|
		descriptor
		nn
	|

	nn := self targetClass.

	descriptor :=
		nn
			Soil
			TensorDescriptor
			tensorKindClass:	
			nn
				Soil
				Tensor
				Weights
			shape:	#(2 3)
			payload:	#(#(1 2 3) #(4 5 6)).

	self
		assert:	
		descriptor
			tensorKindClass
			== nn Soil Tensor Weights.

	self
		assert:	descriptor shape
		equals:	#(2 3).

	self
		assert:	descriptor payload
		equals:	#(#(1 2 3) #(4 5 6)).
]
