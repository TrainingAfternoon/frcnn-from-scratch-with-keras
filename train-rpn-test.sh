#!/bin/bash

#SBATCH --job-name='rpn train'
#SBATCH --partition=teaching
#SBATCH --nodes=1
#SBATCH --gpus=4
#SBATCH --cpus-per-gpu=16
#SBATCH --time=1-0:0
# time format: <days>-<hours>:<minutes>

# set up the environment
source /usr/local/anaconda3/bin/activate keras-frcnn

# command
python3 train_rpn.py --network vgg --num_epochs 1 -o simple -p annotations.csv

# deactivate env
conda deactivate
