# Synchronous FIFO – Functional Specification

**Project:** FIFO Verification Project  
**Document:** Functional Specification  
**Version:** 1.0  
**Status:** Initial Specification  
**Design Type:** Synchronous FIFO  
**Language:** SystemVerilog

---

## 1. Introduction

### 1.1 Purpose

This document defines the functional requirements and expected behavior of a parameterized synchronous FIFO (First-In, First-Out) buffer.

The purpose of the FIFO is to temporarily store data and retrieve it in the same order in which it was written.

This specification serves as the reference for RTL implementation and subsequent functional verification.

### 1.2 Scope

The design shall support:

- Synchronous write and read operations.
- Configurable data width and FIFO depth.
- Full and Empty status indication.
- Simultaneous read and write operations.
- Synchronous reset.
- Correct data ordering and data integrity.
- Pointer wrap-around for arbitrary FIFO depths.

The design is intended to operate using a single clock domain.

---

## 2. Design Parameters

The FIFO shall support the following configurable parameters:

| Parameter     | Default Value | Description                           |
|---------------|---------------|---------------------------------------|
| `DATA_WIDTH`  | 8             | Number of bits per data word          |
| `FIFO_DEPTH`  | 16            | Maximum number of stored data words   |

### 2.1 Parameter Constraints

- `DATA_WIDTH` shall be greater than or equal to 1.
- `FIFO_DEPTH` shall be greater than or equal to 1.
- FIFO depths that are not powers of two shall be supported.

The internal pointer width shall be derived from the FIFO depth:

`PTR_WIDTH = max(1, $clog2(FIFO_DEPTH))`

The occupancy counter shall have sufficient width to represent all values from zero through `FIFO_DEPTH`:

`COUNT_WIDTH = max(1, $clog2(FIFO_DEPTH + 1))`

---

## 3. Interface Description

The FIFO shall expose the following interface signals:

| Signal    | Direction | Width         | Description                       |
|-----------|-----------|:-------------:|-----------------------------------|
| `clk`     | Input     | 1             | System clock                      |
| `reset`   | Input     | 1             | Synchronous active-high reset     |
| `wr_en`   | Input     | 1             | Write enable                      |
| `rd_en`   | Input     | 1             | Read enable                       |
| `din`     | Input     | DATA_WIDTH    | Input data                        |
| `dout`    | Output    | DATA_WIDTH    | Registered output data            |
| `full`    | Output    | 1             | Indicates that the FIFO is full   |
| `empty`   | Output    | 1             | Indicates that the FIFO is empty  |

### 3.1 Clock

All state-changing operations shall occur on the rising edge of `clk`.

### 3.2 Reset

The reset signal shall be synchronous and active-high.

When `reset` is asserted at a rising clock edge:

- The write pointer shall be cleared.
- The read pointer shall be cleared.
- The occupancy counter shall be cleared.
- The output register (`dout`) shall be cleared.
- The FIFO shall enter the Empty state.
- The `full` flag shall be deasserted.

Reset shall have the highest priority over all read and write operations.

The contents of the internal memory array do not need to be physically cleared during reset. They shall be considered invalid because the FIFO occupancy is zero.

---

## 4. Functional Description

### 4.1 Internal Architecture

The FIFO shall contain the following logical components:

- **Memory Array:** Stores the data words.
- **Write Pointer:** Identifies the next memory location available for writing.
- **Read Pointer:** Identifies the next memory location available for reading.
- **Occupancy Counter:** Tracks the number of valid data words currently stored.

The occupancy counter shall always represent a value between zero and `FIFO_DEPTH`, inclusive.

### 4.2 Write Operation

A write operation shall be accepted when:

`wr_en == 1 && full == 0`

On an accepted write operation:

1. The input data (`din`) shall be stored at the current write pointer location.
2. The write pointer shall advance to the next memory location.
3. The FIFO occupancy shall increase by one, unless an accepted read operation occurs during the same clock cycle.

If a write request is asserted while the FIFO is full, the write operation shall be rejected.

A rejected write shall not modify the stored data or advance the write pointer.

### 4.3 Read Operation

A read operation shall be accepted when:

`rd_en == 1 && empty == 0`

On an accepted read operation:

1. The data at the current read pointer location shall be transferred to `dout`.
2. The read pointer shall advance to the next memory location.
3. The FIFO occupancy shall decrease by one, unless an accepted write operation occurs during the same clock cycle.

If a read request is asserted while the FIFO is empty, the read operation shall be rejected.

A rejected read shall not advance the read pointer and shall not modify `dout`.

### 4.4 Simultaneous Read and Write Operations

The FIFO shall support simultaneous read and write requests.

The acceptance of each operation shall be determined by the FIFO status flags at the beginning of the clock cycle.

| FIFO State        | `wr_en`   | `rd_en`   | Accepted Operation    |
|-------------------|:---------:|:---------:|-----------------------|
| Empty             | 1         | 1         | Write only            |
| Full              | 1         | 1         | Read only             |
| Partially Full    | 1         | 1         | Read and Write        |
| Any State         | 0         | 0         | No operation          |

When both operations are accepted:

- The oldest stored data shall be transferred to `dout`.
- The new input data shall be stored in the FIFO.
- Both pointers shall advance.
- The occupancy counter shall remain unchanged.

When the FIFO is Empty, the read request shall be rejected because no previously stored data is available.

When the FIFO is Full, the write request shall be rejected because no free storage location is available at the beginning of the cycle.

### 4.5 Full and Empty Flags

The FIFO shall provide two status flags:

**Empty Flag**

The `empty` flag shall be asserted when:

`occupancy == 0`

**Full Flag**

The `full` flag shall be asserted when:

`occupancy == FIFO_DEPTH`

Both flags shall reflect the current FIFO occupancy and shall update following the corresponding state transition.

The following conditions shall always hold:

- `empty` and `full` shall never be asserted simultaneously.
- The occupancy shall never exceed `FIFO_DEPTH`.
- The occupancy shall never become negative.

### 4.6 Output Data Behavior

The `dout` signal shall be implemented as a registered output.

- Following an accepted read operation, `dout` shall contain the oldest available data word.
- When no read operation is accepted, `dout` shall retain its previous value.
- When a read request is rejected because the FIFO is empty, `dout` shall remain unchanged.
- During reset, `dout` shall be cleared to zero.

The output shall not be required to represent valid FIFO data when no successful read operation has occurred.

---

## 5. Pointer Management

### 5.1 Write Pointer

The write pointer shall identify the next memory location available for writing.

After reaching the final valid memory address (`FIFO_DEPTH - 1`), the pointer shall wrap around to address zero.

### 5.2 Read Pointer

The read pointer shall identify the next memory location available for reading.

After reaching the final valid memory address (`FIFO_DEPTH - 1`), the pointer shall wrap around to address zero.

### 5.3 Non-Power-of-Two Depth Support

Pointer wrap-around shall be explicitly implemented using the configured FIFO depth.

Natural binary overflow shall not be relied upon for pointer wrap-around.

For example, when `FIFO_DEPTH = 6`, the valid pointer addresses shall be:

`0, 1, 2, 3, 4, 5`

After address 5, the pointer shall return to address 0.

---

## 6. Occupancy Management

The occupancy counter shall represent the number of valid data words currently stored in the FIFO.

The following rules shall apply:

| Accepted Write    | Accepted Read | Occupancy Update  |
|:-----------------:|:-------------:|-------------------|
| 0                 | 0             | No change         |
| 1                 | 0             | Increment by 1    |
| 0                 | 1             | Decrement by 1    |
| 1                 | 1             | No change         |

The occupancy counter shall always remain within the valid range:

`0 <= occupancy <= FIFO_DEPTH`

---

## 7. Functional Requirements

The following requirements define the expected behavior of the FIFO.

| Requirement ID    | Description                                                                                   |
|-------------------|-----------------------------------------------------------------------------------------------|
| R01               | The FIFO shall support synchronous active-high reset.                                         |
| R02               | Reset shall initialize the FIFO to the Empty state.                                           |
| R03               | The FIFO shall accept write requests when it is not full.                                     |
| R04               | The FIFO shall reject write requests when it is full.                                         |
| R05               | The FIFO shall accept read requests when it is not empty.                                     |
| R06               | The FIFO shall reject read requests when it is empty.                                         |
| R07               | The FIFO shall preserve the order of stored data.                                             |
| R08               | The FIFO shall preserve data integrity.                                                       |
| R09               | The Full flag shall be asserted when occupancy reaches FIFO_DEPTH.                            |
| R10               | The Empty flag shall be asserted when occupancy reaches zero.                                 |
| R11               | The FIFO shall support simultaneous accepted read and write operations when partially full.   |
| R12               | The occupancy counter shall accurately track the number of stored data words.                 |
| R13               | The write pointer shall wrap around correctly.                                                |
| R14               | The read pointer shall wrap around correctly.                                                 |
| R15               | The FIFO shall support configurable DATA_WIDTH and FIFO_DEPTH parameters.                     |
| R16               | The output data shall update only after an accepted read operation, except during reset.      |

---

## 8. Design Constraints and Assumptions

- All operations shall be synchronous to a single rising-edge clock.
- The FIFO shall not implement asynchronous clock-domain crossing.
- A read request while Empty shall be rejected, even when a write request is asserted simultaneously.
- A write request while Full shall be rejected, even when a read request is asserted simultaneously.
- No additional error or overflow/underflow output signals are required.
- Internal memory contents are considered invalid following reset until written.

---

## 9. Verification Reference

This specification shall serve as the functional reference for:

- RTL implementation.
- Directed functional testing.
- Randomized testing.
- Reference Model and Scoreboard development.
- Assertions and Functional Coverage.
- Regression testing.

All verification scenarios shall be traceable to one or more functional requirements defined in Section 7.

---