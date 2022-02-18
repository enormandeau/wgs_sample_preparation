#!/bin/bash
# 10 CPU
# 100 Go

# Global variables
BAMINDEX="/home/eric/Software/picard-tools-1.119/BuildBamIndex.jar"
DEDUPFOLDER="07_deduplicated"

# Load needed modules
module load java/jdk/1.8.0_102

# Copy script to log folder
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT="$0"
NAME="$(basename $0)"
LOG_FOLDER="99_log_files"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

# Build Bam Index
#ls -1 "$DEDUPFOLDER"/*.dedup.bam |
#while read file
#do
#    java -jar "$BAMINDEX" INPUT="$file"
#done

# Build Bam Index in parallel
ls -1 "$DEDUPFOLDER"/*.dedup.bam |
    parallel -j 10 java -jar "$BAMINDEX" INPUT={}
