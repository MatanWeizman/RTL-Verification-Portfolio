# Counter Requirements

## 1. Functional Requirements

|   ID   |                                          Requirement                                                     | Priority |
|--------|----------------------------------------------------------------------------------------------------------|----------|
| RQ-001 | The counter shall update its output only on the rising edge of the clock.                                |   High   |
| RQ-002 | The counter shall synchronously reset its output to zero when reset is asserted.                         |   High   |
| RQ-003 | The counter shall increment by one when reset is deasserted and enable is asserted.                      |   High   |
| RQ-004 | The counter shall retain its previous value when both reset and enable are deasserted.                   |   High   |
| RQ-005 | Reset shall have priority over enable when both signals are asserted.                                    |   High   |
| RQ-006 | The counter shall wrap around to zero after reaching its maximum representable value.                    |   High   |
| RQ-007 | The counter width shall be configurable through the WIDTH parameter.                                     |   High   |
| RQ-008 | The default value of WIDTH shall be 4.                                                                   |   Medium |
| RQ-009 | Reset shall be synchronous and shall not asynchronously modify the counter output.                       |   High   |
| RQ-010 | The counter shall operate correctly for multiple valid WIDTH configurations.                             |   High   |
| RQ-011 | The counter shall correctly handle consecutive and changing sequences of reset and enable operations.    |   High   |
| RQ-012 | WIDTH shall be greater than or equal to 1.                                                               |   High   |

## 2. Configuration Requirements

|   ID    | Parameter | Default | Constraint |
|---------|-----------|---------|------------|
| CFG-001 |   WIDTH   |    4    | WIDTH >= 1 |

## 3. Verification Acceptance Criteria

The design shall be considered functionally verified when:

1. All mandatory functional requirements have corresponding test cases.
2. All mandatory test cases pass.
3. The reference model and DUT outputs match throughout the simulation.
4. All required assertions pass.
5. All defined functional coverage goals are reached.
6. The simulation completes without unexpected errors.

## 4. Requirement Status

Requirements shall be tracked using the following statuses:

- NOT_STARTED
- IN_PROGRESS
- PASS
- FAIL

A requirement may only be marked PASS after its associated verification checks have completed successfully.