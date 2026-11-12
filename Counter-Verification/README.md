# Counter Verification Project

## Overview

This project implements and verifies a parameterized synchronous binary counter using SystemVerilog.

The project focuses on fundamental hardware verification methodologies, including directed testing, reference modeling, scoreboard-based checking, assertions and functional coverage.

## Design Features

- Parameterized counter width.
- Synchronous active-high reset.
- Enable-controlled increment operation.
- Reset priority over enable.
- Automatic overflow and wrap-around behavior.
- Configurable WIDTH parameter (default: 4).

## Verification Features

The verification environment includes:

- Directed and random stimulus generation.
- Independent reference model.
- Monitor for DUT signal observation.
- Scoreboard for automated result checking.
- SystemVerilog assertions and properties.
- Functional coverage tracking.
- Boundary and corner case testing.
- Parameterization testing.

## Project Structure

```text
counter-verification/
├── docs/
├── rtl/
├── tb/
│   ├── test/
│   ├── monitor/
│   ├── reference_model/
│   ├── scoreboard/
│   ├── assertions/
│   └── coverage/
├── simulation/
└── README.md
```

## Documentation

|      Document       |                 Description                   |
|---------------------|-----------------------------------------------|
| Specification       | Functional design specification               |
| Requirements        | Detailed functional requirements              |
| Test Plan           | Verification scenarios and test strategy      |
| Traceability Matrix | Mapping between requirements and verification |
| Test Report         | Simulation results and verification summary   |

## Verification Methodology

The DUT is verified using an independent reference model and a scoreboard that compares expected and actual counter values.

Assertions are used to check important functional and temporal properties, while functional coverage tracks the exercised verification scenarios.

## Tools

- SystemVerilog
- Icarus Verilog (for supported simulation features)
- GTKWave
- Visual Studio Code
- Git and GitHub

## Verification Status

**Project Status:** In Progress

Final verification results and coverage statistics will be updated after regression testing.

## Learning Objectives

This project demonstrates fundamental RTL verification concepts and serves as a foundation for a larger FIFO verification project, including the future introduction of UVM.