-- Active: 1778737259543@@127.0.0.1@5432@ph
-- Active: 1778737259543@@127.0.0.1@5432@school
SELECT * FROM person WHERE is_active=TRUE LIMIT 100;
SELECT * FROM person WHERE is_active=FALSE LIMIT 100;   
SELECT * FROM person WHERE is_active IS NULL LIMIT 100; 

SELECT * FROM person WHERE is_active IS NOT TRUE LIMIT 100;
SELECT * FROM person WHERE is_active IS NOT FALSE LIMIT 100;
SELECT * FROM person WHERE is_active IS NOT NULL LIMIT 100;

-- select * from students;
ALTER TABLE person ADD COLUMN email VARCHAR(255) DEFAULT 'default@gmail.com' NOT NULL;

INSERT INTO person (first_name, last_name,age, is_active,dod, email) VALUES ('John', 'Doe',25, TRUE, '2023-12-31', 'john.doe@gmail.com');

SELECT * FROM person;

AlTER TABLE person
ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE person
ADD constraint first_name_last_name_unique UNIQUE (first_name, last_name);

AfTER TABLE person
ADD CONSTRAINT age_check CHECK (age >= 0);

--primary key
ALTER TABLE person
ADD constraint person_id_pk PRIMARY KEY (id);

--drop constraint
ALTER TABLE person
DROP CONSTRAINT age_check;


-- ADVANCED STUDENTS TABLE

-- CREATE STUDENTS TABLE

CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    gender VARCHAR(10),
    age INT,
    date_of_birth DATE,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20) UNIQUE,
    address TEXT,
    city VARCHAR(50),
    country VARCHAR(50),
    blood_group VARCHAR(5),
    department VARCHAR(100),
    cgpa DECIMAL(3,2),
    admission_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO students (
    first_name,
    last_name,
    gender,
    age,
    date_of_birth,
    email,
    phone,
    address,
    city,
    country,
    blood_group,
    department,
    cgpa,
    admission_date
)
VALUES
(
    'Salah',
    'Uddin',
    'Male',
    24,
    '2001-02-10',
    'salah@example.com',
    '01711111111',
    'Dhaka Cantonment',
    'Dhaka',
    'Bangladesh',
    'B+',
    'Computer Science',
    3.45,
    '2022-01-15'
),
(
    'Rahim',
    'Ahmed',
    'Male',
    22,
    '2003-05-18',
    'rahim@example.com',
    '01722222222',
    'Uttara Sector 10',
    'Dhaka',
    'Bangladesh',
    'A+',
    'Software Engineering',
    3.75,
    '2021-09-10'
),
(
    'Karim',
    'Hasan',
    'Male',
    23,
    '2002-08-25',
    'karim@example.com',
    '01733333333',
    'Agrabad',
    'Chattogram',
    'Bangladesh',
    'O+',
    'Electrical Engineering',
    3.20,
    '2020-06-20'
),
(
    'Nusrat',
    'Jahan',
    'Female',
    21,
    '2004-01-12',
    'nusrat@example.com',
    '01744444444',
    'Zindabazar',
    'Sylhet',
    'Bangladesh',
    'AB+',
    'Architecture',
    3.90,
    '2023-02-01'
),
(
    'Arosh',
    'Khan',
    'Male',
    20,
    '2005-03-05',
    'arosh@example.com',
    '01755555555',
    'Boyra',
    'Khulna',
    'Bangladesh',
    'B-',
    'Mechanical Engineering',
    3.10,
    '2024-01-10'
);
-- SELECT DISTINCT country FROM students;

SELECT DISTINCT ON (country) * FROM students;
-- upper and lower functions
SELECT UPPER(first_name), LOWER(last_name) FROM students;


-- ============================================================
-- DDL, DML, DCL, TCL, QL (DQL) EXAMPLES
-- ============================================================

-- -------------------------
-- 1) DDL: Data Definition Language
-- -------------------------

CREATE TABLE IF NOT EXISTS departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE students
ADD COLUMN IF NOT EXISTS department_id INT;

ALTER TABLE students
ADD CONSTRAINT students_department_fk
FOREIGN KEY (department_id)
REFERENCES departments(id);

-- -------------------------
-- 2) DML: Data Manipulation Language
-- -------------------------

INSERT INTO departments (name)
VALUES ('Computer Science'), ('Software Engineering')
ON CONFLICT (name) DO NOTHING;

UPDATE students
SET department_id = d.id
FROM departments d
WHERE students.department = d.name;

DELETE FROM students
WHERE email IS NULL;

-- -------------------------
-- 3) DCL: Data Control Language
-- -------------------------
-- Run these with a privileged role/user.

CREATE ROLE read_only_user LOGIN PASSWORD 'change_me_123';
GRANT CONNECT ON DATABASE school TO read_only_user;
GRANT USAGE ON SCHEMA public TO read_only_user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO read_only_user;
REVOKE INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public FROM read_only_user;

-- -------------------------
-- 4) TCL: Transaction Control Language
-- -------------------------

BEGIN;

INSERT INTO students (first_name, last_name, email, age)
VALUES ('Test', 'User', 'test.user@example.com', 30);

SAVEPOINT sp_after_insert;

UPDATE students
SET age = 31
WHERE email = 'test.user@example.com';

ROLLBACK TO SAVEPOINT sp_after_insert;
COMMIT;

-- -------------------------
-- 5) QL / DQL: Query Language
-- -------------------------

SELECT s.first_name, s.last_name, s.email, d.name AS department_name
FROM students s
LEFT JOIN departments d ON d.id = s.department_id
ORDER BY s.first_name;

SELECT city, COUNT(*) AS total_students
FROM students
GROUP BY city
HAVING COUNT(*) >= 1
ORDER BY total_students DESC;
