#!/bin/bash
# 20 CPU
# 200 Go

# Global variables
GATK="/home/clrou103/00-soft/GATK/GenomeAnalysisTK.jar"
DEDUPFOLDER="07_deduplicated"
REALIGNFOLDER="08_realigned"
CLIPFOLDER="09_no_overlap"

# Copy script to log folder
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="99_log_files"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

ls "$REALIGNFOLDER"/*.bam | parallel -j 20 ./01_scripts/util/clip_overlap_one_file.sh {}
