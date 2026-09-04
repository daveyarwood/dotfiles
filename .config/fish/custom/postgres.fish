# Homebrew keeps libpq keg-only because its ~34 binaries (psql, pg_dump,
# initdb, ...) collide with the postgresql formula's, so `pg_config` never
# lands on PATH — and psycopg2 needs it to build from source.
add-dirs-to-path /opt/homebrew/opt/libpq/bin
