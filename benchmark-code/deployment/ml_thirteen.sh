#!/bin/bash
for i in {1..7}; do 
    cp -r function_ml "function_ml$i";
    cd "function_ml$i"
    sed -i "s/ml/ml_big_thirteen_$i/g" main.py
    gcloud functions deploy ml_big_thirteen_$i --runtime python37 --trigger-http --memory=512 --no-allow-unauthenticated
    cd ..
    rm -R "function_ml$i"
done
