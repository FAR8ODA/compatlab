# Database workspace

This directory will contain the database source of truth.

## Planned layout

```text
db/
|-- migrations/       Forward-only versioned SQL migrations
|-- seeds/            Deterministic synthetic demonstration data
|-- queries/          Reviewable SQL used for analysis and documentation
`-- README.md
```

The first schema commit will introduce the migration runner and initial domain tables. Seed data will arrive separately so schema design and demonstration content remain independently reviewable.

Generated database dumps, local volumes, and credentials do not belong in this directory.
