# RISC-V 32-bit Single Cycle Processor

This Folder contains the Verilog implementation of a **RISC-V 32-bit Single Cycle Processor**.  
The design follows the standard single-cycle datapath structure and supports a subset of RISC-V instructions.  

---



##  Architecture Diagram
Below is the complete single-cycle processor datapath:  

![Single Cycle Processor Diagram](images/complete_processor.jpeg)

---

##  Main Decoder Truth Table
The following truth table defines the **control signals** for each instruction type:  

![Main Decoder Truth Table](images/main_decoder_truth_table.jpeg)

---

##  Instruction Set
We are using a subset of the **RISC-V RV32I** instruction set in this project:  

![Instruction Set](images/instructions.jpeg)





