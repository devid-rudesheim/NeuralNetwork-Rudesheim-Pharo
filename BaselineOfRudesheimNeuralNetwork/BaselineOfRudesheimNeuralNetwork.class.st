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
					spec repository: 'github://devid-rudesheim/Utility-Rudesheim-Pharo:develop'
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
					spec repository: 'github://devid-rudesheim/Kernel-Rudesheim-Pharo:develop'
				];

				baseline: 'RudesheimOpenCL'
				with:
				[
					spec repository: 'github://devid-rudesheim/OpenCL-Rudesheim-Pharo:develop'
				];

				baseline: 'Soil'
				with:
				[
					spec repository: 'github://ApptiveGrid/Soil/src'
				];

				project: 'SoilCore'
				copyFrom: 'Soil'
				with:
				[
					spec loads: #( 'Soil-Core' )
				];

				baseline: 'OSSubprocess'
				with:
				[
					spec repository: 'github://pharo-contributions/OSSubprocess:master/repository'
				];

				package: 'Rudesheim-NeuralNetwork-Private'
				with:
				[
					spec
						requires: #( 'RudesheimUtility' 'RudesheimKernel' 'SoilCore' 'OSSubprocess' )
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

				package: 'Rudesheim-NeuralNetwork-OpenCL-Private'
				with:
				[
					spec
						requires: #( 'Rudesheim-NeuralNetwork-Private' 'RudesheimOpenCL' 'RudesheimKernel' )
				];

				package: 'Rudesheim-NeuralNetwork-ONNX-OpenCL'
				with:
				[
					spec
						requires: #( 'Rudesheim-NeuralNetwork-ONNX' 'Rudesheim-NeuralNetwork-OpenCL-Private' )
				];

				package: 'Rudesheim-NeuralNetwork-Private-Tests'
				with:
				[
					spec
						requires: #( 'Rudesheim-NeuralNetwork' 'Rudesheim-NeuralNetwork-ONNX' 'RudesheimUtilityTests' )
				];

				package: 'Rudesheim-NeuralNetwork-OpenCL-Tests'
				with:
				[
					spec
						requires: #( 'Rudesheim-NeuralNetwork-OpenCL-Private' 'Rudesheim-NeuralNetwork-ONNX-OpenCL' 'Rudesheim-NeuralNetwork-Private-Tests' )
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

				group:		#opencl
				with:		#( 'Rudesheim-NeuralNetwork-OpenCL-Private' );

				group:		#onnxOpenCL
				with:		#( 'Rudesheim-NeuralNetwork-ONNX-OpenCL' );

				group:		#tests
				with:		#( 'Rudesheim-NeuralNetwork-Private-Tests' 'Rudesheim-NeuralNetwork-Tests' );

				group:		#openclTests
				with:		#( 'Rudesheim-NeuralNetwork-OpenCL-Tests' );

				group:		#default
				with:		#( #core ).
		]
]
