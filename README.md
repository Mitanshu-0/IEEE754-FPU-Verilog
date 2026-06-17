# IEEE-754 Single Precision Floating Point Unit (FPU) in Verilog

A Verilog HDL implementation of a **32-bit IEEE-754 Single Precision Floating Point Unit (FPU)** supporting floating-point **Addition, Subtraction, Multiplication, and Division** with exception handling and rounding logic.

---

## Features

✔ IEEE-754 Single Precision (32-bit) Floating Point Format

✔ Floating Point Addition (ADD)

✔ Floating Point Subtraction (SUB)

✔ Floating Point Multiplication (MUL)

✔ Floating Point Division (DIV)

✔ Round-to-Nearest-Even Rounding

✔ Guard, Round, Sticky (GRS) Bit Support

✔ Overflow Detection

✔ Underflow Detection

✔ Divide-by-Zero Detection

✔ Invalid Operation Detection

✔ Inexact Result Detection

✔ Infinity Handling

✔ NaN Handling

✔ ModelSim Verified

---

## IEEE-754 Single Precision Format

The FPU operates on standard 32-bit IEEE-754 floating-point numbers.

| Field               | Bits |
| ------------------- | ---- |
| Sign                | 1    |
| Exponent            | 8    |
| Fraction (Mantissa) | 23   |

### Format

```text
31          30........23        22.............0
+------------+------------------+---------------+
| Sign (1)   | Exponent (8)     | Fraction (23) |
+------------+------------------+---------------+
```

Value represented:

```text
(-1)^Sign × 1.Fraction × 2^(Exponent−127)
```

---

## Project Structure

```text
IEEE754-FPU-Verilog/
│
├── README.md
│
└── src/
    ├── FPU_TOP.v
    ├── FPU_addsub.v
    ├── FPU_mul.v
    ├── FPU_div.v
    └── tb_fpu.v
```

---

## Architecture

The design consists of four major modules.

### 1. FPU_TOP

Top-level module responsible for:

* Receiving operands
* Selecting operation
* Routing data to arithmetic units
* Collecting exception flags
* Producing final result

### Operation Encoding

| OP | Operation      |
| -- | -------------- |
| 00 | Addition       |
| 01 | Subtraction    |
| 10 | Multiplication |
| 11 | Division       |

---

### 2. FPU_addsub

Performs:

* Floating Point Addition
* Floating Point Subtraction

Main Operations:

* Exponent comparison
* Mantissa alignment
* Mantissa addition/subtraction
* Normalization
* GRS rounding
* Exception generation

---

### 3. FPU_mul

Performs:

* Floating Point Multiplication

Main Operations:

* Mantissa multiplication
* Exponent addition
* Normalization
* GRS rounding
* Exception generation

---

### 4. FPU_div

Performs:

* Floating Point Division

Main Operations:

* Mantissa division
* Exponent subtraction
* Normalization
* GRS rounding
* Exception generation

---

## Supported Special Values

### Zero

```text
+0
-0
```

### Infinity

```text
+∞
-∞
```

Representation:

```text
Exponent = 255
Mantissa = 0
```

### NaN (Not a Number)

Representation:

```text
Exponent = 255
Mantissa ≠ 0
```

Supported Examples:

```text
∞ - ∞
∞ / ∞
0 / 0
```

---

## Exception Flags

The FPU generates the following IEEE-style exception flags.

| Flag        | Description                              |
| ----------- | ---------------------------------------- |
| overflow    | Result exceeds representable range       |
| underflow   | Result is too small to represent         |
| div_by_zero | Division by zero occurred                |
| invalid     | Invalid arithmetic operation             |
| inexact     | Rounded result differs from exact result |

---

## Rounding Method

The design implements:

### Round-to-Nearest-Even

Using:

* Guard Bit (G)
* Round Bit (R)
* Sticky Bit (S)

Benefits:

* Reduces systematic rounding error
* Standard IEEE-754 rounding method
* Produces unbiased results

---

## Supported Operations

### Addition

```text
A + B
```

Examples:

```text
2.2 + 2.0 = 4.2
5.5 + 3.25 = 8.75
```

---

### Subtraction

```text
A - B
```

Examples:

```text
2.2 - 2.0 = 0.2
10.0 - 3.5 = 6.5
```

---

### Multiplication

```text
A × B
```

Examples:

```text
2.2 × 2.0 = 4.4
3.5 × 4.0 = 14.0
```

---

### Division

```text
A ÷ B
```

Examples:

```text
2.2 ÷ 2.0 = 1.1
10.0 ÷ 4.0 = 2.5
```

---

## Verification

The design was verified using a dedicated Verilog testbench in ModelSim.

### Test Categories

### Basic Arithmetic Tests

* 2.2 + 2.0
* 2.2 − 2.0
* 2.2 × 2.0
* 2.2 ÷ 2.0

---

### Zero Tests

* 0 + 0
* 0 − 0
* 0 × 0
* 0 ÷ 0

---

### Divide-by-Zero Tests

* 5 ÷ 0

---

### Infinity Tests

* ∞ + 1
* ∞ − ∞
* ∞ × 2
* ∞ ÷ ∞

---

### NaN Tests

* NaN + 1
* NaN × 2
* NaN ÷ 2

---

### Overflow Tests

* MAX + MAX
* MAX × 2

---

### Underflow Tests

* MIN_NORMAL × MIN_NORMAL
* MIN_NORMAL ÷ MAX_NORMAL

---

### Sign Tests

* −2 + 2
* −2 − 2
* −2 × 2
* −2 ÷ 2

---

### Inexact Tests

* 1 ÷ 3
* 2 ÷ 3
* 10 ÷ 3

---

### Denormal Tests

* Denormal + Normal
* Denormal × Normal
* Denormal ÷ Normal

---

## Simulation

### Compile

```tcl
vlog src/FPU_addsub.v
vlog src/FPU_mul.v
vlog src/FPU_div.v
vlog src/FPU_TOP.v
vlog src/tb_fpu.v
```

### Simulate

```tcl
vsim tb_fpu
run -all
```

---

## Example Results

| Operation | Result |
| --------- | ------ |
| 2.2 + 2.0 | 4.2    |
| 2.2 − 2.0 | 0.2    |
| 2.2 × 2.0 | 4.4    |
| 2.2 ÷ 2.0 | 1.1    |

All directed test cases passed successfully during simulation.

---

## Design Limitation

To reduce hardware complexity, this implementation intentionally treats IEEE-754 denormal (subnormal) numbers as zero.

### Flush-To-Zero (FTZ)

```text
Denormal Input  →  Zero
Subnormal Result → Zero
```

Therefore:

* Full denormal arithmetic is not implemented.
* Subnormal results are flushed to zero.
* Underflow is reported through the underflow flag.

This behavior is commonly used in simplified educational FPU implementations and some high-performance processors.

---

## Future Improvements

Potential enhancements include:

* Full IEEE-754 Denormal Support
* Multiple Rounding Modes
* Pipelined FPU Architecture
* Double Precision (64-bit) Support
* Fused Multiply-Add (FMA)
* FPGA Implementation
* UVM/SystemVerilog Verification Environment
* Formal Verification

---

## Tools Used

* Verilog HDL
* ModelSim
* IEEE-754 Floating Point Standard

---

## Author

### Mitanshu Dhameliya


---

## License

This project is intended for educational, academic, and learning purposes.

