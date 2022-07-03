
DROP TABLE IF EXISTS employee_history;
DROP TABLE IF EXISTS EMPLOYEE;
DROP TABLE IF EXISTS department;
DROP TABLE IF EXISTS sales ;

create table department
(
	dept_id		int ,
	dept_name	varchar(50) PRIMARY KEY,
	location	varchar(100)
);
insert into department values (1, 'Admin', 'Bangalore');
insert into department values (2, 'HR', 'Bangalore');
insert into department values (3, 'IT', 'Bangalore');
insert into department values (4, 'Finance', 'Mumbai');
insert into department values (5, 'Marketing', 'Bangalore');
insert into department values (6, 'Sales', 'Mumbai');

CREATE TABLE EMPLOYEE
(
    EMP_ID      INT PRIMARY KEY,
    EMP_NAME    VARCHAR(50) NOT NULL,
    DEPT_NAME   VARCHAR(50) NOT NULL,
    SALARY      INT,
    constraint fk_emp foreign key(dept_name) references department(dept_name)
);
insert into employee values(101, 'Mohan', 'Admin', 4000);
insert into employee values(102, 'Rajkumar', 'HR', 3000);
insert into employee values(103, 'Akbar', 'IT', 4000);
insert into employee values(104, 'Dorvin', 'Finance', 6500);
insert into employee values(105, 'Rohit', 'HR', 3000);
insert into employee values(106, 'Rajesh',  'Finance', 5000);
insert into employee values(107, 'Preet', 'HR', 7000);
insert into employee values(108, 'Maryam', 'Admin', 4000);
insert into employee values(109, 'Sanjay', 'IT', 6500);
insert into employee values(110, 'Vasudha', 'IT', 7000);
insert into employee values(111, 'Melinda', 'IT', 8000);
insert into employee values(112, 'Komal', 'IT', 10000);
insert into employee values(113, 'Gautham', 'Admin', 2000);
insert into employee values(114, 'Manisha', 'HR', 3000);
insert into employee values(115, 'Chandni', 'IT', 4500);
insert into employee values(116, 'Satya', 'Finance', 6500);
insert into employee values(117, 'Adarsh', 'HR', 3500);
insert into employee values(118, 'Tejaswi', 'Finance', 5500);
insert into employee values(119, 'Cory', 'HR', 8000);
insert into employee values(120, 'Monica', 'Admin', 5000);
insert into employee values(121, 'Rosalin', 'IT', 6000);
insert into employee values(122, 'Ibrahim', 'IT', 8000);
insert into employee values(123, 'Vikram', 'IT', 8000);
insert into employee values(124, 'Dheeraj', 'IT', 11000);


CREATE TABLE employee_history
(
    emp_id      INT PRIMARY KEY,
    emp_name    VARCHAR(50) NOT NULL,
    dept_name   VARCHAR(50),
    salary      INT,
    location    VARCHAR(100),
    constraint fk_emp_hist_01 foreign key(dept_name) references department(dept_name),
    constraint fk_emp_hist_02 foreign key(emp_id) references employee(emp_id)
);

create table sales
(
	store_id  		int,
	store_name  	varchar(50),
	product_name	varchar(50),
	quantity		int,
	price	     	int
);
insert into sales values
(1, 'Apple Store 1','iPhone 13 Pro', 1, 1000),
(1, 'Apple Store 1','MacBook pro 14', 3, 6000),
(1, 'Apple Store 1','AirPods Pro', 2, 500),
(2, 'Apple Store 2','iPhone 13 Pro', 2, 2000),
(3, 'Apple Store 3','iPhone 12 Pro', 1, 750),
(3, 'Apple Store 3','MacBook pro 14', 1, 2000),
(3, 'Apple Store 3','MacBook Air', 4, 4400),
(3, 'Apple Store 3','iPhone 13', 2, 1800),
(3, 'Apple Store 3','AirPods Pro', 3, 750),
(4, 'Apple Store 4','iPhone 12 Pro', 2, 1500),
(4, 'Apple Store 4','MacBook pro 16', 1, 3500);


select * from department;
select * from employee_history;
select * from sales;


/* QUESTION 1: Find the employees who's salary is more than the average salary earned by all employees */
-- SCALER SUBQUERY - It always returns 1 row and 1 column.

SELECT * -- OUTER QUERY / MAIN QUERY
FROM employee
WHERE salary > (
				SELECT AVG(salary) -- SUBQUERY / INNER QUERY
				FROM employee
				) 

SELECT A.* 
FROM employee A
JOIN 
(SELECT AVG(salary) AS sal
FROM employee) B
ON A.salary > B.sal


/* QUESTION 2: Find the employees who earn the highest salary in each department. */
-- MULTIPLE ROW SUBQUERY - returns multiple column, and multiple rows OR 1 col and multiple rows

SELECT * 
FROM employee 
WHERE (dept_name, salary) IN (SELECT dept_name, MAX(salary) 
							   FROM employee
							   GROUP BY dept_name
							   )


-- Single column, multiple row subquery
/* QUESTION 3: Find department who do not have any employees */

SELECT dept_name 
FROM department 
WHERE dept_name NOT IN (SELECT DISTINCT dept_name 
						FROM employee
						)


/* QUESTION 4: Find the employees in each department who earn more than the average salary in that department. */
-- CORRELATED SUBQUERY - A subquery which is related to the Outer query
SELECT * 
FROM employee A1 
WHERE salary > (SELECT AVG(salary) 
				FROM employee A2 
				WHERE A2.dept_name = A1.dept_name
				)

/* QUESTION 3: Find department who do not have any employees using correlated subquery */
SELECT * 
FROM department A1 
WHERE NOT EXISTS (SELECT 1 
				  FROM employee A2 
				  WHERE A1.dept_name = A2.dept_name 
				  );
				  
/* QUESTION 5: Find stores who's sales where better than the average sales accross all stores */

WITH sales AS (SELECT store_name, SUM(price) AS total_sales 
			   FROM sales
			   GROUP BY store_name)

SELECT sales.* 
FROM sales
JOIN 
(SELECT AVG(total_sales) AS avg_all FROM
sales) avg_sales
ON sales.total_sales > avg_sales.avg_all


/* QUESTION 6: Fetch all employee details and add remarks to those employees who earn more than the average pay. */
SELECT *, (CASE WHEN salary > (
								SELECT AVG(salary) 
								FROM employee) 
					THEN 'MORE THAN AVERAGE'
				ELSE NULL 
				END) AS remark
FROM employee 


/* QUESTION 7: Find the stores who have sold more units than the average units sold by all stores. */
SELECT store_name, SUM(quantity) 
FROM sales
GROUP BY store_name 
HAVING SUM(quantity) > (SELECT AVG(quantity)
						 FROM sales);
						 
						 
/* QUESTION 8: Insert data to employee history table. Make sure not insert duplicate records. */

SELECT * FROM employee_history

INSERT INTO employee_history
SELECT E.*, D.location 
FROM employee E 
JOIN department D 
ON E.dept_name = D.dept_name
WHERE NOT EXISTS (SELECT 1 
				FROM employee_history eh 
				WHERE eh.emp_id = e.emp_id
				)
			
				
/* QUESTION 9: Give 10% increment to all employees in Bangalore location based on the maximum
salary earned by an emp in each dept. Only consider employees in employee_history table. */

SELECT * FROM employee_history

UPDATE EMPLOYEE E
SET salary = (SELECT MAX(salary) + (0.1 * MAX(SALARY)) 
				FROM employee_history EH WHERE
				EH.dept_name = E.dept_name
				)
				
WHERE E.dept_name IN (SELECT dept_name 
					FROM department 
					WHERE location='Bangalore') 

AND E.emp_id IN (SELECT emp_id 
			   FROM employee_history)


/* QUESTION 10: Delete all departments who do not have any employees. */
DELETE FROM department 
WHERE dept_name IN ( SELECT dept_name 
					FROM department A1 
					WHERE NOT EXISTS (SELECT 1 
				  						FROM employee A2 
				  						WHERE A1.dept_name = A2.dept_name 
				  						)
					);
					
	