# Ring Oscillator Based Physically Unclonable Function (RO-PUF)

This project implements a Ring Oscillator (RO) based Physically Unclonable Function (PUF) on the Intel Max 10 FPGA as part of Project 1 for Advanced Digital Systems Design course.

## Table of Contents
- [Overview](#overview)
- [What is a PUF?](#what-is-a-puf)
- [Ring Oscillator PUF Design](#ring-oscillator-puf-design)
- [Hardware Requirements](#hardware-requirements)
- [Project Structure](#project-structure)
- [Implementation Details](#implementation-details)
- [Usage](#usage)
- [References](#references)

## Overview

A Physically Unclonable Function (PUF) is a hardware security primitive that exploits manufacturing process variations to create unique device identifiers. This project implements a Ring Oscillator based PUF on the Intel Max 10 FPGA, demonstrating the principles of hardware security and unique device identification.

## What is a PUF?

A Physically Unclonable Function (PUF) is a physical entity that:
- Produces a unique response to a given challenge (challenge-response pair)
- Is practically impossible to clone due to inherent manufacturing variations
- Provides hardware-level security for device authentication and key generation
- Is resistant to physical attacks and tampering

PUFs are used in various security applications including:
- Device authentication
- Secure key storage and generation
- Anti-counterfeiting
- Hardware-based cryptographic operations

## Ring Oscillator PUF Design

Ring Oscillator PUFs exploit the subtle frequency variations in ring oscillators caused by manufacturing process variations. The basic principle:

1. **Ring Oscillator**: A chain of an odd number of inverters connected in a loop, creating an oscillating signal
2. **Process Variations**: Manufacturing imperfections cause each RO to oscillate at a slightly different frequency
3. **Frequency Comparison**: By comparing frequencies of different ROs, unique device signatures are generated
4. **Challenge-Response**: Selecting different pairs of ROs to compare generates different responses

### Key Advantages
- Simple hardware implementation
- Relatively stable across temperature and voltage variations
- Large number of possible challenge-response pairs
- Non-destructive readout

## Hardware Requirements

- **FPGA Board**: Intel Max 10 FPGA Development Board
- **Development Tools**: Intel Quartus Prime (for synthesis and implementation)
- **Programming Interface**: USB Blaster or equivalent JTAG programmer

## Project Structure

```
ads-ro-puf/
├── README.md           # This file
└── [Design files to be added]
```

## Implementation Details

The RO-PUF implementation includes:

1. **Ring Oscillator Array**: Multiple RO circuits instantiated on the FPGA
2. **Frequency Counters**: Measure oscillation frequencies over a fixed time period
3. **Comparator Logic**: Compare frequencies to generate response bits
4. **Challenge Selection**: Multiplexers to select which RO pairs to compare
5. **Response Generation**: Generate unique binary responses based on comparisons

### Design Considerations
- Number of ring oscillators
- Number of stages per ring oscillator
- Counter resolution and measurement period
- Response bit stability and reliability
- Temperature and voltage compensation techniques

## Usage

### Building the Project
1. Open the project in Intel Quartus Prime
2. Compile the design
3. Program the Max 10 FPGA board

### Testing the PUF
1. Apply different challenges (RO pair selections)
2. Measure and record responses
3. Analyze stability and uniqueness metrics

### Evaluation Metrics
- **Uniqueness**: Inter-chip Hamming distance
- **Reliability**: Intra-chip Hamming distance over multiple measurements
- **Uniformity**: Distribution of 0s and 1s in responses
- **Bit-aliasing**: Independence of response bits

## References

1. Suh, G. E., & Devadas, S. (2007). "Physical Unclonable Functions for Device Authentication and Secret Key Generation"
2. Maes, R. (2013). "Physically Unclonable Functions: Constructions, Properties and Applications"
3. Gassend, B., et al. (2002). "Silicon Physical Random Functions"
4. Herder, C., et al. (2014). "Physical Unclonable Functions and Applications: A Tutorial"

---

**Course**: Advanced Digital Systems Design  
**Project**: Project 1 - PUF Implementation  
**Target Hardware**: Intel Max 10 FPGA
