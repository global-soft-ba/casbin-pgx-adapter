.PHONY: start-postgres stop-postgres run-tests

# Start the PostgreSQL container
start-postgres:
	docker-compose up -d

# Stop the PostgreSQL container
stop-postgres:
	docker-compose down

# Run tests
run-tests:
	PG_CONN=postgresql://postgres:postgres@localhost:5435/postgres?sslmode=disable go test -v -count=1 ./... -coverpkg=./...

# Run all commands needed for tests in sequence
all-for-tests: start-postgres run-tests stop-postgres