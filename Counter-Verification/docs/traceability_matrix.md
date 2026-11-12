# Counter Verification Traceability Matrix

## 1. Requirement-to-Test Mapping

| Requirement ID |           Test Cases             |       Assertion       | Coverage Item |
|----------------|----------------------------------|-----------------------|---------------|
| RQ-001         | TC-017, TC-018                   | AST-006               | COV-001       |
| RQ-002         | TC-001, TC-005, TC-008           | AST-001               | COV-002       |
| RQ-003         | TC-002, TC-004, TC-011           | AST-002               | COV-003       |
| RQ-004         | TC-003, TC-014                   | AST-003               | COV-004       |
| RQ-005         | TC-006, TC-016                   | AST-004               | COV-005       |
| RQ-006         | TC-007, TC-012, TC-013           | AST-005               | COV-006       |
| RQ-007         | TC-019, TC-020, TC-021           | N/A                   | COV-007       |
| RQ-008         | TC-020 using default parameter   | N/A                   | COV-007       |
| RQ-009         | TC-001, TC-017                   | AST-001, AST-006      | COV-002       |
| RQ-010         | TC-019, TC-020, TC-021           | N/A                   | COV-007       |
| RQ-011         | TC-009, TC-010, TC-015           | AST-001 to AST-004    | COV-008       |
| RQ-012         | TC-022                           | Configuration Check   | N/A           |

## 2. Assertion Mapping

| Assertion ID |                        Description                             |
|--------------|----------------------------------------------------------------|
| AST-001      | Reset causes count to become zero                              |
| AST-002      | Enabled counter increments by one                              |
| AST-003      | Disabled counter holds its value                               |
| AST-004      | Reset has priority over enable                                 |
| AST-005      | Counter wraps around after maximum value                       |
| AST-006      | Counter output changes only on the rising edge of the clock    |

## 3. Coverage Mapping

| Coverage ID |          Description            |
|-------------|---------------------------------|
| COV-001     | Clock-related behavior          |
| COV-002     | Reset behavior                  |
| COV-003     | Increment operation             |
| COV-004     | Hold operation                  |
| COV-005     | Reset and enable combination    |
| COV-006     | Overflow                        |
| COV-007     | Parameter configurations        |
| COV-008     | Different operational sequences |

## 4. Verification Status

|  Requirement ID  |   Status    |                  Comments                    |
|------------------|-------------|----------------------------------------------|
| RQ-001 to RQ-012 | IN_PROGRESS | Update after implementation and simulation   |

Note: A requirement shall only be marked PASS after its corresponding tests have been executed successfully.