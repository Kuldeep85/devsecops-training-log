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
- Commands I ran: docker exec -it mysql-lab mysql, CREATE/DROP DATABASE, CREATE TABLE, INSERT / SELECT / UPDATE / DELETE, a JOIN with SUM and GROUP BY, docker stop / start, running a .sql file with docker exec -i. Connected from DbVisualizer to localhost:3306.

- What I learned: The JOIN gave: asha 370.50, meera 99.99. AUTO_INCREMENT does not reset after DELETE (new ids were 7, 8, 9), so my orders with user_id 1 and 3 no longer matched any user and the JOIN returned an empty set. TRUNCATE resets the counter, and a foreign key would have stopped the orphan rows. The data survived docker stop/start; only docker rm deletes it, and a named volume would keep it safe. Only fake data goes into this database.

- What went wrong and how I fixed it: I typed the password with the wrong case (LABOnly123 vs LabOnly123) so login failed; I used the original password. I ran the INSERT twice and made duplicate users, then the JOIN was empty because of the changed ids; I rebuilt the database from a script (shop.sql) and the join worked. DbVisualizer first used the DataDirect driver that needs registration, so I switched to MySQL 8+, and a stopped container caused 'Connection refused' until I ran docker start mysql-lab.

USE shop;
CREATE TABLE users (id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(50), email VARCHAR(100));
INSERT INTO users (name, email) VALUES ('asha','asha@example.com'), ('ravi','ravi@example.com'), ('meera','meera@example.com');
UPDATE users SET email = 'asha@demo.test' WHERE name = 'asha';
DELETE FROM users WHERE name = 'ravi';
SELECT * FROM users;
CREATE TABLE orders (id INT PRIMARY KEY AUTO_INCREMENT, user_id INT, amount DECIMAL(8,2));
INSERT INTO orders (user_id, amount) VALUES (1, 250.00), (1, 120.50), (3, 99.99);
SELECT * FROM orders;
SELECT u.name, SUM(o.amount) AS total FROM users u JOIN orders o ON o.user_id = u.id GROUP BY u.name;

kuldeepyadav@IN-LT-PF5GKA9R:~/repos/devsecops-training-log$ docker exec -i -e MYSQL_PWD="$PW" mysql-lab mysql -uroot -t < labs/day-19/shop.sql
+----+-------+-------------------+
| id | name  | email             |
+----+-------+-------------------+
|  1 | asha  | asha@demo.test    |
|  3 | meera | meera@example.com |
+----+-------+-------------------+
+----+---------+--------+
| id | user_id | amount |
+----+---------+--------+
|  1 |       1 | 250.00 |
|  2 |       1 | 120.50 |
|  3 |       3 |  99.99 |
+----+---------+--------+
+-------+--------+
| name  | total  |
+-------+--------+
| asha  | 370.50 |
| meera |  99.99 |
+-------+--------+