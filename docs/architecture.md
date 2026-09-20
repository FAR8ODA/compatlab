# Architecture

## Design goals

- Keep PostgreSQL visible as a central engineering component.
- Separate domain behavior from rendering and transport concerns.
- Make compatibility decisions reproducible and explainable.
- Keep local development and continuous integration consistent.
- Prefer explicit contracts over framework magic.

## Target request flow

```text
User interaction
  -> Next.js route or server action
  -> Domain service
  -> Typed query function
  -> Parameterized SQL
  -> PostgreSQL transaction
  -> Typed result
  -> Server-rendered or interactive interface
```

## Target repository layout

```text
.
|-- .github/
|   |-- ISSUE_TEMPLATE/
|   `-- workflows/
|-- db/
|   |-- migrations/
|   |-- queries/
|   `-- seeds/
|-- docs/
|   |-- adr/
|   |-- architecture.md
|   |-- database-design.md
|   |-- development-plan.md
|   `-- product-spec.md
|-- src/
|   |-- app/
|   |   |-- actions/
|   |   |-- api/
|   |   |-- compatibility/
|   |   |-- devices/
|   |   |-- releases/
|   |   `-- validation/
|   |-- components/
|   |   |-- charts/
|   |   |-- graph/
|   |   |-- layout/
|   |   `-- ui/
|   |-- db/
|   |   |-- client.ts
|   |   |-- queries/
|   |   `-- types.ts
|   |-- domain/
|   |   |-- compatibility/
|   |   |-- devices/
|   |   |-- releases/
|   |   `-- validation/
|   `-- lib/
|-- tests/
|   |-- database/
|   |-- integration/
|   `-- e2e/
|-- compose.yaml
`-- package.json
```

Directories are created when their first implementation is introduced. Empty architecture should not masquerade as finished code.

## Application boundaries

### Presentation

Routes and components display state, collect user intent, and provide accessible interaction. They do not construct SQL or decide release readiness.

### Domain services

Domain services coordinate workflows such as evaluating a release candidate. They operate on typed inputs and outputs without depending on React.

### Query layer

Query modules own parameterized SQL and map database rows into domain types. Complex SQL remains readable and reviewable rather than being reconstructed through an ORM.

### Database

PostgreSQL owns referential integrity, temporal exclusions, important state invariants, and transactional consistency.

## Planned deployment

- Vercel for the Next.js application
- Neon PostgreSQL for the hosted demonstration
- Docker Compose with PostgreSQL 18 for local development
- GitHub Actions with PostgreSQL for integration tests

Deployment choices may change through an architecture decision record if implementation evidence supports a better option.
