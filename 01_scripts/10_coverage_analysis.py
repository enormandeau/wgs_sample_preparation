#!/usr/bin/env python
"""Extract useful coverage information from beagle file

Usage:
    <program> input_beagle output_stub window_size window_move [position_file]
"""

# Modules
import math
import gzip
import sys

# Functions
def myopen(_file, mode="rt"):
    if _file.endswith(".gz"):
        return gzip.open(_file, mode=mode)

    else:
        return open(_file, mode=mode)


# Parse user input
try:
    input_beagle = sys.argv[1]
    output_stub = sys.argv[2]
    window_size = int(sys.argv[3])
    window_move = int(sys.argv[4])
except:
    print(__doc__)
    sys.exit(1)

# Optional file with positions to treat
try:
    position_file = sys.argv[5]
    position_subseting = True

except:
    print("No position file")
    position_subseting = False

# Get wanted positions
if position_subseting:
    position_subset = set()
    print("Reading position file...")

    with myopen(position_file) as posfile:
        for line in posfile:
            scaffold, position = line.strip().split("\t")[:2]
            position_subset.add((scaffold, int(position)))

    print("  Done.")

# Create output files
output1 = myopen(output_stub + "_1.tsv.gz", "wt")
output1.write("#Scaffold\tposition\tmean\tsd\tminimum\tmaximum\ttotal\n")
output1.flush()

output2 = myopen(output_stub + "_2.tsv.gz", "wt")
output2.write("#Scaffold\tposition\tmean\tsd\tminimum\tmaximum\ttotal\tnum_positions\n")
output2.flush()

# Variables
window = []
window_offset = 0

# Read beagle file line by line
print("Reading beagle file to create summary files...")

with myopen(input_beagle) as infile:
    for line in infile:
        l = line.strip().split()
        scaffold, position = l[0:2]
        position = int(position)
        info = [int(x) for x in l[2:]]

        # Decide if we treat this position
        if position_subseting and not (scaffold, position) in position_subset:
            continue

        # Q1a: Gather stats
        total = sum(info)
        mean = total / len(info)
        minimum = min(info)
        maximum = max(info)
        sd = math.sqrt(sum([(x - mean)**2 for x in info]))

        # Q1a: Write coverage_summary
        coverage_summary = [scaffold, position, mean, sd, minimum, maximum, total]
        coverage_summary_line = "\t".join([str(x)[:6] for x in coverage_summary]) + "\n"
        output1.write(coverage_summary_line)

        # Q1b Gather coverage_summary info for sliding window
        if not window:
            window.append(coverage_summary)
            current_scaffold = scaffold

        # Create report and write to output2
        elif scaffold != current_scaffold or position >= window_offset + window_size:

            mean_mean = sum([x[2] for x in window]) / len(window)
            mean_sd = sum([x[3] for x in window]) / len(window)
            mean_minimum = sum([x[4] for x in window]) / len(window)
            mean_maximum = sum([x[5] for x in window]) / len(window)
            mean_total = sum([x[6] for x in window]) / len(window)
            num_positions = len(window)

            # Write sliding window report to output2
            window_summary = [scaffold, window_offset, mean_mean, mean_sd,
                    mean_minimum, mean_maximum, mean_total, num_positions]
            window_summary_line = "\t".join([str(x) for x in window_summary]) + "\n"
            output2.write(window_summary_line)
            output2.flush()

            # Increment
            if scaffold != current_scaffold:
                current_scaffold = scaffold
                window_offset = 0

                # Flush window and add new coverage_summary
                window = [coverage_summary]

            else:
                window_offset += window_move

                # Flush positions before current position
                window = [x for x in window if x[1] >= window_offset]
                window.append(coverage_summary)
                print(scaffold, window_offset, position, len(window))

        else:
            window.append(coverage_summary)

# Close file handles
output1.close()
output2.close()

print("  Done.")
