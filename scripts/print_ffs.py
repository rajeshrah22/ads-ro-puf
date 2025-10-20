#!/bin/python3

import sys
import os
import glob
import calculate_frequencies

# Assumption:
#   you have all-1_2V-13_5C.csv  all-1_2V-27C.csv  all-1_2V-54C.csv  all-1_5V-27C.csv  all-1V-27C.csv
#   in your input directory!

def main():
    if len(sys.argv) < 2:
        print("usage: python3 calculate_frequencies.py <input-dir>")
        sys.exit(1)
    input_dir = os.path.join(sys.argv[1])

    input_files = ["all-1_2V-13_5C.csv", "all-1_2V-27C.csv", "all-1_2V-54C.csv", "all-1_5V-27C.csv", "all-1V-27C.csv"]

    volts = [1.2, 1.2, 1.2, 1.5, 1.0]

    for i in range(len(input_files)):
        file_path = os.path.join(input_dir, input_files[i])
        print(file_path)
        calculate_frequencies.print_fundamental_frequencies(file_path)
        print("=============================")

if __name__ == "__main__":
    main()
