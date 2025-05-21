#!/bin/bash

# First split sample list to align into different files with:
# cd 05_trimmed
# ls -1S *_1\.trimmed.fastq.gz > ../all_samples_for_alignment.txt
# cd ..
# mkdir samples_split
# split -a 4 -l 1 -d all_samples_for_alignment.txt samples_split/samples_split.

## With GNU Parallel
# ls -1 samples_split/* | parallel -k -j 10 ./01_scripts/02_bwa_mem_align_reads_PE_with_sample_file.sh 4 {}

## With GNU Parallel on SLURM
# ls -1 samples_split/* | parallel -k -j 10 srun -c 4 --mem 20G -p large --time 21-00:00 -J bwaMem -o 99_log_files/bwaMEMsplit_%j.log ./01_scripts/02_bwa_mem_align_reads_PE_with_sample_file.sh 4 {} \; sleep 0.1 &

## srun
# srun -c 4 --mem 20G -p large --time 21-00:00 -J bwaMem -o 10-log_files/bwaMEMsplit_%j.log ./00-scripts/bwa_mem_align_reads_by_n_samples.sh 4 <SAMPLE_FILE>

# Global variables
GENOMEFOLDER="03_genome"
GENOME="genome.fasta"
RAWDATAFOLDER="05_trimmed"
ALIGNEDFOLDER="06_aligned"
NCPU=$1
SAMPLE_FILE="$2"

# Test if user specified a number of CPUs
if [[ -z "$NCPU" ]]
then
    NCPU=4
fi

# Load needed modules
module load bwa
module load samtools

# Index genome if not alread done
#bwa index -p "$GENOMEFOLDER"/"$GENOME" "$GENOMEFOLDER"/"$GENOME"

# Iterate over sequence file pairs and map with bwa
cat "$SAMPLE_FILE" |
while read file
do
    # Name of uncompressed file
    file2=$(echo "$file" | perl -pe 's/_1\.trimmed/_2.trimmed/')
    echo
    echo "Aligning file $file $file2" 

    sample=$(basename -s '_1.trimmed.fastq.gz' "$file")
    name=$(basename "$file")
    name2=$(basename "$file2")
    
    # Format read group tag string with sample name
    ID=$(echo -e "@RG\tID:$sample\tSM:$sample\tPL:Illumina")

    echo "$name"
    echo "$name2"

    # If name and name2 are the same, file names were not parsed properly
    if [[ "$name" == "$name2" ]]
    then
        echo "ERROR: Forward and reverse files are the same"
        echo "-> Check file name parsing on line starting with 'file2='"
        echo
        exit 1
    fi

    # Align reads
    bwa mem -t "$NCPU" -R "$ID" "$GENOMEFOLDER"/"$GENOME" "$RAWDATAFOLDER"/"$name" "$RAWDATAFOLDER"/"$name2" |
    samtools view -Sb -q 10 - > "$ALIGNEDFOLDER"/"${name%.fastq.gz}".bam

    # Sort
    samtools sort --threads "$NCPU" "$ALIGNEDFOLDER"/"${name%.fastq.gz}".bam \
        > "$ALIGNEDFOLDER"/"${name%.fastq.gz}".sorted.bam

    # Index
    samtools index "$ALIGNEDFOLDER"/"${name%.fastq.gz}".sorted.bam

    # Remove unsorted bam file
    rm "$ALIGNEDFOLDER"/"${name%.fastq.gz}".bam
done
