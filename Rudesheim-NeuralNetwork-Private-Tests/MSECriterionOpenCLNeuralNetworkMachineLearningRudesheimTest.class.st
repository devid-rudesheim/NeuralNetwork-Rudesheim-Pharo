Class {
	#name : 'MSECriterionOpenCLNeuralNetworkMachineLearningRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-NeuralNetwork-Tests-Criterion',
	#package : 'Rudesheim-NeuralNetwork-Private-Tests',
	#tag : 'Criterion'
}

{ #category : 'accessing' }
MSECriterionOpenCLNeuralNetworkMachineLearningRudesheimTest class >> targetClass [

	^ MSECriterionOpenCLNeuralNetworkMachineLearningRudesheim
]

{ #category : 'accessing' }
MSECriterionOpenCLNeuralNetworkMachineLearningRudesheimTest >> defaultBasicTarget [

	^ self targetClass predictions: #( 0.9 0.1 0.2 ) targets: #( 1.0 0.0 0.0 )
]

{ #category : 'tests' }
MSECriterionOpenCLNeuralNetworkMachineLearningRudesheimTest >> testGradientMatchesPure [

	|
		pureTarget
		oclGradient
		pureGradient
	|

	pureTarget :=
		Rudesheim MachineLearning NeuralNetwork Pure Criterion MSE
			predictions:	#( 0.9 0.1 0.2 )
			targets:		#( 1.0 0.0 0.0 ).
	oclGradient := self basicTarget gradient.
	pureGradient := pureTarget gradient.

	self assert: oclGradient size equals: pureGradient size.
	oclGradient
		with: pureGradient
		do: [ :left :right | self assert: left closeTo: right precision: 0.0001 ]
]

{ #category : 'tests' }
MSECriterionOpenCLNeuralNetworkMachineLearningRudesheimTest >> testLossMatchesPure [

	|
		pureTarget
	|

	pureTarget :=
		Rudesheim MachineLearning NeuralNetwork Pure Criterion MSE
			predictions:	#( 0.9 0.1 0.2 )
			targets:		#( 1.0 0.0 0.0 ).

	self assert: self basicTarget loss closeTo: pureTarget loss
]
