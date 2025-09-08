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

SELECT * FROM employees
ORDER BY last_name ASC;  -- by default it is ascending only

SELECT * FROM employees
ORDER BY last_name DESC;

SELECT * FROM transactions
ORDER BY amount DESC, customer_id DESC;  -- if amount is same, then it will be ordered by customer_id






-- LIMIT clause
-- Limit clause is used to limit the number of records. Useful if u are working with a lot of data. Can be used to display a large data on pages(pagination) 
 
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






-- UNIONS
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
-- a virtual table based on the result-set of an SQL statement. The fields in a view are fields from 1 or more tables in the database. They're not real tables, but can be interacted with as if they were 

-- suppose our boss want us to make an attendance sheet of employees table of first and last name. We can also make another table, but then if we have to remove an employee, then we have to make changes in both the tables. So, we will use views here 

CREATE VIEW employee_attendance AS 
SELECT first_name, last_name
FROM employees;

select * from employee_attendance;  -- -- Now if we make any change(say add employee) and then run this then it will update, this is the benefit of view

drop view employee_attendance;






-- INDEXES
-- INDEX (BTree data structure)
-- Indexes are used to find values within a specific column more quickly
-- MySQL normally searches sequentially through a column
-- The longer the column, the more expensive the operation is
-- UPDATE takes more time, SELECT takes less time

-- Why Use Indexes?
-- Faster SELECT queries
-- Slightly slower INSERT, UPDATE, DELETE (because index also needs to be updated)
-- Reduces full table scans

show indexes from customers;

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
-- a query within another query

SELECT first_name, last_name, hourly_pay, 
       (SELECT AVG(hourly_pay) FROM employees) AS avg_pay
FROM employees;


SELECT first_name, last_name, hourly_pay 
FROM employees
where hourly_pay > (SELECT AVG(hourly_pay) FROM employees);


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








-- TRIGGERS
-- when an event happens, do something. ex.: insert, update, delete. checks data, handles error, auditing tables.
-- https://www.youtube.com/watch?v=jVbj72YO-8s&list=PLZPZq0r_RZOMskz6MdsMOgxzheIyjo-BZ&index=31&ab_channel=BroCode















 


