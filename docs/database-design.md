# Database design

## Status

This document describes the intended modeling direction before the first schema migration. Table names, keys, and constraints will be finalized during the schema phase and updated alongside the implementation.

## Domain areas

### Hardware catalog

- Product families
- Board revisions
- Components and component revisions
- Component lots
- Hierarchical bills of materials

### Device fleet

- Serialized physical devices
- Installed hardware and component history
- Firmware installation history
- Device lifecycle events

### Firmware catalog

- Firmware projects
- Versioned releases
- Bootloader and firmware dependencies
- Release candidates

### Validation

- Test suites and test cases
- Required tests by supported configuration
- Test runs and individual results
- Failure signatures and linked evidence

### Compatibility

- Candidate hardware and firmware configurations
- Compatibility decisions
- Evidence attached to decisions
- Audit history

## Core invariants

The schema should enforce these rules where practical:

- A revision belongs to exactly one parent product or component.
- A physical device has one stable serial identity.
- Firmware installation periods for the same device cannot overlap.
- Component installation periods for the same device position cannot overlap.
- A test result belongs to a test case included in its test suite.
- A release cannot be approved when required evidence is missing or failing.
- Dependency cycles are rejected or detected before they can affect traversal.
- Compatibility decisions preserve who or what produced the decision and when.

## Planned SQL demonstrations

### Recursive dependency traversal

Use a recursive common table expression to find direct and transitive hardware or firmware dependencies and calculate release impact.

### Temporal configuration lookup

Use timestamp ranges to reconstruct the hardware and firmware installed on a device at any selected time.

### Regression comparison

Use `LAG`, partitioned aggregates, and filtered counts to compare test outcomes between firmware releases.

### Release-gate division

Use relational division to verify that every required test has a passing result for every configuration included in a release candidate.

### Coverage summary

Use a materialized view to summarize validation coverage for the overview and compatibility matrix.

## Migration policy

- SQL migrations are immutable after merging.
- Every schema change receives a new ordered migration.
- Destructive changes require an explicit data-migration plan.
- Seed data is separate from schema migrations.
- Rollback strategy is documented for changes that cannot be reversed automatically.

## Performance policy

Indexes will be added in response to known access paths. Performance documentation must include the query, representative data volume, and `EXPLAIN ANALYZE` evidence rather than unsupported claims.
