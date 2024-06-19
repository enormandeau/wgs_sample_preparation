#!/bin/bash

# Replace read group tag in both header (@RG) AND reads by sample ID
# Unique RG tags for *reads* are required by some SV callers (e.g. lumpy/smoove)

# ls -1 09_no_overlap/*.bam | parallel -j 10 -k srun -p small -c 1 -J 10_replace_RG_{/.} -o 99_log_files/10_replace_RG_{/.}_%j.log /bin/sh 01_scripts/10_replace_RG.sh {} &


# /!\ WARNING /!\
# You may need to edit the perl command to keep the proper sample name


# VARIABLES
BAM=$1                                                           # path to original bam file
SAMPLE=$(basename -s '.bam' $BAM | perl -pe 's/_1\.trimmed.*//') # edit perl command to keep only the string corresponding to sample ID
CPU=1                                                            # number of threads to use, 1 is enough
REHEADER_DIR="10_reheader_RG"                                    # output directory for corrected bam files

# LOAD REQUIRED MODULES
module load samtools/1.15 # Recent version is required for the -w option to work and overwrite existing RG in the header (1.15.1 on superdome)

# 0. Create new directory for edited bam files if required
if [[ ! -d $REHEADER_DIR ]]
then
  mkdir $REHEADER_DIR
fi

# 1. addreplacerg
## the \t after @RG is mandatory ! Otherwise it is not recognized by addreplacerg
## overwritting is not implemented yet.. even with overwrite_all option, so the RG tag must be different from the RG tag in the header
NEW_TAG=$(echo -e "@RG\tID:"$SAMPLE"\tPG:samtools addreplacerg\tSM:"$SAMPLE"")

samtools addreplacerg -m overwrite_all -r "$NEW_TAG" -O BAM -o $REHEADER_DIR/"$SAMPLE".bam -w --threads $CPU $BAM

# 2. Index resulting bam files (.bai)
samtools index $REHEADER_DIR/"$SAMPLE".bam
    
