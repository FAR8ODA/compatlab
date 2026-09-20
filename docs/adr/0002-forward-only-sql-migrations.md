# 0002: Forward-only SQL migrations

## Status

Accepted

## Context

The project needs a reviewable record of schema evolution. Recreating the entire public schema is convenient for a classroom demonstration but does not represent a safe application workflow.

## Decision

Schema changes will use ordered, forward-only SQL migration files tracked in a migration table. Seed data will be managed separately.

## Consequences

- Existing databases can advance without losing all data.
- Every structural change has a visible historical reason.
- Destructive changes require explicit data movement and rollback planning.
- Local setup needs a migration command that will be introduced with the first schema.
