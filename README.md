# Rudesheim Neural Network for Pharo

Rudesheim Neural Network is a Pharo neural-network package for building and evaluating model graphs.
It provides pure Smalltalk layers, graph nodes, criteria, a trainer, Soil-backed model records, ONNX conversion support, and optional OpenCL-backed execution.

The public evaluation entry point for model users is `value:`.
`forward:` is still used internally and in lower-level tests, but its returned object is not guaranteed as a stable public contract for now.
In particular, OpenCL-backed paths may return native-backed buffers before materialization.

## Installation

Load the default project group with Metacello:

```smalltalk
Metacello new
	baseline: 'RudesheimNeuralNetwork';
	repository: 'github://devid-rudesheim/NeuralNetwork-Rudesheim-Pharo:main';
	load
```

The default group loads the pure Smalltalk runtime and the Soil/OSSubprocess dependencies used by the model-store and ONNX conversion code.

## Requirements

- Pharo with Metacello.
- Python 3 is required only when converting ONNX files through `Rudesheim MachineLearning NeuralNetwork ONNX Convertor file:toSoil:`.
- OpenCL support requires `load: #(opencl)` and a native OpenCL runtime visible to the host process.
- OpenCL tests and OpenCL-backed inference need at least one usable OpenCL platform/device.
- ONNX conversion uses the bundled `tool/onnx_to_ston.py` script. The script uses only Python's standard library.

## Dependencies

The baseline loads these repositories:

- `RudesheimKernel`: `github://devid-rudesheim/Kernel-Rudesheim-Pharo:main`
- `RudesheimUtility`: `github://devid-rudesheim/Utility-Rudesheim-Pharo:main`
- `SoilCore`: `github://ApptiveGrid/Soil/src`, loaded with `#( 'Soil-Core' )`
- `OSSubprocess`: `github://pharo-contributions/OSSubprocess:master/repository`

The `opencl` group also loads:

- `RudesheimOpenCL`: `github://devid-rudesheim/OpenCL-Rudesheim-Pharo:main`

## Load Options

Default runtime load:

```smalltalk
Metacello new
	baseline: 'RudesheimNeuralNetwork';
	repository: 'github://devid-rudesheim/NeuralNetwork-Rudesheim-Pharo:main';
	load
```

ONNX name extensions:

```smalltalk
Metacello new
	baseline: 'RudesheimNeuralNetwork';
	repository: 'github://devid-rudesheim/NeuralNetwork-Rudesheim-Pharo:main';
	load: #(onnx)
```

OpenCL-backed layers and criteria:

```smalltalk
Metacello new
	baseline: 'RudesheimNeuralNetwork';
	repository: 'github://devid-rudesheim/NeuralNetwork-Rudesheim-Pharo:main';
	load: #(opencl)
```

ONNX names for OpenCL-backed models:

```smalltalk
Metacello new
	baseline: 'RudesheimNeuralNetwork';
	repository: 'github://devid-rudesheim/NeuralNetwork-Rudesheim-Pharo:main';
	load: #(onnx opencl onnxOpenCL)
```

Core tests:

```smalltalk
Metacello new
	baseline: 'RudesheimNeuralNetwork';
	repository: 'github://devid-rudesheim/NeuralNetwork-Rudesheim-Pharo:main';
	load: #(tests)
```

OpenCL tests:

```smalltalk
Metacello new
	baseline: 'RudesheimNeuralNetwork';
	repository: 'github://devid-rudesheim/NeuralNetwork-Rudesheim-Pharo:main';
	load: #(opencl onnxOpenCL openclTests)
```

## Groups

- `core`: pure Smalltalk neural-network runtime, graph model, trainer, Soil model records, and ONNX converter classes.
- `onnx`: ONNX layer-name extensions for pure backend classes.
- `opencl`: OpenCL-backed layers and criteria.
- `onnxOpenCL`: ONNX layer-name extensions for OpenCL backend classes.
- `tests`: SUnit tests for the pure Smalltalk runtime.
- `openclTests`: SUnit tests for the OpenCL runtime.
- `default`: aliases `core`.

## Basic Use

Build a small pure Smalltalk model and evaluate it with `value:`:

```smalltalk
nn := Rudesheim MachineLearning NeuralNetwork.
layer := nn Layer.

model :=
	nn Model
		neuralNetworkLayers:
		{
			layer LinearTransform
				weightsRows: #( ( 0.5 0.3 ) ( -0.4 0.6 ) )
				biases: #( 0.0 0.0 ).
			layer ReLU.
			layer LinearTransform
				weightsRows: #( ( 0.4 0.7 ) )
				biases: #( 0.0 )
		}.

model value: #( 1.0 2.0 )
```

The result is `#( 1.0 )`.

Use the built-in MLP architecture when randomized weights are acceptable:

```smalltalk
nn := Rudesheim MachineLearning NeuralNetwork.
model := nn Architecture MLP nextModelAs: nn Model.

model value: #( 1.0 0.0 )
```

The MLP architecture builds a fresh three-layer model each time.

After loading the OpenCL group, the same architecture can choose the OpenCL backend:

```smalltalk
nn := Rudesheim MachineLearning NeuralNetwork.

model :=
	nn Architecture MLP
		nextModelAs: nn Model
		backend: nn OpenCL.

model value: #( 1.0 0.0 )
```

## ONNX and Soil

ONNX conversion stores an internal graph representation in Soil and returns a model record:

```smalltalk
nn := Rudesheim MachineLearning NeuralNetwork.

modelRecord :=
	nn ONNX Convertor
		file: 'mnist-8.onnx'
		toSoil: 'mnist-8.soil'.

model := modelRecord nextModelAs: nn Model.
model value: inputValues.
```

For OpenCL-backed ONNX models, pass the backend during conversion:

```smalltalk
nn := Rudesheim MachineLearning NeuralNetwork.

modelRecord :=
	nn ONNX Convertor
		file: 'resnet50-v2-7.onnx'
		toSoil: 'resnet50-v2-7.soil'
		backend: nn OpenCL.

model := modelRecord nextModelAs: nn Model.
model value: inputValues.
```

The converter script emits flat tensor payloads and stores tensor shape separately.
Backends reconstruct row-based or nested views at model-load time when they need them.

## Usage Constraints

- Prefer `model value: inputValues` for public model evaluation.
- Do not depend on the concrete return type of `forward:`. It may be an Array in pure Smalltalk paths or a native-backed object in OpenCL paths, and this return contract is not guaranteed for now.
- Layer-level `forward:` is lower-level API. When calling OpenCL layers directly, materialize results with `asArray` and release native-backed values when ownership is clear.
- Models built from `neuralNetworkLayers:` are linear chains. Use `Node` and `outputNode:` when a graph needs branches or skip connections.
- `Add` nodes merge two predecessor outputs by concatenating them before the Add layer computes pairwise element addition.
- `Conv2D`, `MaxPool2D`, and `GlobalAveragePool` use flat input/output number sequences. Spatial shape is carried by `WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim`.
- Pure `Conv2D` and pure `GlobalAveragePool` are currently forward-only inference layers. OpenCL-backed layers have additional backward coverage, but the training surface is still evolving.
- BatchNormalization represents ONNX inference-time per-channel affine scale/shift. It is not a training-mode BatchNorm layer that recomputes batch statistics.
- ONNX support is intentionally limited to the layer names known to `knownLayerKindSelectors`: `Gemm`, `Relu`, `Conv`, `MaxPool`, `Add`, `BatchNormalization`, and `GlobalAveragePool`. Unsupported ONNX layer names raise an error.
- ONNX conversion invokes a local `python3` command through OSSubprocess and runs the bundled `tool/onnx_to_ston.py` script.
- Soil persists tensor payloads flat to avoid creating large numbers of nested Array objects during serialization.
- OpenCL behavior depends on the host runtime, device, and driver. The code keeps intermediate OpenCL buffers on-device where possible, but native resource behavior can still be platform-specific.
- `value:` materializes the result and owns release of the value returned by `forward:`. It does not remove every platform-specific OpenCL risk.
- Repeated evaluation of the same OpenCL-backed model has known native-resource risk in the current implementation. Rebuild a fresh model from the model source if repeated OpenCL inference shows instability.

## Run Tests

After loading the test groups, run:

```smalltalk
TestSuite new
	addTest: (RPackageOrganizer default packageNamed: 'Rudesheim-NeuralNetwork-Tests') asTestSuite;
	addTest: (RPackageOrganizer default packageNamed: 'Rudesheim-NeuralNetwork-Private-Tests') asTestSuite;
	run
```

For OpenCL coverage, also load `openclTests` and run:

```smalltalk
TestSuite new
	addTest: (RPackageOrganizer default packageNamed: 'Rudesheim-NeuralNetwork-OpenCL-Tests') asTestSuite;
	run
```
