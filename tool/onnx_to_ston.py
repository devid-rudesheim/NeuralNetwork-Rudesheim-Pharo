"""Decode an ONNX model and emit a STON document describing its computation graph,
laid out as position-fixed arrays (no STON maps / dictionary keys), for import into
Rudesheim-NeuralNetwork's ModelRecordSoilNeuralNetworkMachineLearningRudesheim.

Scope: originally this script only understood the linear Conv/MaxPool/ReLU/MatMul-plus-
bias CNN chain shape of ./llm-model/mnist-8.onnx. It has since been extended to also
decode branching graphs with residual/skip connections (the shape of
./llm-model/resnet50-v2-7.onnx): a genuine element-wise 'Add' of two activation
branches (distinct from the bias-fuse Add below), 'BatchNormalization' (implemented as
its own per-channel affine Layer rather than folded into a neighboring Conv - real
resnet50-v2-7.onnx BatchNorm nodes are not always Conv-adjacent, and some carry
negative gamma, both of which make algebraic folding unsafe in general), a native ONNX
'Gemm' node (as opposed to MatMul-plus-bias), and 'GlobalAveragePool'. Conv is still
fused with a following bias Add into one 'Conv' node when present (mnist-8 style); a
bias-less Conv (resnet50 style, its BatchNormalization stays a separate node) is also
supported. MatMul is still fused with its following bias Add into one 'Gemm' node
(reusing the existing LinearTransform Layer, whose nameForONNX is 'Gemm'). Reshape
nodes are elided (folded into a constant tensor when reshaping an initializer, or
treated as a pass-through alias when reshaping runtime data). Any other op type raises
an error rather than being silently skipped. The graph input may be 4-D NCHW or 3-D CHW
(batch dimension omitted, as in resnet50-v2-7.onnx).

Output STON top-level shape:

  [ tensorsArray, nodesArray, outputNodeIndex, metadataArray ]

tensorsArray entries:  [ kindToken, shapeArray, payloadArray ]
  kindToken is 'Weights' or 'Biases'. BatchNormalization reuses these two kinds to
  carry its precomputed per-channel scale ('Weights') and shift ('Biases').
  payloadArray is always a FLAT Array of numbers regardless of the tensor's rank
  (shapeArray alone carries the dimensions) -- a Conv 'Weights' tensor's payload is
  not nested per out_channel/in_channel/kernel_row even though shapeArray is
  4-element, and likewise a Gemm 'Weights' tensor's payload is not nested per row
  even though shapeArray is 2-element. This is deliberate: Pharo's STON reader
  reconstructs nested Arrays as real objects, and persisting millions of tiny
  per-kernel-element Arrays (as resnet50-v2-7.onnx's many 1x1-kernel Convs would
  produce) made Soil's object-identity bookkeeping dominate `Convertor
  file:toSoil:`'s runtime -- see note/resnet50-onnx-support-plan.md 2026-08-09追記(4).
  Backends that need a nested/row-based view reshape from the flat payload once at
  model-load time (never persisted), not at conversion time.

nodesArray entries:    [ layerNameToken, predecessorIndices, tensorIndices, windowArray ]
  layerNameToken matches an existing/'nameForONNX' token ('Conv', 'Relu', 'MaxPool',
  'Gemm', 'Add', 'BatchNormalization', 'GlobalAveragePool').
  predecessorIndices / tensorIndices are 1-based indices into nodesArray / tensorsArray.
  windowArray is [] for nodes without spatial-window attributes, or a single-element
  array [ [ inputChannels, inputRows, inputColumns, kernelRows, kernelColumns,
            strideRows, strideColumns, padTopRows, padBottomRows, padLeftColumns,
            padRightColumns ] ] otherwise. GlobalAveragePool reuses this same 11-field
  window shape with kernel/stride set to the full input spatial extent (see
  note/resnet50-onnx-support-plan.md).

metadataArray: [ sourceFileName, graphName ]
"""

import math
import struct
import sys
from pathlib import Path


WIRE_VARINT = 0
WIRE_FIXED64 = 1
WIRE_LEN = 2
WIRE_FIXED32 = 5


def read_varint(data, pos):
    shift = 0
    result = 0
    while True:
        byte = data[pos]
        pos += 1
        result |= (byte & 0x7F) << shift
        if byte < 0x80:
            return result, pos
        shift += 7


def fields(data):
    pos = 0
    size = len(data)
    while pos < size:
        key, pos = read_varint(data, pos)
        number = key >> 3
        wire = key & 7
        if wire == WIRE_VARINT:
            value, pos = read_varint(data, pos)
        elif wire == WIRE_FIXED64:
            value = data[pos : pos + 8]
            pos += 8
        elif wire == WIRE_LEN:
            length, pos = read_varint(data, pos)
            value = data[pos : pos + length]
            pos += length
        elif wire == WIRE_FIXED32:
            value = data[pos : pos + 4]
            pos += 4
        else:
            raise ValueError(f"unsupported wire type {wire}")
        yield number, wire, value


def text(value):
    return value.decode("utf-8", errors="replace")


# ---- ONNX protobuf decoding -------------------------------------------------


def parse_attribute(blob):
    name = None
    f = None
    i = None
    s = None
    ints = []
    for number, wire, value in fields(blob):
        if number == 1:
            name = text(value)
        elif number == 2 and wire == WIRE_FIXED32:
            f = struct.unpack("<f", value)[0]
        elif number == 3:
            i = value
        elif number == 4:
            s = value
        elif number == 8 and wire == WIRE_LEN:
            position = 0
            while position < len(value):
                entry, position = read_varint(value, position)
                ints.append(entry)
        elif number == 8 and wire == WIRE_VARINT:
            ints.append(value)
    return {"name": name, "f": f, "i": i, "s": s, "ints": ints}


def parse_node(blob):
    inputs = []
    outputs = []
    name = None
    op_type = None
    attributes = {}
    for number, wire, value in fields(blob):
        if number == 1:
            inputs.append(text(value))
        elif number == 2:
            outputs.append(text(value))
        elif number == 3:
            name = text(value)
        elif number == 4:
            op_type = text(value)
        elif number == 5:
            attribute = parse_attribute(value)
            attributes[attribute["name"]] = attribute
    return {
        "inputs": inputs,
        "outputs": outputs,
        "name": name,
        "op_type": op_type,
        "attributes": attributes,
    }


def parse_tensor(blob):
    dims = []
    data_type = None
    name = None
    float_data = []
    int64_data = []
    raw_data = b""
    for number, wire, value in fields(blob):
        if number == 1 and wire == WIRE_VARINT:
            dims.append(value)
        elif number == 2 and wire == WIRE_VARINT:
            data_type = value
        elif number == 4 and wire == WIRE_LEN:
            float_data.extend(struct.unpack("<" + "f" * (len(value) // 4), value))
        elif number == 7 and wire == WIRE_VARINT:
            int64_data.append(value)
        elif number == 7 and wire == WIRE_LEN:
            position = 0
            while position < len(value):
                entry, position = read_varint(value, position)
                int64_data.append(entry)
        elif number == 8 and wire == WIRE_LEN:
            name = text(value)
        elif number == 9 and wire == WIRE_LEN:
            raw_data = value
    if data_type == 1:
        payload = list(struct.unpack("<" + "f" * (len(raw_data) // 4), raw_data)) if raw_data else float_data
    elif data_type == 7:
        payload = list(struct.unpack("<" + "q" * (len(raw_data) // 8), raw_data)) if raw_data else int64_data
    else:
        raise ValueError(f"unsupported initializer data_type {data_type} for tensor {name}")
    return {"name": name, "dims": dims, "data_type": data_type, "payload": payload}


def parse_input_shape(blob):
    name = None
    dims = None
    for n1, w1, v1 in fields(blob):
        if n1 == 1:
            name = text(v1)
        elif n1 == 2:
            for n2, w2, v2 in fields(v1):
                if n2 == 1:
                    for n3, w3, v3 in fields(v2):
                        if n3 == 2:
                            dims = []
                            for n4, w4, v4 in fields(v3):
                                if n4 == 1:
                                    for n5, w5, v5 in fields(v4):
                                        if n5 == 1:
                                            dims.append(v5)
    return name, dims


def parse_graph(onnx_bytes):
    graph_bytes = None
    for number, wire, value in fields(onnx_bytes):
        if number == 7:
            graph_bytes = value
    if graph_bytes is None:
        raise SystemExit("graph not found in ONNX model")

    nodes = []
    initializers = {}
    graph_name = "ONNXGraph"
    graph_input_name = None
    graph_input_dims = None
    for number, wire, value in fields(graph_bytes):
        if number == 1:
            nodes.append(parse_node(value))
        elif number == 2:
            graph_name = text(value)
        elif number == 5:
            tensor = parse_tensor(value)
            initializers[tensor["name"]] = tensor
        elif number == 11 and graph_input_name is None:
            name, dims = parse_input_shape(value)
            if name is not None and name not in initializers:
                graph_input_name = name
                graph_input_dims = dims

    return nodes, initializers, graph_name, graph_input_name, graph_input_dims


# ---- attribute helpers -------------------------------------------------


def attribute_ints(node, attribute_name, default):
    attribute = node["attributes"].get(attribute_name)
    if attribute is None or not attribute["ints"]:
        return default
    return attribute["ints"]


def attribute_string(node, attribute_name, default):
    attribute = node["attributes"].get(attribute_name)
    if attribute is None or attribute["s"] is None:
        return default
    return attribute["s"].decode("ascii")


def attribute_float(node, attribute_name, default):
    attribute = node["attributes"].get(attribute_name)
    if attribute is None or attribute["f"] is None:
        return default
    return attribute["f"]


def attribute_int(node, attribute_name, default):
    attribute = node["attributes"].get(attribute_name)
    if attribute is None or attribute["i"] is None:
        return default
    return attribute["i"]


def resolve_conv_padding(auto_pad, input_size, kernel_size, stride):
    if auto_pad in ("NOTSET", None):
        return 0, 0
    output_size = -(-input_size // stride)  # ceil division
    total_padding = max(0, (output_size - 1) * stride + kernel_size - input_size)
    pad_before = total_padding // 2
    pad_after = total_padding - pad_before
    if auto_pad == "SAME_UPPER":
        return pad_before, pad_after
    if auto_pad == "SAME_LOWER":
        return pad_after, pad_before
    raise ValueError(f"unsupported auto_pad {auto_pad}")


# ---- graph simplification: fuse bias Add, elide Reshape -------------------


def flatten_reshaped_initializer(tensor, new_dims):
    return {"name": tensor["name"], "dims": list(new_dims), "data_type": tensor["data_type"], "payload": tensor["payload"]}


def simplify_graph(nodes, initializers):
    """Returns a new node list with Conv/MatMul+bias-Add fused into single nodes and
    Reshape nodes elided, plus an updated initializer dict (reshaped constants folded
    in). Raises on any node this script does not know how to handle."""

    producer_of_output = {}
    for index, node in enumerate(nodes):
        for output_name in node["outputs"]:
            producer_of_output[output_name] = index

    alias_of = {}

    def resolve(name):
        seen = set()
        while name in alias_of:
            if name in seen:
                raise ValueError(f"cycle while resolving alias for {name}")
            seen.add(name)
            name = alias_of[name]
        return name

    consumed = set()

    for index, node in enumerate(nodes):
        if node["op_type"] != "Reshape":
            continue
        data_input = resolve(node["inputs"][0])
        output_name = node["outputs"][0]
        if data_input in initializers:
            shape_input = resolve(node["inputs"][1])
            new_dims = initializers[shape_input]["payload"]
            initializers[output_name] = flatten_reshaped_initializer(initializers[data_input], new_dims)
        else:
            alias_of[output_name] = data_input
        consumed.add(index)

    bias_of_producer = {}
    for index, node in enumerate(nodes):
        if node["op_type"] != "Add":
            continue
        left = resolve(node["inputs"][0])
        right = resolve(node["inputs"][1])
        left_is_initializer = left in initializers
        right_is_initializer = right in initializers
        if left_is_initializer and right_is_initializer:
            raise ValueError(f"Add node {node['name']}: both inputs are initializers")
        if not left_is_initializer and not right_is_initializer:
            # A genuine element-wise Add of two activation branches (e.g. a residual/
            # skip connection). Leave it unconsumed for pass 3 to handle as its own node.
            continue
        bias_name, activation_name = (left, right) if left_is_initializer else (right, left)
        producer_index = producer_of_output.get(activation_name)
        if producer_index is None or nodes[producer_index]["op_type"] not in ("Conv", "MatMul"):
            raise ValueError(f"cannot fuse Add node {node['name']}: producer is not Conv/MatMul")
        bias_of_producer[producer_index] = bias_name
        alias_of[node["outputs"][0]] = activation_name
        consumed.add(index)

    fused_nodes = []
    output_name_of_fused = {}
    known_op_types = (
        "Conv", "MatMul", "Gemm", "Relu", "MaxPool",
        "Add", "BatchNormalization", "GlobalAveragePool",
    )
    for index, node in enumerate(nodes):
        if index in consumed:
            continue
        op_type = node["op_type"]
        if op_type not in known_op_types:
            raise ValueError(f"unsupported ONNX op_type {op_type!r} (node {node['name']})")
        fused = dict(node)
        fused["inputs"] = [resolve(each) for each in node["inputs"]]
        fused["bias"] = bias_of_producer.get(index)
        fused_nodes.append(fused)
        for output_name in node["outputs"]:
            output_name_of_fused[output_name] = fused

    return fused_nodes, initializers, output_name_of_fused


# ---- building the position-fixed node/tensor records -------------------


class Builder:
    def __init__(self, initializers):
        self.initializers = initializers
        self.tensors = []
        self.node_records = []
        self.node_index_of_output = {}

    def add_tensor(self, kind_token, dims, payload):
        self.tensors.append((kind_token, dims, payload))
        return len(self.tensors)  # 1-based

    def add_node(self, layer_name_token, predecessor_indices, tensor_indices, window_fields, output_names):
        self.node_records.append((layer_name_token, predecessor_indices, tensor_indices, window_fields))
        node_index = len(self.node_records)  # 1-based
        for output_name in output_names:
            self.node_index_of_output[output_name] = node_index
        return node_index

    def predecessor_index_for(self, input_name):
        return self.node_index_of_output.get(input_name)  # None => graph input


def gemm_weight_flat(weight_tensor):
    """weight_tensor dims are [inputSize, outputSize] (post constant-fold reshape,
    matching ONNX MatMul's B operand). Returns the transpose flattened in row-major
    (output-feature, then input-feature) order, matching LinearTransformLayer's
    row = output-feature layout -- but as a single flat list rather than nested
    per-row sublists, so the STON payload stays a flat Array (see
    note/resnet50-onnx-support-plan.md 2026-08-09追記(4): nested per-row Arrays are
    what made SoilSerializer's object-identity bookkeeping dominate Soil commit
    time). Row/column counts travel separately as the tensor's `shape`."""

    input_size, output_size = weight_tensor["dims"]
    flat = weight_tensor["payload"]
    return [flat[input_index * output_size + output_index] for output_index in range(output_size) for input_index in range(input_size)]


def build(nodes, initializers, output_name_of_fused, input_channels, input_rows, input_columns):
    builder = Builder(initializers)
    graph_input_shape = (input_channels, input_rows, input_columns)
    shape_of_node_index = {}

    def shape_of(input_name):
        # A node's runtime (non-initializer) input is either the graph's own input
        # (predecessor_index_for returns None) or the output of an earlier node - this
        # is what lets branching/residual graphs be handled without a single global
        # "current shape" variable (see note/resnet50-onnx-support-plan.md item 5).
        producer_index = builder.predecessor_index_for(input_name)
        return graph_input_shape if producer_index is None else shape_of_node_index[producer_index]

    for node in nodes:
        op_type = node["op_type"]
        predecessor_indices = [
            index
            for index in (builder.predecessor_index_for(each) for each in node["inputs"] if each not in initializers)
            if index is not None
        ]

        if op_type == "Conv":
            weight = initializers[node["inputs"][1]]
            bias = initializers[node["bias"]] if node["bias"] is not None else None
            out_channels, in_channels, kernel_rows, kernel_columns = weight["dims"]
            strides = attribute_ints(node, "strides", [1, 1])
            channels, rows, columns = shape_of(node["inputs"][0])
            explicit_pads = attribute_ints(node, "pads", None)
            if explicit_pads is not None:
                # ONNX 'pads' is [x1_begin, x2_begin, x1_end, x2_end] for 2-D convs
                # (resnet50-v2-7.onnx sets this explicitly rather than using auto_pad).
                pad_top, pad_left, pad_bottom, pad_right = explicit_pads
            else:
                auto_pad = attribute_string(node, "auto_pad", "NOTSET")
                pad_top, pad_bottom = resolve_conv_padding(auto_pad, rows, kernel_rows, strides[0])
                pad_left, pad_right = resolve_conv_padding(auto_pad, columns, kernel_columns, strides[1])
            out_rows = (rows + pad_top + pad_bottom - kernel_rows) // strides[0] + 1
            out_columns = (columns + pad_left + pad_right - kernel_columns) // strides[1] + 1
            window_fields = [
                in_channels, rows, columns,
                kernel_rows, kernel_columns,
                strides[0], strides[1],
                pad_top, pad_bottom, pad_left, pad_right,
            ]
            # weight["payload"] is already flat and correctly ordered (struct.unpack
            # preserves ONNX's row-major [out_channels][in_channels][kernel_rows]
            # [kernel_columns] layout) -- no reshaping needed, unlike the previous
            # conv_weight_nested() which wrapped it in matching nested Arrays purely
            # to mirror the tensor's rank. See note above gemm_weight_flat.
            weight_index = builder.add_tensor("Weights", list(weight["dims"]), weight["payload"])
            biases_payload = list(bias["payload"]) if bias is not None else [0.0] * out_channels
            bias_index = builder.add_tensor("Biases", [out_channels], biases_payload)
            node_index = builder.add_node(
                "Conv", predecessor_indices, [weight_index, bias_index], [window_fields], node["outputs"]
            )
            shape_of_node_index[node_index] = (out_channels, out_rows, out_columns)

        elif op_type == "MaxPool":
            kernel = attribute_ints(node, "kernel_shape", None)
            strides = attribute_ints(node, "strides", kernel)
            pads = attribute_ints(node, "pads", [0, 0, 0, 0])
            channels, rows, columns = shape_of(node["inputs"][0])
            pad_top, pad_left, pad_bottom, pad_right = pads[0], pads[1], pads[2], pads[3]
            out_rows = (rows + pad_top + pad_bottom - kernel[0]) // strides[0] + 1
            out_columns = (columns + pad_left + pad_right - kernel[1]) // strides[1] + 1
            window_fields = [
                channels, rows, columns,
                kernel[0], kernel[1],
                strides[0], strides[1],
                pad_top, pad_bottom, pad_left, pad_right,
            ]
            node_index = builder.add_node("MaxPool", predecessor_indices, [], [window_fields], node["outputs"])
            shape_of_node_index[node_index] = (channels, out_rows, out_columns)

        elif op_type == "Relu":
            node_index = builder.add_node("Relu", predecessor_indices, [], [], node["outputs"])
            shape_of_node_index[node_index] = shape_of(node["inputs"][0])

        elif op_type == "BatchNormalization":
            # Implemented as its own per-channel affine Layer rather than folded into a
            # neighboring Conv: real resnet50-v2-7.onnx BatchNorm nodes are not always
            # Conv-adjacent (some follow MaxPool or a residual Add) and some carry
            # negative gamma, which makes algebraic Conv-folding unsafe in general (see
            # note/resnet50-onnx-support-plan.md and note/decisions.md).
            channels, rows, columns = shape_of(node["inputs"][0])
            gamma = initializers[node["inputs"][1]]["payload"]
            beta = initializers[node["inputs"][2]]["payload"]
            mean = initializers[node["inputs"][3]]["payload"]
            variance = initializers[node["inputs"][4]]["payload"]
            epsilon = attribute_float(node, "epsilon", 1e-5)
            scale = [g / math.sqrt(v + epsilon) for g, v in zip(gamma, variance)]
            shift = [b - g * m / math.sqrt(v + epsilon) for g, b, m, v in zip(gamma, beta, mean, variance)]
            scale_index = builder.add_tensor("Weights", [channels], scale)
            shift_index = builder.add_tensor("Biases", [channels], shift)
            # Reuses the Conv2D/MaxPool2D WindowSpecification carrier purely to pass
            # (channels, rows, columns) through to the Layer -- kernel/stride/padding
            # are meaningless here and set to inert 1x1/stride-1/no-padding values.
            window_fields = [channels, rows, columns, 1, 1, 1, 1, 0, 0, 0, 0]
            node_index = builder.add_node(
                "BatchNormalization", predecessor_indices, [scale_index, shift_index], [window_fields], node["outputs"]
            )
            shape_of_node_index[node_index] = (channels, rows, columns)

        elif op_type == "MatMul":
            weight = initializers[node["inputs"][1]]
            bias = initializers[node["bias"]]
            input_size, output_size = weight["dims"]
            weights_flat = gemm_weight_flat(weight)
            biases_flat = list(bias["payload"])
            weight_index = builder.add_tensor("Weights", [output_size, input_size], weights_flat)
            bias_index = builder.add_tensor("Biases", [len(biases_flat)], biases_flat)
            node_index = builder.add_node(
                "Gemm", predecessor_indices, [weight_index, bias_index], [], node["outputs"]
            )
            shape_of_node_index[node_index] = (output_size,)

        elif op_type == "Gemm":
            # A native ONNX Gemm node (as opposed to MatMul-plus-bias-Add): carries its
            # own bias input and transA/transB/alpha/beta attributes. Only transA=0 is
            # supported (transposing the runtime activation input can't be folded at
            # decode time); resnet50-v2-7.onnx's single Gemm node uses transA=0.
            weight = initializers[node["inputs"][1]]
            bias = initializers[node["inputs"][2]] if len(node["inputs"]) > 2 else None
            trans_a = attribute_int(node, "transA", 0)
            trans_b = attribute_int(node, "transB", 0)
            alpha = attribute_float(node, "alpha", 1.0)
            beta = attribute_float(node, "beta", 1.0)
            if trans_a != 0:
                raise ValueError(f"unsupported Gemm transA={trans_a} (node {node['name']})")
            flat = weight["payload"]
            if trans_b:
                output_size, input_size = weight["dims"]
                weights_flat = [
                    alpha * flat[output_index * input_size + input_index]
                    for output_index in range(output_size)
                    for input_index in range(input_size)
                ]
            else:
                input_size, output_size = weight["dims"]
                weights_flat = [
                    alpha * flat[input_index * output_size + output_index]
                    for output_index in range(output_size)
                    for input_index in range(input_size)
                ]
            biases_flat = [beta * value for value in bias["payload"]] if bias is not None else [0.0] * output_size
            weight_index = builder.add_tensor("Weights", [output_size, input_size], weights_flat)
            bias_index = builder.add_tensor("Biases", [len(biases_flat)], biases_flat)
            node_index = builder.add_node(
                "Gemm", predecessor_indices, [weight_index, bias_index], [], node["outputs"]
            )
            shape_of_node_index[node_index] = (output_size,)

        elif op_type == "Add":
            # A genuine element-wise Add of two activation branches (residual/skip
            # connection), distinct from the bias-fuse Add already consumed in
            # simplify_graph. Both branches must have matching shape.
            left_name, right_name = node["inputs"]
            left_shape = shape_of(left_name)
            right_shape = shape_of(right_name)
            if left_shape != right_shape:
                raise ValueError(
                    f"Add node {node['name']}: branch shape mismatch {left_shape} vs {right_shape}"
                )
            node_index = builder.add_node("Add", predecessor_indices, [], [], node["outputs"])
            shape_of_node_index[node_index] = left_shape

        elif op_type == "GlobalAveragePool":
            channels, rows, columns = shape_of(node["inputs"][0])
            window_fields = [
                channels, rows, columns,
                rows, columns,
                1, 1,
                0, 0, 0, 0,
            ]
            node_index = builder.add_node(
                "GlobalAveragePool", predecessor_indices, [], [window_fields], node["outputs"]
            )
            shape_of_node_index[node_index] = (channels,)

        else:
            raise ValueError(f"unsupported ONNX op_type {op_type!r} after simplification")

    return builder


# ---- STON emission (arrays and primitives only, no maps) -------------------


def ston_string(value):
    return "'" + value.replace("'", "''") + "'"


def ston_number(value):
    if isinstance(value, bool):
        raise TypeError("unexpected bool")
    if isinstance(value, int):
        return str(value)
    return repr(float(value))


def ston_value(value):
    if isinstance(value, str):
        return ston_string(value)
    if isinstance(value, (int, float)):
        return ston_number(value)
    if isinstance(value, (list, tuple)):
        if value:
            # Fast path keyed off the first element's type only (no full-list
            # homogeneity scan -- this script's own parse_tensor never mixes
            # int/float within one payload/dims/window-fields list, so this is
            # safe for all data this script itself produces). Bulk-formats with
            # map() instead of recursing into ston_value per element, which
            # skips a redundant Python call layer, the repeated isinstance
            # dispatch, and (for floats) the redundant float(value) re-conversion
            # of an already-float value. This is the dominant cost for large
            # tensor payloads (e.g. resnet50-v2-7.onnx's ~25.6M float weights);
            # see note/resnet50-onnx-support-plan.md 2026-08-09追記(2).
            first = value[0]
            if type(first) is float:
                return "[" + ",".join(map(repr, value)) + "]"
            if type(first) is int:
                return "[" + ",".join(map(str, value)) + "]"
        return "[" + ",".join(ston_value(each) for each in value) + "]"
    raise TypeError(f"cannot emit STON for {value!r}")


def emit_ston(builder, output_node_index, source_file_name, graph_name):
    tensors_array = [[kind, dims, payload] for kind, dims, payload in builder.tensors]
    nodes_array = [
        [layer_name, predecessors, tensor_indices, window]
        for layer_name, predecessors, tensor_indices, window in builder.node_records
    ]
    metadata_array = [source_file_name, graph_name]
    document = [tensors_array, nodes_array, output_node_index, metadata_array]
    return ston_value(document)


def main(onnx_path, ston_path):
    onnx_path = Path(onnx_path)
    onnx_bytes = onnx_path.read_bytes()
    nodes, initializers, graph_name, input_name, input_dims = parse_graph(onnx_bytes)
    if input_dims is None or len(input_dims) not in (3, 4):
        raise SystemExit(f"expected a 3-D CHW or 4-D NCHW graph input, got {input_dims} for {input_name}")
    if len(input_dims) == 4:
        _batch, input_channels, input_rows, input_columns = input_dims
    else:
        input_channels, input_rows, input_columns = input_dims

    fused_nodes, initializers, _output_name_of_fused = simplify_graph(nodes, initializers)
    builder = build(fused_nodes, initializers, _output_name_of_fused, input_channels, input_rows, input_columns)

    last_outputs = fused_nodes[-1]["outputs"]
    output_node_index = builder.node_index_of_output[last_outputs[0]]

    ston_text = emit_ston(builder, output_node_index, str(onnx_path.resolve()), graph_name)
    Path(ston_path).write_text(ston_text)
    print(f"wrote {ston_path}: {len(builder.tensors)} tensors, {len(builder.node_records)} nodes, output node {output_node_index}")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        raise SystemExit(f"usage: {sys.argv[0]} <input.onnx> <output.ston>")
    main(sys.argv[1], sys.argv[2])
