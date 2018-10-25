#!/bin/bash
# 6 CPUs
# 10 Go

# trim input files in 04_raw_data with fastp
# No need to parallelize more, using 6 CPUs makes fastp really fast

# WARNING: File name formats may require changing code below

# Iterate over files in data folder
for file in $(ls -1 04_raw_data/*_R1*.gz)
do
    input_file=$(echo "$file" | perl -pe 's/_R1.*\.fastq.gz//')
    output_file=$(basename "$input_file")
    echo "Treating: $output_file"

    fastp -w 6 \
        -i "$input_file"_R1.fastq.gz \
        -I "$input_file"_R2.fastq.gz \
        -o 05_trimmed/"$output_file"_1.trimmed.fastq.gz \
        -O 05_trimmed/"$output_file"_2.trimmed.fastq.gz \
        -j 05_trimmed/01_reports/"$output_file".json \
        -h 05_trimmed/01_reports/"$output_file".html
done
