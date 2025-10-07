# ads-ro-puf

## Abstract
For Project 1 of Advanced Digital Systems Design, we create a Physically Un-cloneable Function (PUF) with Ring Oscillators on the Max 10 FPGA.

A PUF is essentially a Random Number Generator that relies on variations in silicon processes due to nano-scale imperfections for its source of natural randomness.

Hardware Description is written in VHDL 1993, and synthesized for Max 10 using Intel Quartus Prime.
Ring Oscillator circuit simulations are written in ngpsice and simulated using `ngspice`. 

## Introduction
- Motivation
- Background: PUFs, ring oscillators, hardware security
- Related Work

## Design & Implementation
### Ring Oscillator PUF Concept
- Explain RO-PUF operation
- Diagrams (Markdown image links)

### Spice Simulation
- Setup (software, parameters, etc.)
- Results: frequency variation, randomness tests
- Graphs (exported from simulation and referenced in Markdown)

### VHDL FPGA Implementation
- Target FPGA and design flow
- RTL structure (use code blocks for snippets)
- Testbench and validation results

## Results & Analysis
- Compare simulation and FPGA results
- Statistical properties of the PUF
- Challenges and observations

## Conclusion
- Summary of achievements
- Potential improvements
- Applications

## References
- Any papers, manuals, and software used
