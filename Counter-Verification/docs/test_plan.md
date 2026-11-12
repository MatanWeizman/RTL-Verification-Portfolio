# Counter Verification Test Plan

## 1. Objective

The objective of this test plan is to verify the functional correctness of the parameterized synchronous counter.

Verification will include directed testing, boundary testing, corner cases, random stimulus, assertions and functional coverage.

## 2. Verification Environment

The verification environment consists of:

- DUT: Counter RTL implementation.
- Test: Generates directed and random stimulus.
- Monitor: Observes DUT inputs and outputs.
- Reference Model: Calculates expected counter behavior.
- Scoreboard: Compares actual and expected results.
- Assertions: Verify temporal and functional properties.
- Coverage: Tracks exercised functional scenarios.

## 3. Directed Test Cases

| Test ID |             Test Description                 |            Expected Result            |
|---------|----------------------------------------------|---------------------------------------|
| TC-001  | Apply reset at a rising clock edge           | Count becomes zero                    |
| TC-002  | Enable counting for several cycles           | Count increments by one per cycle     |
| TC-003  | Disable enable during counting               | Count holds its previous value        |
| TC-004  | Re-enable counting after a hold period       | Counting resumes correctly            |
| TC-005  | Assert reset during active counting          | Count becomes zero                    |
| TC-006  | Assert reset and enable simultaneously       | Count becomes zero                    |
| TC-007  | Count through the maximum value              | Counter wraps to zero                 |
| TC-008  | Keep reset asserted for multiple cycles      | Count remains zero                    |
| TC-009  | Change enable repeatedly                     | Count updates only when enabled       |
| TC-010  | Apply multiple consecutive reset operations  | Count is correctly reset each time    |

## 4. Boundary and Corner Case Testing

| Test ID |                 Scenario                     |                     Expected Result                      |
|---------|----------------------------------------------|----------------------------------------------------------|
| TC-011  | Increment from 0 to 1                        | Count equals 1                                           |
| TC-012  | Increment from MAX-1 to MAX                  | Count equals MAX                                         |
| TC-013  | Increment from MAX to 0                      | Counter wraps around                                     |
| TC-014  | Disable enable when count is MAX             | Count remains MAX                                        |
| TC-015  | Assert reset when count is MAX               | Count becomes zero                                       |
| TC-016  | Assert reset and enable when count is MAX    | Count becomes zero                                       |
| TC-017  | Assert reset between clock edges             | Count does not change until the next rising edge         |
| TC-018  | Change enable between clock edges            | Count changes only according to the next rising edge     |

## 5. Parameterization Testing

| Test ID | WIDTH |         Expected Behavior           |
|---------|-------|-------------------------------------|
| TC-019  |   1   | Counter cycles between 0 and 1      |
| TC-020  |   4   | Counter cycles between 0 and 15     |
| TC-021  |   8   | Counter cycles between 0 and 255    |

Additional configuration test:

- TC-022: Attempt to elaborate the design with WIDTH=0 and verify that the configuration is rejected.

## 6. Random Testing

Random stimulus shall be applied to reset and enable.

The random test shall include:

- Random reset assertion and deassertion.
- Random enable assertion and deassertion.
- Consecutive enabled cycles.
- Consecutive disabled cycles.
- Simultaneous reset and enable.
- Repeated transitions between operational modes.

All DUT outputs shall be checked against the reference model.

A reproducible random seed should be used when possible.

## 7. Assertions

The verification environment shall include properties for:

- Synchronous reset behavior.
- Counter increment behavior.
- Counter hold behavior.
- Reset priority.
- No output change between active clock edges.

## 8. Functional Coverage

The following functional coverage goals shall be tracked:

- Reset asserted.
- Enable asserted.
- Enable deasserted.
- Counter increment operation.
- Counter hold operation.
- Simultaneous reset and enable.
- Overflow.
- Reset during counting.
- Counter reaching zero.
- Counter reaching its maximum value.
- Multiple WIDTH configurations.

The four combinations of reset and enable shall be exercised.

## 9. Pass/Fail Criteria

A test passes when the observed DUT behavior matches the expected behavior.

A test fails if:

- An unexpected counter value is observed.
- An assertion fails.
- An illegal configuration is accepted.
- A required functional coverage goal remains unachieved.

The overall verification result shall be PASS only when all mandatory tests and acceptance criteria are satisfied.