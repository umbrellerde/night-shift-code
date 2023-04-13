How to reproduce the SeBS benchmark a couple of times:

- clone into their repository
- run `git checkout v1.1` for our exact setup
- merge all the files in this folder into their folders
- run `./sebs.py install --gcp --aws` and enter the created virtualenv
    - Follow the SeBS documentation to make sure that all credentials are set up correctly etc.
    - Update the deployment information in all config files in `./config/` with your Google and AWS Credentials
- run `./consistency-benchmark.sh` until you have collected enough data
- `reproduce.ipynb` contains our scripts to generate the graph in the paper. Just replace the `base_folder` in the first cell with your relative path to the results folder

If you encounter any problems, please make sure that your `python3` executable is newer than python3.7.