#!/bin/bash
# Rename samples using a tab-separated correspondance file
#
# Usage:
#   <program> input_folder output_folder correspondance_file
#
# Correspondance file format:
# 
# original_file_name<tab>wanted_file_name
# original_file_name     wanted_file_name
# original_file_name     wanted_file_name
# original_file_name     wanted_file_name
# original_file_name     wanted_file_name

# Global variables
input_folder="$1"
output_folder="$2"
correspondance_file="$3"

# Confirm that input folder, output folder, and correspondance file all exist
if [[ ! -d "$input_folder" || ! -d "$output_folder" || ! -e "$correspondance_file" ]]
then
    echo "Usage:"
    echo "    <program> input_folder output_folder correspondance_file"
fi

# Rename each file using "ln"
cat "$correspondance_file" |
while read correspondance
do
    from=$(echo "$correspondance" | cut -f 1)
    to=$(echo "$correspondance" | cut -f 2)
    ln "$input_folder"/"$from" "$output_folder"/"$to"
done
