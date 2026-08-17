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

{ #category : 'converting' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> modelKeyFromFileReference: aFileReferenceObject [
	^ aFileReferenceObject asFileReference withoutExtension basename.
]

{ #category : 'accessing' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> modelRecordAt: aKeyString
inRoot: aStoreRootSoilNeuralNetworkMachineLearningRudesheim [
	^ aStoreRootSoilNeuralNetworkMachineLearningRudesheim
		at:
		(
			aStoreRootSoilNeuralNetworkMachineLearningRudesheim
				symbolByName:	aKeyString
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

{ #category : 'converting' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> file: aFileReferenceObject
toSoil: aSoilFileReferenceObject
at: aKeyString [
	^ self
		file:	aFileReferenceObject
		toSoil:	aSoilFileReferenceObject
		at:	aKeyString
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

{ #category : 'converting' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> file: aFileReferenceObject
toSoil: aSoilFileReferenceObject
at: aKeyString
backend: aTBackendNeuralNetworkMachineLearningRudesheimClass [
	^ self
		file:	aFileReferenceObject
		toSoil:	aSoilFileReferenceObject
		at:	aKeyString
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

{ #category : 'converting' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> file: aFileReferenceObject
toSoil: aSoilFileReferenceObject
at: aKeyString
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
						at:	aKeyString
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

{ #category : 'converting' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> file: aFileReferenceObject
toSoil: aSoilFileReferenceObject
at: aKeyString
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
						at:	aKeyString
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
	"Locates tool/onnx_to_ston.py inside whichever Iceberg-registered repository this class's
	own package (Rudesheim-NeuralNetwork-Private) was loaded from. Matching by package
	membership rather than by a hardcoded repository name works both for a local dev checkout
	(commonly registered as 'rudesheim') and for CI, where .smalltalk.ston's
	#registerInIceberg : true registers the actions/checkout@v4 clone under whatever name that
	checkout happens to have."

	^ ( self onnxToSTONScriptRepositoryLocations
		ifEmpty:
		[
			self
				error:	'No Iceberg-registered repository found for package ' , self package name , '; ensure .smalltalk.ston sets #registerInIceberg : true.'.
		] )
		first / 'tool' / 'onnx_to_ston.py'.
]

{ #category : 'as yet unclassified' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> onnxToSTONScriptRepositoryLocations [
	|
		repository
	|

	repository := IceRepository registeredRepositoryIncludingPackage: self package.

	^ repository
		ifNil:		[ #() ]
		ifNotNil:	[ { repository location } ].
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

{ #category : 'converting' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> readStream: aReadStream
toSoil: aSoil
at: aKeyString
sourceFileReference: aFileReference [
	^ self
		readStream:	aReadStream
		toSoil:	aSoil
		at:	aKeyString
		sourceFileReference:	aFileReference
		progress:
		[ :event :object |
		].
]

{ #category : 'converting' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> readStream: aReadStream
toSoil: aSoil
at: aKeyString
progress: aBlock [
	^ self
		readStream:	aReadStream
		toSoil:	aSoil
		at:	aKeyString
		sourceFileReference:	nil
		progress:	aBlock.
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

{ #category : 'converting' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> readStream: aReadStream
toSoil: aSoil
at: aKeyString
sourceFileReference: aFileReference
progress: aBlock [
	^ self
		readStream:	aReadStream
		toSoil:	aSoil
		at:	aKeyString
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
	aFileReference
		ifNil:
		[
			self
				error:	'A source ONNX file reference is required to derive the model key; use the at: variant instead.'.
		].

	^ self
		readStream:	aReadStream
		toSoil:	aSoil
		at:	(self modelKeyFromFileReference: aFileReference)
		sourceFileReference:	aFileReference
		progress:	aBlock
		backend:	aTBackendNeuralNetworkMachineLearningRudesheimClass.
]

{ #category : 'converting' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> readStream: aReadStream
toSoil: aSoil
at: aKeyString
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
			modelRecordAt:	aKeyString
			inRoot:	root.

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

{ #category : 'converting' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> soil: aSoilFileReferenceObject
toFile: aFileReferenceObject
at: aKeyString [
	^ self
		soil:	aSoilFileReferenceObject
		toFile:	aFileReferenceObject
		at:	aKeyString
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
						at:	(self modelKeyFromFileReference: fileReference)
						progress:	aBlock.

					fileReference.
				].
		].
]

{ #category : 'converting' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> soil: aSoilFileReferenceObject
toFile: aFileReferenceObject
at: aKeyString
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
						at:	aKeyString
						progress:	aBlock.

					fileReference.
				].
		].
]

{ #category : 'converting' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> soil: aSoil
toWriteStream: aWriteStream
at: aKeyString [
	^ self
		soil:	aSoil
		toWriteStream:	aWriteStream
		at:	aKeyString
		progress:
		[ :event :object |
		].
]

{ #category : 'converting' }
ConvertorONNXNeuralNetworkMachineLearningRudesheim class >> soil: aSoil
toWriteStream: aWriteStream
at: aKeyString
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
			modelRecordAt:	aKeyString
			inRoot:	root.

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
	^ Rudesheim MachineLearning NeuralNetwork Soil WindowSpecification
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
