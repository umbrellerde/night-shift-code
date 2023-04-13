# Source: https://github.com/ddps-lab/serverless-faas-workbench
# License: Apache 2.0
# changed it myself -> allowed under Apache 2.0

from time import time
START_TIME = time()
import math

COLD_START = True

def float_small(request):
    start = time()
    global COLD_START
    if (COLD_START):
        start = START_TIME
    cold = COLD_START
    COLD_START = False
    id = request.headers.get('function-execution-id')
    request_json = request.get_json(silent=True)
    N = request_json['N']
    for i in range(0, N):
        sin_i = math.sin(i)
        cos_i = math.cos(i)
        sqrt_i = math.sqrt(i)
    end = time()
    return str(id) + "\n" + str(start)+ "\n"+ str(end) + "\n" + str(cold)
