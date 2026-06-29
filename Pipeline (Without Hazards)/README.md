# RISC-V 32-bit Pipelined Processor (Without Hazard Handling)

This folder contains the Verilog implementation of a **32-bit RISC-V Pipelined Processor** based on the standard **5-stage pipeline architecture**. This design is a pipelined extension of the Advanced Single-Cycle Processor and supports the same instruction set. Hazard handling (data, control, and structural hazards) is **not implemented** in this version, making it suitable for understanding the basic pipelined datapath and its operation.

## Supported Instructions

### R-Type

* `add`
* `sub`
* `xor`
* `or`
* `and`
* `sll`
* `srl`
* `slt`

### I-Type

* `addi`
* `xori`
* `ori`
* `andi`

### Load/Store

* `lw`
* `sw`

### Branch

* `beq`
* `bne`
* `blt`
* `bge`

### Jump

* `jal`
* `jalr`

## Pipeline Stages

The processor implements the standard 5-stage RISC-V pipeline:

1. **IF** – Instruction Fetch
2. **ID** – Instruction Decode / Register Read
3. **EX** – Execute / ALU Operations
4. **MEM** – Data Memory Access
5. **WB** – Register Write Back

## How to Simulate the Design

Install **Icarus Verilog** and **GTKWave** on your machine, then execute the following commands:

```bash
iverilog -o simv *.v
vvp simv
gtkwave waveform.vcd
```
