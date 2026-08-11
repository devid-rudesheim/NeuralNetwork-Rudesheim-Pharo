Trait {
	#name : 'TBackwardModelNeuralNetworkMachineLearningRudesheim',
	#traits : 'TModelNeuralNetworkMachineLearningRudesheim',
	#classTraits : 'TModelNeuralNetworkMachineLearningRudesheim classTrait',
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'training' }
TBackwardModelNeuralNetworkMachineLearningRudesheim >> backward:	aTPredictionsNeuralNetworkMachineLearningRudesheim
usingCriterion:		aTCriterionNeuralNetworkMachineLearningRudesheim [
	"Reverse-mode autodiff over the whole graph (reachable from outputNode), generalizing the
	single-predecessor-chain-only backward that used to live directly in Trainer. Runs one
	forward pass (via TNode>>forwardTraceGivenInput:cache:order:) to get both a node ->
	{input. output} value cache and a valid reverse-topological node order, seeds the output
	node's gradient from the criterion, then walks that order in reverse: for each node, read
	its accumulated gradient, call its layer's backward:, collect any parameter delta, and
	push the layer's input gradient on to its predecessors via TNode>>distributeGradient:
	toPredecessorGradients:usingValueCache: (which is what actually does the fan-out
	accumulation for a node with more than one downstream consumer). Because defaultOutputNode
	turns a flat neuralNetworkLayers: model into a degenerate single-predecessor chain of
	Nodes, this is a strict superset of the old flat-only backward -- it needs no separate
	code path for that case.

	Returns { loss. parameterDeltas }, where parameterDeltas is an OrderedCollection of
	{ aTNodeNeuralNetworkMachineLearningRudesheim. aParameterDeltaLayer } pairs (one per node
	whose layer returned a delta from backward:, i.e. has learned parameters), in the same
	reverse-topological order they were computed -- mirroring the { layer. delta } pairs
	TTrainer>>train:withExample: used to build from its traceCollection."

	|
		valueCache
		order
		criterionResult
		gradients
		parameterDeltas
	|

	valueCache := IdentityDictionary new.
	order := OrderedCollection new.

	self outputNode
		forwardTraceGivenInput:	aTPredictionsNeuralNetworkMachineLearningRudesheim inputPredictions
		cache:				valueCache
		order:				order.

	criterionResult :=
		aTCriterionNeuralNetworkMachineLearningRudesheim
			predictions:	( ( valueCache at: self outputNode ) outputPredictions ) asArray
			targets:			aTPredictionsNeuralNetworkMachineLearningRudesheim outputPredictions.

	gradients := IdentityDictionary new.
	gradients at: self outputNode put: criterionResult gradient.

	parameterDeltas :=
		OrderedCollection
			streamContents:
			[ :writeStream |
				order reverseDo:
				[ :eachNode |
					|
						backwardResult
					|

					backwardResult :=
						eachNode layer
							backward:
							(
								( valueCache at: eachNode )
									backwardContextWithGradient: ( gradients at: eachNode )
							).

					backwardResult
						ifNotEmpty:
						[
							writeStream
								nextPut:	{ eachNode. backwardResult last }
						].

					eachNode
						distributeGradient:			backwardResult first
						toPredecessorGradients:	gradients
						usingValueCache:				valueCache.
				]
			].

	"Every node's forward input/output may be a live OpenCL buffer (buffer-passthrough
	design) that forward: itself never downloads or releases -- TModel>>forward:
	releases its own single-pass-only cache the same way once it is done reading
	from it, and this cache is no different, just also read from during the
	backward pass above. releaseRudesheim is called only on values that provide
	that hook and is safe to call more than once on the same buffer (release
	checks its own handle for nil first), so no aliasing between a node's input
	and its predecessor's output needs to be tracked here."
	valueCache
		valuesDo:
		[ :eachPredictions |
			(eachPredictions inputPredictions respondsTo: #releaseRudesheim)
				ifTrue:
				[
					eachPredictions inputPredictions releaseRudesheim.
				].
			(eachPredictions outputPredictions respondsTo: #releaseRudesheim)
				ifTrue:
				[
					eachPredictions outputPredictions releaseRudesheim.
				].
		].

	^
	{
		criterionResult loss.
		parameterDeltas.
	}
]
