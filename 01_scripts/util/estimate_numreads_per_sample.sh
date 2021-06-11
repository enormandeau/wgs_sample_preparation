#!/bin/bash
# Estimate the number of reads in .fastq.gz and .bam file from a folder
#
# Usage:
#     <program> input_folder

# Global variables
input_folder="$1"
output_file=numreads_per_sample_"${input_folder%/}"
rm $output_file 
module load samtools

# Fastq files
for fastq in $(ls -1 "$input_folder"/*.fastq.gz)
do
    base=$(basename "$fastq")
    temp=."$base".deleteme

    # Extract last 10K of the first 100K reads
    gunzip -c "$fastq" | head -400000 | tail -40000 | gzip -c - > "$temp"
    size_subset=$(ls -l "$temp" | awk '{print $5}')
    size_full=$(ls -l "$fastq" | awk '{print $5}')
    numreads=$(echo 10000 $size_subset $size_full | awk '{print $1 * $3 / $2}')
    echo -e "$base\t$numreads"

    # Cleanup
    rm "$temp"
done | tee "$output_file"_fastq
[ -s "$output_file"_fastq ] ||  rm "$output_file"_fastq

# Bam files
for bamfile in $(ls -1 "$input_folder"/*.bam)
do
    base=$(basename "$bamfile")
    temp=."$base".deleteme

    # Extract last 10K of the first 100K reads
    samtools view -h "$bamfile" | head -100000 | samtools view -Sb - > "$temp"
    size_subset=$(ls -l "$temp" | awk '{print $5}')
    size_full=$(ls -l "$bamfile" | awk '{print $5}')
    numreads=$(echo 100000 $size_subset $size_full | awk '{print $1 * $3 / $2}')
    echo -e "$base\t$numreads"

    # Cleanup
    rm "$temp"
done | tee "$output_file"_bam
[ -s "$output_file"_bam ] || rm "$output_file"_bam
