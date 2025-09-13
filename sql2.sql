-- Functions

SELECT COUNT(amount) as count  -- as count means what will be shown in heading, u can also remove this. It is called alias
FROM transactions;

SELECT MAX(amount) AS maximum
FROM transactions;

SELECT MIN(amount) AS minimum
FROM transactions;

SELECT AVG(amount) AS average
FROM transactions;

SELECT SUM(amount) AS sum
FROM transactions;

SELECT CONCAT(first_name,' ', last_name) AS full_name
FROM customers;





-- logical operators 
-- AND, OR, NOT, IN, NOT IN, BETWEEN, LIKE, IS NULL, IS NOT NULL

-- first updating our table a little, then we'll learn logical operators

alter table employees
add column job varchar(25) after hourly_pay;

update employees 
set job="manager"
where employee_id=1;

update employees 
set job="cashier"
where employee_id=2;

update employees 
set job="cook"
where employee_id=3;

update employees 
set job="cook"
where employee_id=4;

update employees 
set job="asst. manager"
where employee_id=5;

update employees 
set job="janitor"
where employee_id=6;


-- now logical operators

SELECT * FROM employees
WHERE hire_date  > '2023-01-05' AND job = 'cook';

SELECT * FROM employees
WHERE job = 'Cook' OR job = 'Cashier';

SELECT * FROM employees
WHERE NOT job = 'Manager';

SELECT * FROM employees
WHERE NOT job = 'Manager' AND NOT job = 'Asst. Manager';

SELECT *
FROM employees
WHERE hire_date BETWEEN '2023-01-04' AND '2023-01-07';
-- or
SELECT *
FROM employees
WHERE hire_date >= '2023-01-04' AND hire_date <= '2023-01-07';



SELECT * 
FROM employees
WHERE job IN ("cook", "cashier", "janitor");





-- wild cards 
-- wild card characters %_ are used to substitute one or more characters in a string
--  % = any amount of random characters
-- _ = one single random character


-- starts with the letter s, other are understood by itself
SELECT * FROM employees
WHERE first_name LIKE "s%";

SELECT * FROM employees
WHERE last_name LIKE "%r";

SELECT * FROM employees
WHERE hire_date LIKE "2023%";

SELECT * FROM employees
WHERE job LIKE "_ook";

SELECT * FROM employees
WHERE hire_date LIKE "____-01-__";

SELECT * FROM employees
WHERE job LIKE "_a%";





-- ORDER BY clause
-- ORDER BY is used to sort the result set of a query by one or more columns.

SELECT * FROM employees
ORDER BY last_name ASC;  -- by default it is ascending only

SELECT * FROM employees
ORDER BY last_name DESC;

SELECT * FROM transactions
ORDER BY amount DESC, customer_id DESC;  -- if amount is same, then it will be ordered by customer_id

-- Sort by column position (not recommended, but works)
SELECT employee_id, first_name, last_name
FROM employees
ORDER BY 2;   -- sorts by 2nd column (first_name)







-- LIMIT clause
-- Limit clause is used to limit the number of records. Useful if u are working with a lot of data. Can be used to display a large data on pages(pagination) 
 -- The LIMIT clause is used to restrict the number of rows returned by a query. It’s often combined with ORDER BY when you want the "top N" rows.

SELECT * FROM customers
LIMIT 1;

SELECT *FROM customers
LIMIT 2;

SELECT * FROM customers
LIMIT 3;

SELECT * FROM customers
ORDER BY last_name DESC
LIMIT 3;

SELECT * FROM customers
ORDER BY last_name ASC
LIMIT 3;

-- LIMIT offset, count.    
SELECT * FROM customers
LIMIT 1, 3;   -- 1 is the offset: skip the first row. 3 is the count: return the next 3 rows.

SELECT * 
FROM employees 
LIMIT 5 OFFSET 2;    -- skip 2, return next 5







-- UNIONS
-- The UNION operator combines the results of two or more SELECT queries into a single result set. Each SELECT must return the same number of columns and the columns must have compatible data types.
-- Union combines the results of 2 or more select statements. all tables should have same number of columns.
-- Explore UNION ALL also. In union, if 2 tables have duplicate row, it'll be displayed only once but if union all written, duplicates are allowed there

-- this will not work as they have different number of columns
-- SELECT * FROM employees
-- UNION
-- SELECT * FROM customers;


-- Duplicates not allowed
SELECT first_name, last_name FROM employees
UNION
SELECT first_name, last_name FROM customers;


-- if we are writing job also, then also it is working and no error
-- SELECT first_name, job FROM employees
-- UNION
-- SELECT first_name, last_name FROM customers;
-- -- OR
-- SELECT first_name, job AS detail FROM employees
-- UNION
-- SELECT first_name, last_name AS detail FROM customers;


-- DUPLICATES OK
SELECT first_name, last_name FROM employees
UNION ALL
SELECT first_name, last_name FROM customers;





-- SELF JOINS
-- just another copy of a copy to itself, used to compare rows of the same table, helps to display a heierarchy of data 
-- https://www.youtube.com/watch?v=lweF--_3Pk8&list=PLZPZq0r_RZOMskz6MdsMOgxzheIyjo-BZ&index=23&ab_channel=BroCode
-- Study...

SELECT a.first_name, a.last_name,
               CONCAT(b.first_name," ", b.last_name) AS "reports_to"
FROM employees AS a
INNER JOIN employees AS b
ON a.supervisor_id = b.employee_id;





-- Views
-- A View is a virtual table created from the result of an SQL query.
-- It does not store data physically → only stores the query.
-- Whenever you query the view, it dynamically fetches fresh data from the base tables.
-- a virtual table based on the result-set of an SQL statement. The fields in a view are fields from 1 or more tables in the database. They're not real tables, but can be interacted with as if they were 

-- suppose our boss want us to make an attendance sheet of employees table of first and last name. We can also make another table, but then if we have to remove an employee, then we have to make changes in both the tables. So, we will use views here 

CREATE VIEW employee_attendance AS 
SELECT first_name, last_name
FROM employees;

select * from employee_attendance;  -- -- Now if we make any change(say add employee) and then run this then it will update, this is the benefit of view

-- Modify or Drop a View
ALTER VIEW employee_attendance AS
SELECT first_name, last_name, job
FROM employees;

DROP VIEW employee_attendance;

drop view employee_attendance;


-- Updating Views
-- If a view is based on one simple table (no aggregates, no joins) → it’s updatable (you can INSERT, UPDATE, DELETE through the view).
-- If a view has joins, aggregations, DISTINCT, GROUP BY, UNION, etc. → it’s usually read-only.   (but I created a view using join and tried to update it and it was being updated :)  so explore this... :)


-- if we insert, update or delete something in a view, the original table will also get updated


-- | Feature | Table                           | View                           |
-- | ------- | ------------------------------- | ------------------------------ |
-- | Storage | Stores data physically          | Stores only query (virtual)    |
-- | Speed   | Faster (direct data)            | Slightly slower (runs query)   |
-- | Update  | Can always insert/update/delete | Only sometimes (if simple)     |
-- | Purpose | Data storage                    | Query simplification, security |




-- Benefits of Views
-- Simplifies queries → write once, reuse many times.
-- Security → restrict users to certain columns/rows (hide sensitive data).
-- Abstraction → underlying table structure changes won’t affect end-users if they query via views.
-- Consistency → ensures same business logic/query everywhere.






-- INDEXES
-- INDEX (BTree data structure)
-- Indexes are used to find values within a specific column more quickly
-- MySQL normally searches sequentially through a column
-- The longer the column, the more expensive the operation is
-- UPDATE takes more time, SELECT takes less time
-- Indexes improve read performance (SELECT, WHERE, ORDER BY, JOIN) but can slow down writes (INSERT, UPDATE, DELETE) because the index must be updated.

-- Why Use Indexes?
-- Faster SELECT queries
-- Slightly slower INSERT, UPDATE, DELETE (because index also needs to be updated)
-- Reduces full table scans

show indexes from customers;

-- Column Explanation:
-- Table → Table name.
-- Non_unique → 0 = unique index, 1 = not unique.
-- Key_name → Name of the index.
-- Seq_in_index → Column position in the index (1 = first).
-- Column_name → Column included in the index.
-- Collation → Sorting order (A = ascending).
-- Cardinality → Approximate number of unique values in the index.
-- Index_type → Usually BTREE.

-- Single column index
CREATE INDEX last_name_idx
ON customers (last_name);

show indexes from customers;

-- Multi column index
CREATE INDEX last_name_first_name_idx
ON customers (last_name, first_name);  -- order is very important

show indexes from customers;

-- to delete index
alter table customers
drop index last_name_idx;


-- from chatGpt

-- ✅ Uses single-column index 'last_name_idx'
-- Speeds up lookup by 'last_name'
SELECT *
FROM customers
WHERE last_name = 'Sharma';

-- ✅ Uses multi-column index 'last_name_first_name_idx'
-- Optimized for searches using both columns in order
SELECT *
FROM customers
WHERE last_name = 'Sharma' AND first_name = 'Ayush';

-- ⚠️ This query also benefits from 'last_name_first_name_idx'
-- because it uses the left-most column of the composite index
SELECT *
FROM customers
WHERE last_name = 'Sharma';

-- ❌ Does NOT benefit from any index
-- Because it skips the left-most column of the composite index
SELECT *
FROM customers
WHERE first_name = 'Ayush';






-- subquery
-- A subquery is a query inside another query. It is used when you want the result of one query to be used in another.
-- a query within another query

SELECT first_name, last_name, hourly_pay, 
       (SELECT AVG(hourly_pay) FROM employees) AS avg_pay
FROM employees;


SELECT first_name, last_name, hourly_pay 
FROM employees
where hourly_pay > (SELECT AVG(hourly_pay) FROM employees);


-- different types of subqueries: Single-row Subquery, Multi-row Subquery, Multi-column Subquery, Correlated Subquery, Subquery in FROM Clause (Derived Table), Subquery in SELECT Clause

-- single
SELECT first_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- multi row: Returns multiple values → used with IN, ANY, or ALL.
SELECT first_name, department_id
FROM employees
WHERE department_id IN (SELECT department_id
                        FROM departments
                        WHERE location = 'New York');
                        
                        
-- Multi-column Subquery
-- Find employees who have the same job and department as employee_id 101
SELECT first_name, job_id, department_id
FROM employees
WHERE (job_id, department_id) = 
      (SELECT job_id, department_id
       FROM employees
       WHERE employee_id = 101);

-- Correlated Subquery: The subquery depends on the outer query (executed row by row).
-- Find employees who earn more than the average salary of their department
SELECT e.first_name, e.salary, e.department_id
FROM employees e
WHERE e.salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e.department_id
);

-- Subquery in FROM Clause (Derived Table): Treats the subquery as a temporary table.
-- Find department-wise highest salary
SELECT department_id, MAX(salary) AS max_salary
FROM (SELECT department_id, salary FROM employees) AS temp
GROUP BY department_id;


-- Subquery in SELECT Clause: Returns a value that appears as a column in the result.
-- Show each employee and total number of employees in the company
SELECT first_name,
       (SELECT COUNT(*) FROM employees) AS total_employees
FROM employees;





-- distinct keyword
select distinct customer_id
from transactions
where customer_id is not null; 


SELECT first_name, last_name
FROM customers
WHERE customer_id IN (SELECT DISTINCT customer_id  -- also try NOT IN
FROM transactions WHERE customer_id IS NOT NULL);







-- GROUP BY
-- aggregate all rows by a specific column often used with aggregate functions sum, max, min, avg, count

-- first creating a table

DROP TABLE IF EXISTS transactions;  -- find what will happen if exists not written

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    amount DECIMAL(5, 2),
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) 
    REFERENCES customers(customer_id)
);

INSERT INTO transactions
VALUES  (1000, 4.99, 3, "2023-01-01"),
  (1001, 2.89, 2, "2023-01-01"),
  (1002, 3.38, 3, "2023-01-02"),
  (1003, 4.99, 1, "2023-01-02"),
  (1004, 1.00, NULL, "2023-01-03"),
  (1005, 2.49, 4, "2023-01-03"),
  (1006, 5.48, NULL, "2023-01-03");
        
SELECT * FROM transactions;


-- EXAMPLE 1 --
SELECT SUM(amount), order_date
FROM transactions 
GROUP BY order_date;

-- if not using aggregate functoins, then write all(all means which u are selecting) the column names after group by clause
SELECT customer_id, order_date FROM transactions GROUP BY customer_id, order_date;


-- HAVING
-- if u want to use where along with group by, then u have to write having instead of where

SELECT COUNT(amount), customer_id
FROM transactions 
GROUP BY customer_id
HAVING COUNT(amount) > 1 AND customer_id IS NOT NULL;







-- ROLLUP
-- ROLLUP, extension of the GROUP BY clause 
-- produces another row and shows the grand-total (super-aggregate) value

SELECT SUM(amount) AS "daily_sales", order_date
FROM transactions
GROUP BY order_date WITH ROLLUP;

SELECT COUNT(transaction_id) AS "# of orders", order_date
FROM transactions
GROUP BY order_date WITH ROLLUP;

SELECT COUNT(transaction_id) AS "# of orders", customer_id
FROM transactions
GROUP BY customer_id WITH ROLLUP;

SELECT SUM(hourly_pay) AS "hourly_pay", employee_id
FROM employees
GROUP BY employee_id WITH ROLLUP;







-- ON DELETE       https://www.youtube.com/watch?v=vANfY96ccOY&list=PLZPZq0r_RZOMskz6MdsMOgxzheIyjo-BZ&index=29&t=2s&ab_channel=BroCode
-- on delete set null- when a fk is deleted, replace fk with null
-- on delete cascade- when a fk is deleted, delete row 
-- RESTRICT/NO ACTION

-- ON DELETE specifies what happens to the child table rows when a parent table row is deleted. It’s part of the FOREIGN KEY definition.

-- while creating table
-- CREATE TABLE transactions (
--     transaction_id INT PRIMARY KEY AUTO_INCREMENT,
--     amount DECIMAL(5, 2),
--     customer_id INT,
--     order_date DATE,
--     FOREIGN KEY (customer_id) 
--     REFERENCES customers(customer_id)
--     on delete set null
-- );

-- if table is already existing
alter table transactions drop foreign key transactions_ibfk_1;   -- deleting the previous foreign key, now we will add foreign key along with on delete

-- if table already exists
ALTER TABLE transactions
ADD CONSTRAINT fk_customer_id 
FOREIGN KEY (customer_id) REFERENCES customers(customer_id) 
ON DELETE SET NULL;

-- now if we delete from customers of customer_id=4 and since customer_id is a foreign key. So now if we check our traansactions table, then from there id=4 will be set to null.

-- now since we have deleted id=4 from customers table and transactions table will also be changed(according to null or cascade) and we also want to delete id=4 further to check cascade.
-- So, make drop transactions table and make again. the query is written above in the group by clause. But it will result in error bcz there we are inserting id=4 also and since 
-- it is a FK(foreign key), id=4 also must be present in customers table. so insert that value. That query is written few lines below. 
delete from customers where customer_id=4;


-- cascade.
ALTER TABLE transactions 
ADD CONSTRAINT fk_customer_id 
FOREIGN KEY (customer_id) REFERENCES customers(customer_id) 
ON DELETE CASCADE;

-- now if we delete, the whole row wll be deleted
delete from customers where customer_id=4;

-- Deleting from Child Table: Always allowed. Deleting a child row does not affect the parent table, because the parent exists independently.



SELECT * FROM transactions;
SELECT * FROM customers;

insert into customers
values (4,"Ayush","Kr Sinha");








-- Stored Procedures
-- is prepared SQL code that u can save. Great if there's a query that u write often

-- Example 1 

DELIMITER $$
CREATE PROCEDURE get_customers()
BEGIN
 SELECT * FROM customers;
END $$
DELIMITER ;

CALL get_customers();

DROP PROCEDURE get_customers;


-- Types of Parameters in Stored Procedures: Need to study properly
-- IN → Input only (you pass a value, procedure uses it).
-- OUT → Output only (procedure gives you back a value).
-- INOUT → Both input and output (you pass a value, it gets modified, and returned).

-- Rule of Thumb
-- IN → like a function argument.
-- OUT → like a return value.
-- INOUT → like passing a variable by reference.

-- IN Parameter: You pass a value → procedure uses it.
DELIMITER $$
CREATE PROCEDURE GetEmployeeByJob(IN jobTitle VARCHAR(50))
BEGIN
    SELECT first_name, last_name, job
    FROM employees
    WHERE job = jobTitle;
END $$
DELIMITER ;
CALL GetEmployeeByJob('cook');  -- Call it

-- OUT Parameter: Procedure calculates something and returns it via an OUT variable.
DELIMITER $$
CREATE PROCEDURE GetTotalEmployees(OUT total INT)
BEGIN
    SELECT COUNT(*) INTO total   -- assigns value to OUT parameter
    FROM employees;
END $$
DELIMITER ;

CALL GetTotalEmployees(@emp_count);   -- procedure sets @emp_count
SELECT @emp_count;   -- see the value returned


-- INOUT Parameter: You give a value → procedure changes it → returns the new value.
DELIMITER $$
CREATE PROCEDURE UpdatePay(INOUT emp_id INT, IN increment DECIMAL(5,2))
BEGIN
    UPDATE employees
    SET hourly_pay = hourly_pay + increment
    WHERE employee_id = emp_id;
END $$
DELIMITER ;

SET @id = 3;
CALL UpdatePay(@id, 2.5);












-- TRIGGERS
-- when an event happens, do something. ex.: insert, update, delete. checks data, handles error, auditing tables.
-- https://www.youtube.com/watch?v=jVbj72YO-8s&list=PLZPZq0r_RZOMskz6MdsMOgxzheIyjo-BZ&index=31&ab_channel=BroCode

-- A trigger is a special object in MySQL that automatically executes some code when an event happens on a table.
-- Events can be:
-- INSERT
-- UPDATE
-- DELETE
-- So, a trigger = “If something happens in this table → do this automatically.”

-- Types of Triggers
-- BEFORE INSERT / AFTER INSERT
-- BEFORE UPDATE / AFTER UPDATE
-- BEFORE DELETE / AFTER DELETE
-- BEFORE → executes before the action happens.
-- AFTER → executes after the action happens.

CREATE TABLE employee_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    action VARCHAR(50),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- Now the trigger:
DELIMITER $$
CREATE TRIGGER after_employee_insert
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employee_log (employee_id, action)
    VALUES (NEW.employee_id, 'Employee Added');
END $$
DELIMITER ;


-- explore other types of triggers...

-- Rule of Thumb
-- NEW → used in INSERT or UPDATE (represents new values).
-- OLD → used in UPDATE or DELETE (represents old values).
-- Triggers run automatically, you don’t call them manually.






-- CTE
-- A CTE (Common Table Expression) is a temporary result set that you can reference within a SELECT, INSERT, UPDATE, or DELETE statement.
-- It makes queries easier to read, organize, and reuse.
-- Think of it as a named subquery that exists only during the execution of the main query.

-- Example 1: Simple CTE
WITH HighSalaryEmployees AS (
    SELECT first_name, last_name, salary
    FROM employees
    WHERE salary > 5000
)
SELECT * FROM HighSalaryEmployees;

-- Example 2: CTE with Aggregation
WITH DeptAvg AS (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
)
SELECT * 
FROM DeptAvg
WHERE avg_salary > 6000;


-- Example 3: Recursive CTE: Used for hierarchical data (like managers → employees).   Couldnt understand
-- Understand this example... Currently I've just copy pasted it
WITH RECURSIVE EmployeeHierarchy AS (
    -- Base case
    SELECT employee_id, manager_id, first_name, 1 AS level
    FROM employees
    WHERE manager_id IS NULL
    UNION ALL
    -- Recursive part
    SELECT e.employee_id, e.manager_id, e.first_name, eh.level + 1
    FROM employees e
    INNER JOIN EmployeeHierarchy eh ON e.manager_id = eh.employee_id
)
SELECT * FROM EmployeeHierarchy;















 

