#!/bin/bash
# 10 CPU
# 400 Go

# Global variables
MARKDUPS="/home/eric/Software/picard-tools-1.119/MarkDuplicates.jar"
ALIGNEDFOLDER="06_aligned"
DEDUPFOLDER="07_deduplicated"
METRICSFOLDER="98_metrics"

# Copy script to log folder
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="99_log_files"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

# Load needed modules
module load java/jdk/1.8.0_102

# Remove duplicates from bam alignments
#ls -1 "$ALIGNEDFOLDER"/*.bam |
#while read file
#do

# Remove duplicates from bam alignments in parallel
ls -1 "$ALIGNEDFOLDER"/*.bam |
    parallel -j 10 echo "Deduplicating sample {}" \; java -jar "$MARKDUPS" INPUT={} OUTPUT="$DEDUPFOLDER"/{/}.dedup.bam METRICS_FILE="$METRICSFOLDER"/metrics.txt VALIDATION_STRINGENCY=SILENT REMOVE_DUPLICATES=true MAX_FILE_HANDLES=200
#done
