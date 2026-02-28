# 2-Bit Multiplier Using Logic Gates (Verilog)

A Verilog implementation of a **2-bit binary multiplier** using half adders, developed with the Vivado IDE. This document explains the underlying theory, shows how binary multiplication works with position weights, presents the complete truth table, describes the gate-level architecture, and summarizes the circuit, waveform, and simulation results.

---

## Table of Contents

- [What Is a 2-Bit Multiplier?](#what-is-a-2-bit-multiplier)
- [2-Bit Multiplier Theory](#2-bit-multiplier-theory)
- [Binary Multiplication with Weights (General Case)](#binary-multiplication-with-weights-general-case)
- [Learning Resources](#learning-resources)
- [Truth Table](#truth-table)
- [Circuit Architecture and Boolean Equations](#circuit-architecture-and-boolean-equations)
- [Circuit Diagram](#circuit-diagram)
- [Waveform Diagram](#waveform-diagram)
- [Testbench Output](#testbench-output)
- [Running the Project in Vivado](#running-the-project-in-vivado)
- [Project Files](#project-files)

---

## What Is a 2-Bit Multiplier?

A **2-bit multiplier** is a combinational circuit that **multiplies two 2-bit binary numbers** and produces a **4-bit product**. It has four inputs and four outputs:

- **Inputs**
  - **A** = A<sub>1</sub>A<sub>0</sub> — first 2-bit number (A<sub>1</sub> = MSB, A<sub>0</sub> = LSB).
  - **B** = B<sub>1</sub>B<sub>0</sub> — second 2-bit number (B<sub>1</sub> = MSB, B<sub>0</sub> = LSB).
- **Outputs**
  - **P** = P<sub>3</sub>P<sub>2</sub>P<sub>1</sub>P<sub>0</sub> — 4-bit product (P<sub>3</sub> = MSB, P<sub>0</sub> = LSB).

So the circuit computes **P = A × B** where A and B range from 0 to 3, and P ranges from 0 to 9. The implementation uses **AND gates** for the partial products and **half adders** (XOR for sum, AND for carry) to add the weighted bits and propagate carries.

---

## 2-Bit Multiplier Theory

The 2-bit multiplier implements:

\[
P = A \times B
\]

where \(A = 2A_1 + A_0\), \(B = 2B_1 + B_0\), and \(P = 8P_3 + 4P_2 + 2P_1 + P_0\). The multiplication is performed the same way as pencil-and-paper (binary) multiplication: form partial products by multiplying A by each bit of B (with the appropriate weight), then add them. The result is expressed as four output bits and internal carries, as shown in the next section.

---

## Binary Multiplication with Weights (General Case)

Binary multiplication follows the same idea as multiplying two 2-digit decimal numbers: each digit of the multiplier is multiplied by the whole multiplicand, and the partial products are shifted by position (weight) and added.

### Notation (General Case)

| Symbol | Meaning |
|--------|--------|
| **a<sub>0</sub>** | LSB of first number (weight 2<sup>0</sup>) |
| **a<sub>1</sub>** | MSB of first number (weight 2<sup>1</sup>) |
| **b<sub>0</sub>** | LSB of second number (weight 2<sup>0</sup>) |
| **b<sub>1</sub>** | MSB of second number (weight 2<sup>1</sup>) |

So:
- **A** = a<sub>1</sub>a<sub>0</sub> = 2·a<sub>1</sub> + a<sub>0</sub> (values 0–3).
- **B** = b<sub>1</sub>b<sub>0</sub> = 2·b<sub>1</sub> + b<sub>0</sub> (values 0–3).
- **P** = A × B = p<sub>3</sub>p<sub>2</sub>p<sub>1</sub>p<sub>0</sub> = 8·p<sub>3</sub> + 4·p<sub>2</sub> + 2·p<sub>1</sub> + p<sub>0</sub> (values 0–9).

### How Multiplication Works (Position Weights)

When we multiply **A × B**, we multiply A by each bit of B and assign a **weight** (power of 2) to each product based on the position of that bit in B.

**Step 1 — Multiply A by b<sub>0</sub> (weight 2<sup>0</sup>):**

| Term        | Weight | Expression   | Contributes to |
|-------------|--------|--------------|----------------|
| a<sub>0</sub>·b<sub>0</sub> | 2<sup>0</sup> | LSB × LSB     | **p<sub>0</sub>** |
| a<sub>1</sub>·b<sub>0</sub> | 2<sup>1</sup> | MSB × LSB     | **p<sub>1</sub>** (and possibly carry) |

**Step 2 — Multiply A by b<sub>1</sub> (weight 2<sup>1</sup>):**

| Term        | Weight | Expression   | Contributes to |
|-------------|--------|--------------|----------------|
| a<sub>0</sub>·b<sub>1</sub> | 2<sup>1</sup> | LSB × MSB     | **p<sub>1</sub>** (and possibly carry) |
| a<sub>1</sub>·b<sub>1</sub> | 2<sup>2</sup> | MSB × MSB     | **p<sub>2</sub>** (and possibly carry) |

**Step 3 — Add terms by weight:**

| Output bit | Weight | Sum of terms at this weight | Equation |
|------------|--------|-----------------------------|----------|
| **p<sub>0</sub>** | 2<sup>0</sup> | Only a<sub>0</sub>·b<sub>0</sub> | \(p_0 = a_0 \cdot b_0\) |
| **p<sub>1</sub>** | 2<sup>1</sup> | a<sub>1</sub>·b<sub>0</sub> + a<sub>0</sub>·b<sub>1</sub> (plus any carry-in 0) | \(p_1 = (a_1 b_0) \oplus (a_0 b_1)\), carry c<sub>1</sub> from half adder |
| **p<sub>2</sub>** | 2<sup>2</sup> | a<sub>1</sub>·b<sub>1</sub> + c<sub>1</sub> | \(p_2 = (a_1 b_1) \oplus c_1\), carry c<sub>2</sub> from half adder |
| **p<sub>3</sub>** | 2<sup>3</sup> | c<sub>2</sub> only | \(p_3 = c_2\) |

### Example: A = 11 (3), B = 10 (2) → P = 0110 (6)

| Weight | Contributing terms        | Sum (binary) | Result bit / carry |
|--------|---------------------------|--------------|---------------------|
| 2<sup>0</sup> | a<sub>0</sub>·b<sub>0</sub> = 1·0 = 0 | 0 | p<sub>0</sub> = 0 |
| 2<sup>1</sup> | a<sub>1</sub>·b<sub>0</sub> + a<sub>0</sub>·b<sub>1</sub> = 1·0 + 1·1 = 0+1 = 1 | 1 | p<sub>1</sub> = 1, c<sub>1</sub> = 0 |
| 2<sup>2</sup> | a<sub>1</sub>·b<sub>1</sub> + c<sub>1</sub> = 1·1 + 0 = 1 | 1 | p<sub>2</sub> = 1, c<sub>2</sub> = 0 |
| 2<sup>3</sup> | c<sub>2</sub> = 0 | 0 | p<sub>3</sub> = 0 |

So P = 0110 = 6, which matches 3 × 2 = 6.

---

## Learning Resources

Useful online resources for binary multipliers, half adders, and digital design:

| Resource | Description |
|----------|-------------|
| [2-Bit Multiplier (YouTube)](https://www.youtube.com/results?search_query=2+bit+multiplier) | Concept, partial products, and typical gate-level implementations. |
| [Binary Multiplication (YouTube)](https://www.youtube.com/results?search_query=binary+multiplication) | How binary multiplication works with shifting and adding. |
| [Half Adder and Full Adder (YouTube)](https://www.youtube.com/results?search_query=half+adder+full+adder) | Building blocks used in the multiplier (sum and carry). |
| [Verilog Combinational Circuits (YouTube)](https://www.youtube.com/results?search_query=verilog+combinational+circuits) | RTL and testbench examples for basic logic circuits in Verilog. |

---

## Truth Table

The 2-bit multiplier has four inputs (A<sub>1</sub>, A<sub>0</sub>, B<sub>1</sub>, B<sub>0</sub>) and four outputs (P<sub>3</sub>, P<sub>2</sub>, P<sub>1</sub>, P<sub>0</sub>). The truth table covers all 16 input combinations and the expected 4-bit product **P = A × B**.

| **A<sub>1</sub>** | **A<sub>0</sub>** | **B<sub>1</sub>** | **B<sub>0</sub>** | **P<sub>3</sub>** | **P<sub>2</sub>** | **P<sub>1</sub>** | **P<sub>0</sub>** | **A (dec)** | **B (dec)** | **P (dec)** |
|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 0 |
| 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 0 |
| 0 | 0 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 3 | 0 |
| 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
| 0 | 1 | 0 | 1 | 0 | 0 | 0 | 1 | 1 | 1 | 1 |
| 0 | 1 | 1 | 0 | 0 | 0 | 1 | 0 | 1 | 2 | 2 |
| 0 | 1 | 1 | 1 | 0 | 0 | 1 | 1 | 1 | 3 | 3 |
| 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 |
| 1 | 0 | 0 | 1 | 0 | 0 | 1 | 0 | 2 | 1 | 2 |
| 1 | 0 | 1 | 0 | 0 | 1 | 0 | 0 | 2 | 2 | 4 |
| 1 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 2 | 3 | 6 |
| 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 |
| 1 | 1 | 0 | 1 | 0 | 0 | 1 | 1 | 3 | 1 | 3 |
| 1 | 1 | 1 | 0 | 0 | 1 | 1 | 0 | 3 | 2 | 6 |
| 1 | 1 | 1 | 1 | 1 | 0 | 0 | 1 | 3 | 3 | 9 |

This table is the **complete truth table** of the 2-bit multiplier and matches the behavioral and gate-level design.

---

## Circuit Architecture and Boolean Equations

The multiplier is built from **AND gates** (for partial products) and **half adders** (XOR for sum, AND for carry). The equations in terms of A<sub>0</sub>, A<sub>1</sub>, B<sub>0</sub>, B<sub>1</sub> and internal carries c<sub>1</sub>, c<sub>2</sub> are:

| Output / internal | Equation | Implementation |
|-------------------|----------|----------------|
| **P<sub>0</sub>** | \(P_0 = A_0 \cdot B_0\) | Single AND gate |
| **P<sub>1</sub>** | \(P_1 = (A_1 B_0) \oplus (A_0 B_1)\) | Two ANDs + half adder (XOR for sum) |
| **c<sub>1</sub>** | \(c_1 = (A_1 B_0) \cdot (A_0 B_1)\) | Half adder carry (AND) |
| **P<sub>2</sub>** | \(P_2 = (A_1 B_1) \oplus c_1\) | AND + half adder (XOR for sum) |
| **c<sub>2</sub>** | \(c_2 = (A_1 B_1) \cdot c_1\) | Half adder carry (AND) |
| **P<sub>3</sub>** | \(P_3 = c_2\) | Direct connection from carry |

Conceptually:

1. **P<sub>0</sub>**: AND of the two LSBs (A<sub>0</sub>, B<sub>0</sub>).
2. **P<sub>1</sub>**: Add the two products at weight 2<sup>1</sup> (A<sub>1</sub>B<sub>0</sub> and A<sub>0</sub>B<sub>1</sub>) with a half adder → sum gives P<sub>1</sub>, carry gives c<sub>1</sub>.
3. **P<sub>2</sub>**: Add A<sub>1</sub>B<sub>1</sub> and c<sub>1</sub> with a half adder → sum gives P<sub>2</sub>, carry gives c<sub>2</sub>.
4. **P<sub>3</sub>**: Equals c<sub>2</sub> (no further addition at 2<sup>3</sup>).

In the Verilog module `twoBitMultiplier`, these equations are realized using continuous assignments (`assign`) with bitwise AND (`&`) and XOR (`^`). Ports are: inputs `A0`, `A1`, `B0`, `B1`; outputs `P0`, `P1`, `P2`, `P3`.

---

## Circuit Diagram

The logic diagram shows the AND gates for partial products and the half-adders (XOR + AND for carry) that build P<sub>1</sub>, P<sub>2</sub>, and propagate carries to P<sub>3</sub>.

![2-Bit Multiplier Circuit](imageAssets/twoBitMultiplierCircuit.png)

---

## Waveform Diagram

The behavioral simulation waveform shows A<sub>1</sub>, A<sub>0</sub>, B<sub>1</sub>, B<sub>0</sub> cycling through all 16 input combinations, with P<sub>3</sub>, P<sub>2</sub>, P<sub>1</sub>, P<sub>0</sub> giving the expected product for each pair (A, B).

![2-Bit Multiplier Waveform](imageAssets/twoBitMultiplierWaveform.png)

---

## Testbench Output

The testbench applies all 16 combinations of (A, B) and prints A, B, and P in binary. A representative simulation log is:

```text
A = 00, B = 00, P = 0000
A = 00, B = 01, P = 0000
A = 00, B = 10, P = 0000
A = 00, B = 11, P = 0000
A = 01, B = 00, P = 0000
A = 01, B = 01, P = 0001
A = 01, B = 10, P = 0010
A = 01, B = 11, P = 0011
A = 10, B = 00, P = 0000
A = 10, B = 01, P = 0010
A = 10, B = 10, P = 0100
A = 10, B = 11, P = 0110
A = 11, B = 00, P = 0000
A = 11, B = 01, P = 0011
A = 11, B = 10, P = 0110
A = 11, B = 11, P = 1001
```

These results match the 2-bit multiplier truth table and confirm that the **implementation is functionally correct**.

---

## Running the Project in Vivado

Follow these steps to open the project in **Vivado** and run the simulation.

### Prerequisites

- **Xilinx Vivado** installed (Vivado HL Design Edition, Lab Edition, or any recent version compatible with your OS).

### 1. Launch Vivado

1. Start Vivado from the Start Menu (Windows) or your application launcher.
2. Choose **Vivado** (or **Vivado HLx**).

### 2. Create a New RTL Project

1. Click **Create Project** (or **File → Project → New**).
2. Click **Next** on the welcome page.
3. Choose **RTL Project** and leave **Do not specify sources at this time** unchecked if you plan to add sources immediately.
4. Click **Next**.

### 3. Add Design and Simulation Sources

1. In the **Add Sources** step, add the Verilog design files:
   - **Design sources:**
     - `twoBitMultiplier.v` — 2-bit multiplier module (inputs A0, A1, B0, B1; outputs P0, P1, P2, P3).
   - **Simulation sources:**
     - `twoBitMultiplier_tb.v` — testbench that applies all 16 input combinations and prints A, B, and P.
2. Set the testbench as the **top module for simulation**:
   - In the **Sources** window, under **Simulation Sources**, right-click `twoBitMultiplier_tb.v` → **Set as Top**.
3. Click **Next**, choose a suitable **target device** (or leave default / "Don't specify" for simulation-only), then **Next → Finish**.

### 4. Run Behavioral Simulation

1. In the **Flow Navigator** (left panel), under **Simulation**, click **Run Behavioral Simulation**.
2. Vivado will elaborate the design (`twoBitMultiplier` as the DUT), compile, and open the **Simulation** view with the waveform.
3. Inspect the waveform:
   - Confirm that {A1, A0} and {B1, B0} cycle through 00, 01, 10, 11 (all 16 combinations).
   - Verify that {P3, P2, P1, P0} equals A × B for each combination.

### 5. (Optional) Re-run or Modify the Design

- To re-run: **Flow Navigator → Simulation → Run Behavioral Simulation** (or the re-run icon in the simulation toolbar).
- To change the design or testbench: edit `twoBitMultiplier.v` or `twoBitMultiplier_tb.v`, save, then re-run behavioral simulation.

### 6. (Optional) Synthesis, Implementation, and Bitstream

To map the design to an FPGA:

1. In **Sources**, right-click the top-level RTL module (`twoBitMultiplier.v`) → **Set as Top** (for synthesis/implementation).
2. Run **Synthesis** from the Flow Navigator.
3. Run **Implementation**.
4. Create or edit a constraints file (e.g. `.xdc`) to assign pins for A0, A1, B0, B1, P0, P1, P2, P3.
5. Run **Generate Bitstream** to produce the configuration file for your FPGA board.

---

## Project Files

- `twoBitMultiplier.v` — RTL for the 2-bit multiplier \((A_1, A_0, B_1, B_0) \rightarrow (P_3, P_2, P_1, P_0)\).
- `twoBitMultiplier_tb.v` — testbench for the 2-bit multiplier; applies all 16 input combinations and prints A, B, and P.

---

*Author: **Kadhir Ponnambalam***
