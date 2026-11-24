# Synchronous FIFO – Verification Test Plan

**Project:** FIFO Verification Project  
**Document:** Verification Test Plan  
**Version:** 1.0  
**Status:** Initial Verification Plan  
**DUT:** Parameterized Synchronous FIFO  
**Verification Language:** SystemVerilog

---

## 1. Introduction

### 1.1 Purpose

This document defines the verification strategy and test scenarios for the parameterized synchronous FIFO design.

The objective is to verify that the FIFO behaves according to its functional specification under normal operating conditions, boundary conditions, and corner cases.

The verification environment shall identify functional errors such as:

- Data loss.
- Data corruption.
- Incorrect data ordering.
- Incorrect Full and Empty flag behavior.
- Incorrect occupancy management.
- Pointer wrap-around errors.
- Incorrect handling of simultaneous read and write operations.
- Reset-related functional errors.

### 1.2 Verification Scope

The verification effort shall cover:

- Reset functionality.
- Basic read and write operations.
- FIFO Full and Empty conditions.
- Data ordering and integrity.
- Simultaneous read and write operations.
- Pointer wrap-around.
- Boundary and corner cases.
- Parameterized configurations.
- Randomized read and write sequences.

### 1.3 Verification Methodology

The FIFO shall initially be verified using a SystemVerilog-based testbench.

The verification environment is planned to include:

- **DUT:** FIFO RTL implementation.
- **Stimulus Generator:** Generates read, write, and reset requests.
- **Driver:** Applies stimulus to the DUT.
- **Monitor:** Observes DUT signals and accepted operations.
- **Reference Model:** Maintains the expected FIFO behavior.
- **Scoreboard:** Compares actual DUT outputs against expected results.
- **Assertions:** Checks important functional properties.
- **Functional Coverage:** Measures whether important scenarios have been exercised.

The initial implementation may use a procedural testbench. The environment may subsequently be extended to UVM.

---

## 2. Verification Configuration

### 2.1 Default Configuration

The initial verification configuration shall use:

| Parameter     | Value                     |
|---------------|--------------------------:|
| DATA_WIDTH    | 8                         |
| FIFO_DEPTH    | 16                        |
| Clock         | Single clock              |
| Reset         | Synchronous, active-high  |

### 2.2 Additional Configurations

The design shall also be verified using alternative parameter configurations.

| Configuration | DATA_WIDTH    | FIFO_DEPTH    | Purpose                           |
|---------------|:-------------:|:-------------:|-----------------------------------|
| CFG01         | 8             | 16            | Default configuration             |
| CFG02         | 16            | 8             | Alternative data width and depth  |
| CFG03         | 32            | 32            | Wider data and larger depth       |
| CFG04         | 4             | 4             | Small FIFO configuration          |
| CFG05         | 8             | 6             | Non-power-of-two depth            |
| CFG06         | 8             | 1             | Minimum supported depth           |

The purpose of these configurations is to verify that the design correctly supports different data widths and FIFO depths.

---

## 3. Test Scenarios

The following test scenarios define the initial directed verification plan.

### 3.1 Reset Tests

| Test ID | Test Scenario | Description | Expected Result | Requirement |
|---|---|---|---|---|
| T01 | Initial Reset | Assert reset at startup. | FIFO becomes empty, pointers and occupancy are cleared, and dout becomes zero. | R01, R02, R16 |
| T02 | Reset While Partially Full | Write several data words and then assert reset. | All previous FIFO contents become logically invalid and FIFO returns to Empty. | R01, R02 |
| T03 | Reset While Full | Fill the FIFO and then assert reset. | FIFO returns to Empty and full is deasserted. | R01, R02, R09 |

### 3.2 Basic Read and Write Tests

| Test ID | Test Scenario | Description | Expected Result | Requirement |
|---|---|---|---|---|
| T04 | Single Write | Write one data word into an empty FIFO. | Data is stored and Empty is deasserted. | R03, R10, R12 |
| T05 | Single Read | Write one data word and read it back. | The correct data appears on dout. | R05, R07, R08 |
| T06 | Multiple Writes | Write multiple distinct data words. | All data words are stored in the correct order. | R03, R07, R08 |
| T07 | Multiple Reads | Read all previously written data words. | Data is returned in First-In, First-Out order. | R05, R07, R08 |
| T08 | Write and Read Inactive | Keep wr_en and rd_en deasserted for multiple clock cycles. | FIFO state, occupancy, flags, and dout remain unchanged. | R12, R16 |

### 3.3 Full and Empty Boundary Tests

| Test ID | Test Scenario | Description | Expected Result | Requirement |
|---|---|---|---|---|
| T09 | Fill FIFO | Write exactly FIFO_DEPTH data words. | Full is asserted and occupancy reaches FIFO_DEPTH. | R09, R12 |
| T10 | Write While Full | Attempt an additional write when Full is asserted. | Write is rejected and existing data remains unchanged. | R04, R08, R12 |
| T11 | Read While Full | Read one data word from a full FIFO. | The oldest data is returned and Full is deasserted. | R05, R07, R09 |
| T12 | Empty FIFO | Read all stored data words until no data remains. | Empty is asserted and occupancy reaches zero. | R10, R12 |
| T13 | Read While Empty | Attempt a read when Empty is asserted. | Read is rejected, read pointer remains unchanged, and dout is retained. | R06, R16 |

### 3.4 Simultaneous Read and Write Tests

| Test ID | Test Scenario | Description | Expected Result | Requirement |
|---|---|---|---|---|
| T14 | Simultaneous Read/Write – Partially Full | Assert wr_en and rd_en when FIFO contains data and has free space. | Both operations are accepted, the oldest data is returned, and occupancy remains unchanged. | R07, R11, R12 |
| T15 | Simultaneous Read/Write – Empty | Assert both enables when FIFO is empty. | Write is accepted, read is rejected, and occupancy increases by one. | R03, R05, R11, R12 |
| T16 | Simultaneous Read/Write – Full | Assert both enables when FIFO is full. | Read is accepted, write is rejected, and occupancy decreases by one. | R04, R05, R11, R12 |

### 3.5 Pointer and Data Integrity Tests

| Test ID | Test Scenario | Description | Expected Result | Requirement |
|---|---|---|---|---|
| T17 | Write Pointer Wrap-Around | Perform enough accepted writes and reads to cause the write pointer to wrap around. | Write pointer returns to address zero without data corruption. | R07, R08, R13 |
| T18 | Read Pointer Wrap-Around | Perform enough accepted reads and writes to cause the read pointer to wrap around. | Read pointer returns to address zero without data corruption. | R07, R08, R14 |
| T19 | Repeated Write/Read Cycles | Perform multiple sequences of writes and reads. | No data loss, duplication, or ordering errors occur. | R07, R08, R12 |
| T20 | Output Hold Behavior | Perform a successful read followed by cycles without accepted reads. | dout retains the previously read value. | R16 |

### 3.6 Parameterization Tests

| Test ID | Test Scenario | Description | Expected Result | Requirement |
|---|---|---|---|---|
| T21 | Alternative Data Width | Run the FIFO with DATA_WIDTH different from the default. | All data words are transferred correctly using the configured width. | R08, R15 |
| T22 | Alternative FIFO Depth | Run the FIFO with a different depth. | Full, Empty, occupancy, and pointer behavior remain correct. | R09, R10, R12, R15 |
| T23 | Non-Power-of-Two Depth | Run the FIFO with FIFO_DEPTH = 6. | Both pointers wrap correctly between addresses 0 and 5. | R13, R14, R15 |

### 3.7 Randomized Testing

| Test ID | Test Scenario | Description | Expected Result | Requirement |
|---|---|---|---|---|
| T24 | Randomized Read/Write Sequence | Generate randomized write and read requests over an extended simulation. | The DUT matches the Reference Model throughout the test, with no data or status mismatches. | R01–R16 |

---

## 4. Reference Model and Scoreboard Strategy

### 4.1 Reference Model

The Reference Model shall independently represent the expected FIFO behavior.

A SystemVerilog Queue is planned as the primary data structure for the model.

The Reference Model shall:

- Track accepted write operations.
- Track accepted read operations.
- Maintain the expected data ordering.
- Calculate expected occupancy.
- Determine expected Full and Empty status.
- Model simultaneous read and write behavior.
- Handle reset operations.

The Reference Model shall not depend on the internal DUT pointers or memory implementation.

### 4.2 Scoreboard

The Scoreboard shall compare the expected behavior against the observed DUT behavior.

The following items shall be checked:

- Actual output data versus expected output data.
- Actual Full flag versus expected Full flag.
- Actual Empty flag versus expected Empty flag.
- Correct response to accepted and rejected operations.
- Correct output retention when no read is accepted.

Any mismatch shall be reported as a verification error.

The verification environment shall maintain an error counter and report the final number of errors at the end of simulation.

---

## 5. Assertions Strategy

The following functional properties are planned for assertion-based verification:

| Assertion ID | Property | Expected Behavior |
|---|---|---|
| A01 | Empty Consistency | Empty shall be asserted when occupancy is zero. |
| A02 | Full Consistency | Full shall be asserted when occupancy equals FIFO_DEPTH. |
| A03 | Occupancy Upper Bound | Occupancy shall never exceed FIFO_DEPTH. |
| A04 | Occupancy Lower Bound | Occupancy shall never become negative. |
| A05 | Write Pointer Stability | Write pointer shall not advance when a write is rejected. |
| A06 | Read Pointer Stability | Read pointer shall not advance when a read is rejected. |
| A07 | Reset Behavior | Reset shall clear the FIFO state at the next rising clock edge. |
| A08 | Output Stability | dout shall remain stable when no read operation is accepted, except during reset. |

These properties shall be implemented and validated as part of the verification environment.

---

## 6. Functional Coverage Plan

Functional Coverage shall measure whether important FIFO operating conditions have been exercised.

The following coverage items are planned:

| Coverage ID | Coverage Item | Coverage Goal |
|---|---|---|
| C01 | Reset occurrence | Reset exercised during initial and active operation |
| C02 | FIFO Empty state | Empty state reached |
| C03 | FIFO Full state | Full state reached |
| C04 | Partially Full state | Intermediate occupancy states exercised |
| C05 | Write operation | Accepted write exercised |
| C06 | Read operation | Accepted read exercised |
| C07 | Write rejection | Write attempted while Full |
| C08 | Read rejection | Read attempted while Empty |
| C09 | Simultaneous operations | Read and write requested in the same cycle |
| C10 | Pointer wrap-around | Both read and write pointers wrap |
| C11 | Reset during activity | Reset asserted while FIFO contains data |
| C12 | Parameter configurations | Multiple supported configurations exercised |

### 6.1 Coverage Goals

The initial verification target shall be:

- All mandatory directed scenarios executed.
- All functional coverage items exercised.
- No unexpected data mismatches.
- No unexpected status mismatches.
- No unresolved functional errors.

Coverage closure shall be evaluated against the defined verification requirements rather than relying only on simulation runtime or the number of transactions.

---

## 7. Requirement Traceability Matrix

The following table links functional requirements to their corresponding test scenarios.

| Requirement | Related Tests |
|---|---|
| R01 | T01, T02, T03 |
| R02 | T01, T02, T03 |
| R03 | T04, T06, T15 |
| R04 | T10, T16 |
| R05 | T05, T07, T11, T14, T16 |
| R06 | T13, T15 |
| R07 | T06, T07, T14, T17, T18, T19 |
| R08 | T06, T07, T10, T19 |
| R09 | T03, T09, T11 |
| R10 | T01, T04, T12 |
| R11 | T14, T15, T16 |
| R12 | T04, T08, T09, T12, T14, T15, T16, T19 |
| R13 | T17, T23 |
| R14 | T18, T23 |
| R15 | T21, T22, T23 |
| R16 | T01, T13, T20 |

---

## 8. Test Execution and Reporting

Each test shall produce a clear pass or fail result.

The verification environment shall report:

- Test name and test ID.
- Simulation configuration.
- Number of transactions.
- Number of detected errors.
- Final FIFO status.
- Test execution result.

A test shall be considered successful only when all expected results are observed and no unexpected mismatches are detected.

---

## 9. Verification Completion Criteria

The FIFO verification effort shall be considered complete when:

1. All mandatory directed tests have passed.
2. Randomized testing has completed without unexplained mismatches.
3. All defined functional coverage goals have been achieved or any exclusions have been documented.
4. All critical assertions have been validated.
5. All supported parameter configurations have been tested.
6. No unresolved functional bugs remain.
7. Simulation and verification results are documented.

---