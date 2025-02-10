# PGX Adapter

[![Tests](https://github.com/pckhoi/casbin-pgx-adapter/actions/workflows/ci.yml/badge.svg)](https://github.com/global-soft-ba/casbin-pgx-adapter/actions/workflows/ci.yml)
[![Coverage Status](https://coveralls.io/repos/github/pckhoi/casbin-pgx-adapter/badge.svg?branch=main)](https://coveralls.io/github/pckhoi/casbin-pgx-adapter?branch=main)

PGX Adapter is the [pgx](https://github.com/jackc/pgx) adapter for [Casbin](https://github.com/casbin/casbin). With this library, Casbin can load policy from PostgreSQL or save policy to it.

## Installation

    go get global-soft-ba/casbin-pgx-adapter

## Simple Postgres Example

```go
package main

import (
	pgxadapter "github.com/global-soft-ba/casbin-pgx-adapter"
	"github.com/casbin/casbin/v2"
)

func main() {
	// Initialize a PGX adapter and use it in a Casbin enforcer:
	// The adapter will use the Postgres database named "casbin".
	// If it doesn't exist, the adapter will create it automatically.
	a, _ := pgxadapter.NewAdapter("postgresql://username:password@postgres:5432/database?sslmode=disable") // Your driver and data source.
	// Alternatively, you can construct an adapter instance with *pgx.ConnConfig:
    // conf, _ := pgx.ParseConfig("postgresql://pguser:pgpassword@localhost:5432/pgdb?sslmode=disable")
	// a, _ := pgxadapter.NewAdapter(conf)

	// The adapter will use the table named "casbin_rule" by default.
	// If it doesn't exist, the adapter will create it automatically.

	e := casbin.NewEnforcer("examples/rbac_model.conf", a)

	// Load the policy from DB.
	e.LoadPolicy()

	// Check the permission.
	e.Enforce("alice", "data1", "read")

	// Modify the policy.
	// e.AddPolicy(...)
	// e.RemovePolicy(...)

	// Save the policy back to DB.
	e.SavePolicy()
}
```

## Support for FilteredAdapter interface

You can [load a subset of policies](https://casbin.org/docs/en/policy-subset-loading) with this adapter:

```go
package main

import (
	"github.com/casbin/casbin/v2"
	pgxadapter "github.com/global-soft-ba/casbin-pgx-adapter"
)

func main() {
	a, _ := pgxadapter.NewAdapter("postgresql://username:password@postgres:5432/database?sslmode=disable")
	e, _ := casbin.NewEnforcer("examples/rbac_model.conf", a)

	e.LoadFilteredPolicy(&pgxadapter.Filter{
		P: [][]string{{"", "data1"}},
		G: [][]string{{"alice"}},
	})
	...
}
```

## Custom database name and table name

You can provide a custom table or database name with option functions

```go
package main

import (
	"github.com/casbin/casbin/v2"
	pgxadapter "github.com/global-soft-ba/casbin-pgx-adapter"
	"github.com/jackc/pgx/v5"
)

func main() {
    conf, _ := pgx.ParseConfig("postgresql://pguser:pgpassword@localhost:5432/pgdb?sslmode=disable")

    a, _ := pgxadapter.NewAdapter(conf,
        pgxadapter.WithDatabase("custom_database"),
        pgxadapter.WithTableName("custom_table"),
    )
	e, _ := casbin.NewEnforcer("examples/rbac_model.conf", a)
    ...
}
```

## Run all tests

To run all tests, follow these steps:

1. Ensure you have Docker and Docker Compose installed.
2. Open a terminal and navigate to the root directory of the project.
3. Run the following command:

    ```sh
    make all-for-tests
    ```

This command will:
- Start the PostgreSQL container.
- Run the tests.
- Stop the PostgreSQL container.

## Getting Help

- [Casbin](https://github.com/casbin/casbin)

## License

This project is under Apache 2.0 License. See the [LICENSE](LICENSE) file for the full license text.
