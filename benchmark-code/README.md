### Instructions for Benchmarks

First the functions are deployed on GCF.
## Deployment Cloud Functions
Condition: local connection to Google Cloud Account
'''
cd deployment
chmod +x all_deploy.sh
'''
This uploads the functions within the folders deployment/function_float, deployment/function_matrixmult, deployment/function_ml in sequence to GCF. 

## Execution of cloud functions
Each benchmark is executed on a seperated VM within in Google Cloud Compute Engine.

Create an MYSQL Database instance within the Google Cloud Account. Change the password and IP within each timeline of the YYY_benchmark/product_XXX/timeline_XXX.sh to the setting of your own MYSQL Database.
Insert the IP of the VMs into the allowed Section of the MYSQL Database.
Create a Table benchmark.data after the following format: 

'''
CREATE DATABASE benchmark;
CREATE TABLE benchmark.data(invoke_id INT AUTO_INCREMENT NOT NULL PRIMARY KEY, func_name VARCHAR(15), type ENUM ('Warm', 'Cold'), isCold ENUM ('True', 'False'), size INT(10), function_start FLOAT(30),function_stop FLOAT(30), invoke_time FLOAT(30), return_time FLOAT(30), google_time FLOAT(10), function_id CHAR(20));
'''

Each VM instance needs either the float_benchmark, matrix_benchmark, or ml_benchmark folder. The VMs need to have the rights for communication with MYSQL Database and Cloud Functions.
To execute the function (examplary for float_benchmark): 
'''
chmod +x float_benchmark/all_products.sh
nohup ./float_benchmark/all_products.sh > /dev/null 2>&1
'''

Beware: Within an execution of several weeks a VM may have a memory overflow. To prevent this, the log data of the functions must be deleted periodically (suggestion: every two weeks). 

