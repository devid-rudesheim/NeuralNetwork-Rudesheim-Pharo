Class {
	#name : 'OpenCLNeuralNetworkMachineLearningRudesheim',
	#superclass : 'Object',
	#traits : 'TBackendNeuralNetworkMachineLearningRudesheim',
	#classTraits : 'TBackendNeuralNetworkMachineLearningRudesheim classTrait',
	#classInstVars : [
		'devices',
		'context',
		'commandQueue'
	],
	#category : 'Rudesheim-NeuralNetwork-OpenCL-Private',
	#package : 'Rudesheim-NeuralNetwork-OpenCL-Private'
}

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> Criterion [
	^ CriterionOpenCLNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> Layer [
	^ LayerOpenCLNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> Model [
	^ ModelNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> addAndClassifySelector: selector
withMethod: compiledMethod
inProtocol: aProtocol [
	self localMethodDict
		at:	selector
		put:	compiledMethod.

	super
		addAndClassifySelector:	selector
		withMethod:	compiledMethod
		inProtocol:	aProtocol.

	TraitChange
		addSelector:	selector
		on:	self.
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> allTraits [
	^ self
		traitComposition
		allTraits.
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> commandQueue [
	^ commandQueue
		ifNil:
		[
			commandQueue :=
				self context
					newCLCommandQueueFor:	self device.
		].
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> context [
	^ context
		ifNil:
		[
			context :=
				Rudesheim
					OpenCL
					Context
					clContextFor:	self devices.
		].
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> default [
	^ PureNeuralNetworkMachineLearningRudesheim.
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> device [
	^ self
		devices
		first.
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> devices [
	^ devices
		ifNil:
		[
			devices := Rudesheim OpenCL Platform clPlatforms first clDevices.
		].
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> doRebuildMethodDictionary [
	|
		selectors
		removedSelectors
		modified
	|

	modified := false.

	self methodDict
		valuesDo:
		[ :m |
			m traitSource
				ifNil:
				[
					self localMethodDict
						at:	m selector
						put:	m.
				].
		].

	selectors :=
		self
			traitComposition
			selectors
			reject:
			[ :e |
				self localMethodDict
					includesKey:	e.
			].

	selectors
		do:
		[ :e |
			modified := modified | (self traitComposition installSelector: e into: self replacing: false).
		].

	removedSelectors :=
		self
			methodDict
			keys
			reject:
			[ :aSelector |
				(
					selectors
						includes:	aSelector
				)
					or:
					[
						self localMethodDict
							includesKey:	aSelector.
					].
			].

	modified := modified | removedSelectors isNotEmpty.

	removedSelectors
		do:
		[ :aSelector |
			self methodDict
				removeKey:	aSelector.

			self
				removeFromProtocols:	aSelector.
		].

	^ modified.
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> fileOutLocalMethodsInProtocol: protocol
on: aFileStream [
	aFileStream cr.

	protocol methodSelectors
		select:
		[ :selector |
			(
				self
					isLocalSelector:	selector
			)
				or:
				[
					(
						self
							traitComposition
							selectors
							includes:	selector
					)
						not.
				].
		]
		thenDo:
		[ :selector |
			self
				printMethodChunk:	selector
				on:	aFileStream.
		].
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> findOriginClassOf: aMethod [
	(
		aMethod
			hasProperty:	#traitSource
	)
		ifTrue:
		[
			^ aMethod
				traitSource
				innerClass.
		].

	(
		self
			includesLocalSelector:	aMethod selector
	)
		ifTrue:
		[
			^ self.
		].

	^
	(
		self traitComposition
			traitDefining:	aMethod selector
			ifNone:
			[
				^ self.
			]
	)
		innerClass.
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> findOriginMethodOf: aMethod [
	(
		self
			includesLocalSelector:	aMethod selector
	)
		ifTrue:
		[
			^ aMethod.
		].

	(
		aMethod
			hasProperty:	#traitSource
	)
		ifTrue:
		[
			|
				newSelector
			|

			newSelector :=
				self traitComposition
					originSelectorOf:	aMethod selector.

			^ aMethod traitSource
				compiledMethodAt:	newSelector
				ifAbsent:
				[
					aMethod.
				].
		].

	^
	(
		self traitComposition
			traitDefining:	aMethod selector
			ifNone:
			[
				self.
			]
	)
		compiledMethodAt:	aMethod selector
		ifAbsent:
		[
			^ aMethod.
		].
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> hasTraitComposition [
	^ self
		traitComposition
		isEmpty
		not.
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> includesLocalSelector: aSymbol [
	^ self
		isLocalSelector:	aSymbol.
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> includesTrait: aTrait [
	^ self traitComposition
		includesTrait:	aTrait.
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> isAliasSelector: aSymbol [
	^ self traitComposition
		isAliasSelector:	aSymbol.
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> isLocalAliasSelector: aSymbol [
	^ self traitComposition
		isLocalAliasSelector:	aSymbol.
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> isLocalSelector: aSelector [
	^ self localMethodDict
		includesKey:	aSelector.
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> kernelAt: aNameString
parameterTypes: aCTypeSequencialCollection [
	^ self context
		cachedCLKernelAt:	aNameString
		ofProgram:	self program
		withParameterTypes:	aCTypeSequencialCollection.
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> kernelSource [
	^ '
kernel void GemvForward(
	global const float* weights,
	global const float* biases,
	global const float* input,
	global float* output,
	uint rows,
	uint columns)
{
	uint i = get_global_id(0);
	float total = 0.0f;
	uint j;
	for (j = 0; j < columns; j++) {
		total += weights[i * columns + j] * input[j];
	}
	output[i] = total + biases[i];
}

kernel void GemvTransposeBackward(
	global const float* weights,
	global const float* gradient,
	global float* input_gradient,
	uint rows,
	uint columns)
{
	uint j = get_global_id(0);
	float total = 0.0f;
	uint i;
	for (i = 0; i < rows; i++) {
		total += weights[i * columns + j] * gradient[i];
	}
	input_gradient[j] = total;
}

kernel void OuterProduct(
	global const float* input,
	global const float* gradient,
	global float* weight_gradient,
	uint columns)
{
	uint i = get_global_id(0);
	uint j = get_global_id(1);
	weight_gradient[i * columns + j] = input[j] * gradient[i];
}

kernel void ReluForward(
	global const float* input,
	global float* output,
	uint count)
{
	uint i = get_global_id(0);
	if (i < count) {
		output[i] = max(input[i], 0.0f);
	}
}

kernel void ReluBackward(
	global const float* input,
	global const float* gradient,
	global float* input_gradient,
	uint count)
{
	uint i = get_global_id(0);
	if (i < count) {
		input_gradient[i] = (input[i] > 0.0f) ? gradient[i] : 0.0f;
	}
}

kernel void CriterionGradientScale(
	global const float* predictions,
	global const float* targets,
	global float* gradient,
	float scale,
	uint count)
{
	uint i = get_global_id(0);
	if (i < count) {
		gradient[i] = scale * (predictions[i] - targets[i]);
	}
}

kernel void Conv2dForward(
	global const float* weights,
	global const float* biases,
	global const float* input,
	global float* output,
	uint in_channels, uint in_height, uint in_width,
	uint out_channels, uint out_height, uint out_width,
	uint kernel_height, uint kernel_width,
	uint stride_height, uint stride_width,
	int pad_top, int pad_left)
{
	uint oc = get_global_id(0);
	uint oy = get_global_id(1);
	uint ox = get_global_id(2);
	float total = 0.0f;
	uint ic, ky, kx;
	for (ic = 0; ic < in_channels; ic++) {
		for (ky = 0; ky < kernel_height; ky++) {
			int iy = (int)(oy * stride_height + ky) - pad_top;
			if (iy < 0 || iy >= (int)in_height) continue;
			for (kx = 0; kx < kernel_width; kx++) {
				int ix = (int)(ox * stride_width + kx) - pad_left;
				if (ix < 0 || ix >= (int)in_width) continue;
				float weight = weights[((oc * in_channels + ic) * kernel_height + ky) * kernel_width + kx];
				float value = input[(ic * in_height + (uint)iy) * in_width + (uint)ix];
				total += weight * value;
			}
		}
	}
	output[(oc * out_height + oy) * out_width + ox] = total + biases[oc];
}

kernel void Conv2dBiasGradient(
	global const float* gradient,
	global float* bias_gradient,
	uint out_channels, uint out_height, uint out_width)
{
	uint oc = get_global_id(0);
	if (oc >= out_channels) return;
	float total = 0.0f;
	uint count = out_height * out_width;
	uint p;
	for (p = 0; p < count; p++) {
		total += gradient[oc * count + p];
	}
	bias_gradient[oc] = total;
}

kernel void Conv2dWeightGradient(
	global const float* input,
	global const float* gradient,
	global float* weight_gradient,
	uint in_channels, uint in_height, uint in_width,
	uint out_channels, uint out_height, uint out_width,
	uint kernel_height, uint kernel_width,
	uint stride_height, uint stride_width,
	int pad_top, int pad_left)
{
	uint oc = get_global_id(0);
	uint ic = get_global_id(1);
	if (oc >= out_channels || ic >= in_channels) return;
	uint ky, kx, oy, ox;
	for (ky = 0; ky < kernel_height; ky++) {
		for (kx = 0; kx < kernel_width; kx++) {
			float total = 0.0f;
			for (oy = 0; oy < out_height; oy++) {
				int iy = (int)(oy * stride_height + ky) - pad_top;
				if (iy < 0 || iy >= (int)in_height) continue;
				for (ox = 0; ox < out_width; ox++) {
					int ix = (int)(ox * stride_width + kx) - pad_left;
					if (ix < 0 || ix >= (int)in_width) continue;
					float inputValue = input[(ic * in_height + (uint)iy) * in_width + (uint)ix];
					float gradientValue = gradient[(oc * out_height + oy) * out_width + ox];
					total += inputValue * gradientValue;
				}
			}
			weight_gradient[((oc * in_channels + ic) * kernel_height + ky) * kernel_width + kx] = total;
		}
	}
}

kernel void Conv2dInputGradient(
	global const float* weights,
	global const float* gradient,
	global float* input_gradient,
	uint in_channels, uint in_height, uint in_width,
	uint out_channels, uint out_height, uint out_width,
	uint kernel_height, uint kernel_width,
	uint stride_height, uint stride_width,
	int pad_top, int pad_left)
{
	uint ic = get_global_id(0);
	uint iy = get_global_id(1);
	uint ix = get_global_id(2);
	if (ic >= in_channels || iy >= in_height || ix >= in_width) return;
	float total = 0.0f;
	uint oc, ky, kx;
	for (ky = 0; ky < kernel_height; ky++) {
		int numerator_y = (int)iy + pad_top - (int)ky;
		if (numerator_y < 0 || numerator_y % (int)stride_height != 0) continue;
		int oy = numerator_y / (int)stride_height;
		if (oy < 0 || oy >= (int)out_height) continue;
		for (kx = 0; kx < kernel_width; kx++) {
			int numerator_x = (int)ix + pad_left - (int)kx;
			if (numerator_x < 0 || numerator_x % (int)stride_width != 0) continue;
			int ox = numerator_x / (int)stride_width;
			if (ox < 0 || ox >= (int)out_width) continue;
			for (oc = 0; oc < out_channels; oc++) {
				float weight = weights[((oc * in_channels + ic) * kernel_height + ky) * kernel_width + kx];
				float gradientValue = gradient[(oc * out_height + (uint)oy) * out_width + (uint)ox];
				total += weight * gradientValue;
			}
		}
	}
	input_gradient[(ic * in_height + iy) * in_width + ix] = total;
}

kernel void Pool2dForward(
	global const float* input,
	global float* output,
	uint in_height, uint in_width,
	uint out_height, uint out_width,
	uint kernel_height, uint kernel_width,
	uint stride_height, uint stride_width,
	int pad_top, int pad_left)
{
	uint c = get_global_id(0);
	uint oy = get_global_id(1);
	uint ox = get_global_id(2);
	float best = -INFINITY;
	uint ky, kx;
	for (ky = 0; ky < kernel_height; ky++) {
		int iy = (int)(oy * stride_height + ky) - pad_top;
		if (iy < 0 || iy >= (int)in_height) continue;
		for (kx = 0; kx < kernel_width; kx++) {
			int ix = (int)(ox * stride_width + kx) - pad_left;
			if (ix < 0 || ix >= (int)in_width) continue;
			float value = input[(c * in_height + (uint)iy) * in_width + (uint)ix];
			if (value > best) { best = value; }
		}
	}
	output[(c * out_height + oy) * out_width + ox] = best;
}

kernel void Pool2dBackward(
	global const float* input,
	global const float* gradient,
	global float* input_gradient,
	uint in_height, uint in_width,
	uint out_height, uint out_width,
	uint kernel_height, uint kernel_width,
	uint stride_height, uint stride_width,
	int pad_top, int pad_left)
{
	uint c = get_global_id(0);
	uint iy = get_global_id(1);
	uint ix = get_global_id(2);
	float total = 0.0f;
	uint ky, kx;
	for (ky = 0; ky < kernel_height; ky++) {
		int numerator_y = (int)iy + pad_top - (int)ky;
		if (numerator_y < 0 || numerator_y % (int)stride_height != 0) continue;
		int oy = numerator_y / (int)stride_height;
		if (oy < 0 || oy >= (int)out_height) continue;
		for (kx = 0; kx < kernel_width; kx++) {
			int numerator_x = (int)ix + pad_left - (int)kx;
			if (numerator_x < 0 || numerator_x % (int)stride_width != 0) continue;
			int ox = numerator_x / (int)stride_width;
			if (ox < 0 || ox >= (int)out_width) continue;

			/* Replay the Pool2dForward arg-max scan for output cell (c, oy, ox)
			   to determine whether (iy, ix) is the winner (first occurrence,
			   matching the strict greater-than tie-break in Pool2dForward). */
			float best = -INFINITY;
			uint best_y = 0;
			uint best_x = 0;
			uint ky2, kx2;
			for (ky2 = 0; ky2 < kernel_height; ky2++) {
				int iy2 = (int)((uint)oy * stride_height + ky2) - pad_top;
				if (iy2 < 0 || iy2 >= (int)in_height) continue;
				for (kx2 = 0; kx2 < kernel_width; kx2++) {
					int ix2 = (int)((uint)ox * stride_width + kx2) - pad_left;
					if (ix2 < 0 || ix2 >= (int)in_width) continue;
					float value = input[(c * in_height + (uint)iy2) * in_width + (uint)ix2];
					if (value > best) {
						best = value;
						best_y = (uint)iy2;
						best_x = (uint)ix2;
					}
				}
			}

			if (best_y == iy && best_x == ix) {
				total += gradient[(c * out_height + (uint)oy) * out_width + (uint)ox];
			}
		}
	}
	input_gradient[(c * in_height + iy) * in_width + ix] = total;
}

kernel void AddForward(
	global const float* input,
	global float* output,
	uint half_count)
{
	uint i = get_global_id(0);
	output[i] = input[i] + input[half_count + i];
}

kernel void AddBackward(
	global const float* gradient,
	global float* input_gradient,
	uint half_count)
{
	uint i = get_global_id(0);
	input_gradient[i] = gradient[i];
	input_gradient[half_count + i] = gradient[i];
}

kernel void GlobalAvgPoolForward(
	global const float* input,
	global float* output,
	uint rows, uint columns)
{
	uint c = get_global_id(0);
	uint count = rows * columns;
	float total = 0.0f;
	uint p;
	for (p = 0; p < count; p++) {
		total += input[c * count + p];
	}
	output[c] = total / (float)count;
}

kernel void GlobalAvgPoolBackward(
	global const float* gradient,
	global float* input_gradient,
	uint spatial_count)
{
	uint c = get_global_id(0);
	uint p = get_global_id(1);
	input_gradient[c * spatial_count + p] = gradient[c] / (float)spatial_count;
}

kernel void BatchNormalizationForward(
	global const float* scale,
	global const float* shift,
	global const float* input,
	global float* output,
	uint channels, uint spatial_count)
{
	uint c = get_global_id(0);
	uint p = get_global_id(1);
	uint i = c * spatial_count + p;
	output[i] = input[i] * scale[c] + shift[c];
}

kernel void BatchNormalizationInputGradient(
	global const float* scale,
	global const float* gradient,
	global float* input_gradient,
	uint channels, uint spatial_count)
{
	uint c = get_global_id(0);
	uint p = get_global_id(1);
	if (c >= channels || p >= spatial_count) return;
	uint i = c * spatial_count + p;
	input_gradient[i] = gradient[i] * scale[c];
}

kernel void BatchNormalizationParamGradient(
	global const float* input,
	global const float* gradient,
	global float* scale_gradient,
	global float* shift_gradient,
	uint channels, uint spatial_count)
{
	uint c = get_global_id(0);
	float scaleTotal = 0.0f;
	float shiftTotal = 0.0f;
	uint p;
	if (c >= channels) return;
	for (p = 0; p < spatial_count; p++) {
		uint i = c * spatial_count + p;
		scaleTotal += gradient[i] * input[i];
		shiftTotal += gradient[i];
	}
	scale_gradient[c] = scaleTotal;
	shift_gradient[c] = shiftTotal;
}
'.
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> localMethodDict [
	^ self
		class
		baseLocalMethods.
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> localMethodDict: aMethodDictionary [
	^ self class
		baseLocalMethods:	aMethodDictionary.
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> localMethods [
	^ self
		localMethodDict
		values.
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> localSelectors [
	^ self
		localMethodDict
		keys.
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> program [
	^ self context
		cachedCLProgramFor:	self devices
		fromSources:	{self kernelSource}
		withOptions:	''.
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> rebuildMethodDictionary [
	^ self doRebuildMethodDictionary.
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> recategorizeSelector: selector
from: oldProtocol
to: newProtocol [
	|
		originalProtocol
	|

	newProtocol
		ifNil:
		[
			^ self.
		].

	originalProtocol :=
		(
			self
				protocolOfSelector:	selector
		)
			ifNil:
			[
				^ self.
			].

	originalProtocol
		name
		= oldProtocol name
		ifTrue:
		[
			self
				classify:	selector
				under:	newProtocol name.
		].

	(
		self traitComposition
			reverseAlias:	selector
	)
		do:
		[ :selectorAlias |
			self
				recategorizeSelector:	selectorAlias
				from:	oldProtocol
				to:	newProtocol.

			self
				notifyOfRecategorizedSelector:	selectorAlias
				from:	oldProtocol
				to:	newProtocol.
		].
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> recompile: selector
from: oldClass [
	super
		recompile:	selector
		from:	oldClass.

	TraitChange
		addSelector:	selector
		on:	self.
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> removeFromComposition: aTrait [
	self
		setTraitComposition:	
		(
			self traitComposition
				copyWithoutTrait:	aTrait asTraitComposition
		).
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> removeFromSystem: logged [
	|
		mySubclasses
	|

	self traitComposition
		removeUser:	self.

	self
		class
		traitComposition
		removeUser:	self class.

	TraitedClass
		removeUser:	self class.

	mySubclasses := self subclasses.

	super
		removeFromSystem:	logged.

	mySubclasses
		do:
		[ :each |
			each
				class
				initializeBasicMethods.
		].
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> removeSelector: aSelector [
	super
		removeSelector:	aSelector.

	self localMethodDict
		removeKey:	aSelector
		ifAbsent:
		[
		].

	TraitChange
		removeSelector:	aSelector
		on:	self.
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> traitComposition [
	^ self
		class
		baseComposition.
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> traitComposition: aComposition [
	aComposition
		asTraitComposition
		allTraits
		do:
		[ :aMaybeTrait |
			aMaybeTrait isTrait
				ifFalse:
				[
					self
						error:	'All the members of the trait composition should be traits'.
				].
		].

	self class
		baseComposition:	aComposition.
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> traitCompositionString [
	^ self
		traitComposition
		asString.
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> traitUsers [
	^ #().
]

{ #category : 'as yet unclassified' }
OpenCLNeuralNetworkMachineLearningRudesheim class >> traits [
	^ self
		traitComposition
		traits.
]
