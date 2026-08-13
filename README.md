# Rudesheim Neural Network for Pharo

Rudesheim Neural Network is a Pharo neural-network package for building and evaluating model graphs.
It provides pure Smalltalk layers, graph nodes, criteria, a trainer, Soil-backed model records, ONNX conversion support, and optional OpenCL-backed execution.

The runtime model code is Pharo.
Python is used only as an import helper for ONNX files: `tool/onnx_to_ston.py` decodes ONNX protobuf data into a STON document that Pharo then imports into Soil.

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
- OpenCL-backed inference needs at least one usable OpenCL platform/device.
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

## Groups

- `core`: pure Smalltalk neural-network runtime, graph model, trainer, Soil model records, and ONNX converter classes.
- `onnx`: ONNX layer-name extensions for pure backend classes.
- `opencl`: OpenCL-backed layers and criteria.
- `onnxOpenCL`: ONNX layer-name extensions for OpenCL backend classes.
- `default`: aliases `core`.

## Basic Use

Build a small pure Smalltalk model and evaluate it with `value:`:

```smalltalk
nn := Rudesheim MachineLearning NeuralNetwork.
layer := nn Layer.

model :=
	nn Pure Model
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
model := nn Architecture MLP nextModelAs: nn Pure Model.

model value: #( 1.0 0.0 )
```

The MLP architecture builds a fresh three-layer model each time.

After loading the OpenCL group, the same architecture can choose the OpenCL backend by passing the backend model class to `nextModelAs:`:

```smalltalk
nn := Rudesheim MachineLearning NeuralNetwork.

model :=
	nn Architecture MLP
		nextModelAs: nn OpenCL Model.

model value: #( 1.0 0.0 )
```

The older `nextModelAs:backend:` form remains available for compatibility.
Do not pass bare `nn Model` to `nextModelAs:`; use `nn Pure Model` or `nn OpenCL Model` so the backend is explicit.

## Training

`Trainer` consumes a model and a collection of `Predictions`.
It returns `{ averageLoss. trainedModel }`; use the trained model from the returned pair for later evaluation.

```smalltalk
nn := Rudesheim MachineLearning NeuralNetwork.
layer := nn Layer.

model :=
	nn Pure Model
		neuralNetworkLayers:
		{
			layer LinearTransform
				weightsRows: #( ( 0.5 0.3 ) )
				biases: #( 0.0 )
		}.

dataset :=
{
	nn Predictions
		inputPredictions: #( 1.0 0.0 )
		outputPredictions: #( 1.0 )
}.

trainer :=
	nn Trainer new
		epochs: 100;
		learningRate: 0.05;
		yourself.

result :=
	trainer
		train: model
		withDataset: dataset.

trainedModel := result last.
trainedModel value: #( 1.0 0.0 )
```

When training a model with a selected backend, the criterion can be selected from the model backend:

```smalltalk
result :=
	trainer
		train: model
		withDataset: dataset
		byCriterion:
		[ :criterion |
			criterion MSE
		].
```

## ONNX and Soil

ONNX conversion stores a backend-neutral internal graph representation in Soil.
Open the Soil database and read the model record from its root:

```smalltalk
nn := Rudesheim MachineLearning NeuralNetwork.

nn ONNX Convertor
	file: 'mnist-8.onnx'
	toSoil: 'mnist-8.soil'.

(Soil openOnPath: 'mnist-8.soil' asFileReference) intoRHScope
	do:
	[ :soil |
		| modelRecord model root |

		root := soil newTransaction root.
		modelRecord := root at: (root symbolByName: 'default').
		model := modelRecord nextModelAs: nn Pure Model.
		model value: ( ( 1 to: 1 * 28 * 28) collect: [ :unused | 0.0 ] ).
	].

```

Choose the execution backend when reading the model record:

```smalltalk
nn := Rudesheim MachineLearning NeuralNetwork.

nn ONNX Convertor
	file: 'resnet50-v2-7.onnx'
	toSoil: 'resnet50-v2-7.soil'.

(Soil openOnPath: 'resnet50-v2-7.soil' asFileReference) intoRHScope
	do:
	[ :soil |
		| modelRecord model root |

		root := soil newTransaction root.
		modelRecord := root at: (root symbolByName: 'default').
		model := modelRecord nextModelAs: nn OpenCL Model.
		model value: ( ( 1 to: 3 * 224 * 224) collect: [ :unused | 0.0 ] ).
	].
```

Use `nn Pure Model` at the same read point to build a Pure-backed model from the same Soil record.

The converter script emits flat tensor payloads and stores tensor shape separately.
Backends reconstruct row-based or nested views at model-load time when they need them.

## Feature Goals

- Remove the Python dependency from ONNX import by moving the ONNX decoder/import path into Pharo.
- Keep ONNX import backend-neutral so the same Soil model record can be read with `nn Pure Model` or `nn OpenCL Model`.
- Add computation cluster support for partitioned models and coordinated multi-host execution.
- Add Apple Neural Engine support as an execution backend where the platform allows it.
- Support LLM-oriented model structures and inference workflows.
- Persist trained model results back into a database-backed model store.
- Export trained model results to portable external formats.

## Usage Constraints

- Prefer `model value: inputValues` for public model evaluation.
- Do not depend on the concrete return type of `forward:`. It may be an Array in pure Smalltalk paths or a native-backed object in OpenCL paths, and this return contract is not guaranteed for now.
- Layer-level `forward:` is lower-level API. When calling OpenCL layers directly, materialize results with `asArray` and release native-backed values when ownership is clear.
- Models built from `neuralNetworkLayers:` are linear chains. Use `Node` and `outputNode:` when a graph needs branches or skip connections.
- `Add` nodes merge two predecessor outputs by concatenating them before the Add layer computes pairwise element addition.
- `Conv2D`, `MaxPool2D`, and `GlobalAveragePool` use flat input/output number sequences. Spatial shape is carried by `WindowSpecificationSoilNeuralNetworkMachineLearningRudesheim`.
- Pure `Conv2D` and pure `GlobalAveragePool` are currently forward-only inference layers. OpenCL-backed layers have additional backward coverage, but the training surface is still evolving.
- Training returns the updated model in memory. Persisting trained model results back into Soil or another database-backed store is not supported yet.
- BatchNormalization represents ONNX inference-time per-channel affine scale/shift. It is not a training-mode BatchNorm layer that recomputes batch statistics.
- ONNX support is intentionally limited to the layer names known to `knownLayerKindSelectors`: `Gemm`, `Relu`, `Conv`, `MaxPool`, `Add`, `BatchNormalization`, and `GlobalAveragePool`. Unsupported ONNX layer names raise an error.
