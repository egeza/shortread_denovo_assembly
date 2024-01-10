#!/bin/bash
#SBATCH --job-name='shortreaddenovo_assembly'
#SBATCH --nodes=1 --ntasks=15
#SBATCH --partition=Main
#SBATCH --mem=100GB
#SBATCH --output=/cbio/projects/026/logs/short-read-denovo-assembly-%j-stdout.txt
#SBATCH --error=/cbio/projects/026/logs/short-read-denovo-assembly-%j-stderr.txt
#SBATCH --time=336:00:00
#SBATCH --mail-user=ephie.geza@uct.ac.za
#SBATCH --mail-type=FAIL


echo "Assmbly Started"

# Set important dirs
proj="/cbio/projects/026/"

module load  nextflow/23.04.4 

## REQUIRED FOR ABYSS
module load openmpi/4.1.5


cd /cbio/projects/026/shortread_denovo_assembly_pipeline/
nextflow run main.nf --datadir "/cbio/projects/026/data_1"  \
	--outdir "/cbio/projects/026/results/run1" \
	-config "/cbio/projects/026/shortread_denovo_assembly_pipeline/nextflow.config" \
	-profile singularity,ilifu -resume
