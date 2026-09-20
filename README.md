# CompatLab

CompatLab is a hardware and firmware compatibility intelligence platform for engineering teams. It will connect board revisions, installed components, firmware releases, validation evidence, and physical devices so engineers can understand what is safe to release and why.

## Project status

CompatLab is currently in its foundation phase. The repository contains the product specification, target architecture, engineering decisions, development plan, local PostgreSQL configuration, continuous integration workflow, and initial application shell.

The relational schema, compatibility engine, validation workflows, and interactive visualizations are planned work. They are documented here before implementation so the repository history can show how the design develops over time.

## The problem

Firmware compatibility is rarely determined by a version number alone. A release may behave differently across board revisions, bootloaders, component lots, and device configurations. Test results are often scattered across spreadsheets, issue trackers, and laboratory notes, which makes release decisions difficult to explain and reproduce.

CompatLab is designed around one question:

> Which configurations are supported by this release, what evidence supports that decision, and what would be affected if it shipped?

## Planned capabilities

- Compare firmware support across hardware and component configurations.
- Trace transitive dependencies between products, boards, components, and firmware.
- Evaluate release readiness against required validation evidence.
- Detect untested configurations and regressions between releases.
- Inspect the complete configuration and test history of a physical device.
- Visualize release impact as an interactive dependency graph.
- Preserve an auditable explanation for every compatibility decision.

## Technical direction

- Next.js and TypeScript for the application
- PostgreSQL as the system of record
- Hand-written, parameterized SQL for the query layer
- Versioned SQL migrations instead of destructive initialization
- React Flow for dependency and impact visualization
- Automated database, integration, and browser tests
- GitHub Actions with a real PostgreSQL service for continuous integration
- Docker Compose for reproducible local development

## Database focus

The product is intentionally designed so SQL is part of the application logic rather than hidden behind an object-relational mapper. Planned database work includes:

- Recursive common table expressions for dependency traversal
- Temporal ranges and exclusion constraints for configuration history
- Window functions for regression analysis
- Relational division for release-gate evaluation
- Materialized views for coverage summaries
- Transactions, audit triggers, and explicit referential actions
- Index design supported by query-plan analysis

## Architecture

```text
Browser
  -> Next.js routes and components
  -> Application services
  -> Typed SQL query modules
  -> PostgreSQL
```

The application will keep domain decisions, SQL, and presentation concerns separate. See [docs/architecture.md](docs/architecture.md) for the planned boundaries and request flow.

## Repository structure

```text
.
|-- .github/             Issue, pull request, and CI configuration
|-- db/                  SQL migrations, seeds, and database documentation
|-- docs/                Product, architecture, database, and planning documents
|   `-- adr/             Architecture decision records
|-- src/
|   `-- app/             Initial Next.js application shell
|-- tests/               Planned database, integration, and browser test suites
|-- compose.yaml         Local PostgreSQL service
`-- README.md
```

Directories will be expanded only when their first real implementation is added. The intended finished layout is documented in [docs/architecture.md](docs/architecture.md).

## Local setup

### Prerequisites

- Bun 1.3 or newer
- Docker Desktop or another PostgreSQL 18 environment

### Install dependencies

```bash
bun install
```

### Configure the environment

```powershell
Copy-Item .env.example .env.local
```

### Start PostgreSQL

```bash
docker compose up -d database
```

### Start the application

```bash
bun run dev
```

Open `http://localhost:3000`.

## Available commands

- `bun run dev` starts the development server.
- `bun run build` creates a production build.
- `bun run start` runs the production build.
- `bun run lint` runs ESLint.
- `bun run typecheck` checks TypeScript without emitting files.

Database migration and test commands will be added with the first schema implementation rather than documented before they exist.

## Documentation

- [Product specification](docs/product-spec.md)
- [Architecture](docs/architecture.md)
- [Database design](docs/database-design.md)
- [Development and commit plan](docs/development-plan.md)
- [Architecture decisions](docs/adr/)

## Project standards

- Every feature must have an observable user or engineering outcome.
- Database rules should be enforced by the database when practical.
- Dynamic values must be parameterized.
- Migrations must be forward-only and reviewable.
- Tests must exercise real PostgreSQL behavior for database contracts.
- Documentation must distinguish implemented behavior from planned work.
- Performance claims require reproducible evidence.

## Ownership

CompatLab is an independent portfolio project created and maintained by [Farbod Alikhanzadeh](https://github.com/FAR8ODA).

## License

CompatLab is available under the [MIT License](LICENSE).
