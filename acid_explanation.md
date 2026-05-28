## ACID Properties
## Atomicity
Atomicity means the transaction is all-or-nothing. In this example, the database must not allow a situation where ₹1000 is deducted from Account A but not added to Account B. If the second update fails, the first update must also be undone through rollback.
For this reason, both SQL updates are grouped into one transaction. The transfer succeeds only when both operations complete successfully. If not, there is no permanent change.

## Consistency
Consistency means the database moves from one valid state to another valid state while following all defined rules and constraints. In this example, the total amount of money across both accounts should stay the same before and after the transfer. The transaction must uphold that rule.
For instance, if Account A has ₹5000 and Account B has ₹3000 before the transaction, the total is ₹8000. After transferring ₹1000, the balances become ₹4000 and ₹4000, so the total remains ₹8000. If a partial update breaks this rule, the transaction must be rejected or rolled back.

## Isolation
Isolation means concurrent transactions should not interfere with each other. While this transfer is running, another transaction should not read half-updated data, such as seeing Account A debited before Account B is credited, because that would create an incorrect intermediate view.
The database handles concurrent operations as if transactions are executed one after another, even when they happen simultaneously. This prevents issues like dirty reads and inconsistent results in balance calculations.

## Durability
Durability means that once the transaction is committed, the changes are permanently stored and will survive system failure. In this example, after the COMMIT, the updated balances of both accounts must remain saved even if the server crashes immediately afterward.
This typically supported through transaction logs and recovery methods. As a result, a completed money transfer is preserved after power failure, restart, or crash recovery.

## Example Transaction Script
```sql
BEGIN TRANSACTION;

UPDATE Accounts
SET balance = balance - 1000
WHERE account_id = 'A';

UPDATE Accounts
SET balance = balance + 1000
WHERE account_id = 'B';

COMMIT;
```
Here, ₹1000 is deducted from Account A and added to Account B in one transaction block. If any of the statement fails before COMMIT, the database will  roll back the entire transaction to ensure the data is safe in it.
