# Incident Note

## What Happened

A developer tried to fix invalid contest status values in the `contests` table. The goal was to update only contests with the status `published` and change them to `active`.

However, the UPDATE statement was run without a proper WHERE clause. As a result, all contest records in the table were changed, and every contest status turned to `active`.

## What Was Affected

All contest records in the `contests` table were affected.

Incorrect changes included:

* scheduled contests becoming active
* completed contests becoming active
* upcoming contests losing their original status

Because of this:

* contest scheduling became inaccurate
* reports showed incorrect contest states
* users could see inactive contests as active
* contest workflow tracking became unreliable

## How It Could Be Detected

The issue could be found by running a SELECT query after the UPDATE operation.

Example:

```sql
SELECT contest_id, contest_status
FROM contests;
```

The result would show that every contest had the same status value.

The problem could also be detected by:

* comparing current records with backup data
* checking audit logs
* monitoring sudden large-scale row updates
* verifying unusually high numbers of modified rows

## How Rollback Could Have Helped

If the developer had used a transaction, the mistake could have been reversed safely before finalizing the changes.

Example:

```sql
BEGIN TRANSACTION;

UPDATE contests
SET contest_status = 'active'
WHERE contest_status = 'published';

-- verify changes first

ROLLBACK;
```

After reviewing the results, the developer would see whether unexpected rows were changed.

If the update was correct, `COMMIT` could replace `ROLLBACK`.

Using transactions helps prevent accidental permanent changes.

## What To Do in Future

To avoid similar incidents in future database operations:

* always include a proper WHERE clause in UPDATE and DELETE statements
* always run a SELECT query first to verify affected rows
* use transactions for risky operations
* verify row counts before finalizing changes
* create backups before large updates
* test updates in staging tables before applying them to production data
* review queries carefully before running them
* enable logging or auditing for critical database changes

These practices help improve database safety and reduce the chance of accidental data corruption.
