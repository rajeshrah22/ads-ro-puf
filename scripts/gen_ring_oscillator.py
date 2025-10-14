#!/bin/python3

# Inspired by code from ChatGPT

import os
import random
import math
import sys

def guassian_clamped(mean, sigma, min_factor, max_factor):
    val = random.gauss(mean, sigma)
    return max(min(val, max_factor), min_factor)


def gen_ring_osc(num, file_dir_path, num_inv=12):
    subckt_name = f"ring_oscillator_{num}"
    filename = f"{subckt_name}.cir"
    path = os.path.join(file_dir_path, filename)

    with open(path, "w") as f:
        f.write(f"* {subckt_name}\n")
        f.write(f".subckt {subckt_name} en out\n")
        f.write(".include inverter.sp\n")
        f.write(".include nand.cir\n")

        f.write(f"XNAND en n0 n1 nand2x1\n")

        # Chain of inverters with random process variation
        for i in range(num_inv):
            tplv = guassian_clamped(1.0, 0.065, 0.85, 1.15)
            tpwv = guassian_clamped(1.0, 0.065, 0.85, 1.15)
            tnln = guassian_clamped(1.0, 0.065, 0.85, 1.15)
            tnwn = guassian_clamped(1.0, 0.065, 0.85, 1.15)
            tpotv = guassian_clamped(1.0, 0.05, 0.9, 1.1)
            tnotv = guassian_clamped(1.0, 0.05, 0.9, 1.1)
            f.write(f"XINV{i} n{i+1} n{i+2} inverter tplv={tplv:.4f} tpwv={tpwv:.4f} tnln={tnln:.4f} tnwn={tnwn:.4f} tpotv={tpotv:.4f} tnotv={tnotv:.4f}\n")

        # Close the loop: connect last inverter output back to NAND input
        f.write(f"XINV_LOOP n{num_inv+1} out inverter tplv=1 tpmv=1 tnln=1 tnwn=1 tpotv=1 tnotv=1\n")
        f.write(".ends\n")

    print(f"Generated {filename}")

def main():
    if len(sys.argv) < 2:
        print("Usage: ./gen_ring_oscillator.py <output_dir>")
        sys.exit(1)

    out_dir = sys.argv[1]
    if not os.path.exists(out_dir):
        print(f"Directory {out_dir} does not exist.")
        sys.exit(1)

    for i in range(8):
        gen_ring_osc(i, out_dir)

if __name__ == "__main__":
    main()
