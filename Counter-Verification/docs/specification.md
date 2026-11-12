# Counter Specification

## 1. Overview

This document defines the functional specification of a parameterized synchronous binary counter.

The counter increments its value on every rising edge of the clock when counting is enabled. It supports a synchronous active-high reset and configurable output width.

## 2. Interface Description

| Signal | Direction |          Description          |
|--------|-----------|-------------------------------|
|  clk   |   Input   | Clock signal                  |
| reset  |   Input   | Active-high synchronous reset |
| enable |   Input   | Enables counter increment     |
| count  |  Output   | Current counter value         |
| WIDTH  | Parameter | Counter width (default: 4)    |

## 3. Functional Description

### 3.1 Clock Behavior

The counter updates its output only on the rising edge of `clk`.

### 3.2 Reset Behavior

When `reset` is asserted at a rising clock edge, the counter output is set to zero.

Reset is synchronous and has the highest priority.

### 3.3 Enable Behavior

When `reset` is deasserted and `enable` is asserted, the counter increments by one on every rising clock edge.

### 3.4 Hold Behavior

When both `reset` and `enable` are deasserted, the counter retains its previous value.

### 3.5 Overflow Behavior

The counter operates as an unsigned binary counter.

When the maximum representable value is reached, the next increment wraps the counter back to zero.

The maximum value is:

`2**WIDTH - 1`

### 3.6 Parameterization

The counter width is configurable through the `WIDTH` parameter.

The default value is 4.

Valid configurations require `WIDTH >= 1`.

## 4. Operation Priority

The following priority shall be implemented:

1. Reset
2. Enable
3. Hold

| Reset | Enable | Expected Behavior |
|-------|--------|-------------------|
|   0   |   0    | Hold              |
|   0   |   1    | Increment         |
|   1   |   0    | Reset             |
|   1   |   1    | Reset             |

## 5. Reset Characteristics

- Reset type: Synchronous
- Reset polarity: Active High
- Reset priority: Highest

## 6. Scope

This project verifies the functional behavior of the counter through simulation.

Physical implementation, timing closure, power consumption and synthesis optimization are outside the scope of this project.