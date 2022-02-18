#!/bin/bash
# Re header all bam files to contain sample name

# /!\ WARNING /!\
# You may need to edit the perl command to keep the proper sample name

for i in $(ls -1 *.bam | grep -v "\.reheader\.bam")
do echo "$i"
    sample=$(echo "$i" | perl -pe 's/_1\.trimmed.*//')
    echo "$sample"
    samtools view -H "$i" | sed "s/ind/$sample/g" | samtools reheader - "$i" > "${i%.bam}".reheader.bam
    samtools index "${i%.bam}".reheader.bam

    # Alternative (longer ?)
    # samtools addreplacerg -r "ID:asdf" -o ...
done
