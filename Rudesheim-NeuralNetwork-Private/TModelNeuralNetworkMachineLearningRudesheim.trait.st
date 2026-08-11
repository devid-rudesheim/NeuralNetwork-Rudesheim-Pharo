Trait {
	#name : 'TModelNeuralNetworkMachineLearningRudesheim',
	#traits : 'TModuleNeuralNetworkMachineLearningRudesheim',
	#classTraits : 'TModuleNeuralNetworkMachineLearningRudesheim classTrait',
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'instance creation' }
TModelNeuralNetworkMachineLearningRudesheim classSide >> neuralNetworkLayers:	aSequencialCollectionWIthTLayerNeuralNetworkMachineLearningRudesheim [

	^ self
		neuralNetworkLayers:	aSequencialCollectionWIthTLayerNeuralNetworkMachineLearningRudesheim
		backend:				TBackendNeuralNetworkMachineLearningRudesheim default
]

{ #category : 'instance creation' }
TModelNeuralNetworkMachineLearningRudesheim classSide >> neuralNetworkLayers:	aSequencialCollectionWIthTLayerNeuralNetworkMachineLearningRudesheim
backend:						aTBackendNeuralNetworkMachineLearningRudesheim [

	^ super new
		setNeuralNetworkLayers:	aSequencialCollectionWIthTLayerNeuralNetworkMachineLearningRudesheim;
		setBackend:				aTBackendNeuralNetworkMachineLearningRudesheim;
		yourself.
]

{ #category : 'instance creation' }
TModelNeuralNetworkMachineLearningRudesheim classSide >> outputNode:	aTNodeNeuralNetworkMachineLearningRudesheim [

	^ self
		outputNode:	aTNodeNeuralNetworkMachineLearningRudesheim
		backend:		TBackendNeuralNetworkMachineLearningRudesheim default
]

{ #category : 'instance creation' }
TModelNeuralNetworkMachineLearningRudesheim classSide >> outputNode:	aTNodeNeuralNetworkMachineLearningRudesheim
backend:					aTBackendNeuralNetworkMachineLearningRudesheim [

	^ super new
		setOutputNode:	aTNodeNeuralNetworkMachineLearningRudesheim;
		setBackend:		aTBackendNeuralNetworkMachineLearningRudesheim;
		yourself.
]

{ #category : 'accessing' }
TModelNeuralNetworkMachineLearningRudesheim >> backend [

	^ self subclassResponsibility.
]

{ #category : 'accessing' }
TModelNeuralNetworkMachineLearningRudesheim classSide >> species [

	^ Rudesheim MachineLearning NeuralNetwork Model.
]

{ #category : 'evaluating' }
TModelNeuralNetworkMachineLearningRudesheim >> forward:	anInputNumbersSequencialCollection [
	"A resolved node value may be a live OpenCL buffer (see
	note/opencl-layer-buffer-passthrough-design.md); the model's public
	contract is a plain Array, so the final value is downloaded here (a
	no-op for a Pure-backend value that's already an Array). Every node
	value this forward pass resolved (cached in aValueCacheIdentityDictionary,
	including the output node's own value) is then released -- see
	SequenceableCollection>>releaseRudesheim / BufferOpenCLRudesheim>>releaseRudesheim
	for why this is the single, safe place to do that: nothing in the
	traversal above releases a shared/cached node value itself, only ever a
	private buffer a Layer uploaded just for its own use."

	|
		aValueCacheIdentityDictionary
		result
	|

	aValueCacheIdentityDictionary := IdentityDictionary new.
	result :=
		(
			self outputNode
				resolvedValueGivenInput:	anInputNumbersSequencialCollection
				cache:						aValueCacheIdentityDictionary
		) asArray.
	aValueCacheIdentityDictionary valuesDo: [ :each | each releaseRudesheim ].
	^ result
]

{ #category : 'accessing' }
TModelNeuralNetworkMachineLearningRudesheim >> neuralNetworkLayers [

	^ self subclassResponsibility.
]

{ #category : 'accessing' }
TModelNeuralNetworkMachineLearningRudesheim >> outputNode [

	^ self subclassResponsibility.
]

{ #category : 'initialization' }
TModelNeuralNetworkMachineLearningRudesheim >> setNeuralNetworkLayers:	aSequencialCollectionWIthTLayerNeuralNetworkMachineLearningRudesheim [

	^ self subclassResponsibility.
]

{ #category : 'initialization' }
TModelNeuralNetworkMachineLearningRudesheim >> setBackend: aTBackendNeuralNetworkMachineLearningRudesheim [

	^ self subclassResponsibility.
]

{ #category : 'initialization' }
TModelNeuralNetworkMachineLearningRudesheim >> setOutputNode:	aTNodeNeuralNetworkMachineLearningRudesheim [

	^ self subclassResponsibility.
]

{ #category : 'accessing' }
TModelNeuralNetworkMachineLearningRudesheim >> species [

	^ self class species.
]
