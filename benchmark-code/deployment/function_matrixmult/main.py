from time import time
START_TIME = time()
import numpy as np

COLD_START = True

# only multiplication of square matrices
def matrixmult(request):
    start = time()
    global COLD_START
    if (COLD_START):
       start = START_TIME
    cold = COLD_START
    COLD_START = False
    id = request.headers.get('function-execution-id')
    request_json = request.get_json(silent=True)
    A = request_json['A']
    B = request_json['B']
    n = len(A)
    C = np.zeros((n,n))
    for i in range(300):
        for x in range (n):
            for y in range (n):
                for z in range (n):
                    C[x][y] += A[x][z] * B[z][y]
    end = time()
    return str(id) + "\n" + str(start)+ "\n"+ str(end) + "\n" + str(cold)