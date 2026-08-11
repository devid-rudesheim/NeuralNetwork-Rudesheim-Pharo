Trait {
	#name : 'TTrainerNeuralNetworkMachineLearningRudesheim',
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'accessing' }
TTrainerNeuralNetworkMachineLearningRudesheim classSide >> criterion [
	
	^ self subclassResponsibility.
]

{ #category : 'instance creation' }
TTrainerNeuralNetworkMachineLearningRudesheim classSide >> criterion: aTCriterionNeuralNetworkMachineLearningRudesheim [

	^ super new
		setCriterion: aTCriterionNeuralNetworkMachineLearningRudesheim;
		yourself
]

{ #category : 'accessing' }
TTrainerNeuralNetworkMachineLearningRudesheim classSide >> epochs [
	
	^ self subclassResponsibility.
]

{ #category : 'accessing' }
TTrainerNeuralNetworkMachineLearningRudesheim classSide >> learningRate [
	
	^ self subclassResponsibility.
]

{ #category : 'accessing' }
TTrainerNeuralNetworkMachineLearningRudesheim >> criterion [
	
	^ self class criterion.
]

{ #category : 'accessing' }
TTrainerNeuralNetworkMachineLearningRudesheim >> epochs [
	
	^ self class epochs.
]

{ #category : 'accessing' }
TTrainerNeuralNetworkMachineLearningRudesheim >> learningRate [
	
	^ self class learningRate
]

{ #category : 'initialization' }
TTrainerNeuralNetworkMachineLearningRudesheim >> setCriterion: aTCriterionNeuralNetworkMachineLearningRudesheim [

	^ self subclassResponsibility
]

{ #category : 'training' }
TTrainerNeuralNetworkMachineLearningRudesheim >> train:				aTModelNeuralNetworkMachineLearningRudesheim
withDataset:		aSequencialCollection [

	^
	(
		1
			to:	 self epochs
	)
		inject:
		{
			0.0.
			aTModelNeuralNetworkMachineLearningRudesheim
		}
		into:
		[ :state :unused |
			self
				trainOneEpoch:	state last
				withDataset:		aSequencialCollection.
		].
]

{ #category : 'training' }
TTrainerNeuralNetworkMachineLearningRudesheim >> train:				aTModelNeuralNetworkMachineLearningRudesheim
withDataset:		aSequencialCollection
byCriterion:		aCriterionBlock [

	^ ( self class criterion: ( aCriterionBlock value: aTModelNeuralNetworkMachineLearningRudesheim backend Criterion ) )
		train:			aTModelNeuralNetworkMachineLearningRudesheim
		withDataset:	aSequencialCollection
]

{ #category : 'training' }
TTrainerNeuralNetworkMachineLearningRudesheim >> train:				aTModelNeuralNetworkMachineLearningRudesheim
withExample:		aTPredictionsNeuralNetworkMachineLearningRudesheim [
	"Delegates to TBackwardModel>>backward:usingCriterion: (reverse-mode autodiff over
	aTModelNeuralNetworkMachineLearningRudesheim's outputNode graph) rather than walking
	neuralNetworkLayers directly: defaultOutputNode turns a flat neuralNetworkLayers:
	model into a degenerate single-predecessor chain of Nodes, so the graph traversal is
	a strict superset of what this method used to do by hand (build a traceCollection,
	walk it in reverse) -- no separate flat-only code path is needed. The one thing this
	method still owns is turning backward:usingCriterion:'s { node. delta } pairs into
	the next epoch's Model, via Node>>rebuiltUsingParameterDeltas:learningRate:cache:."

	|
		result
		parameterDeltasByNode
	|

	result :=
		aTModelNeuralNetworkMachineLearningRudesheim
			backward:			aTPredictionsNeuralNetworkMachineLearningRudesheim
			usingCriterion:	self criterion.

	parameterDeltasByNode := IdentityDictionary new.
	result last
		do:
		[ :eachPair |
			parameterDeltasByNode
				at:		eachPair first
				put:	eachPair last
		].

	^
	{
		result first.
		aTModelNeuralNetworkMachineLearningRudesheim species
			outputNode:
			(
				aTModelNeuralNetworkMachineLearningRudesheim outputNode
					rebuiltUsingParameterDeltas:	parameterDeltasByNode
					learningRate:					self learningRate
					cache:							IdentityDictionary new
			)
			backend:	aTModelNeuralNetworkMachineLearningRudesheim backend
	}
]

{ #category : 'training' }
TTrainerNeuralNetworkMachineLearningRudesheim >> trainOneEpoch:	aTModelNeuralNetworkMachineLearningRudesheim
withDataset:		aSequencialCollectionWithTPredictionsNeuralNetworkMachineLearningRudesheim [
	|
		result
	|
	
	aSequencialCollectionWithTPredictionsNeuralNetworkMachineLearningRudesheim
		ifEmpty:
		[
			^ aTModelNeuralNetworkMachineLearningRudesheim.
		].	

	result := aSequencialCollectionWithTPredictionsNeuralNetworkMachineLearningRudesheim
		inject:
		{
			0.0.
			aTModelNeuralNetworkMachineLearningRudesheim.
		}
		into:
		[ :state :each |
			|
				nextState
			|
			
			nextState :=
				self
					train:				state last
					withExample:		each.
			
			{
				nextState first + state first.
				nextState last.
			}
		].

	"Every parameter-updated Layer/Node from every example this epoch (see
	Node>>rebuiltUsingParameterDeltas:learningRate:cache:) is superseded and
	unreachable by now, but the native semaphores OpenCL kernel launches use
	(distinct from the buffers Layer>>releaseRudesheim already frees explicitly)
	are only returned to their pool via GC-triggered finalization. Without
	forcing a collection here, a long OpenCL-backed training run reliably
	exhausts the VM's external-object table well before Pharo's own GC would
	otherwise have run one on its own (confirmed empirically: identical training
	code reliably failed within ~10 epochs without this, and ran cleanly with it)."
	Smalltalk garbageCollect.

	^
	{
		result first / aSequencialCollectionWithTPredictionsNeuralNetworkMachineLearningRudesheim size.
		result last.
	}.
]
