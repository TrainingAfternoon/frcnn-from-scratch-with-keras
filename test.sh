#!/bin/bash

#SBATCH --job-name='eval'
#SBATCH --partition=teaching
#SBATCH --nodes=1
#SBATCH --gpus=4
#SBATCH --cpus-per-gpu=16
#SBATCH --time=1-0:0
# time format: <days>-<hours>:<minutes>

# set up the environment
source /usr/local/anaconda3/bin/activate keras-frcnn

# command
python3 test_frcnn.py -p ../data/test_data --network vgg --write --load models/vgg/boosted.hdf5

# deactivate env
conda deactivate
