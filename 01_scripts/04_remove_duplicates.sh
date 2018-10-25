#!/bin/bash
# 1 CPU
# 30 Go

# Global variables
MARKDUPS="/prg/picard-tools/1.119/MarkDuplicates.jar"
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
ls -1 "$ALIGNEDFOLDER"/*.bam |
while read file
do
    java -jar "$MARKDUPS" \
        INPUT="$file" \
        OUTPUT="$DEDUPFOLDER"/$(basename "$file" .trimmed.sorted.bam).dedup.bam \
        METRICS_FILE="$METRICSFOLDER"/metrics.txt \
        VALIDATION_STRINGENCY=SILENT \
        REMOVE_DUPLICATES=true
done
