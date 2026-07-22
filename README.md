# APB-UART UVM Verification

A complete Universal Verification Methodology (UVM) based verification environment for an APB-connected UART controller. This project verifies the APB register interface, UART transmit functionality, FIFO behavior, interrupt generation, baud-rate configuration, and frame-format programming using constrained-random verification, scoreboards, protocol monitors, and functional coverage.

---

# Project Overview

This project implements a reusable UVM verification environment for an APB UART peripheral.

The verification environment validates:

- APB protocol compliance
- UART transmit (TX) functionality
- UART register programming
- FIFO operation
- Interrupt generation
- Baud-rate programming
- Frame configuration
- Functional coverage
- End-to-end data integrity

The DUT is based on the open-source APB UART implementation from the PULP Platform.

---

# Verification Features

## APB Verification

- APB Master Driver
- APB Monitor
- APB Sequencer
- APB Agent
- APB Scoreboard
- APB Functional Coverage

### Verified Operations

- Register Writes
- Register Reads
- Back-to-Back Transfers
- Random APB Transactions
- DLAB Access Verification
- LCR Programming
- FIFO Register Verification
- Interrupt Register Verification
- Status Register Verification

---

## UART Verification

- UART Monitor
- UART Scoreboard
- UART Functional Coverage
- Frame Configuration Verification

### Verified Features

-Frame Configuration
- Parity Modes
-Stop Bits
-UART Features
- Baud Rate Configuration
- FIFO Enable/Disable
- FIFO Fill & Empty Verification
- Interrupt Generation
- Random Frame Transmission
- TX Stress Testing
- RX Status Monitoring

---

# UVM Test Sequences

## APB Sequences

- APB Write Sequence
- APB Read Sequence
- Write-Read Sequence
- Random Transaction Sequence
- LCR Configuration Sequence
- FIFO Control Sequence
- Baud Rate Programming Sequence
- DLAB Access Sequence
- Interrupt Verification Sequence
- LSR Status Sequence
- Coverage Closure Sequence
- Regression Sequence

---

## UART Sequences

- UART Frame Configuration Sequence
- UART Random Frame Sequence
- UART FIFO Fill & Empty Sequence
- UART Interrupt Sequence
- UART LCR Exhaustive Sweep
- UART Baud Sweep
- UART TX Stress Sequence
- UART RX Stress Sequence
- UART Regression Sequence

---

# Verification Components

### APB Environment

- APB Driver
- APB Monitor
- APB Sequencer
- APB Agent
- APB Scoreboard
- APB Coverage Collector

### UART Environment

- UART Monitor
- UART Scoreboard
- UART Coverage Collector

---

# Functional Coverage

The functional coverage model includes:

### UART Coverage

- Data Width
- Parity Enable
- Stop Bits
- Data Patterns
- Start Bit
- Stop Bit
- Interrupt Events
- Configuration Cross Coverage

### APB Coverage

- Register Address Coverage
- Read Operations
- Write Operations
- Register Access Patterns
- Transaction Types

---

# Verification Methodology

The verification environment follows the Universal Verification Methodology (UVM) and incorporates:

- Constrained Random Verification
- Functional Coverage
- Transaction-Level Scoreboarding
- Passive Protocol Monitoring
- Regression Testing
- Coverage-Driven Verification

---

# Final Coverage Results

APB Functional Coverage - 96.61%
UART Functional Coverage- 76.82%
Overall Functional Coverage- 86.71%

Simulation completed successfully with:

- ✅ Zero UVM Errors
- ✅ Zero UVM Warnings
- ✅ Zero UVM Fatal Errors

---

# Project Limitations

The current verification environment focuses on comprehensive verification of the **APB interface** and the **UART Transmit (TX) datapath**.

### RTL / Verification Limitations

The APB-UART RTL does not provide an internal UART loopback mechanism, and the current verification environment does not include an active UART RX agent capable of driving serial data into the receiver.

Consequently, several receiver-side scenarios cannot be fully exercised, including:

- UART Receive (RX) datapath verification
- Parity Error Detection
- Framing Error Detection
- Break Condition Detection
- Continuous Serial RX Stream Verification
- Receiver Error Injection

Because these receiver-oriented features are not reachable within the current DUT and verification scope, a portion of the UART functional coverage remains intentionally uncovered.

Despite these RTL limitations, the implemented UVM environment provides comprehensive verification of:

- APB Register Interface
- UART Transmit Path
- FIFO Operation
- Frame Configuration
- Baud Rate Programming
- Interrupt Generation
- Constrained-Random APB Transactions
- Functional Coverage Collection
- End-to-End Transaction Checking

The achieved coverage therefore accurately reflects the verification scope of the implemented design rather than incomplete verification.

---

# Tools Used

- SystemVerilog
- UVM 1.2
- Xilinx Vivado 2025.2
- XSim Simulator

---

# Simulation Flow

1. Compile RTL and UVM Environment
2. Elaborate Design
3. Execute Regression Tests
4. Collect Functional Coverage
5. Generate Coverage Report

---

# Future Improvements

Future extensions to the verification environment include:

- Active UART RX Agent
- Serial Line Driver
- UART Loopback Verification
- Receiver Error Injection
- Assertion-Based Verification (SVA)
- Extended Receiver Functional Coverage

---

# Acknowledgement

The UART RTL used in this project is based on the open-source **APB UART** implementation from the PULP Platform:

https://github.com/pulp-platform/apb_uart_sv

The complete UVM verification environment—including drivers, monitors, scoreboards, sequences, coverage model, regression tests, and verification infrastructure—was developed as part of this project.
