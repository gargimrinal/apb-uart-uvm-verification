# Testbench

This directory contains the top-level simulation testbench for the APB-UART verification environment.

## Contents

- **tb_top.sv** – Instantiates the DUT, APB/UART interfaces, clock and reset generators, protocol assertions, and launches the UVM test using `run_test()`.

## Responsibilities

- Instantiate the APB-UART DUT
- Generate clock and reset
- Connect APB and UART interfaces
- Configure virtual interfaces for UVM
- Instantiate protocol assertions
- Start the UVM verification environment
