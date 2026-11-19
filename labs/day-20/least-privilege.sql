-- Lab only: local mysql-lab container, fake data and fake passwords.
CREATE USER 'app_ro'@'%' IDENTIFIED BY 'LabOnly456';
GRANT SELECT ON shop.* TO 'app_ro'@'%';
SHOW GRANTS FOR 'app_ro'@'%';

CREATE USER 'app_rw'@'%' IDENTIFIED BY 'LabOnly789';
GRANT SELECT, INSERT ON shop.users TO 'app_rw'@'%';
SHOW GRANTS FOR 'app_rw'@'%';

REVOKE SELECT ON shop.* FROM 'app_ro'@'%';
SHOW GRANTS FOR 'app_ro'@'%';

-- Injection demo
SELECT * FROM users WHERE name = '' OR '1'='1';
PREPARE stmt FROM 'SELECT * FROM users WHERE name = ?';
SET @n = ''' OR ''1''=''1';
EXECUTE stmt USING @n;
DEALLOCATE PREPARE stmt;
