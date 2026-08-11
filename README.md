# Rudesheim Neural Network for Pharo

Rudesheim Neural Network is a Pharo neural-network package with model graphs, layers, criteria, training support, Soil persistence, ONNX loading, and optional OpenCL execution.
It is part of the Rudesheim project family and depends on the shared Kernel and Utility repositories.

## Installation

Load the default project group with Metacello:

```smalltalk
Metacello new
	baseline: 'RudesheimNeuralNetwork';
	repository: 'github://devid-rudesheim/NeuralNetwork-Rudesheim-Pharo:main';
	load
```

The default group loads the pure Smalltalk core.

## Optional Features

Load ONNX support:

```smalltalk
Metacello new
	baseline: 'RudesheimNeuralNetwork';
	repository: 'github://devid-rudesheim/NeuralNetwork-Rudesheim-Pharo:main';
	load: #(onnx)
```

Load OpenCL support:

```smalltalk
Metacello new
	baseline: 'RudesheimNeuralNetwork';
	repository: 'github://devid-rudesheim/NeuralNetwork-Rudesheim-Pharo:main';
	load: #(opencl onnxOpenCL)
```

OpenCL support also loads `RudesheimOpenCL` from GitHub.

## Groups

- `core`: pure Smalltalk neural-network runtime.
- `onnx`: ONNX model import support.
- `opencl`: OpenCL-backed layers and criteria.
- `onnxOpenCL`: ONNX extensions for OpenCL-backed models.
- `tests`: SUnit tests for the pure Smalltalk runtime.
- `openclTests`: SUnit tests for the OpenCL runtime.
- `default`: aliases `core`.

## Run Tests

After loading the test groups, run:

```smalltalk
TestSuite new
	addTest: (RPackageOrganizer default packageNamed: 'Rudesheim-NeuralNetwork-Tests') asTestSuite;
	addTest: (RPackageOrganizer default packageNamed: 'Rudesheim-NeuralNetwork-Private-Tests') asTestSuite;
	run
```

For OpenCL coverage, also load and run `openclTests`.
