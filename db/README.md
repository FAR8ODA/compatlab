# Database workspace

This directory contains the database source of truth.

## Planned layout

```text
db/
|-- migrations/       Forward-only versioned SQL migrations
|-- seeds/            Deterministic synthetic demonstration data
|-- queries/          Reviewable SQL used for analysis and documentation
`-- README.md
```

## Current migrations

- `0001_catalog.sql` creates the `compatlab` schema and the initial hardware and firmware catalog.

The migration runner will be introduced with the device-history work. Until then, the catalog migration can be applied directly with `psql` in a disposable local database:

```bash
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f db/migrations/0001_catalog.sql
```

Seed data will arrive separately so schema design and demonstration content remain independently reviewable.

## Migration rules

- Apply migrations in numeric order.
- Do not edit a migration after it has been committed to `main`.
- Add a new migration for every schema change.
- Keep schema migrations separate from demonstration seeds.
- Use explicit constraints and referential actions.

Generated database dumps, local volumes, and credentials do not belong in this directory.
