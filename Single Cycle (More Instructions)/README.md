# RISC-V 32-bit Single Cycle Processor (Advanced)

This folder contains the Verilog implementation of an **enhanced RISC-V 32-bit Single Cycle Processor**.

This design is a **modification and extension of the basic single-cycle processor**, with additional control-flow and immediate arithmetic instructions added while retaining the original single-cycle datapath architecture.

The processor currently supports the following RV32I instructions:

### Arithmetic Instructions
- `add`
- `sub`
- `and`
- `or`
- `xor`
- `slt`

### Immediate Instructions
- `addi`
- `andi`
- `ori`
- `xori`

### Memory Instructions
- `lw`
- `sw`

### Branch Instructions
- `beq`
- `blt`
- `bge`

### Jump Instructions
- `jal`
- `jalr`

---




## How do we simulate the design ?

Install **Icarus Verilog** and **GTKWave** on your machine and then hit the following commands:

```bash
iverilog -o simv *.v
vvp simv
gtkwave waveform.vcd
```

---
## Verification

The processor was verified using the following hand-written instruction sequence stored in the instruction memory.

|  Address | Instruction | Description |
| -------: | ----------- | ----------- |
| `32'd0`  | `addi x1, x0, 5` | Initialize register x1 with the value 5 |
| `32'd4`  | `addi x2, x0, 10` | Initialize register x2 with the value 10 |
| `32'd8`  | `blt x1, x2, +8` | Branch to address 16 if x1 is less than x2 |
| `32'd12` | `addi x3, x0, 99` | Instruction skipped due to the BLT branch |
| `32'd16` | `bge x2, x1, +8` | Branch to address 24 if x2 is greater than or equal to x1 |
| `32'd20` | `addi x4, x0, 88` | Instruction skipped due to the BGE branch |
| `32'd24` | `beq x1, x1, +8` | Branch to address 32 since x1 equals x1 |
| `32'd28` | `addi x5, x0, 77` | Instruction skipped due to the BEQ branch |
| `32'd32` | `jal x6, +8` | Jump to address 40 and store the return address (36) in x6 |
| `32'd36` | `addi x7, x0, 66` | Instruction skipped due to JAL |
| `32'd40` | `addi x8, x0, 48` | Load the JALR target address into x8 |
| `32'd44` | `jalr x9, 0(x8)` | Jump to address stored in x8 (48) and store the return address (48) in x9 |
| `32'd48` | `addi x10, x0, 123` | Final instruction executed after JALR |

The following console output is obtained while simulating the above instruction sequence.

```text
-----------------------------------------------------
PC          = 0
Instruction = 00500093
PCNext      = 4
PCSrc       = 00
RD1         = 0
RD2         = 0
ImmExt      = 5
ALUResult   = 5
Zero        = 0
Negative    = 0
RegWrite    = 1
MemWrite    = 0
x1 <- 5
-----------------------------------------------------
PC          = 4
Instruction = 00a00113
PCNext      = 8
PCSrc       = 00
RD1         = 0
RD2         = 0
ImmExt      = 10
ALUResult   = 10
Zero        = 0
Negative    = 0
RegWrite    = 1
MemWrite    = 0
x2 <- 10
-----------------------------------------------------
PC          = 8
Instruction = 0020c463
PCNext      = 16
PCSrc       = 01
RD1         = 5
RD2         = 10
ImmExt      = 8
ALUResult   = 4294967291
Zero        = 0
Negative    = 1
RegWrite    = 0
MemWrite    = 0
-----------------------------------------------------
PC          = 16
Instruction = 00115463
PCNext      = 24
PCSrc       = 01
RD1         = 10
RD2         = 5
ImmExt      = 8
ALUResult   = 5
Zero        = 0
Negative    = 0
RegWrite    = 0
MemWrite    = 0
-----------------------------------------------------
PC          = 24
Instruction = 00108463
PCNext      = 32
PCSrc       = 01
RD1         = 5
RD2         = 5
ImmExt      = 8
ALUResult   = 0
Zero        = 1
Negative    = 0
RegWrite    = 0
MemWrite    = 0
-----------------------------------------------------
PC          = 32
Instruction = 0080036f
PCNext      = 40
PCSrc       = 01
RD1         = 0
RD2         = 0
ImmExt      = 8
ALUResult   = 0
Zero        = 1
Negative    = 0
RegWrite    = 1
MemWrite    = 0
x6 <- 36
-----------------------------------------------------
PC          = 40
Instruction = 03000413
PCNext      = 44
PCSrc       = 00
RD1         = 0
RD2         = 0
ImmExt      = 48
ALUResult   = 48
Zero        = 0
Negative    = 0
RegWrite    = 1
MemWrite    = 0
x8 <- 48
-----------------------------------------------------
PC          = 44
Instruction = 000404e7
PCNext      = 48
PCSrc       = 10
RD1         = 48
RD2         = 0
ImmExt      = 0
ALUResult   = 48
Zero        = 0
Negative    = 0
RegWrite    = 1
MemWrite    = 0
x9 <- 48
-----------------------------------------------------
PC          = 48
Instruction = 07b00513
PCNext      = 52
PCSrc       = 00
RD1         = 0
RD2         = 0
ImmExt      = 123
ALUResult   = 123
Zero        = 0
Negative    = 0
RegWrite    = 1
MemWrite    = 0
x10 <- 123
```

The above simulation output serves as proof that the implemented processor correctly executes the supplied instruction sequence. The console trace verifies the correct operation of:

* Immediate arithmetic (`addi`)
* Conditional branching (`blt`, `bge`, `beq`)
* Unconditional jump (`jal`)
* Register-indirect jump (`jalr`)
* Register write-back
* Program Counter (PC) update logic

The generated GTKWave waveform can also be used to verify the correct timing and functionality of the datapath and control signals.