# Day 19 — Local MySQL in Docker and DbVisualizer

**Week 4 · about 45 minutes · Run in: Ubuntu (WSL) terminal + DbVisualizer on Windows**

## Why this matters
Databases are where the valuable data lives. You will practise SQL on a private database you own, not on any client system.

## Goal today
Run MySQL in a container, connect from both the terminal and DbVisualizer, create a table and query it.

## Commands you will learn

| Command | What it does |
|---|---|
| `docker run -d --name mysql-lab ... mysql:8` | start a throwaway MySQL server |
| `docker exec -it mysql-lab mysql -uroot -p` | open the MySQL command line |
| `CREATE DATABASE / CREATE TABLE` | define structure |
| `INSERT / SELECT / UPDATE / DELETE` | change and read data |
| `docker volume` | keep data between restarts |

## Do this (run each block, then read the output before moving on)
```bash
docker run -d --name mysql-lab -e MYSQL_ROOT_PASSWORD=LabOnly123 -p 3306:3306 mysql:8
docker logs mysql-lab 2>&1 | tail -3        # wait until you see "ready for connections"
docker exec -it mysql-lab mysql -uroot -pLabOnly123
```

Inside the `mysql>` prompt:

```sql
CREATE DATABASE shop;
USE shop;
CREATE TABLE users (id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(50), email VARCHAR(100));
INSERT INTO users (name, email) VALUES ('asha','asha@example.com'), ('ravi','ravi@example.com'), ('meera','meera@example.com');
SELECT * FROM users;
SELECT id, name FROM users WHERE name = 'asha';
UPDATE users SET email = 'asha@demo.test' WHERE name = 'asha';
DELETE FROM users WHERE name = 'ravi';
SELECT COUNT(*) FROM users;
EXIT;
```

Now DbVisualizer (on Windows): **Database → Create Database Connection** → driver **MySQL** → Server `localhost`, Port `3306`, Userid `root`, Password `LabOnly123` → **Connect**. Open a SQL Commander tab and run `SELECT * FROM shop.users;`.

## What you should see
You see the two remaining rows and a count of 2. DbVisualizer shows the same rows. If it cannot connect, check `docker ps` shows `0.0.0.0:3306->3306/tcp`, wait a bit longer for MySQL to start, or try the WSL address from PowerShell: `wsl hostname -I`.

## Your exercise (type it yourself, don't copy)
1. Add a second table `orders (id, user_id, amount)` and insert three orders.
2. Write a `JOIN` that shows each user's name with their total order amount.
3. Stop and restart the container. Is the data still there? (It is, until you `docker rm` it. Why would a named volume be safer?)

## Save your evidence
Save your SQL as `labs/day-19/shop.sql` and paste the join result into **My notes**. Use only the fake data from today.

Then commit and push (from the training repo):

```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 19 "local mysql and dbvisualizer"
```

## My notes (fill in before you commit)
- Commands I ran:
- What I learned:
- What went wrong and how I fixed it:
