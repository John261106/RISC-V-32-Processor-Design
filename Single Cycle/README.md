# RISC-V 32-bit Single Cycle Processor

This Folder contains the Verilog implementation of a **RISC-V 32-bit Single Cycle Processor**.  
The design follows the standard single-cycle datapath structure and supports a subset of RISC-V instructions.  
add,sub,and,or,slt,beq,lw and sw is implemented.  

---



##  Architecture Diagram
Below is the complete single-cycle processor datapath:  

![Single Cycle Processor Diagram](images/complete_processor.jpeg)

---
##  Control Unit
The control unit consists of Main decoder and ALU decoder:  

![Main Decoder Truth Table](images/control_unit.jpeg)

---


##  Main Decoder Truth Table
Below is the main decoder truth table:  

![Main Decoder Truth Table](images/main_decoder_truth_table.jpeg)

---

##  ALU Decoder Truth Table
Below is the ALU decoder truth tabe:  

![Instruction Set](images/alu_decoder_truth_table.jpeg)





