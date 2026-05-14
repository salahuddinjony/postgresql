# Basic SQL

This repository includes examples of the main SQL command groups:

- DDL (Data Definition Language)
- DML (Data Manipulation Language)
- DCL (Data Control Language)
- TCL (Transaction Control Language)
- QL / DQL (Query Language / Data Query Language)

## 1) DDL - Data Definition Language

Used to define and change database structure.

```sql
CREATE DATABASE school;

CREATE TABLE students (
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50),
	email VARCHAR(100) UNIQUE,
	age INT CHECK (age >= 0),
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE students ADD COLUMN is_active BOOLEAN DEFAULT TRUE;
ALTER TABLE students RENAME COLUMN first_name TO given_name;
ALTER TABLE students RENAME TO app_students;

TRUNCATE TABLE app_students;

DROP TABLE app_students;
DROP DATABASE school;
```

## 2) DML - Data Manipulation Language

Used to insert, update, and delete data.

```sql
INSERT INTO students (first_name, last_name, email, age)
VALUES ('Salah', 'Uddin', 'salah@example.com', 24);

UPDATE students
SET age = 25
WHERE email = 'salah@example.com';

DELETE FROM students
WHERE email = 'salah@example.com';
```

## 3) DCL - Data Control Language

Used to control access and permissions.

```sql
CREATE USER app_user WITH PASSWORD 'strong_password';

GRANT CONNECT ON DATABASE school TO app_user;
GRANT USAGE ON SCHEMA public TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO app_user;

REVOKE DELETE ON ALL TABLES IN SCHEMA public FROM app_user;
```

## 4) TCL - Transaction Control Language

Used to manage transactions.

```sql
BEGIN;

INSERT INTO students (first_name, last_name, email, age)
VALUES ('Rahim', 'Ahmed', 'rahim@example.com', 22);

SAVEPOINT after_first_insert;

UPDATE students
SET age = 23
WHERE email = 'rahim@example.com';

ROLLBACK TO SAVEPOINT after_first_insert;
COMMIT;
```

## 5) QL / DQL - Query Language

Used to read/query data.

```sql
SELECT * FROM students;

SELECT first_name, age
FROM students
WHERE age >= 20
ORDER BY age DESC;

SELECT city, COUNT(*) AS total_students
FROM students
GROUP BY city
HAVING COUNT(*) > 1;

SELECT DISTINCT country FROM students;
```

## Notes

- Different databases (PostgreSQL, MySQL, SQL Server, Oracle) can have slightly different syntax.
- In many resources, "QL" is referred to as "DQL".
