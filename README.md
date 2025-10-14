# Ring Oscillator Based Physically Unclonable Function (RO-PUF)

For Project 1 of Advanced Digital Systems Design, this project implements a Physically Unclonable Function (PUF) using Ring Oscillators on the Intel Max 10 FPGA.

A PUF is essentially a hardware-based random number generator that relies on variations in silicon manufacturing processes due to nano-scale imperfections for its source of natural randomness. Each FPGA chip will produce unique responses due to inherent process variations, making it ideal for device authentication and cryptographic key generation.

## Table of Contents
- [Overview](#overview)
- [Project Structure](#project-structure)
- [Hardware Implementation](#hardware-implementation)
- [SPICE Simulation](#spice-simulation)
- [Python Scripts](#python-scripts)
- [Building and Running](#building-and-running)
- [Results](#results)
- [Requirements](#requirements)

## Overview

This project consists of three main components:

1. **VHDL Hardware Design**: Complete FPGA implementation targeting Intel Max 10
2. **SPICE Simulations**: Circuit-level simulations of ring oscillators with process variations
3. **Analysis Scripts**: Python tools for generating circuits, analyzing frequencies, and visualizing results

### How It Works

Ring Oscillator PUFs exploit subtle frequency variations in oscillating circuits caused by manufacturing process variations:

1. Multiple ring oscillators are instantiated on the FPGA (default: 16 oscillators)
2. Each ring oscillator consists of an odd number of inverters in a feedback loop (default: 13 stages)
3. Manufacturing variations cause each RO to oscillate at a slightly different frequency
4. A challenge selects pairs of ROs to compare
5. Frequency counters measure oscillations over a fixed time period
6. The RO with the higher frequency determines the response bit (0 or 1)
7. Different challenges generate different response bits, creating a unique signature

## Project Structure

```
ads-ro-puf/
├── vhdl/                           # VHDL hardware description files
│   ├── toplevel.vhd               # Top-level entity integrating all components
│   ├── ro_puf.vhd                 # RO-PUF core logic with counters and comparators
│   ├── ring_oscillator.vhd        # Individual ring oscillator implementation
│   ├── control_unit.vhd           # FSM for challenge generation and response collection
│   ├── project_pkg.vhd            # Package with shared types and functions
│   ├── toplevel.qpf               # Quartus project file
│   ├── toplevel.qsf               # Quartus settings file
│   ├── connect_pins.tcl           # TCL script for pin assignments
│   ├── place_inverters.tcl        # TCL script for placement constraints
│   ├── read_memory.tcl            # TCL script for reading memory contents
│   └── memdump/                   # Memory initialization files (MIF)
│       └── memory_contents_*.mif  # Response storage for different challenges
│
├── spice/                          # SPICE circuit simulations
│   ├── inverter.sp                # Inverter subcircuit with process variation parameters
│   ├── nand.cir                   # NAND gate subcircuit
│   ├── ring_oscillator_*.cir      # Generated RO circuits (8 variants with variations)
│   └── run_oscillators.cir        # Main simulation testbench
│
├── scripts/                        # Python analysis and generation scripts
│   ├── gen_ring_oscillator.py     # Generates SPICE ring oscillator circuits with Gaussian process variations
│   ├── gen_oscillator.cpp         # C++ alternative for circuit generation
│   ├── calculate_frequencies.py   # FFT-based frequency analysis from simulation data
│   ├── plot_simulation.py         # Visualization of oscillator waveforms and frequency spectra
│   └── run_calculations.py        # Batch processing script
│
├── results/                        # Simulation results and plots
│   └── first-run/                 # Initial simulation data
│       ├── plot_*.svg             # Frequency spectrum plots at various conditions
│       └── plot_54c.ps            # PostScript output
│
├── .gitignore                      # Git ignore patterns for build artifacts
└── README.md                       # This file
```

## Hardware Implementation

### VHDL Components

#### Ring Oscillator (`ring_oscillator.vhd`)
- Configurable chain of inverters (default 13 stages, must be odd)
- Enable control via NAND gate for power management
- Placement constraints to prevent optimization
- Generates free-running oscillation when enabled

#### RO-PUF Core (`ro_puf.vhd`)
- Instantiates array of ring oscillators (default 16)
- Frequency counters for each oscillator (16-bit counters)
- Challenge decoder to select RO pairs for comparison
- Comparator logic to generate response bit
- Supports power-of-2 RO counts for efficient multiplexing

#### Control Unit (`control_unit.vhd`)
- Finite State Machine (FSM) for orchestrating operation
- Generates sequential challenges automatically
- Configurable measurement period (default 10 microseconds)
- Response storage control signals
- Status output (done signal)

#### Top Level (`toplevel.vhd`)
- Integrates RO-PUF core, control unit, and memory
- Generic parameters for customization:
  - `ro_length`: Number of inverter stages (default 13)
  - `ro_count`: Number of ring oscillators (default 16)
- BRAM integration for response storage
- Clock and reset management

### Synthesis Details

- **Target Device**: Intel Max 10 FPGA
- **Tools**: Intel Quartus Prime
- **HDL Standard**: VHDL-1993
- **Clock Frequency**: 200 MHz (configurable)
- **Measurement Period**: 10 μs per challenge (configurable)

## SPICE Simulation

The SPICE simulations model ring oscillators with realistic process variations to validate the PUF concept before FPGA implementation.

### Circuit Components

- **Inverter Cell** (`inverter.sp`): Parameterized with 6 process variation factors:
  - `tplv`: PMOS channel length variation
  - `tpwv`: PMOS channel width variation
  - `tnln`: NMOS channel length variation
  - `tnwn`: NMOS channel width variation
  - `tpotv`: PMOS threshold voltage variation
  - `tnotv`: NMOS threshold voltage variation

- **NAND Gate** (`nand.cir`): Enable control for ring oscillators

- **Ring Oscillators** (`ring_oscillator_*.cir`): Generated with randomized process variations following Gaussian distribution (σ=6.5%, clamped to ±15%)

### Running Simulations

Simulations use **ngspice** circuit simulator:

```bash
cd spice
ngspice run_oscillators.cir
```

The simulation generates time-domain waveforms for 8 different ring oscillators, each with unique process variations.

## Python Scripts

### Circuit Generation

**`gen_ring_oscillator.py`**: Generates SPICE netlists for ring oscillators with statistical process variations

```bash
./scripts/gen_ring_oscillator.py spice
```

- Uses Gaussian distribution for process parameter variation
- Mean = 1.0, σ = 0.065 (6.5%) for transistor dimensions
- Mean = 1.0, σ = 0.05 (5%) for threshold voltages
- Values clamped to prevent unrealistic variations

### Frequency Analysis

**`calculate_frequencies.py`**: Analyzes simulation output using Fast Fourier Transform (FFT)

- Reads time-domain waveforms from ngspice output
- Applies FFT to extract fundamental frequencies
- Identifies dominant frequency component for each oscillator
- Outputs frequency measurements for PUF characterization

**`plot_simulation.py`**: Visualization tools for simulation data

- Time-domain waveform plots
- Frequency spectrum analysis
- Comparative plots across different operating conditions

### Results Processing

**`run_calculations.py`**: Batch processing for multiple simulation runs

## Building and Running

### FPGA Implementation

1. **Open Project in Quartus**:
   ```bash
   quartus toplevel.qpf
   ```

2. **Configure Parameters** (optional):
   Edit `toplevel.vhd` to modify generics:
   - Number of ring oscillators
   - Inverter chain length
   - Clock frequency

3. **Compile Design**:
   - Analysis & Synthesis
   - Fitter (Place & Route)
   - Assembler (Generate Programming File)

4. **Program FPGA**:
   - Connect USB Blaster
   - Use Quartus Programmer to load `.sof` file

5. **Extract Responses**:
   - Use `read_memory.tcl` to retrieve stored PUF responses from BRAM

### SPICE Simulation Workflow

1. **Generate Ring Oscillator Circuits**:
   ```bash
   ./scripts/gen_ring_oscillator.py spice
   ```

2. **Run Simulation**:
   ```bash
   cd spice
   ngspice run_oscillators.cir
   ```

3. **Analyze Results**:
   ```bash
   ./scripts/calculate_frequencies.py results/simulation_output.txt
   ./scripts/plot_simulation.py results/simulation_output.txt
   ```

## Results

The `results/first-run/` directory contains frequency spectrum plots from initial SPICE simulations:

- **`plot_1v.svg`**: Analysis at 1.0V supply
- **`plot_1_5v.svg`**: Analysis at 1.5V supply  
- **`plot_13.5c.svg`**: Analysis at 13.5°C
- **`plot_27c.svg`**: Analysis at 27°C
- **`plot_54c.svg`**: Analysis at 54°C

These plots demonstrate:
- Unique frequency signatures for each ring oscillator
- Frequency variations due to process variations
- Temperature and voltage sensitivity analysis

## Requirements

### Hardware
- Intel Max 10 FPGA Development Board
- USB Blaster or compatible JTAG programmer

### Software
- **Intel Quartus Prime** (for FPGA synthesis and programming)
- **ngspice** (for circuit simulation)
- **Python 3.x** with libraries:
  - `numpy` - Numerical computing
  - `matplotlib` - Plotting and visualization
  - Standard library modules: `os`, `sys`, `random`, `math`

### Installation

**ngspice** (Ubuntu/Debian):
```bash
sudo apt-get install ngspice
```

**Python dependencies**:
```bash
pip install numpy matplotlib
```

## Technical Background

### PUF Properties
- **Uniqueness**: Different chips produce different responses (inter-chip variation)
- **Reliability**: Same chip produces consistent responses (intra-chip stability)  
- **Unpredictability**: Responses are difficult to predict or clone
- **Tamper Evidence**: Physical attacks alter PUF characteristics

### Design Parameters
- **Challenge Space**: With 16 ROs and pair selection, supports 2^8 = 256 unique challenges
- **Response Bits**: One bit per challenge measurement
- **Counter Resolution**: 16-bit counters provide fine-grained frequency discrimination
- **Measurement Time**: 10 μs measurement period balances accuracy and speed

## References

1. Suh, G. E., & Devadas, S. (2007). "Physical Unclonable Functions for Device Authentication and Secret Key Generation"
2. Maes, R. (2013). "Physically Unclonable Functions: Constructions, Properties and Applications"
3. Gassend, B., et al. (2002). "Silicon Physical Random Functions"

---

**Course**: Advanced Digital Systems Design  
**Project**: Project 1 - Ring Oscillator PUF Implementation  
**Target Hardware**: Intel Max 10 FPGA  
**HDL**: VHDL-1993  
**Simulator**: ngspice 
