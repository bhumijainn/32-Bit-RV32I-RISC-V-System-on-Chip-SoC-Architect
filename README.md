# 32-Bit RV32I Pipelined RISC-V System-on-Chip (SoC)

## Overview
This repository contains the complete RTL (Register-Transfer Level) implementation of a fully functional 32-bit RISC-V processor core, upgraded into a true System-on-Chip (SoC). Written in standard Verilog, the core implements the RV32I Base Integer Instruction Set and features a classic 5-stage synchronous pipeline with robust hazard detection, data forwarding, and integrated Memory-Mapped I/O (MMIO) for external communication.

This project was developed to deepen expertise in advanced digital circuits, embedded systems architecture, and signal integrity within FPGA development environments.

## Key Features
* **Core Architecture:** 32-bit RISC-V (RV32I Base ISA).
* **5-Stage Pipeline:** Instruction Fetch (IF), Decode (ID), Execute (EX), Memory (MEM), and Write-Back (WB).
* **Advanced Hazard Resolution:**
    * **Forwarding Unit:** Dynamically resolves EX-stage and MEM-stage Read-After-Write (RAW) data hazards via internal multiplexing, preventing unnecessary stalls.
    * **Hazard Detection Unit:** Detects Load-Use hazards and automatically injects pipeline bubbles to maintain data integrity.
    * **Internal Register Bypassing:** Resolves simultaneous Read/Write collisions in the WB-to-ID stages.
* **Embedded System Communication (UART):**
    * Custom asynchronous UART peripheral (Transmitter & Receiver state machines).
    * Synchronized to parameterized clock divisions/baud rates.
    * Interfaced directly to the CPU Datapath via Memory-Mapped I/O (mapped to `0x8000`).
* **Design & Verification:** Designed in Verilog-2001 and rigorously validated using Xilinx Vivado behavioral testbenches to ensure cycle-accurate execution.

## Datapath & Modules

The system is isolated into distinct stages separated by synchronous pipeline registers, ensuring smooth concurrent instruction execution:

* **`riscv_top_pipelined.v`**: The master Top-Level module that routes the datapath, MMIO, and hazard units.
* **ALU & Control (`alu.v`, `control_unit.v`)**: Handles arithmetic operations and generates pipeline control signals.
* **Memory (`inst_mem.v`, `data_mem.v`)**: Byte-addressed, word-aligned Instruction ROM and Data RAM.
* **Hazard Logic (`hazard_unit.v`, `forwarding_unit.v`)**: The intelligence layer preventing data corruption.
* **Peripherals (`uart_tx.v`, `uart_rx.v`)**: Serial communication interfaces enabling CPU-to-external-world data transfer.

## Skills Demonstrated 
* **FPGA RTL Design:** Verilog HDL, synchronous datapath routing, state machine design.
* **EDA Tools:** Synthesis and simulation using **Xilinx Vivado**.
* **Digital Circuits:** Pipeline register isolation, clock-cycle timing constraints, multiplexer routing.
* **Communication Protocols:** Hardware-level implementation of **UART** (Start, Data, Stop bit sequencing).
* **Embedded Systems:** System-on-Chip integration via MMIO address decoding.

## How to Simulate (Xilinx Vivado)

1.  Clone this repository to your local machine.
2.  Open **Xilinx Vivado** and create a new RTL Project.
3.  Add all files from the `Design Sources` folder to your project.
4.  Add all testbench files to your `Simulation Sources`.
5.  Set `tb_soc_final.v` as your Top Simulation Source.
6.  Click **Run Simulation** -> **Run Behavioral Simulation**.
7.  *Note on UART Verification:* Ensure the simulation runs for at least `1500ns` to view the complete UART transmission sequence. Zoom into the waveform to observe the `tx_out` pin pulsing the binary data sequence!

## Future Scope
* Implementation of Branch Prediction and Control Hazard Flushing (`BEQ`, `BNE`, `JAL`).
* Integration of additional communication protocols (SPI, I2C, CAN).
* Hardware interface layers for motor drivers (BLDC, stepper) for robotics applications.
