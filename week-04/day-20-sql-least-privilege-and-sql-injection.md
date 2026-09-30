# Day 20 — SQL least privilege and SQL injection

**Week 4 · about 45 minutes · Run in: Ubuntu (WSL) terminal + DbVisualizer**

## Why this matters
Least privilege and SQL injection are two of the most tested security ideas. You will show both with commands, on your own database.

## Goal today
Create a read-only database user, prove it cannot write, and see why string-built SQL is dangerous while parameterised SQL is safe.

## Commands you will learn

| Command | What it does |
|---|---|
| `CREATE USER` | make a database login |
| `GRANT SELECT ON db.* TO user` | give only read permission |
| `SHOW GRANTS FOR user` | list what a user may do |
| `REVOKE` | remove a permission |
| `PREPARE / EXECUTE` | parameterised (safe) queries in plain SQL |

## Do this (run each block, then read the output before moving on)
```bash
docker start mysql-lab           # if it is stopped
docker exec -it mysql-lab mysql -uroot -pLabOnly123 shop
```

```sql
-- 1. Least privilege
CREATE USER 'app_ro'@'%' IDENTIFIED BY 'LabOnly456';
GRANT SELECT ON shop.* TO 'app_ro'@'%';
SHOW GRANTS FOR 'app_ro'@'%';
EXIT;
```

```bash
# Log in as the read-only user and try to write
docker exec -it mysql-lab mysql -uapp_ro -pLabOnly456 shop -e "SELECT * FROM users;"
docker exec -it mysql-lab mysql -uapp_ro -pLabOnly456 shop -e "INSERT INTO users (name,email) VALUES ('x','x@x.test');"
```

```sql
-- 2. Injection: what a string-built query does with hostile input
-- The app would build:  SELECT * FROM users WHERE name = '<input>'
-- With input  ' OR '1'='1   it becomes:
SELECT * FROM users WHERE name = '' OR '1'='1';          -- returns EVERY row

-- 3. The safe way: a parameterised query treats the input as data
PREPARE stmt FROM 'SELECT * FROM users WHERE name = ?';
SET @n = ''' OR ''1''=''1';
EXECUTE stmt USING @n;                                   -- returns nothing
DEALLOCATE PREPARE stmt;
```

## What you should see
The `SELECT` works for `app_ro`, and the `INSERT` fails with `INSERT command denied`. The injected query returns all rows; the prepared statement returns none.

## Your exercise (type it yourself, don't copy)
1. Create a second user that can `SELECT` and `INSERT` on `users` only, and test that `DELETE` is refused.
2. Revoke `SELECT` from `app_ro` and confirm it can no longer read.
3. Explain why your demo app's `/user` route from the starter project has the same flaw as step 2.

## Save your evidence
Save your SQL as `labs/day-20/least-privilege.sql` and paste the `INSERT command denied` error and your explanation into **My notes**.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 20 "sql least privilege and injection"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
