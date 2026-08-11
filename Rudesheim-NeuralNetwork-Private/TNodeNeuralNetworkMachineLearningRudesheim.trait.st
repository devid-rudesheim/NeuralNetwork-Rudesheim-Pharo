Trait {
	#name : 'TNodeNeuralNetworkMachineLearningRudesheim',
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'instance creation' }
TNodeNeuralNetworkMachineLearningRudesheim classSide >> layer: aTLayerNeuralNetworkMachineLearningRudesheim [

	^ self
		layer: aTLayerNeuralNetworkMachineLearningRudesheim
		predecessors: #()
]

{ #category : 'instance creation' }
TNodeNeuralNetworkMachineLearningRudesheim classSide >> layer: aTLayerNeuralNetworkMachineLearningRudesheim predecessor: aNodeNeuralNetworkMachineLearningRudesheim [

	^ self
		layer: aTLayerNeuralNetworkMachineLearningRudesheim
		predecessors: { aNodeNeuralNetworkMachineLearningRudesheim }
]

{ #category : 'instance creation' }
TNodeNeuralNetworkMachineLearningRudesheim classSide >> layer: aTLayerNeuralNetworkMachineLearningRudesheim predecessors: aPredecessorsSequenceableCollection [

	^ super new
		setLayer: aTLayerNeuralNetworkMachineLearningRudesheim
		predecessors: aPredecessorsSequenceableCollection;
		yourself
]

{ #category : 'accessing' }
TNodeNeuralNetworkMachineLearningRudesheim classSide >> species [

	^ Rudesheim MachineLearning NeuralNetwork Node
]

{ #category : 'accessing' }
TNodeNeuralNetworkMachineLearningRudesheim >> layer [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
TNodeNeuralNetworkMachineLearningRudesheim >> predecessors [

	^ self subclassResponsibility
]

{ #category : 'training' }
TNodeNeuralNetworkMachineLearningRudesheim classSide >> accumulateGradient:	aGradientSequenceableCollection
forNode:	aTNodeNeuralNetworkMachineLearningRudesheim
in:			aGradientAccumulatorIdentityDictionary [
	"Sums aGradientSequenceableCollection into aTNodeNeuralNetworkMachineLearningRudesheim's
	running total in aGradientAccumulatorIdentityDictionary, lazily seeding a same-shaped
	zero vector the first time a node is touched -- this is how fan-out (a node with more
	than one downstream consumer) accumulates every consumer's contribution before the
	node's own backward: runs."

	|
		zeroGradient
		existingGradient
	|

	zeroGradient := aGradientSequenceableCollection collect: [ :each | 0.0 ].

	existingGradient :=
		aGradientAccumulatorIdentityDictionary
			at:	aTNodeNeuralNetworkMachineLearningRudesheim
			ifAbsentPut: [ zeroGradient ].

	aGradientAccumulatorIdentityDictionary
		at:		aTNodeNeuralNetworkMachineLearningRudesheim
		put:	( existingGradient with: aGradientSequenceableCollection collect: [ :left :right | left + right ] )
]

{ #category : 'training' }
TNodeNeuralNetworkMachineLearningRudesheim >> distributeGradient:	anInputGradientSequenceableCollection
toPredecessorGradients:	aGradientAccumulatorIdentityDictionary
usingValueCache:			aValueCacheIdentityDictionary [
	"The exact inverse of valueFromPredecessorValues:givenInput: (which concatenates every
	predecessor's output into one flat array before forward:): routes anInputGradientSequenceableCollection
	(this node's layer's backward:-returned input gradient) back to each predecessor's own
	accumulator slot, splitting it into predecessor-sized slices for the 2+ case using each
	predecessor's own output length from aValueCacheIdentityDictionary."

	self predecessors isEmpty
		ifTrue: [ ^ self ].

	self predecessors size = 1
		ifTrue:
		[
			^ self class
				accumulateGradient:	anInputGradientSequenceableCollection
				forNode:				self predecessors first
				in:						aGradientAccumulatorIdentityDictionary
		].

	self predecessors
		inject:	0
		into:
		[ :offset :eachPredecessorNode |
			|
				length
			|

			"outputPredictions may be a live OpenCL buffer passed through from an
			upstream Layer -- see note/opencl-layer-buffer-passthrough-design.md --
			which is not indexable/does not understand #size directly, so asArray
			it first (a no-op for a value that's already a plain Array)."
			length := ( ( aValueCacheIdentityDictionary at: eachPredecessorNode ) outputPredictions ) asArray size.

			self class
				accumulateGradient:
					( anInputGradientSequenceableCollection copyFrom: offset + 1 to: offset + length )
				forNode:	eachPredecessorNode
				in:			aGradientAccumulatorIdentityDictionary.

			offset + length
		]
]

{ #category : 'training' }
TNodeNeuralNetworkMachineLearningRudesheim >> forwardTraceGivenInput:	anInputNumbersSequenceableCollection
cache:				aValueCacheIdentityDictionary
order:				anOrderedCollection [
	"Like resolvedValueGivenInput:cache:, but additionally records this layer's own input
	(not just its output) and appends every node to anOrderedCollection the first time it is
	resolved. Because a node is only appended after every predecessor's recursive call above
	has already appended itself, anOrderedCollection ends up in a valid topological order
	(graph inputs first, this node's own output node last) -- reverseDo: over it is therefore
	a valid reverse-topological order for backward traversal."

	|
		layerInput
		layerOutput
	|

	^ aValueCacheIdentityDictionary
		at: self
		ifAbsentPut:
		[
			layerInput :=
				self
					valueFromPredecessorValues:
					(
						self predecessors
							collect:
							[ :eachPredecessorNode |
								(
									eachPredecessorNode
										forwardTraceGivenInput:	anInputNumbersSequenceableCollection
										cache:				aValueCacheIdentityDictionary
										order:				anOrderedCollection
								)
									outputPredictions
							]
					)
					givenInput: anInputNumbersSequenceableCollection.

			layerOutput := self layer forward: layerInput.

			anOrderedCollection addLast: self.

			Rudesheim MachineLearning NeuralNetwork Predictions
				inputPredictions:	layerInput
				outputPredictions:	layerOutput
		]
]

{ #category : 'training' }
TNodeNeuralNetworkMachineLearningRudesheim >> rebuiltUsingParameterDeltas:	aParameterDeltaIdentityDictionary
learningRate:				aRateFloat
cache:						aRebuiltNodeCacheIdentityDictionary [
	"Returns a new Node graph, structurally identical to self's, with every node's
	layer replaced by layer withUpdatedWeightsRows:learningRate: applied against
	that node's entry in aParameterDeltaIdentityDictionary (the parameterDeltas
	TBackwardModel>>backward:usingCriterion: returns, keyed by node). Predecessors
	are rebuilt first (memoized, so a shared predecessor is only rebuilt once) --
	this is how Trainer produces the next epoch's Model from one call to
	backward:usingCriterion:.

	A parameterized Layer's withUpdatedWeightsRows:learningRate: builds a whole
	new instance (with its own new GPU buffers) rather than mutating self in
	place, so once the replacement exists the superseded old layer's own buffers
	are released via releaseRudesheim (where implemented -- a parameterless Layer's
	withUpdatedWeightsRows:learningRate: is a no-op returning self unchanged, so
	oldLayer == newLayer there and nothing needs releasing). Training repeats this
	once per example, so without this release a long training run reliably
	exhausts the VM's external-object table."

	|
		delta
		oldLayer
		newLayer
	|

	^ aRebuiltNodeCacheIdentityDictionary
		at: self
		ifAbsentPut:
		[
			delta := aParameterDeltaIdentityDictionary at: self ifAbsent: [ nil ].
			oldLayer := self layer.
			newLayer :=
				delta
					ifNil:		[ oldLayer ]
					ifNotNil:	[ oldLayer withUpdatedWeightsRows: delta learningRate: aRateFloat ].

			( newLayer == oldLayer )
				ifFalse:
				[
					( oldLayer respondsTo: #releaseRudesheim )
						ifTrue: [ oldLayer releaseRudesheim ]
				].

			self species
				layer:			newLayer
				predecessors:
				(
					self predecessors
						collect:
						[ :eachPredecessorNode |
							eachPredecessorNode
								rebuiltUsingParameterDeltas:	aParameterDeltaIdentityDictionary
								learningRate:					aRateFloat
								cache:							aRebuiltNodeCacheIdentityDictionary
						]
				)
		]
]

{ #category : 'evaluating' }
TNodeNeuralNetworkMachineLearningRudesheim >> resolvedValueGivenInput: anInputNumbersSequenceableCollection cache: aValueCacheIdentityDictionary [

	^ aValueCacheIdentityDictionary
		at: self
		ifAbsentPut:
		[
			self layer
				forward:
				(
					self
						valueFromPredecessorValues:
						(
							self predecessors
								collect:
								[ :eachPredecessorNode |
									eachPredecessorNode
										resolvedValueGivenInput: anInputNumbersSequenceableCollection
										cache: aValueCacheIdentityDictionary
								]
						)
						givenInput: anInputNumbersSequenceableCollection
				)
		]
]

{ #category : 'initialization' }
TNodeNeuralNetworkMachineLearningRudesheim >> setLayer: aTLayerNeuralNetworkMachineLearningRudesheim predecessors: aPredecessorsSequenceableCollection [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
TNodeNeuralNetworkMachineLearningRudesheim >> species [

	^ self class species
]

{ #category : 'private' }
TNodeNeuralNetworkMachineLearningRudesheim >> valueFromPredecessorValues: aPredecessorValuesSequenceableCollection givenInput: anInputNumbersSequenceableCollection [

	self predecessors isEmpty
		ifTrue: [ ^ anInputNumbersSequenceableCollection ].

	self predecessors size = 1
		ifTrue: [ ^ aPredecessorValuesSequenceableCollection first ].

	"Merges a branching node's 2+ predecessor outputs into the one flat value its
	layer expects (currently always AddLayer, per its class comment). If the
	value provides an OpenCL-side concatenation hook, use it; otherwise fall back
	to ordinary host-side sequence concatenation. It does not release anything: a
	predecessor buffer may still have another downstream consumer sharing the
	same cached node value, so ownership of the release stays with
	TModel>>forward:'s end-of-pass cache cleanup."
	^ aPredecessorValuesSequenceableCollection allButFirst
		inject: aPredecessorValuesSequenceableCollection first
		into:
		[ :combined :each |
			(combined respondsTo: #rudesheimConcatenatedWith:)
				ifTrue:
				[
					combined rudesheimConcatenatedWith: each
				]
				ifFalse:
				[
					combined , each asArray
				]
		]
]
