# UVM

This directory contains the complete UVM verification environment developed for the APB-UART peripheral.

The environment is organized into separate folders based on the functionality of each verification component.

## Directory Organization

| Folder | Description |
|--------|-------------|
| **agent/** | APB and UART components including driver, sequencer, monitor, agent, scoreboard, coverage, and environment. |
| **interfaces/** | APB and UART SystemVerilog interfaces used to connect the DUT with the UVM environment. |
| **transactions/** | Transaction classes representing APB and UART protocol packets. |
| **sequences/** | Directed, constrained-random, and regression sequences used to verify UART functionality. |
| **tests/** | UVM test classes responsible for configuring and executing verification scenarios. |

## Verification Features

- APB Master Agent
- Passive UART Monitor
- Functional Scoreboards
- Functional Coverage Collection
- Constrained Random Verification
- Protocol Assertions
- Regression Test Support
- Coverage-Driven Verification
