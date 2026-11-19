-- Lab only: fake data, local mysql-lab container.
DROP DATABASE IF EXISTS shop;
CREATE DATABASE shop;
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
