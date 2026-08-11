Class {
	#name : 'BaselineOfRudesheimNeuralNetwork',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfRudesheimNeuralNetwork',
	#package : 'BaselineOfRudesheimNeuralNetwork'
}

{ #category : 'baselines' }
BaselineOfRudesheimNeuralNetwork >> baseline: spec [
	<baseline>

	spec
		for: #common
		do:
		[
			spec
				baseline: 'RudesheimUtility'
				with:
				[
					spec repository: 'github://devid-rudesheim/Utility-Rudesheim-Pharo:main'
				];

				project: 'RudesheimUtilityTests'
				copyFrom: 'RudesheimUtility'
				with:
				[
					spec loads: #( 'tests' )
				];

				baseline: 'RudesheimKernel'
				with:
				[
					spec repository: 'github://devid-rudesheim/Kernel-Rudesheim-Pharo:main'
				];

				baseline: 'RudesheimOpenCL'
				with:
				[
					spec repository: 'github://devid-rudesheim/OpenCL-Rudesheim-Pharo:main'
				];

				package: 'Rudesheim-NeuralNetwork-Private'
				with:
				[
					spec
						requires: #( 'RudesheimUtility' 'RudesheimKernel' 'RudesheimOpenCL' )
				];

				package: 'Rudesheim-NeuralNetwork'
				with:
				[
					spec
						requires: #( 'Rudesheim-NeuralNetwork-Private' )
				];

				package: 'Rudesheim-NeuralNetwork-ONNX'
				with:
				[
					spec
						requires: #( 'Rudesheim-NeuralNetwork-Private' )
				];

				package: 'Rudesheim-NeuralNetwork-Private-Tests'
				with:
				[
					spec
						requires: #( 'Rudesheim-NeuralNetwork' 'Rudesheim-NeuralNetwork-ONNX' 'RudesheimUtilityTests' )
				];

				package: 'Rudesheim-NeuralNetwork-Tests'
				with:
				[
					spec
						requires: #( 'Rudesheim-NeuralNetwork' 'RudesheimUtilityTests' )
				];

				group:		#core
				with:		#( 'Rudesheim-NeuralNetwork-Private' 'Rudesheim-NeuralNetwork' );

				group:		#onnx
				with:		#( 'Rudesheim-NeuralNetwork-ONNX' );

				group:		#tests
				with:		#( 'Rudesheim-NeuralNetwork-Private-Tests' 'Rudesheim-NeuralNetwork-Tests' );

				group:		#default
				with:		#( #core ).
		]
]
