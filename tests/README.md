# Test strategy

Tests will be added with the behavior they validate.

## Planned suites

```text
tests/
|-- database/       Constraints, migrations, and advanced SQL behavior
|-- integration/    Application services against real PostgreSQL
`-- e2e/            Critical browser workflows
```

Database and integration tests will use an isolated PostgreSQL instance locally and in GitHub Actions. Mocked SQL is not sufficient evidence for database contracts.

The first executable tests will arrive in the relational-foundation phase.
