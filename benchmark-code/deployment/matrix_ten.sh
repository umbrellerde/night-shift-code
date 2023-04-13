#!/bin/bash
for i in {1..7}; do 
    cp -r function_matrixmult "function_matrixmult$i";
    cd "function_matrixmult$i"
    sed -i "s/matrixmult/matrixmult_middle_ten_$i/g" main.py
    gcloud functions deploy matrixmult_middle_ten_$i --runtime python37 --trigger-http --memory=256 --no-allow-unauthenticated
    cd ..
    rm -R "function_matrixmult$i"
done
