"
A ModelNeuralNetworkMachineLearningRudesheim represents its network as a computation graph of NodeNeuralNetworkMachineLearningRudesheim objects. Each Node pairs one layer with a collection of predecessor nodes it reads its input from (0 nodes = a graph input, 1 node = a linear chain step, 2+ nodes = a branch/skip-connection merge). Model holds an outputNode; TModel>>forward: resolves that node's value by first resolving its predecessor nodes' values, caching each node's value in a fresh IdentityDictionary for the duration of one forward pass so a node with multiple downstream consumers is not recomputed.

The neuralNetworkLayers: constructor still builds a plain linear sequence of layers, unchanged; outputNode is now lazily derived from it as a single-predecessor chain of nodes, so existing linear-model usage (e.g. the MLP architecture) is unaffected.

TBackwardModel adds backward:usingCriterion:, reverse-mode autodiff over the same graph: one forward pass records both the per-node {input. output} values and a valid reverse-topological node order (TNode>>forwardTraceGivenInput:cache:order:), then that order is walked in reverse calling each node's layer backward:, accumulating gradients at any node with more than one downstream consumer (TNode>>distributeGradient:toPredecessorGradients:usingValueCache:). Because defaultOutputNode turns a flat neuralNetworkLayers: model into a degenerate single-predecessor chain, this graph backward is a strict superset of the old chain-only backward that used to live directly in Trainer -- no separate code path is needed for that case.
"
Class {
	#name : 'ModelNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#traits : 'TBackwardModelNeuralNetworkMachineLearningRudesheim + TShouldntNewRudesheim',
	#classTraits : 'TBackwardModelNeuralNetworkMachineLearningRudesheim classTrait + TShouldntNewRudesheim classTrait',
	#instVars : [
		'neuralNetworkLayers',
		'outputNode',
		'backend'
	],
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'accessing' }
ModelNeuralNetworkMachineLearningRudesheim >> backend [

	^ backend
		ifNil: [ self error: 'Model backend must be explicit; use nn Pure Model or nn OpenCL Model' ]
]

{ #category : 'accessing' }
ModelNeuralNetworkMachineLearningRudesheim >> defaultOutputNode [

	|
		nn
		layers
	|

	nn := Rudesheim MachineLearning NeuralNetwork.
	layers := self neuralNetworkLayers.

	^ layers allButFirst
		inject:	( nn Node layer: layers first )
		into:
		[ :previousNode :eachLayer |
			nn Node
				layer:			eachLayer
				predecessor:	previousNode.
		]
]

{ #category : 'accessing' }
ModelNeuralNetworkMachineLearningRudesheim >> neuralNetworkLayers [

	^ neuralNetworkLayers.
]

{ #category : 'accessing' }
ModelNeuralNetworkMachineLearningRudesheim >> outputNode [

	^ outputNode
		ifNil: [ outputNode := self defaultOutputNode ]
]

{ #category : 'initialization' }
ModelNeuralNetworkMachineLearningRudesheim >> setBackend: aTBackendNeuralNetworkMachineLearningRudesheim [

	backend := aTBackendNeuralNetworkMachineLearningRudesheim
]

{ #category : 'initialization' }
ModelNeuralNetworkMachineLearningRudesheim >> setNeuralNetworkLayers:	aSequencialCollectionWIthTLayerNeuralNetworkMachineLearningRudesheim [

	neuralNetworkLayers := aSequencialCollectionWIthTLayerNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'initialization' }
ModelNeuralNetworkMachineLearningRudesheim >> setOutputNode:	aTNodeNeuralNetworkMachineLearningRudesheim [

	outputNode := aTNodeNeuralNetworkMachineLearningRudesheim.
]
