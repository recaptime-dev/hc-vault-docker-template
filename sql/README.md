# Documentation for Initializing PostgresDB for Vault

Currently, you need to manually initialize the Postgres database before running a Vault server. If you running this in Docker using either our bootstrap script
or our Docker image available at GHCR and RHQCR, you don't need to do this again as we'll run these scripts.

## With Postgres CLI client

1. Download the `initdb.sql` file first with wget:

```sh
wget https://github.com/MadeByThePinsHub/hc-vault-docker-template/raw/main/sql/manual/init-db.sql
```

2. Import with `psql`:

```sh
# Notes:
# 1. If you don't want to make your database password to be stored in terminal history, omit the PGPASSWORD=shitfuckery part to interactively enter your password
# when prompted.

# What to replace with your own values:
#  - shitfuckery: Postgres database password, if PGPASSWORD= is prefixed
#  - localhost: Postgres host 
#  - 5432: Postgres port
#  - bullshithq: Postgres database user
#  - hashcorpvault_db: Postgres database name
PGPASSWORD=shitfukery psql -h localhost -p 5432 -U bullshithq -d hashicorpvault_db < init-db.sql
```

3. Now you can start the server with `vault server -config=/path/to/config_dir/optionally_filename.hcl`.

## With Node.js

TODO
