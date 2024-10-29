#!/bin/bash
#SBATCH --partition=general
#SBATCH --time=1-21:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=100G
#SBATCH --job-name=2024_10_129_01_combine_raw_data
#SBATCH --output=2024_10_129_01_combine_raw_data_%A-%a.out

srun cd $(pwd)

conda activate scell-rna

Rscript 02_StandardWorkFlow.R