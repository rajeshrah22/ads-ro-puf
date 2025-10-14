#!/bin/python3

def get_value_from_file(file):
    with open(file) as f:
        lines = f.readlines()

    in_content = False

    for line in lines:
        line = line.strip()
        if (not line or
            line.startswith("--") or
            "ADDRESS_RADIX" in line or
            "DATA_RADIX" in line or
            "WIDTH" in line
            "DEPTH" in line):
            continue

        if line.startswith("CONTENT BEGIN")
            in_content = True


def hamming_distance(a, b):
    return (a ^ b).bit_count()

def main():
    return 0

if __name__ == "__main__":
    main()
