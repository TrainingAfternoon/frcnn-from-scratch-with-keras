#!/bin/bash

#SBATCH --job-name='baseline'
#SBATCH --partition=teaching
#SBATCH --nodes=1
#SBATCH --gpus=4
#SBATCH --cpus-per-gpu=16
#SBATCH --time=2-0:0
#SBATCH --account=undergrad_research
# time format: <days>-<hours>:<minutes>

# set up the environment
source /usr/local/anaconda3/bin/activate keras-frcnn

# command
python3 train_frcnn.py --network vgg -o simple -p annotations-no-sig.csv --elen 360 --hf false

# deactivate env
conda deactivate
