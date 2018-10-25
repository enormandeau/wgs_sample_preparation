#!/bin/bash
# WGS data preparation pipeline - main script
# Edit the scripts as needed

# Rename samples if needed
#01_scripts/00_rename_samples.sh

# Trim reads for quality
srun -c 6 -p medium --mem 10G 01_scripts/01_fastp.sh

# Align reads to reference
srun -c 4 -p medium --mem 10G 01_scripts/02_bwa_mem_align_reads_PE.sh

# Collect duplicat metrics
srun -c 1 -p medium --mem 10G 01_scripts/03_collect_metrics.sh

# Remove duplicates
srun -c 1 -p medium --mem 30G 01_scripts/04_remove_duplicates.sh

# Index bam files
srun -c 1 -p medium --mem 10G 01_scripts/05_gatk_index_bam.sh

# Index reference genome
srun -c 1 -p medium --mem 10G 01_scripts/06_gatk_dictionnary_reference.sh

# Find regions to re-align
srun -c 1 -p medium --mem 30G 01_scripts/07_gatk_realign_targets.sh

# Re-align around indels
srun -c 1 -p medium --mem 10G 01_scripts/08_gatk_realign_indel.sh

# Remove reads overlap
srun -c 1 -p medium --mem 10G 01_scripts/09_clip_overlap.sh
