# RISC-V 32-bit Pipelined Processor with Forwarding and Hazard Detection

This folder contains the Verilog implementation of a **32-bit RISC-V Pipelined Processor** based on the standard **5-stage pipeline architecture**.

This version extends the previous pipelined processor(with reduced instructions) by implementing:

* **Data Forwarding Unit**
* **Hazard Detection Unit** (Load-Use Hazard)

The processor now correctly resolves most **Read-After-Write (RAW)** data hazards using forwarding, while automatically inserting a single pipeline bubble for load-use hazards that cannot be resolved through forwarding alone.




---

## Pipeline Stages

The processor follows the standard 5-stage pipeline:

1. **IF** – Instruction Fetch
2. **ID** – Instruction Decode / Register Read
3. **EX** – Execute / ALU Operations
4. **MEM** – Data Memory Access
5. **WB** – Register Write Back

---

# Forwarding Unit

A forwarding unit has been implemented to eliminate unnecessary pipeline stalls caused by ALU data dependencies.

The forwarding unit compares the source registers (`rs1`, `rs2`) of the instruction currently in the **Execute** stage with the destination registers (`rd`) of instructions present in the **Memory** and **Write-Back** stages.

If a dependency is detected:

* The result from the **EX/MEM** pipeline register is forwarded directly to the ALU inputs.
* If required, the value being written back from the **MEM/WB** stage is forwarded instead.

Forwarding multiplexers have been added before the ALU inputs, allowing the ALU to receive the most recent operand values without waiting for register write-back.

---

# Hazard Detection Unit

Forwarding alone cannot resolve the classic **load-use hazard**.

For example,

```assembly
lw  x2, 0(x1)
add x3, x2, x4
```

Since the loaded data becomes available only after the memory stage, the processor automatically inserts a **single bubble** into the pipeline.

The hazard detection unit:

* Detects when the instruction in the Execute stage is a load.
* Checks whether its destination register matches either source register of the instruction currently in Decode.
* Stalls the **Program Counter**.
* Stalls the **Fetch/Decode pipeline register**.
* Flushes the **Decode/Execute pipeline register**, thereby inserting a NOP into the Execute stage.

After one cycle, the loaded value is forwarded from the Write-Back stage and execution resumes normally.

---

# Test Program

```assembly
lw   x2, 0(x1)
add  x3, x2, x4
sub  x5, x3, x6
and  x7, x5, x4
```

---

# Initial Register Values

| Register | Value |
| -------- | ----: |
| x1       |   100 |
| x2       |     0 |
| x3       |     0 |
| x4       |    10 |
| x5       |    20 |
| x6       |     5 |
| x7       |     0 |

---

# Initial Data Memory

| Address | Value |
| ------: | ----: |
|     100 |    50 |

---

# Expected Register Values After Execution

| Register | Final Value |
| -------- | ----------: |
| x2       |          50 |
| x3       |          60 |
| x5       |          55 |
| x7       |           2 |

---

# Simulation Output

```text
--------------------------------
PC =          0
ALUResult =          0
--------------------------------
PC =          4
ALUResult =          0
--------------------------------
PC =          8
ALUResult =        100
--------------------------------
PC =          8
ALUResult =          0
--------------------------------
PC =         12
ALUResult =         60
--------------------------------
PC =         16
ALUResult =         55
--------------------------------
PC =         20
ALUResult =          2
--------------------------------
```

---

# Result Analysis

The simulation demonstrates the correct operation of both the forwarding and hazard detection units.

* The ALU first computes the effective memory address (`100`) for the `lw` instruction.
* The Program Counter remains at **8** for one additional cycle, confirming that the hazard detection unit successfully stalled the pipeline and inserted a bubble.
* Once the loaded value becomes available, the `add` instruction computes `60`.
* The subsequent `sub` instruction immediately receives the forwarded result (`60`) without stalling and produces `55`.
* Finally, the `and` instruction forwards the value `55` from the previous instruction and computes the final result `2`.

The observed pipeline behavior verifies that:

* **ALU-to-ALU data hazards** are resolved through forwarding.
* **Load-use hazards** are detected automatically and resolved by inserting a single pipeline stall.
* Normal execution resumes immediately after the stall without requiring software-inserted NOP instructions.

---

