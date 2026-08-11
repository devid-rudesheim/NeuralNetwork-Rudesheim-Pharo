Class {
	#name : 'NodeNeuralNetworkMachineLearningRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-NeuralNetwork-Tests-Layer',
	#package : 'Rudesheim-NeuralNetwork-Private-Tests',
	#tag : 'Layer'
}

{ #category : 'accessing' }
NodeNeuralNetworkMachineLearningRudesheimTest class >> targetClass [

	^ NodeNeuralNetworkMachineLearningRudesheim
]

{ #category : 'accessing' }
NodeNeuralNetworkMachineLearningRudesheimTest >> defaultBasicTarget [

	^ self targetClass layer: CountingLayerForTestNeuralNetworkMachineLearningRudesheim new
]

{ #category : 'tests' }
NodeNeuralNetworkMachineLearningRudesheimTest >> testChainForwardMatchesFlatLayerFold [

	|
		nn
		layers
		input
		expected
		model
	|

	nn := Rudesheim MachineLearning NeuralNetwork.
	layers := {
		nn Layer LinearTransform
			weightsRows: #( ( 0.5 0.3 ) ( -0.4 0.6 ) )
			biases: #( 0.0 0.0 ).
		nn Layer ReLU.
		nn Layer LinearTransform
			weightsRows: #( ( 0.4 0.7 ) )
			biases: #( 0.0 ).
	}.
	input := #( 1.0 0.0 ).
	expected := layers inject: input into: [ :predictions :eachLayer | eachLayer forward: predictions ].
	model := nn Model neuralNetworkLayers: layers.

	self assert: (model forward: input) equals: expected
]

{ #category : 'tests' }
NodeNeuralNetworkMachineLearningRudesheimTest >> testConstructorLeafHasSpecifiedLayer [

	|
		someLayer
		node
	|

	someLayer := CountingLayerForTestNeuralNetworkMachineLearningRudesheim new.
	node := self targetClass layer: someLayer.

	self assert: node layer == someLayer
]

{ #category : 'tests' }
NodeNeuralNetworkMachineLearningRudesheimTest >> testDefaultPredecessorsIsEmpty [

	self assert: self basicTarget predecessors isEmpty
]

{ #category : 'tests' }
NodeNeuralNetworkMachineLearningRudesheimTest >> testForwardWithZeroPredecessorsUsesModelInput [

	|
		result
	|

	result := self basicTarget resolvedValueGivenInput: #( 1.0 2.0 ) cache: IdentityDictionary new.

	self assert: result equals: #( 1.0 2.0 ).
	self assert: self basicTarget layer forwardCallCount equals: 1
]

{ #category : 'tests' }
NodeNeuralNetworkMachineLearningRudesheimTest >> testMergeNodeCombinesPredecessorValues [

	|
		nn
		root
		branchA
		branchB
		merge
		result
	|

	nn := Rudesheim MachineLearning NeuralNetwork.
	root := nn Node layer: CountingLayerForTestNeuralNetworkMachineLearningRudesheim new.
	branchA := nn Node layer: CountingLayerForTestNeuralNetworkMachineLearningRudesheim new predecessor: root.
	branchB := nn Node layer: CountingLayerForTestNeuralNetworkMachineLearningRudesheim new predecessor: root.
	merge := nn Node layer: CountingLayerForTestNeuralNetworkMachineLearningRudesheim new predecessors: { branchA. branchB }.
	result := merge resolvedValueGivenInput: #( 1.0 2.0 ) cache: IdentityDictionary new.

	self assert: result equals: #( 1.0 2.0 1.0 2.0 )
]

{ #category : 'tests' }
NodeNeuralNetworkMachineLearningRudesheimTest >> testAccumulateGradientSumsMultipleContributions [

	|
		accumulator
		node
	|

	accumulator := IdentityDictionary new.
	node := self targetClass layer: CountingLayerForTestNeuralNetworkMachineLearningRudesheim new.

	self targetClass
		accumulateGradient:	#( 1.0 2.0 )
		forNode:				node
		in:						accumulator.
	self targetClass
		accumulateGradient:	#( 0.5 -1.0 )
		forNode:				node
		in:						accumulator.

	self assert: ( accumulator at: node ) equals: #( 1.5 1.0 )
]

{ #category : 'tests' }
NodeNeuralNetworkMachineLearningRudesheimTest >> testDistributeGradientWithZeroPredecessorsIsNoOp [

	|
		accumulator
	|

	accumulator := IdentityDictionary new.

	self basicTarget
		distributeGradient:			#( 1.0 2.0 )
		toPredecessorGradients:	accumulator
		usingValueCache:				IdentityDictionary new.

	self assert: accumulator isEmpty
]

{ #category : 'tests' }
NodeNeuralNetworkMachineLearningRudesheimTest >> testDistributeGradientWithOnePredecessorPassesThroughUnchanged [

	|
		nn
		root
		leaf
		accumulator
	|

	nn := Rudesheim MachineLearning NeuralNetwork.
	root := nn Node layer: CountingLayerForTestNeuralNetworkMachineLearningRudesheim new.
	leaf := nn Node layer: CountingLayerForTestNeuralNetworkMachineLearningRudesheim new predecessor: root.
	accumulator := IdentityDictionary new.

	leaf
		distributeGradient:			#( 1.0 2.0 )
		toPredecessorGradients:	accumulator
		usingValueCache:				IdentityDictionary new.

	self assert: ( accumulator at: root ) equals: #( 1.0 2.0 )
]

{ #category : 'tests' }
NodeNeuralNetworkMachineLearningRudesheimTest >> testDistributeGradientWithTwoPredecessorsSplitsGradientByPredecessorLength [

	|
		nn
		root
		branchA
		branchB
		merge
		valueCache
		accumulator
	|

	nn := Rudesheim MachineLearning NeuralNetwork.
	root := nn Node layer: CountingLayerForTestNeuralNetworkMachineLearningRudesheim new.
	branchA := nn Node layer: CountingLayerForTestNeuralNetworkMachineLearningRudesheim new predecessor: root.
	branchB := nn Node layer: CountingLayerForTestNeuralNetworkMachineLearningRudesheim new predecessor: root.
	merge := nn Node layer: CountingLayerForTestNeuralNetworkMachineLearningRudesheim new predecessors: { branchA. branchB }.

	valueCache := IdentityDictionary new.
	valueCache
		at:	branchA
		put:	( nn Predictions inputPredictions: #() outputPredictions: #( 10.0 20.0 ) ).
	valueCache
		at:	branchB
		put:	( nn Predictions inputPredictions: #() outputPredictions: #( 30.0 ) ).

	accumulator := IdentityDictionary new.
	merge
		distributeGradient:			#( 1.0 2.0 3.0 )
		toPredecessorGradients:	accumulator
		usingValueCache:				valueCache.

	self assert: ( accumulator at: branchA ) equals: #( 1.0 2.0 ).
	self assert: ( accumulator at: branchB ) equals: #( 3.0 )
]

{ #category : 'tests' }
NodeNeuralNetworkMachineLearningRudesheimTest >> testForwardTraceGivenInputRecordsReverseTopologicalOrderForBranchingGraph [

	|
		nn
		root
		branchA
		branchB
		merge
		valueCache
		order
	|

	nn := Rudesheim MachineLearning NeuralNetwork.
	root := nn Node layer: CountingLayerForTestNeuralNetworkMachineLearningRudesheim new.
	branchA := nn Node layer: CountingLayerForTestNeuralNetworkMachineLearningRudesheim new predecessor: root.
	branchB := nn Node layer: CountingLayerForTestNeuralNetworkMachineLearningRudesheim new predecessor: root.
	merge := nn Node layer: CountingLayerForTestNeuralNetworkMachineLearningRudesheim new predecessors: { branchA. branchB }.

	valueCache := IdentityDictionary new.
	order := OrderedCollection new.
	merge
		forwardTraceGivenInput:	#( 1.0 2.0 )
		cache:				valueCache
		order:				order.

	"root must come before both branches, and both branches before merge;
	root is only ever resolved once despite feeding two downstream consumers."
	self assert: order last equals: merge.
	self assert: ( order indexOf: root ) < ( order indexOf: branchA ).
	self assert: ( order indexOf: root ) < ( order indexOf: branchB ).
	self assert: order size equals: 4.
	self assert: root layer forwardCallCount equals: 1
]

{ #category : 'tests' }
NodeNeuralNetworkMachineLearningRudesheimTest >> testSharedPredecessorIsResolvedOnce [

	|
		nn
		rootLayer
		root
		branchA
		branchB
		merge
	|

	nn := Rudesheim MachineLearning NeuralNetwork.
	rootLayer := CountingLayerForTestNeuralNetworkMachineLearningRudesheim new.
	root := nn Node layer: rootLayer.
	branchA := nn Node layer: CountingLayerForTestNeuralNetworkMachineLearningRudesheim new predecessor: root.
	branchB := nn Node layer: CountingLayerForTestNeuralNetworkMachineLearningRudesheim new predecessor: root.
	merge := nn Node layer: CountingLayerForTestNeuralNetworkMachineLearningRudesheim new predecessors: { branchA. branchB }.
	merge resolvedValueGivenInput: #( 1.0 ) cache: IdentityDictionary new.

	self assert: rootLayer forwardCallCount equals: 1
]
