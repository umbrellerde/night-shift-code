# Source 1: https://github.com/umbrellerde/hal-faas/blob/main/runtimes/onnx/main.py
# Source 2: https://github.com/onnx/models/tree/main/vision/body_analysis/emotion_ferplus
from time import time
START_TIME = time()
import json
import onnx
import onnxruntime as rt
from onnx import numpy_helper


COLD_START = True

def ml(request):
    start= time()
    global COLD_START
    if (COLD_START):
        start = START_TIME
    cold = COLD_START
    COLD_START = False
    id = request.headers.get('function-execution-id')
    params = '{"configuration": "./emotion-ferplus-7/model/model.onnx", ' \
                '"params": {' \
                '"payload":"./emotion-ferplus-7/model/test_data_set_0/input_0.pb"}}'  #
    parameters = json.loads(params)

    # Load tensor
    tensor = onnx.TensorProto()
    with open(parameters['params']['payload'], 'rb') as f:
        tensor.ParseFromString(f.read())

    image_data = numpy_helper.to_array(tensor)

    # Run Inference

    sess = rt.InferenceSession(parameters['configuration'])
    outputs = sess.get_outputs()
    output_names = list(map(lambda output: output.name, outputs))
    input_name = sess.get_inputs()[0].name

    detections = sess.run(output_names, {input_name: image_data})

    # Stop the session to hopefully release some memory...
    del sess
    

    end = time()
    return str(id) + "\n" + str(start)+ "\n"+ str(end) + "\n" + str(cold)