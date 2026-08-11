Class {
	#name : 'ModelNeuralNetworkMachineLearningRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-NeuralNetwork-OpenCL-Tests-Layer',
	#package : 'Rudesheim-NeuralNetwork-OpenCL-Tests',
	#tag : 'Layer'
}

{ #category : 'accessing' }
ModelNeuralNetworkMachineLearningRudesheimTest class >> targetClass [

	^ ModelNeuralNetworkMachineLearningRudesheim
]

{ #category : 'tests' }
ModelNeuralNetworkMachineLearningRudesheimTest >> testBackwardUsingCriterionMatchesFlatChainNeuralNetworkLayersConstructor [
	"defaultOutputNode turns a flat neuralNetworkLayers: model into a degenerate
	single-predecessor chain of Nodes, so backward:usingCriterion: (graph) must
	return exactly the same loss and the same number of parameter deltas as
	building the equivalent graph explicitly out of Nodes."

	|
		nn
		linearLayer1
		reluLayer
		linearLayer2
		flatModel
		graphModel
		example
		criterionClass
		flatResult
		graphResult
	|

	nn := Rudesheim MachineLearning NeuralNetwork.
	linearLayer1 :=
		nn OpenCL Layer LinearTransform
			weightsRows:	#( #( 0.5 0.3 ) #( -0.1 0.4 ) )
			biases:			#( 0.1 -0.2 ).
	reluLayer := nn OpenCL Layer ReLU.
	linearLayer2 :=
		nn OpenCL Layer LinearTransform
			weightsRows:	#( #( 0.2 -0.3 ) )
			biases:			#( 0.05 ).

	flatModel :=
		nn Model
			neuralNetworkLayers:	{ linearLayer1. reluLayer. linearLayer2 }
			backend:					nn OpenCL.
	graphModel :=
		nn Model
			outputNode:
			(
				nn Node
					layer:	linearLayer2
					predecessor:
					(
						nn Node
							layer:	reluLayer
							predecessor:	( nn Node layer: linearLayer1 )
					)
			)
			backend:	nn OpenCL.

	example :=
		nn Predictions
			inputPredictions:	#( 1.0 2.0 )
			outputPredictions:	#( 0.7 ).
	criterionClass := nn OpenCL Criterion MSE.

	flatResult := flatModel backward: example usingCriterion: criterionClass.
	graphResult := graphModel backward: example usingCriterion: criterionClass.

	self assert: flatResult first closeTo: graphResult first precision: 0.0001.
	self assert: flatResult last size equals: graphResult last size
]

{ #category : 'tests' }
ModelNeuralNetworkMachineLearningRudesheimTest >> testBackwardUsingCriterionAccumulatesGradientAtFanOutNode [
	"root -> mid -> {branchA, branchB} -> merge, all identity (CountingLayerForTest)
	layers, so every value stays exactly equal to the raw model input except for the
	merge node's concatenation. mid feeds two downstream consumers (branchA and
	branchB), so its own backward: must be called with the SUM of both branches'
	gradients, not just one of them -- this is the one behavior specific to
	branching that a single-predecessor-chain backward could never exercise."

	|
		nn
		rootLayer
		midLayer
		branchALayer
		branchBLayer
		mergeLayer
		root
		mid
		branchA
		branchB
		merge
		graphModel
		example
	|

	nn := Rudesheim MachineLearning NeuralNetwork.
	rootLayer := CountingLayerForTestNeuralNetworkMachineLearningRudesheim new.
	midLayer := CountingLayerForTestNeuralNetworkMachineLearningRudesheim new.
	branchALayer := CountingLayerForTestNeuralNetworkMachineLearningRudesheim new.
	branchBLayer := CountingLayerForTestNeuralNetworkMachineLearningRudesheim new.
	mergeLayer := CountingLayerForTestNeuralNetworkMachineLearningRudesheim new.

	root := nn Node layer: rootLayer.
	mid := nn Node layer: midLayer predecessor: root.
	branchA := nn Node layer: branchALayer predecessor: mid.
	branchB := nn Node layer: branchBLayer predecessor: mid.
	merge := nn Node layer: mergeLayer predecessors: { branchA. branchB }.

	graphModel := nn Model outputNode: merge backend: nn OpenCL.

	"root input #(5.0) stays #(5.0) through every identity layer down to branchA/
	branchB; merge concatenates the two identical branch outputs into #(5.0 5.0).
	MSE gradient against targets #(4.0 4.0) is (2/2)*(5-4, 5-4) = #(1.0 1.0).
	distributeGradient: splits that 1-and-1 between branchA/branchB, each of which
	passes its 1.0 straight through to mid -- so mid's backward: must see #(2.0),
	the sum of both, not #(1.0)."
	example :=
		nn Predictions
			inputPredictions:	#( 5.0 )
			outputPredictions:	#( 4.0 4.0 ).

	graphModel backward: example usingCriterion: nn OpenCL Criterion MSE.

	self assert: midLayer backwardCallCount equals: 1.
	self assert: midLayer lastBackwardGradient equals: #( 2.0 ).
	self assert: rootLayer lastBackwardGradient equals: #( 2.0 )
]
