"
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim describes the spatial-window parameters (input shape, kernel, stride, padding) a Soil-stored graph node needs to reconstruct a Conv2D/MaxPool2D layer, since GraphNodeRecordSoilNeuralNetworkMachineLearningRudesheim's tensorDescriptorRecords only carry learned weight/bias tensors, not structural parameters.
"
Class {
	#name : 'WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#instVars : [
		'inputChannels',
		'inputRows',
		'inputColumns',
		'kernelRows',
		'kernelColumns',
		'strideRows',
		'strideColumns',
		'paddingTopRows',
		'paddingBottomRows',
		'paddingLeftColumns',
		'paddingRightColumns'
	],
	#category : 'Rudesheim-NeuralNetwork-Private',
	#package : 'Rudesheim-NeuralNetwork-Private'
}

{ #category : 'instance creation' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim class >> inputChannels:	anInputChannelsInteger
inputRows:	anInputRowsInteger
inputColumns:	anInputColumnsInteger
kernelRows:	aKernelRowsInteger
kernelColumns:	aKernelColumnsInteger
strideRows:	aStrideRowsInteger
strideColumns:	aStrideColumnsInteger
paddingTopRows:	aPaddingTopRowsInteger
paddingBottomRows:	aPaddingBottomRowsInteger
paddingLeftColumns:	aPaddingLeftColumnsInteger
paddingRightColumns:	aPaddingRightColumnsInteger [

	^ super new
		setInputChannels:		anInputChannelsInteger
		inputRows:				anInputRowsInteger
		inputColumns:			anInputColumnsInteger
		kernelRows:				aKernelRowsInteger
		kernelColumns:			aKernelColumnsInteger
		strideRows:				aStrideRowsInteger
		strideColumns:			aStrideColumnsInteger
		paddingTopRows:			aPaddingTopRowsInteger
		paddingBottomRows:		aPaddingBottomRowsInteger
		paddingLeftColumns:		aPaddingLeftColumnsInteger
		paddingRightColumns:	aPaddingRightColumnsInteger;
		yourself
]

{ #category : 'accessing' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim >> inputChannels [

	^ inputChannels
]

{ #category : 'accessing' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim >> inputColumns [

	^ inputColumns
]

{ #category : 'accessing' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim >> inputRows [

	^ inputRows
]

{ #category : 'accessing' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim >> kernelColumns [

	^ kernelColumns
]

{ #category : 'accessing' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim >> kernelRows [

	^ kernelRows
]

{ #category : 'accessing' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim >> outputColumns [

	^ ( self paddedColumns - kernelColumns ) // strideColumns + 1
]

{ #category : 'accessing' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim >> outputRows [

	^ ( self paddedRows - kernelRows ) // strideRows + 1
]

{ #category : 'accessing' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim >> paddedColumns [

	^ inputColumns + paddingLeftColumns + paddingRightColumns
]

{ #category : 'accessing' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim >> paddedRows [

	^ inputRows + paddingTopRows + paddingBottomRows
]

{ #category : 'accessing' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim >> paddingBottomRows [

	^ paddingBottomRows
]

{ #category : 'accessing' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim >> paddingLeftColumns [

	^ paddingLeftColumns
]

{ #category : 'accessing' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim >> paddingRightColumns [

	^ paddingRightColumns
]

{ #category : 'accessing' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim >> paddingTopRows [

	^ paddingTopRows
]

{ #category : 'initialization' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim >> setInputChannels:	anInputChannelsInteger
inputRows:	anInputRowsInteger
inputColumns:	anInputColumnsInteger
kernelRows:	aKernelRowsInteger
kernelColumns:	aKernelColumnsInteger
strideRows:	aStrideRowsInteger
strideColumns:	aStrideColumnsInteger
paddingTopRows:	aPaddingTopRowsInteger
paddingBottomRows:	aPaddingBottomRowsInteger
paddingLeftColumns:	aPaddingLeftColumnsInteger
paddingRightColumns:	aPaddingRightColumnsInteger [

	inputChannels			:= anInputChannelsInteger.
	inputRows				:= anInputRowsInteger.
	inputColumns			:= anInputColumnsInteger.
	kernelRows				:= aKernelRowsInteger.
	kernelColumns			:= aKernelColumnsInteger.
	strideRows				:= aStrideRowsInteger.
	strideColumns			:= aStrideColumnsInteger.
	paddingTopRows			:= aPaddingTopRowsInteger.
	paddingBottomRows		:= aPaddingBottomRowsInteger.
	paddingLeftColumns		:= aPaddingLeftColumnsInteger.
	paddingRightColumns	:= aPaddingRightColumnsInteger
]

{ #category : 'accessing' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim >> strideColumns [

	^ strideColumns
]

{ #category : 'accessing' }
WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim >> strideRows [

	^ strideRows
]
