# General-Purpose Microcoded Processor — FPGA Implementation

**Course:** COE328 — Digital Systems | Toronto Metropolitan University  
**Semester:** Fall 2024  
**Tools:** VHDL · Intel Quartus Prime · DE1-SoC / Intel Cyclone V FPGA

---

## Overview

A fully functional general-purpose processor designed from scratch in VHDL and deployed on an Intel FPGA. The processor executes a custom 16-bit one-hot encoded instruction set through a Moore FSM sequencer, with a custom ALU supporting 9 arithmetic and logic operations. Results are displayed in real-time on seven-segment hex displays.

This project was completed in three incremental problems, each adding hardware complexity and additional instructions.

---

## Architecture

```
         ┌────────────┐     16-bit OP     ┌─────────────┐
Inputs   │  Storage   │ ───────────────▶  │   ALU_GPU   │
A, B ──▶ │   Latch    │                   │  (9 ops)    │
         │  (8-bit)   │ ──── A, B ──────▶ │             │
         └────────────┘                   └──────┬──────┘
                                                 │ Result (8-bit)
         ┌────────────┐                          │
Clock ──▶│  GPU_FSM   │ ──── OP (16-bit) ───────▶│
         │ (9-state   │                   ┌──────▼──────┐
         │  Moore FSM)│                   │   4×16      │
         └────────────┘                   │  Decoder    │
                                          └──────┬──────┘
                                                 │
                                          ┌──────▼──────┐
                                          │  sseg (×2)  │
                                          │ 7-seg display│
                                          └─────────────┘
```

### Components

| File | Description |
|------|-------------|
| `ALU_GPU.vhd` | 8-bit ALU with 9 operations, active-low reset, 16-bit one-hot opcode input |
| `GPU_FSM.vhd` | 9-state Moore FSM sequencer — generates OP codes on each clock cycle |
| `GPU_FSM3.vhd` | Extended FSM for Problem 3 with additional instruction states |
| `StorageLatch.vhd` | 8-bit synchronous storage register with active-low reset |
| `dec3to8.vhd` | 3-to-8 decoder with enable — used to build the 4×16 decoder |
| `sseg.vhd` | BCD-to-7-segment decoder with negative sign handling |
| `GPU_BLOCK.bdf` | Top-level block diagram connecting all components |

---

## Instruction Set

The ALU uses a 16-bit one-hot encoded opcode — each bit position maps to exactly one operation. This is a one-hot encoding scheme: only one bit is high at a time.

| OP Code (binary) | Operation | Description |
|------------------|-----------|-------------|
| `0000000000000001` | ADD | R = A + B |
| `0000000000000010` | SUB | R = \|A − B\|, Neg flag set if A < B |
| `0000000000000100` | NOT A | R = ~A |
| `0000000000001000` | NAND | R = ~(A AND B) |
| `0000000000010000` | NOR | R = ~(A OR B) |
| `0000000000100000` | AND | R = A AND B |
| `0000000001000000` | OR | R = A OR B |
| `0000000010000000` | XOR | R = A XOR B |
| `0000000100000000` | XNOR | R = A XNOR B |

---

## FSM Sequencer

The `GPU_FSM` is a 9-state Moore FSM that cycles through states S0→S1→...→S8→S0 on each rising clock edge. Each state outputs a specific OP code to the ALU, causing it to execute one instruction per cycle. The FSM also outputs a 4-bit `student_id` signal at each state, encoding digits of student ID 501308663 for display verification.

```
S0 → S1 → S2 → S3 → S4 → S5 → S6 → S7 → S8 → S0 (loops)
```

- **Reset (active-low):** Returns to S0, clears outputs
- **Moore outputs:** Set on the same rising edge as the state transition

---

## Project Structure

```
fpga-processor/
├── src/
│   ├── ALU_GPU.vhd          ← ALU: 9 operations, 16-bit one-hot opcode
│   ├── GPU_FSM.vhd          ← Moore FSM sequencer (Problems 1 & 2)
│   ├── GPU_FSM3.vhd         ← Extended FSM (Problem 3)
│   ├── StorageLatch.vhd     ← 8-bit synchronous register
│   ├── dec3to8.vhd          ← 3-to-8 decoder (building block)
│   ├── sseg.vhd             ← 7-segment display decoder
│   └── sseg_modified.vhd    ← Modified display (Problem 3)
├── block_diagram/
│   └── GPU_BLOCK.bdf        ← Top-level Quartus block diagram
├── simulation/
│   └── Waveform*.vwf        ← Quartus simulation waveforms
├── docs/
│   └── (add waveform screenshots here)
└── README.md
```

---

## How to Open in Quartus Prime

1. Clone the repository
2. Open Intel Quartus Prime
3. File → Open Project → select `GPU.qpf`
4. The top-level block diagram is `GPU_BLOCK.bdf`
5. Run Analysis & Synthesis, then Fitter, then Assembler
6. Open Simulation Waveform Editor to run functional simulation

---

## Problems / Incremental Design

### Problem 1 — Base Processor
Core design: ALU + storage latch + 9-state FSM + 4×16 decoder + 7-segment display. All 9 ALU instructions functional. FSM cycles through all states outputting correct OP codes. Results displayed on two 7-segment displays (upper nibble, lower nibble).

### Problem 2 — Extended Verification
Additional waveform verification and simulation of all instruction types. Confirmed correct ALU output for all 9 operations across all FSM states.

### Problem 3 — Modified FSM and Display
Extended FSM (`GPU_FSM3`) and modified 7-segment decoder (`sseg_modified`) implementing additional display requirements. Separate FSM entity to maintain backward compatibility with Problems 1 and 2.

---

## Key Design Decisions

**One-hot opcode encoding** — Each operation is assigned a unique bit position in the 16-bit OP bus. This simplifies decoding (no additional decoder needed between FSM and ALU) and makes the case statement in the ALU trivially extensible.

**Active-low reset** — Consistent with common FPGA board conventions where reset buttons pull low. Applied uniformly across ALU, FSM, and storage latch.

**Moore FSM** — Outputs depend only on current state, not inputs. This eliminates glitches on outputs during state transitions, which is important for clean 7-segment display behavior.

**Split nibble display** — The 8-bit result is split into two 4-bit nibbles (R1 = lower, R2 = upper) and fed to two separate 7-segment decoders, allowing display of hex values 0x00–0xFF.

---

## Skills Demonstrated

- VHDL entity/architecture design for combinational and sequential circuits
- Moore FSM design and implementation
- Custom ALU design with multiple arithmetic and logic operations
- Synchronous register design with active-low reset
- Hierarchical design using block diagrams in Intel Quartus Prime
- Functional simulation and waveform verification
- FPGA synthesis and deployment on Intel Cyclone V hardware

---

*Computer Engineering · Toronto Metropolitan University · Fall 2024*
