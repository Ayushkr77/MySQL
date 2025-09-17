-- https://datagrokranalytics-my.sharepoint.com/personal/naveen_gainedi_datagrokr_co/_layouts/15/onedrive.aspx?csf=1&web=1&e=mvmAP4&CID=c0a5c8e8%2D400c%2D4560%2D8e49%2Df79e931d32c1&FolderCTID=0x01200053DB1F00694C364085BA4E75F65C58C7&id=%2Fpersonal%2Fnaveen%5Fgainedi%5Fdatagrokr%5Fco%2FDocuments%2FPublic%2FTraining%2FCourses%2FSQL%2FSQL%20Assignment%2Epdf&parent=%2Fpersonal%2Fnaveen%5Fgainedi%5Fdatagrokr%5Fco%2FDocuments%2FPublic%2FTraining%2FCourses%2FSQL

DROP DATABASE IF EXISTS company;
CREATE DATABASE company;
USE company;

CREATE TABLE Employee (
  id INT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  department VARCHAR(50),
  managerId INT
);

-- insert manager first (managerId = NULL)
INSERT INTO Employee (id, name, department, managerId) VALUES
(101, 'John', 'A', NULL);
-- insert direct reports
INSERT INTO Employee VALUES
(102, 'Dan',   'A', 101),
(103, 'James', 'A', 101),
(104, 'Amy',   'A', 101),
(105, 'Anne',  'A', 101),
(106, 'Ron',   'B', 101);

select * from employee;


-- ques 1
select m.name
from employee m
join employee e
on m.id=e.managerId
group by m.name
having count(e.id)>=5;   -- count(m.name) is also working fine but for only this data set, find out where it'll fail and why e.id is more robust.



-- ******************************************************************************************************************



CREATE TABLE Employees (
  id INT PRIMARY KEY,
  salary INT NOT NULL
);
INSERT INTO Employees (id, salary) VALUES
(1, 100),
(2, 200),
(3, 300),
(4, 400),
(5, 500),
(6, 600);

select * from employees;


-- ques 2
-- doing it using stored function, not stored procedures

-- DROP FUNCTION IF EXISTS getNthHighestSalary;

DELIMITER $$
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
DETERMINISTIC    -- A function is deterministic if it always returns the same result for the same input values.
BEGIN
  DECLARE offset_val INT;    -- MySQL doesn’t allow expressions like N-1 directly inside LIMIT … OFFSET when you’re creating a stored function/procedure.
  SET offset_val = N - 1;     -- We need to handle OFFSET using a variable, not N-1 directly:
  RETURN (
    SELECT salary
    FROM (
      SELECT DISTINCT salary
      FROM employees
      ORDER BY salary DESC
      LIMIT offset_val, 1     -- here we cant write n-1 directly, thats why offset_val variable is used
    ) AS sub
  );
END $$
DELIMITER ;

SELECT getNthHighestSalary(2);



-- ******************************************************************************************************************





CREATE TABLE RequestAccepted (
    requester_id INT,
    accepter_id INT,
    accept_date DATE,
    PRIMARY KEY (requester_id, accepter_id)
);
INSERT INTO RequestAccepted (requester_id, accepter_id, accept_date) VALUES
(1, 2, '2016-06-03'),
(1, 3, '2016-06-08'),
(2, 3, '2016-06-08'),
(3, 4, '2016-06-09');

select * from requestaccepted;



-- ques 3
with temp as (
	select requester_id as id, accepter_id as accept
	from requestaccepted
	union
	select accepter_id, requester_id
	from requestaccepted
) 
-- select * from temp;
select id, count(id) as num
from temp
group by id
order by num desc
limit 1;




-- ******************************************************************************************************************

CREATE TABLE Seat (
    id INT PRIMARY KEY,
    student VARCHAR(50)
);
INSERT INTO Seat (id, student) VALUES
(1, 'Abbot'),
(2, 'Doris'),
(3, 'Emerson'),
(4, 'Green'),
(5, 'Jeames');


-- ques 4

select 
case when id%2=1 and id<(select max(id) from seat) then id+1
	 when id%2=0 then id-1
     else id
end as id,
student from seat
order by id;


-- ******************************************************************************************************************

CREATE TABLE Product (
    product_key INT PRIMARY KEY
);
CREATE TABLE Customer (
    customer_id INT,
    product_key INT,
    FOREIGN KEY (product_key) REFERENCES Product(product_key)
);
-- Product table
INSERT INTO Product (product_key) VALUES
(5),
(6);
-- Customer table
INSERT INTO Customer (customer_id, product_key) VALUES
(1, 5),
(2, 6),
(3, 5),
(3, 6),
(1, 6);


-- ques 5

-- for my understanding
-- with temp as(
-- 	select customer_id, count(*) as cnt
--     from customer
--     group by customer_id
-- )
-- select * from temp;

select customer_id
from customer
group by customer_id
having count(distinct product_key)=(select count(*) from product);



-- ******************************************************************************************************************


CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    join_date DATE,
    favorite_brand VARCHAR(50)
);

CREATE TABLE Items (
    item_id INT PRIMARY KEY,
    item_brand VARCHAR(50)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    item_id INT,
    buyer_id INT,
    seller_id INT,
    FOREIGN KEY (item_id) REFERENCES Items(item_id),
    FOREIGN KEY (buyer_id) REFERENCES Users(user_id),
    FOREIGN KEY (seller_id) REFERENCES Users(user_id)
);

-- Users
INSERT INTO Users (user_id, join_date, favorite_brand) VALUES
(1, '2018-01-01', 'Lenovo'),
(2, '2018-02-09', 'Samsung'),
(3, '2018-01-19', 'LG'),
(4, '2018-05-21', 'HP');

-- Items
INSERT INTO Items (item_id, item_brand) VALUES
(1, 'Samsung'),
(2, 'Lenovo'),
(3, 'LG'),
(4, 'HP');

-- Orders
INSERT INTO Orders (order_id, order_date, item_id, buyer_id, seller_id) VALUES
(1, '2019-08-01', 4, 1, 2),
(2, '2018-08-02', 2, 1, 3),
(3, '2019-08-03', 3, 2, 3),
(4, '2018-08-04', 1, 4, 2),
(5, '2018-08-04', 1, 3, 4),
(6, '2019-08-05', 2, 2, 4);


-- ques 6
select u.user_id as buyer_id, u.join_date, count(o.order_id) as orders_in_2019   -- not count(*)
from users u
left join
orders o
on u.user_id=o.buyer_id and o.order_date like "2019%"  -- or YEAR(o.order_date) = 2019
group by u.user_id, u.join_date;



-- ******************************************************************************************************************

CREATE TABLE Traffic (
    user_id INT,
    activity ENUM('login','logout','jobs','groups','homepage'),
    activity_date DATE
);
INSERT INTO Traffic (user_id, activity, activity_date) VALUES
(1, 'login', '2019-05-01'),
(1, 'homepage', '2019-05-01'),
(1, 'logout', '2019-05-01'),
(2, 'login', '2019-06-21'),
(2, 'logout', '2019-06-21'),
(3, 'login', '2019-01-01'),
(3, 'jobs', '2019-01-01'),
(3, 'logout', '2019-01-01'),
(4, 'login', '2019-06-21'),
(4, 'groups', '2019-06-21'),
(4, 'logout', '2019-06-21'),
(5, 'login', '2019-03-01'),
(5, 'logout', '2019-03-01'),
(5, 'login', '2019-06-21'),
(5, 'logout', '2019-06-21');

-- ques 7

select first_login, count(user_id) as user_count
from (   -- can also be done using cte instead of subquery
	select user_id, min(activity_date) as first_login
	from traffic
	where activity="login"
	group by user_id    -- Without GROUP BY, MIN(activity_date) would calculate the minimum for the whole table (just one value). Group all rows that belong to the same user_id, and then compute MIN(activity_date) for each group.
) temp
where first_login between date_sub("2019-06-30",interval 90 day) and "2019-06-30"
group by first_login;


-- ******************************************************************************************************************

-- Step 1: Create table
CREATE TABLE Products (
    product_id INT,
    new_price INT,
    change_date DATE,
    PRIMARY KEY (product_id, change_date)
);

-- Step 2: Insert sample data
INSERT INTO Products (product_id, new_price, change_date) VALUES
(1, 20, '2019-08-14'),
(2, 50, '2019-08-14'),
(1, 30, '2019-08-15'),
(1, 35, '2019-08-16'),
(2, 65, '2019-08-17'),
(3, 20, '2019-08-18');

-- ques 8

-- select product_id, new_price    -- was just trying...
-- from products 
-- where change_date<="2019-08-16";

with temp as (
	select product_id, new_price
	from products
	where (product_id, change_date) in (
		select product_id, max(change_date)    -- bcz we want the latest change in the price thats why
		from products
		where change_date<="2019-08-16"
		group by product_id
	)
)

select p.product_id, 
coalesce(t.new_price,10) as price   -- coalesce gives the first non null val, and if all null, then only it shows null
from (select distinct product_id from products) p   -- bcz we want for every product_id
left join
temp t
on p.product_id=t.product_id;


-- ******************************************************************************************************************

-- Step 1: Create Transactions table
CREATE TABLE Transactions (
    id INT PRIMARY KEY,
    country VARCHAR(50),
    state ENUM('approved', 'declined'),
    amount INT,
    trans_date DATE
);

-- Step 2: Create Chargebacks table
CREATE TABLE Chargebacks (
    trans_id INT,
    trans_date DATE,
    FOREIGN KEY (trans_id) REFERENCES Transactions(id)
);

-- Step 3: Insert sample data into Transactions
INSERT INTO Transactions (id, country, state, amount, trans_date) VALUES
(101, 'US', 'approved', 1000, '2019-05-18'),
(102, 'US', 'declined', 2000, '2019-05-19'),
(103, 'US', 'approved', 3000, '2019-06-10'),
(104, 'US', 'declined', 4000, '2019-06-13'),
(105, 'US', 'approved', 5000, '2019-06-15');

-- Step 4: Insert sample data into Chargebacks
INSERT INTO Chargebacks (trans_id, trans_date) VALUES
(102, '2019-05-29'),
(101, '2019-06-30'),
(105, '2019-09-18');


-- ques 9

WITH MonthCountry AS (
    -- Step 1: Get all months and countries from Transactions and Chargebacks
    SELECT DISTINCT DATE_FORMAT(trans_date, '%Y-%m') AS month, country
    FROM Transactions
    UNION
    SELECT DISTINCT DATE_FORMAT(cb.trans_date, '%Y-%m') AS month, t.country
    FROM Chargebacks cb
    JOIN Transactions t ON cb.trans_id = t.id
),
Approved AS (
    -- Step 2: Aggregate approved transactions
    SELECT DATE_FORMAT(trans_date, '%Y-%m') AS month,
           country,
           COUNT(*) AS approved_count,
           SUM(amount) AS approved_amount
    FROM Transactions
    WHERE state = 'approved'
    GROUP BY month, country
),
Chargeback AS (
    -- Step 3: Aggregate chargebacks
    SELECT DATE_FORMAT(cb.trans_date, '%Y-%m') AS month,
           t.country,
           COUNT(*) AS chargeback_count,
           SUM(t.amount) AS chargeback_amount
    FROM Chargebacks cb
    JOIN Transactions t ON cb.trans_id = t.id
    GROUP BY month, t.country
)
-- Step 4: Combine everything
SELECT 
    mc.month,
    mc.country,
    COALESCE(a.approved_count, 0) AS approved_count,
    COALESCE(a.approved_amount, 0) AS approved_amount,
    COALESCE(c.chargeback_count, 0) AS chargeback_count,
    COALESCE(c.chargeback_amount, 0) AS chargeback_amount
FROM MonthCountry mc
LEFT JOIN Approved a ON mc.month = a.month AND mc.country = a.country
LEFT JOIN Chargeback c ON mc.month = c.month AND mc.country = c.country
ORDER BY mc.month, mc.country;


-- ******************************************************************************************************************

-- Step 1: Create Teams table
CREATE TABLE Teams (
    team_id INT PRIMARY KEY,
    team_name VARCHAR(50)
);

-- Step 2: Create Matches table
CREATE TABLE Matches (
    match_id INT PRIMARY KEY,
    host_team INT,
    guest_team INT,
    host_goals INT,
    guest_goals INT
);

-- Step 3: Insert sample data into Teams
INSERT INTO Teams (team_id, team_name) VALUES
(10, 'Leetcode FC'),
(20, 'NewYork FC'),
(30, 'Atlanta FC'),
(40, 'Chicago FC'),
(50, 'Toronto FC');

-- Step 4: Insert sample data into Matches
INSERT INTO Matches (match_id, host_team, guest_team, host_goals, guest_goals) VALUES
(1, 10, 20, 3, 0),
(2, 30, 10, 2, 2),
(3, 10, 50, 5, 1),
(4, 20, 30, 1, 0),
(5, 50, 30, 1, 0);


-- ques 10

SELECT 
    t.team_id,
    t.team_name,
    COALESCE(SUM(
        CASE 
            WHEN t.team_id = m.host_team AND m.host_goals > m.guest_goals THEN 3
            WHEN t.team_id = m.host_team AND m.host_goals = m.guest_goals THEN 1
            WHEN t.team_id = m.guest_team AND m.guest_goals > m.host_goals THEN 3
            WHEN t.team_id = m.guest_team AND m.guest_goals = m.host_goals THEN 1
            ELSE 0
        END
    ), 0) AS num_points
FROM Teams t
LEFT JOIN Matches m 
    ON t.team_id = m.host_team OR t.team_id = m.guest_team
GROUP BY t.team_id, t.team_name
ORDER BY num_points DESC, t.team_id ASC;
