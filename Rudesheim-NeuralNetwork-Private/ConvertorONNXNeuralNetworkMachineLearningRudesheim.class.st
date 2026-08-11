"
ConvertorONNXNeuralNetworkMachineLearningRudesheim defines ONNX conversion entry points for Soil-backed neural network roots.
"
Class {
	#name : 'ConvertorONNXNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'as yet unclassified' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> commitRoot: aStoreRootSoilNeuralNetworkMachineLearningRudesheim
toSoil: aSoil [
	|
		transaction
	|

	transaction := aSoil newTransaction.

	transaction
		root:	aStoreRootSoilNeuralNetworkMachineLearningRudesheim.

	transaction commit.
	^ aStoreRootSoilNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'as yet unclassified' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> defaultModelRecordInRoot: aStoreRootSoilNeuralNetworkMachineLearningRudesheim [
	^ aStoreRootSoilNeuralNetworkMachineLearningRudesheim
		at:	
		(
			aStoreRootSoilNeuralNetworkMachineLearningRudesheim
				symbolByName:	'default'
		)
		ifAbsentPut:
		[
			ModelRecordSoilNeuralNetworkMachineLearningRudesheim new.
		].
]

{ #category : 'as yet unclassified' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> file: aFileReferenceObject
toSoil: aSoilFileReferenceObject [
	^ self
		file:	aFileReferenceObject
		toSoil:	aSoilFileReferenceObject
		progress:
		[ :event :object |
		].
]

{ #category : 'as yet unclassified' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> file: aFileReferenceObject
toSoil: aSoilFileReferenceObject
backend: aTBackendNeuralNetworkMachineLearningRudesheimClass [
	^ self
		file:	aFileReferenceObject
		toSoil:	aSoilFileReferenceObject
		progress:
		[ :event :object |
		]
		backend:	aTBackendNeuralNetworkMachineLearningRudesheimClass.
]

{ #category : 'as yet unclassified' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> file: aFileReferenceObject
toSoil: aSoilFileReferenceObject
progress: aBlock [
	|
		fileReference
		soilFileReference
	|

	fileReference := aFileReferenceObject asFileReference.
	soilFileReference := aSoilFileReferenceObject asFileReference.

	fileReference exists
		ifFalse:
		[
			self
				notifyProgress:	aBlock
				event:	#failed
				object:	fileReference.

			self
				error:	'ONNX file does not exist: ' , fileReference fullName.
		].

	^
	(
		Soil
			ensureOnPath:	soilFileReference
	)
		intoRHScope
		do:
		[ :soil |
			fileReference
				binaryReadStreamDo:
				[ :readStream |
					self
						readStream:	readStream
						toSoil:	soil
						sourceFileReference:	fileReference
						progress:	aBlock.
				].
		].
]

{ #category : 'as yet unclassified' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> file: aFileReferenceObject
toSoil: aSoilFileReferenceObject
progress: aBlock
backend: aTBackendNeuralNetworkMachineLearningRudesheimClass [
	|
		fileReference
		soilFileReference
	|

	fileReference := aFileReferenceObject asFileReference.
	soilFileReference := aSoilFileReferenceObject asFileReference.

	fileReference exists
		ifFalse:
		[
			self
				notifyProgress:	aBlock
				event:	#failed
				object:	fileReference.

			self
				error:	'ONNX file does not exist: ' , fileReference fullName.
		].

	^
	(
		Soil
			ensureOnPath:	soilFileReference
	)
		intoRHScope
		do:
		[ :soil |
			fileReference
				binaryReadStreamDo:
				[ :readStream |
					self
						readStream:	readStream
						toSoil:	soil
						sourceFileReference:	fileReference
						progress:	aBlock
						backend:	aTBackendNeuralNetworkMachineLearningRudesheimClass.
				].
		].
]

{ #category : 'as yet unclassified' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> graphNodeRecordFromSTONEntry: aSTONNodeEntryArray
builtNodeRecords: aBuiltNodeRecordsSequenceableCollection
tensorDescriptorRecords: aTensorDescriptorRecordsSequenceableCollection [
	^ self
		graphNodeRecordFromSTONEntry:	aSTONNodeEntryArray
		builtNodeRecords:	aBuiltNodeRecordsSequenceableCollection
		tensorDescriptorRecords:	aTensorDescriptorRecordsSequenceableCollection
		backend:	PureNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'as yet unclassified' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> graphNodeRecordFromSTONEntry: aSTONNodeEntryArray
builtNodeRecords: aBuiltNodeRecordsSequenceableCollection
tensorDescriptorRecords: aTensorDescriptorRecordsSequenceableCollection
backend: aTBackendNeuralNetworkMachineLearningRudesheimClass [
	|
		layerName
		predecessorIndices
		tensorIndices
		windowArray
		record
	|

	layerName := aSTONNodeEntryArray first.
	predecessorIndices := aSTONNodeEntryArray second.
	tensorIndices := aSTONNodeEntryArray third.
	windowArray := aSTONNodeEntryArray fourth.

	record :=
		Rudesheim
			MachineLearning
			NeuralNetwork
			Soil
			GraphNodeRecord
			layerClass:	
			(
				ONNXNeuralNetworkMachineLearningRudesheim
					layerClassForName:	layerName
					backend:	aTBackendNeuralNetworkMachineLearningRudesheimClass
			)
			predecessorRecords:	
			(
				predecessorIndices
					collect:
					[ :eachIndex |
						aBuiltNodeRecordsSequenceableCollection
							at:	eachIndex.
					]
			)
			tensorDescriptorRecords:	
			(
				tensorIndices
					collect:
					[ :eachIndex |
						aTensorDescriptorRecordsSequenceableCollection
							at:	eachIndex.
					]
			).

	record
		layerAttributesRecords:	
		(
			self
				layerAttributesRecordsFromSTONWindowArray:	windowArray
		).

	^ record.
]

{ #category : 'as yet unclassified' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> layerAttributesRecordsFromSTONWindowArray: aSTONWindowArray [
	^ aSTONWindowArray
		collect:
		[ :eachFieldsArray |
			self
				windowSpecificationFromSTONFieldsArray:	eachFieldsArray.
		].
]

{ #category : 'as yet unclassified' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> notifyProgress: aBlock
event: aSymbol
object: anObject [
	^ aBlock
		cull:	aSymbol
		cull:	anObject.
]

{ #category : 'as yet unclassified' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> onnxToSTONScriptFileReference [
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
		/ 'tool'
		/ 'onnx_to_ston.py'.
]

{ #category : 'as yet unclassified' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> payloadFromModelRecord: aModelRecordSoilNeuralNetworkMachineLearningRudesheim [
	|
		payload
		sourceFileReference
	|

	payload := aModelRecordSoilNeuralNetworkMachineLearningRudesheim externalPayload.

	payload
		ifNotNil:
		[
			^ payload.
		].

	sourceFileReference := aModelRecordSoilNeuralNetworkMachineLearningRudesheim externalFileReference.

	sourceFileReference
		ifNil:
		[
			self
				error:	'Model record does not contain ONNX payload'.
		].

	sourceFileReference exists
		ifFalse:
		[
			self
				error:	'ONNX source file does not exist: ' , sourceFileReference fullName.
		].

	^ sourceFileReference
		binaryReadStream
		contents.
]

{ #category : 'as yet unclassified' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> populateGraphFor: aModelRecordSoilNeuralNetworkMachineLearningRudesheim
fromONNXFileReference: aFileReference [
	^ self
		populateGraphFor:	aModelRecordSoilNeuralNetworkMachineLearningRudesheim
		fromONNXFileReference:	aFileReference
		backend:	PureNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'as yet unclassified' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> populateGraphFor: aModelRecordSoilNeuralNetworkMachineLearningRudesheim
fromONNXFileReference: aFileReference
backend: aTBackendNeuralNetworkMachineLearningRudesheimClass [
	|
		stonFileReference
		document
		tensorEntries
		nodeEntries
		outputNodeIndex
		metadata
		tensorDescriptorRecords
		nodeRecords
	|

	stonFileReference :=
		self
			stonFileReferenceForONNXFileReference:	aFileReference.
	[
		document :=
			STON
				fromStream:	stonFileReference readStream.

		tensorEntries := document first.
		nodeEntries := document second.
		outputNodeIndex := document third.
		metadata := document fourth.

		tensorDescriptorRecords :=
			tensorEntries
				collect:
				[ :eachEntry |
					self
						tensorDescriptorFromSTONEntry:	eachEntry.
				].

		nodeRecords := OrderedCollection new.

		nodeEntries
			do:
			[ :eachEntry |
				nodeRecords
					add:	
					(
						self
							graphNodeRecordFromSTONEntry:	eachEntry
							builtNodeRecords:	nodeRecords
							tensorDescriptorRecords:	tensorDescriptorRecords
							backend:	aTBackendNeuralNetworkMachineLearningRudesheimClass
					).
			].

		tensorDescriptorRecords
			do:
			[ :each |
				aModelRecordSoilNeuralNetworkMachineLearningRudesheim
					addTensorDescriptorRecord:	each.
			].

		nodeRecords
			do:
			[ :each |
				aModelRecordSoilNeuralNetworkMachineLearningRudesheim
					addGraphNodeRecord:	each.
			].

		aModelRecordSoilNeuralNetworkMachineLearningRudesheim
			outputGraphNodeRecord:	
			(
				nodeRecords
					at:	outputNodeIndex
			).

		aModelRecordSoilNeuralNetworkMachineLearningRudesheim metadata
			at:	#graphName
			put:	metadata second.
	]
		ensure:
		[
			stonFileReference exists
				ifTrue:
				[
					stonFileReference delete.
				].
		].
]

{ #category : 'as yet unclassified' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> readStream: aReadStream
toSoil: aSoil [
	^ self
		readStream:	aReadStream
		toSoil:	aSoil
		sourceFileReference:	nil.
]

{ #category : 'as yet unclassified' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> readStream: aReadStream
toSoil: aSoil
progress: aBlock [
	^ self
		readStream:	aReadStream
		toSoil:	aSoil
		sourceFileReference:	nil
		progress:	aBlock.
]

{ #category : 'as yet unclassified' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> readStream: aReadStream
toSoil: aSoil
sourceFileReference: aFileReference [
	^ self
		readStream:	aReadStream
		toSoil:	aSoil
		sourceFileReference:	aFileReference
		progress:
		[ :event :object |
		].
]

{ #category : 'as yet unclassified' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> readStream: aReadStream
toSoil: aSoil
sourceFileReference: aFileReference
progress: aBlock [
	^ self
		readStream:	aReadStream
		toSoil:	aSoil
		sourceFileReference:	aFileReference
		progress:	aBlock
		backend:	PureNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'as yet unclassified' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> readStream: aReadStream
toSoil: aSoil
sourceFileReference: aFileReference
progress: aBlock
backend: aTBackendNeuralNetworkMachineLearningRudesheimClass [
	|
		modelRecord
		root
	|

	self
		notifyProgress:	aBlock
		event:	#started
		object:	aReadStream.

	self
		notifyProgress:	aBlock
		event:	#readStream
		object:	aReadStream.

	root :=
		self
			rootFromSoil:	aSoil.

	modelRecord :=
		self
			defaultModelRecordInRoot:	root.

	modelRecord
		formatClass:	ONNXNeuralNetworkMachineLearningRudesheim.

	modelRecord
		externalFileReference:	aFileReference.

	modelRecord
		externalPayload:	aReadStream contents.

	aFileReference
		ifNotNil:
		[
			[
				self
					populateGraphFor:	modelRecord
					fromONNXFileReference:	aFileReference
					backend:	aTBackendNeuralNetworkMachineLearningRudesheimClass.
			]
				on:	Error
				do:
				[ :exception |
					modelRecord metadata
						at:	#graphPopulationError
						put:	exception description.
				].
		].

	self
		commitRoot:	root
		toSoil:	aSoil.

	self
		notifyProgress:	aBlock
		event:	#wroteSoil
		object:	modelRecord.

	self
		notifyProgress:	aBlock
		event:	#done
		object:	modelRecord.

	^ modelRecord.
]

{ #category : 'as yet unclassified' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> rootFromSoil: aSoil [
	^
	[
		aSoil
			newTransaction
			root.
	]
		on:	Error
		do:
		[ :exception |
			StoreRootSoilNeuralNetworkMachineLearningRudesheim new.
		].
]

{ #category : 'as yet unclassified' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> soil: aSoilFileReferenceObject
toFile: aFileReferenceObject [
	^ self
		soil:	aSoilFileReferenceObject
		toFile:	aFileReferenceObject
		progress:
		[ :event :object |
		].
]

{ #category : 'as yet unclassified' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> soil: aSoilFileReferenceObject
toFile: aFileReferenceObject
progress: aBlock [
	|
		fileReference
		soilFileReference
	|

	soilFileReference := aSoilFileReferenceObject asFileReference.
	fileReference := aFileReferenceObject asFileReference.

	^
	(
		Soil
			openOnPath:	soilFileReference
	)
		intoRHScope
		do:
		[ :soil |
			fileReference
				binaryWriteStreamDo:
				[ :writeStream |
					self
						soil:	soil
						toWriteStream:	writeStream
						progress:	aBlock.

					fileReference.
				].
		].
]

{ #category : 'as yet unclassified' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> soil: aSoil
toWriteStream: aWriteStream [
	^ self
		soil:	aSoil
		toWriteStream:	aWriteStream
		progress:
		[ :event :object |
		].
]

{ #category : 'as yet unclassified' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> soil: aSoil
toWriteStream: aWriteStream
progress: aBlock [
	|
		modelRecord
		root
	|

	self
		notifyProgress:	aBlock
		event:	#started
		object:	aSoil.

	root :=
		self
			rootFromSoil:	aSoil.

	modelRecord :=
		self
			defaultModelRecordInRoot:	root.

	modelRecord
		formatClass
		= ONNXNeuralNetworkMachineLearningRudesheim
		ifFalse:
		[
			self
				notifyProgress:	aBlock
				event:	#failed
				object:	modelRecord.

			self
				error:	'Model record is not an ONNX model'.
		].

	self
		notifyProgress:	aBlock
		event:	#readSoil
		object:	modelRecord.

	aWriteStream
		nextPutAll:	
		(
			self
				payloadFromModelRecord:	modelRecord
		).

	self
		notifyProgress:	aBlock
		event:	#wroteStream
		object:	aWriteStream.

	self
		notifyProgress:	aBlock
		event:	#done
		object:	aWriteStream.

	^ aWriteStream.
]

{ #category : 'as yet unclassified' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> stonFileReferenceForONNXFileReference: aFileReference [
	|
		process
		stonFileReference
		command
	|

	stonFileReference :=
		FileReference
			newTempFilePrefix:	'rudesheim-onnx-ston'
			suffix:	'.ston'.

	command := 'python3 ''' , self onnxToSTONScriptFileReference fullName , ''' ''' , aFileReference fullName , ''' ''' , stonFileReference fullName , ''''.
	process := OSSUnixSubprocess new.

	process
		shellCommand:	command;
		redirectStdout;
		redirectStderr.

	process
		runAndWaitOnExitDo:
		[ :exit :p |
		].

	process isSuccess
		ifFalse:
		[
			stonFileReference exists
				ifTrue:
				[
					stonFileReference delete.
				].

			self
				error:	'onnx_to_ston.py failed with exit status ' , process exitStatus printString.
		].

	^ stonFileReference.
]

{ #category : 'as yet unclassified' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> tensorDescriptorFromSTONEntry: aSTONTensorEntryArray [
	^ Rudesheim
		MachineLearning
		NeuralNetwork
		Soil
		TensorDescriptor
		tensorKindClass:	
		(
			self
				tensorKindClassForToken:	aSTONTensorEntryArray first
		)
		shape:	aSTONTensorEntryArray second
		payload:	aSTONTensorEntryArray third.
]

{ #category : 'as yet unclassified' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> tensorKindClassForToken: aTokenString [
	^
	{WeightsTensorSoilNeuralNetworkMachineLearningRudesheim .  BiasesTensorSoilNeuralNetworkMachineLearningRudesheim}
		detect:
		[ :eachTensorKindClass |
			eachTensorKindClass
				tensorKindToken
				= aTokenString.
		]
		ifNone:
		[
			self
				error:	'unsupported Soil tensor kind token: ' , aTokenString.
		].
]

{ #category : 'as yet unclassified' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> windowSpecificationFromSTONFieldsArray: aSTONWindowFieldsArray [
	^ WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim
		inputChannels:	
		(
			aSTONWindowFieldsArray
				at:	1
		)
		inputRows:	
		(
			aSTONWindowFieldsArray
				at:	2
		)
		inputColumns:	
		(
			aSTONWindowFieldsArray
				at:	3
		)
		kernelRows:	
		(
			aSTONWindowFieldsArray
				at:	4
		)
		kernelColumns:	
		(
			aSTONWindowFieldsArray
				at:	5
		)
		strideRows:	
		(
			aSTONWindowFieldsArray
				at:	6
		)
		strideColumns:	
		(
			aSTONWindowFieldsArray
				at:	7
		)
		paddingTopRows:	
		(
			aSTONWindowFieldsArray
				at:	8
		)
		paddingBottomRows:	
		(
			aSTONWindowFieldsArray
				at:	9
		)
		paddingLeftColumns:	
		(
			aSTONWindowFieldsArray
				at:	10
		)
		paddingRightColumns:	
		(
			aSTONWindowFieldsArray
				at:	11
		).
]
