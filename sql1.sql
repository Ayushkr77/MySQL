create database myDb;
use myDb;
CREATE TABLE employees (
	employee_id int,
	first_name VARCHAR(50),
	last_name VARCHAR(50), 
	hourly_pay DECIMAL(5, 2),    -- 5 digits total, 2 digits after the decimal point
	hire_date DATE
);

-- RENAME TABLE employees TO workers;
-- DROP TABLE employees;
-- select * from employees;
select * from employees;

-- whenever you want to modify the structure of a table—such as adding, dropping, or modifying a column—you must use the ALTER TABLE statement.+

ALTER TABLE employees
ADD phone_number VARCHAR(15);

-- ALTER TABLE employees
-- drop column phone_number

ALTER TABLE employees
RENAME COLUMN phone_number TO email;

ALTER TABLE employees
MODIFY COLUMN email VARCHAR(100);

ALTER TABLE employees 
MODIFY email VARCHAR(100) 
AFTER last_name;

ALTER TABLE employees 
MODIFY email VARCHAR(100) 
FIRST;

-- ALTER TABLE employees
-- drop column email





-- Insert rows into a table

-- EXAMPLE 1 --
INSERT INTO employees
VALUES (1, "Eugene", "Krabs", 25.50, "2023-01-02");
SELECT * FROM employees;

DELETE FROM employees
WHERE employee_id = 1;


-- EXAMPLE 2 --
INSERT INTO employees
VALUES 	(2, "Squidward", "Tentacles", 15.00, "2023-01-03"), 
		(3, "Spongebob", "Squarepants", 12.50, "2023-01-04"), 
                (4, "Patrick", "Star", 12.50, "2023-01-05"), 
                (5, "Sandy", "Cheeks", 17.25, "2023-01-06");
SELECT * FROM employees;

-- EXAMPLE 3 --
-- If u dont want to insert values in all the columns 
INSERT INTO employees (employee_id, first_name, last_name)
VALUES 	(6, "Sheldon", "Plankton");
SELECT * FROM employees;






-- How to SELECT data from a TABLE

SELECT * FROM employees;

SELECT first_name, last_name FROM employees;

SELECT last_name, first_name FROM employees;

SELECT *
FROM employees
WHERE employee_id = 1;

SELECT *
FROM employees
WHERE first_name = "Spongebob";

SELECT *
FROM employees
WHERE hourly_pay >= 15;

SELECT hire_date, first_name
FROM employees
WHERE hire_date <= "2023-01-03";

SELECT *
FROM employees
WHERE employee_id != 1;

SELECT *
FROM employees
WHERE hire_date IS NULL;

SELECT *
FROM employees
WHERE hire_date IS NOT NULL;





-- UPDATE and DELETE data from a TABLE

UPDATE employees
SET hourly_pay = 10.25
WHERE employee_id = 6;   -- if where not written, then it will set all to that value
SELECT * FROM employees;


DELETE FROM employees
WHERE employee_id = 6;  -- if where not written, all will be deleted
SELECT * FROM employees;






-- AUTOCOMMIT, COMMIT, ROLLBACK

-- 1. AUTOCOMMIT
-- By default, MySQL runs with AUTOCOMMIT = ON.
-- This means: every statement you run is immediately and permanently saved.

-- 2. COMMIT
-- COMMIT permanently saves all the changes made during the current transaction.

-- 3. ROLLBACK
-- ROLLBACK undoes all changes made in the current transaction (since the last START TRANSACTION or disabling of AUTOCOMMIT).


set autocommit=off;  -- off or 0
commit;   -- here commit is useless, no use
delete from employees;
select * from employees;
rollback;
select * from employees;


-- COMMIT should be used after a change, like an INSERT, UPDATE, or DELETE, to permanently save that change.
-- If you skip COMMIT, you can still use ROLLBACK to undo.


-- SET autocommit = OFF;
-- DELETE FROM employees;
-- COMMIT;  -- Now the delete is permanent
-- ROLLBACK;  -- Too late, can't undo!







-- CURRENT_DATE() & CURRENT_TIME()

CREATE TABLE test(
     my_date DATE,
     my_time TIME,
     my_datetime DATETIME
);

INSERT INTO test
VALUES(CURRENT_DATE(), CURRENT_TIME(), NOW());
SELECT * FROM test;






-- UNIQUE constraint

CREATE TABLE products (
    product_id INT,
    product_name varchar(25) UNIQUE,
    price DECIMAL(4, 2)
);

-- if while creating table, if we forget to product_name unique, then it can be done by the below query
ALTER TABLE products
ADD CONSTRAINT 
UNIQUE (product_name);

INSERT INTO products
VALUES (100, 'hamburger', 3.99),
               (101, 'fries', 1.89),
               (102, 'soda', 1.00),
               (103, "ice cream", 1.49);

SELECT * FROM products;





-- NOT NULL constraint
CREATE TABLE products (
    product_id INT,
    product_name varchar(25),
    price DECIMAL(4, 2) NOT NULL
);

-- You use MODIFY when you want to:
-- 	Change the data type
-- 	Add/remove constraints
-- 	Adjust precision/scale for numeric types
-- Important:
-- 	If price already has NULL values, this will fail because NOT NULL would conflict.
-- 	You should ensure that all rows have a value in price before running this.


-- if while creating table, if we forget to price not null, then it can be done by the below query
ALTER TABLE products
MODIFY price DECIMAL(4, 2) NOT NULL;     -- MODIFY price DECIMAL(7, 2) NOT NULL;  we can also change its precision to (7,2) or itts data type:  ALTER TABLE products MODIFY price FLOAT;  it can receive null values, its also okay if u write null

INSERT INTO products
VALUES(104, "cookie", NULL);

select * from products;





-- CHECK constraint
CREATE TABLE employees(
	employee_id INT,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	hourly_pay DECIMAL (5, 2),
	hire_date DATE,
	CONSTRAINT chk_hourly_pay CHECK (hourly_pay >= 10.00)   -- Add a constraint named chk_hourly_pay. Ensure that all future rows must have hourly_pay >= 10.00.
)

-- 			Important Notes:
-- 				Existing Rows:
-- 					The ALTER TABLE statement does not validate existing rows by default in some databases (like PostgreSQL).
-- 					But in MySQL and SQL Server, it might reject the ALTER if existing data violates the condition.
-- 					If Existing Rows Violate the Constraint:
-- 					You must either update or delete those rows first.
-- 				Constraint Naming:
-- 					You must provide a unique name for the constraint in the table.

-- if forgot to add check constraint, then u can add it by below command
-- ALTER TABLE employees
-- ADD CONSTRAINT chk_hourly_pay CHECK (hourly_pay >= 10.00);

-- ALTER TABLE employees ADD CHECK (hourly_pay >= 10.00);  its not necessary to add constraint but its a good practice to manage later

INSERT INTO employees
VALUES (6, "Sheldon", "Plankton", 5.00, "2023-01-07");

-- to drop the check 
-- ALTER TABLE employees
-- DROP CHECK chk_hourly_pay;


-- When CHECK is added	Are existing rows checked?	What to do if they violate?
-- During CREATE TABLE	✅ Yes – always checked		Not allowed at all
-- Via ALTER TABLE	✅ Depends on DB (usually yes)	Fix or delete bad data first







-- DEFAULT constraint
-- EXAMPLE 1
CREATE TABLE products (
    product_id INT,
    product_name varchar(25),
    price DECIMAL(4, 2) DEFAULT 0
);

-- if forgot to set default while creating table
-- ALTER TABLE products 
-- ALTER price SET DEFAULT 0;

INSERT INTO products (product_id, product_name)
VALUES	(104, "straw"),
		(105, "napkin"),
		(106, "fork"),
		(107, "spoon");
SELECT * FROM products;



-- EXAMPLE 2
CREATE TABLE transactions(
	transaction_id INT,
	amount DECIMAL(5, 2),
   	transaction_date DATETIME DEFAULT NOW()
);
SELECT * FROM transactions;

INSERT INTO transactions (transaction_id, amount)
VALUES	(1, 4.99);
SELECT * FROM transactions;

INSERT INTO transactions (transaction_id, amount)
VALUES	(2, 2.89);
SELECT * FROM transactions;

INSERT INTO transactions
VALUES	(3, 8.37, "2025-05-23 11:52:51");
SELECT * FROM transactions;







-- PRIMARY KEYS 
-- EXAMPLE 1
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    amount DECIMAL(5, 2)
);

-- EXAMPLE 2   if forgot to make primary key while creating table
ALTER TABLE transactions
ADD CONSTRAINT
PRIMARY KEY (transaction_id);

-- difference b/w primary key and unique. Nulls not allowed in primary key. Search for more...






-- AUTO_INCREMENT 
-- AUTO_INCREMENT keyword used to automatically create a sequence of a column when inserting data. Applied to a column set as a ‘key’.    
-- AUTO_INCREMENT is a keyword used in SQL (especially in MySQL, MariaDB, and similar systems) to automatically generate unique numeric values for a column — usually used for primary keys.

-- Feature					Description
-- Default start			Usually starts at 1
-- Increment step			Increases by 1 by default
-- Only one allowed		Only one AUTO_INCREMENT column per table
-- Must be indexed			Usually used with PRIMARY KEY or UNIQUE
-- Optional insert			You can override it manually if needed (INSERT INTO users VALUES (99, 'Charlie'))

-- ALTER TABLE users AUTO_INCREMENT = 100;
-- Now the next inserted ID will be 100.

drop table transactions;

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    amount DECIMAL(5, 2)
);

insert into transactions(amount)
values (30);
select * from transactions;

ALTER TABLE transactions 
AUTO_INCREMENT = 1000;







-- FOREIGN KEYS

CREATE TABLE customers (
     customer_id INT PRIMARY KEY AUTO_INCREMENT,
     first_name VARCHAR(50),
     last_name VARCHAR(50)
);
INSERT INTO customers (first_name, last_name)
VALUES  ("Fred", "Fish"),
                ("Larry", "Lobster"),
                ("Bubble", "Bass");
SELECT * FROM customers;


CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    amount DECIMAL(5, 2),
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
ALTER TABLE transactions
AUTO_INCREMENT = 1000;

-- if want to delete foreign key
-- alter table transactions
-- drop foreign key transactions_ibfk_1;  -- this name transactions_ibfk_1, u will get from see left, then under transactions table, then under foreign keys

-- Add a named foreign key constraint to an existing table
-- ALTER TABLE customers
-- ADD CONSTRAINT fk_customer_id
-- FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

insert into transactions(amount,customer_id)
values (4.99,3),
		(2.89,2),
        (1.14,3),
        (2.32,1);

SELECT * FROM transactions;

-- deleting from customers table is also not allowed due to foreign key constraint, but u can delete from transactions table
delete from customers
where customer_id=3;






-- JOINS (INNER, LEFT, RIGHT)   Think of it as a venn diagram
-- INNER JOIN = Show what is common in both table
-- LEFT JOIN = Shows the full left table but the only the common items from the right table
-- RIGHT JOIN = Shows the full right table but the only the common items from the left table

insert into transactions (amount,customer_id)
values(1.00,null)

insert into customers(first_name,last_name)
values("Poppy","Puff");

-- inner join selects records that have a matching key in both tables.
SELECT *
FROM transactions INNER JOIN customers  -- can also write just join instead of inner join
ON transactions.customer_id = customers.customer_id;

-- OR
SELECT c.first_name, c.last_name, t.amount
FROM customers c JOIN transactions t
ON c.customer_id = t.customer_id;
 
 
-- LEFT JOIN returns all records from the left table and the matching records from the right table
SELECT *
FROM transactions LEFT JOIN customers
ON transactions.customer_id = customers.customer_id;


-- RIGHT JOIN returns all records from the right table and the matching records from the left table
SELECT *
FROM transactions RIGHT JOIN customers
ON transactions.customer_id = customers.customer_id;








-- SELECT * FROM employees;
























