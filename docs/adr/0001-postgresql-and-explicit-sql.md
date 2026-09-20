# 0001: PostgreSQL and explicit SQL

## Status

Accepted

## Context

CompatLab depends on recursive dependency traversal, temporal configuration history, strong relational constraints, analytical queries, and auditable release decisions. The project also exists to demonstrate database engineering directly.

## Decision

PostgreSQL will be the system of record. Application queries will be written as explicit, parameterized SQL behind typed TypeScript functions. An object-relational mapper will not own the schema or hide the core queries.

## Consequences

- Database behavior remains directly reviewable.
- PostgreSQL-specific capabilities can be used deliberately.
- Query mapping and migration discipline require more explicit code.
- Portability to a different database is not a version 1 objective.
