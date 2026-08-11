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
		backend:				self backend
]

{ #category : 'accessing' }
TModelNeuralNetworkMachineLearningRudesheim classSide >> backend [

	^ TBackendNeuralNetworkMachineLearningRudesheim default
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
		backend:		self backend
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
	note/opencl-layer-buffer-passthrough-design.md). The caller decides when
	to materialize it with asArray. Every cached node value except the returned
	final value is released here; ownership of the returned value moves to the
	caller."

	|
		aValueCacheIdentityDictionary
		result
	|

	aValueCacheIdentityDictionary := IdentityDictionary new.
	result :=
		self outputNode
			resolvedValueGivenInput:	anInputNumbersSequencialCollection
			cache:						aValueCacheIdentityDictionary.
	aValueCacheIdentityDictionary valuesDo:
	[ :each |
		each == result
			ifFalse:
			[
				each releaseRudesheim.
			].
	].
	^ result
]

{ #category : 'evaluating' }
TModelNeuralNetworkMachineLearningRudesheim >> value: aSequenceableCollection [

	|
		result
	|

	result := self forward: aSequenceableCollection.
	^
	[
		result asArray
	]
		ensure:
		[
			result releaseRudesheim.
		]
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
