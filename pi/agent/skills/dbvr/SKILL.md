---
name: dbvr
description: Query databases and export results to CSV using the dbvr CLI (DBeaver command-line interface). Use when you need to run SQL queries, inspect database data, list tables, get table DDL, or export query results to CSV. Activate when the user mentions dbvr, DBeaver CLI, database export, or needs to query a database from the command line.
---

# DBVR — DBeaver CLI

## Binary

```
/Applications/dbvr.app/Contents/MacOS/dbvr
```

Add to PATH (optional):
```bash
source /Applications/dbvr.app/Contents/MacOS/add-dbvr-ce-to-path.sh
```

## List Available Datasources

```bash
dbvr datasource list
```

## View Datasource Details

```bash
dbvr datasource view <name>
```

## Run a SQL Query

```bash
dbvr sql -ds=<datasource> "SELECT * FROM schema.TableName"
```

## Export Query to CSV File

```bash
dbvr sql -ds=<datasource> --disable-status -format=csv -out=output.csv "SELECT * FROM schema.TableName"
```

## Export to CSV via stdout

```bash
dbvr sql -ds=<datasource> --disable-status -format=csv "SELECT * FROM schema.TableName" 2>/dev/null > output.csv
```

## Run SQL from a File

```bash
dbvr sql -ds=<datasource> --disable-status -format=csv -in=query.sql
```

## Metadata Commands

### List tables in a schema

```bash
dbvr meta table list -ds=<datasource> -db=<database> -sn=<schema>
```

### Get table DDL

```bash
dbvr meta table ddl -ds=<datasource> -db=<database> -sn=<schema> =<TableName>
```

## Key Flags

| Flag | Description |
|------|-------------|
| `-ds=<name>` | Datasource name (from `datasource list`) |
| `-format=csv` | Output as CSV (default is table) |
| `-out=<file>` | Write output to file |
| `-in=<file>` | Read SQL from file |
| `--disable-status` | Suppress "Rows read" footer |
| `-l=<limit>` | Limit rows (default 1000). Use `-l=0` for all rows |
| `-op=<params>` | Output format params: `delimiter=\|,quoteall=true` |
| `-u=<user>` | Database user |
| `-p=<password>` | Database password |
| `2>/dev/null` | Suppress Java/TLS warnings from stderr |
