# Database Backup System

## Automatic Protection

The database backup system automatically creates backups before any dangerous operations in development:
- `rails db:reset` - automatically backed up first
- `rails db:drop` - automatically backed up first

## Manual Backup Commands

### Create a backup
```bash
bin/rails db:backup:create
```
Creates a timestamped backup in `db/backups/`. Automatically keeps only the last 10 backups.

### List all backups
```bash
bin/rails db:backup:list
```
Shows all available backups with size and date.

### Restore from backup
```bash
bin/rails db:backup:restore[development_20231103_120000.dump]
```
Restores your database from the specified backup file. **Only works in development for safety.**

## Important Notes

1. Backups are stored in `db/backups/` (not tracked in git)
2. Old backups are automatically cleaned up (keeps last 10)
3. Always create a manual backup before making major changes:
   ```bash
   bin/rails db:backup:create
   ```
4. Test environment uses transactional fixtures - no backups needed

## Recovery Example

If you lose data:
1. List available backups: `bin/rails db:backup:list`
2. Restore the one you want: `bin/rails db:backup:restore[filename]`

## Requirement

PostgreSQL command-line tools must be installed (pg_dump and pg_restore).
On macOS with Postgres.app, these are usually already available.

