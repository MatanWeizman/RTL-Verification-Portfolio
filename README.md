# Hardware Verification Portfolio

This repository contains a collection of hardware design and verification projects developed as part of my preparation for an entry-level **Hardware / Design Verification Engineer** position.

The projects focus on digital design fundamentals, SystemVerilog, verification methodologies, and the development of structured test environments.

## Projects

### 1. Counter Verification

**Status:** In Progress

A parameterizable synchronous up-counter and its accompanying SystemVerilog verification environment.

The purpose of this project is to practice the fundamentals of functional verification, from understanding design requirements to developing test scenarios and checking the DUT behavior.

**Design Features**
- Parameterizable counter width (`WIDTH`).
- Synchronous, active-high reset.
- Enable-controlled counting.
- Counter holds its value when enable is low.
- Natural overflow behavior.

**Verification Scope**

The verification environment is being developed to include:

- **Directed Testing** – verifying specific functional scenarios.
- **Corner Case Testing** – checking boundary conditions, reset priority, and overflow behavior.
- **Reference Model** – independently calculating the expected counter value.
- **Scoreboard** – comparing the DUT output against the expected result.
- **Assertions** – checking important design properties.
- **Functional Coverage** – tracking which scenarios and conditions have been exercised.
- **Random Testing** – applying randomized input sequences to explore additional scenarios.

**Tools**
- SystemVerilog
- Icarus Verilog
- GTKWave
- Visual Studio Code
- Git / GitHub

---

## Repository Structure

```text
RTL-Verification-Portfolio/
│
├── README.md
│
├── Counter-Verification/
│   ├── README.md
│   ├── rtl/
│   ├── tb/
│   ├── docs/
│   └── simulation/
│
└── [Additional projects]
```

## Goals

The main goals of this portfolio are to demonstrate:

- Understanding of digital logic and synchronous design.
- Ability to develop and debug SystemVerilog testbenches.
- Understanding of verification concepts and methodologies.
- Ability to translate design specifications into verification scenarios.
- Structured documentation and professional project organization.

Projects and verification environments will be expanded incrementally as new concepts and techniques are learned.