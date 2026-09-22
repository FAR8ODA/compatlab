# Database design

## Status

Migration `0001_catalog.sql` establishes the first implemented part of the model: the hardware and firmware catalogs. Device history, validation, release candidates, and compatibility decisions remain planned work for later Phase 1 commits.

## Implemented catalog

### Product hardware

- `product_family` identifies a product line.
- `board_revision` records a physical board revision and its lifecycle.
- `component` identifies a manufacturer and component independent of revision.
- `component_revision` records revision-specific part information and specifications.
- `component_lot` records supplier lots for a component revision.
- `board_bom_item` assigns component revisions to positions on a board revision.
- `component_bom_item` represents nested hardware assemblies.

### Firmware

- `firmware_project` identifies an independently versioned firmware product.
- `firmware_release` stores structured semantic versions and release state.
- `firmware_release_dependency` creates directed bootloader, runtime, radio, or toolchain dependencies between releases.

The catalog uses generated identity keys internally while preserving natural uniqueness through explicit constraints. Foreign-key actions are stated rather than left implicit. Indexes are present for reverse dependency and bill-of-material lookups that are not already supported by a unique constraint.

Multi-level dependency cycles are not yet rejected by the database. That rule will be addressed with the Phase 1 invariant work after the complete device-history model is present.

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
