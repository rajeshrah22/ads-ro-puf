#!/bin/python3

import sys
import glob
import matplotlib.pyplot as plt
from collections import Counter

def get_value_from_file(file):
    with open(file) as f:
        lines = f.readlines()

    num = 0

    for line in lines:
        line = line.strip(" ;\n")

        if line.startswith("["):
            inside, value = line.split("]  :")
            index_start, index_end = inside.strip("[").split("..")
        else:
            index_start, value = line.split(" :")
            index_end = None

        index_start = int(index_start, 16)
        value = int(value)
        num = num | (value << index_start)
        if not index_end is None:
            index_end = int(index_end, 16)
            for i in range(index_start + 1, index_end + 1):
                num = num | (value << i)

    return num


def hamming_distance(a, b):
    return (a ^ b).bit_count()


def get_hamming_distances(nums):
    hamming_distances = []
    for i in range(len(nums)):
        for j in range(i + 1, len(nums)):
            hamming_distances.append(hamming_distance(nums[i], nums[j]))

    return hamming_distances


def plot_hamming_distribution(hamming_distances):
    counts = Counter(hamming_distances)

    distances = sorted(counts.keys())
    frequencies = [counts[d] for d in distances]

    plt.figure(figsize=(8, 5))
    plt.bar(distances, frequencies, width=0.8, align='center', edgecolor='black')

    plt.xlabel("Hamming Distance")
    plt.ylabel("Frequency (unique pairs)")
    plt.title("Hamming Distance Distribution")
    plt.xticks(distances)
    plt.tight_layout()
    plt.show()


def main():
    if len(sys.argv) < 2:
        print("usage ./script <path_to_data>")

    path = sys.argv[1]
    num_array = []

    for file in glob.glob(path + "/memory_data_*.txt"):
        num_array.append(get_value_from_file(file))

    hamming_distances = get_hamming_distances(num_array)
    plot_hamming_distribution(hamming_distances)

if __name__ == "__main__":
    main()
