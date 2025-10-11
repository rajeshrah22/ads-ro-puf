#!/bin/python3

import sys
import os
import glob
import calculate_frequencies

# Assumption:
#   you have all-1_2V-13_5C.csv  all-1_2V-27C.csv  all-1_2V-54C.csv  all-1_5V-27C.csv  all-1V-27C.csv
#   in your input directory!

def main():
    if len(sys.argv) < 3:
        print("usage: python3 plot_simulation.py <input-dir> <output-dir>")
        sys.exit(1)
    input_dir = os.path.join(sys.argv[1])
    output_dir = os.path.join(sys.argv[2])

    input_files = ["all-1_2V-13_5C.csv", "all-1_2V-27C.csv", "all-1_2V-54C.csv", "all-1_5V-27C.csv", "all-1V-27C.csv"]
    output_files = []
    for i in range(len(input_files)):
        output_files.append(input_files[i][:-3] + "-time.png")

    volts = [1.2, 1.2, 1.2, 1.5, 1.0]

    for i in range(len(input_files)):
        calculate_frequencies.save_plot_data(os.path.join(input_dir, input_files[i]), os.path.join(output_dir, output_files[i]))

if __name__ == "__main__":
    main()
