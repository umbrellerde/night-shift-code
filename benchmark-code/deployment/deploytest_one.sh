#!/bin/bash
for i in {1..7}; do 
    cp -r function_float "function_float$i";
    cd "function_float$i"
    sed -i "s/float_small/float_small_one_$i/g" main.py
    gcloud functions deploy float_small_one_$i --runtime python37 --trigger-http --memory=128 --no-allow-unauthenticated
    cd ..
    rm -R "function_float$i"
done
