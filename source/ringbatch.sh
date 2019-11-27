#!/bin/bash
#SBATCH -J ring_batch
#SBATCH -o ringoutput.txt
#SBATCH -e ringerrors.txt
#SBATCH -t 00:10:00
#SBATCH -N 3
#
./ringtest
