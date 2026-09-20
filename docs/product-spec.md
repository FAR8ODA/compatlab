# Product specification

## Product statement

CompatLab helps an engineering team determine whether a firmware release is compatible with the hardware configurations it may reach and inspect the evidence behind that decision.

## Primary user

The primary user is an embedded, firmware, validation, or systems engineer preparing a release across multiple board and component revisions.

## Core questions

CompatLab must eventually answer:

1. Which configurations are supported by a firmware release?
2. Which required tests support each compatibility decision?
3. Which configurations are untested, failing, or blocked?
4. Which physical devices would be affected by a proposed release?
5. What changed between two releases or test campaigns?
6. How did a specific device configuration evolve over time?

## Demonstration scenario

The public demonstration will use a synthetic family of embedded controllers with multiple board revisions, component alternatives, bootloader versions, firmware releases, and validation suites.

One release candidate will contain a deliberate compatibility problem. The application must expose the problem through the matrix, impact graph, device history, and release gate without relying on hard-coded interface logic.

## Planned workflows

### Review fleet readiness

An engineer opens the overview and sees supported, blocked, failing, and untested configuration counts derived from the database.

### Inspect a compatibility decision

An engineer selects a hardware and firmware pair, then reviews the relevant components, requirements, latest tests, failures, and decision history.

### Evaluate a release candidate

An engineer selects a release candidate. CompatLab checks every required configuration and test, then explains which conditions prevent approval.

### Trace release impact

An engineer explores a dependency graph from firmware release to affected hardware configurations and physical devices.

### Investigate a device

An engineer opens a device record and reviews its assembly, component, firmware, testing, and failure timeline.

## Non-goals for version 1

- Controlling physical laboratory equipment
- Flashing firmware onto devices
- Replacing a full product lifecycle management system
- Production authentication or enterprise authorization
- Predicting failures with machine learning
- Claiming regulatory compliance or safety certification

## Version 1 completion criteria

- The application implements all five planned workflows.
- Compatibility and release status are derived from relational data.
- The database rejects invalid temporal and referential states.
- Recursive impact analysis works for multi-level dependencies.
- Automated tests cover schema invariants and critical workflows.
- A new developer can run the project from documented instructions.
- The deployed demonstration uses synthetic data and contains no secrets.
