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

	^ self subclassResponsibility
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
	note/opencl-layer-buffer-passthrough-design.md) before it is materialized here.
	Every cached node value, including the final one, is released once this pass is
	done reading from it; the returned value is always a plain materialized Array,
	identical to what value: returns (value: is a plain alias for this method)."

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
				each releaseIfApplicableRudesheim.
			].
	].
	^
	[
		result asArray
	]
		ensure:
		[
			result releaseIfApplicableRudesheim.
		]
]

{ #category : 'evaluating' }
TModelNeuralNetworkMachineLearningRudesheim >> value: aSequenceableCollection [

	^ self forward: aSequenceableCollection
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
