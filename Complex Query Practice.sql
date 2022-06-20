-- Q1) Write a SQL query to fetch all the duplicate records from a table.

create table users
(
user_id int primary key,
user_name varchar(30) not null,
email varchar(50));

insert into users values
(1, 'Sumit', 'sumit@gmail.com'),
(2, 'Reshma', 'reshma@gmail.com'),
(3, 'Farhana', 'farhana@gmail.com'),
(4, 'Robin', 'robin@gmail.com'),
(5, 'Robin', 'robin@gmail.com');

SELECT * FROM users;

-- SOLUTION

SELECT * FROM(
SELECT *, ROW_NUMBER() OVER(PARTITION BY user_name, email ORDER BY email) 
FROM users ) X
WHERE row_number > 1

-- Q2) Write a SQL query to fetch the employee with second highest salary from employee table.

create table employee
( emp_ID int primary key
, emp_NAME varchar(50) not null
, DEPT_NAME varchar(50)
, SALARY int);

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

select * from employee;

-- SOLUTION

SELECT emp_id, emp_name, dept_name, salary 
FROM(
SELECT *, ROW_NUMBER() OVER(ORDER BY salary desc)
FROM employee) X
WHERE row_number = 2;

-- Q3) Write a SQL query to display only the details of employees who either earn the highest salary or the lowest salary in each department from the employee table.

-- SOLUTION

SELECT * 
FROM (
SELECT *, RANK() OVER(PARTITION BY dept_name ORDER BY salary DESC, emp_id) 
FROM employee
UNION 
SELECT *, RANK() OVER(PARTITION BY dept_name ORDER BY salary, emp_id) 
FROM employee
ORDER BY dept_name, salary) X
WHERE rank=1;


-- Q4) From the doctors table, fetch the details of doctors who work in the same hospital but in different specialty.

create table doctors
(
id int primary key,
name varchar(50) not null,
speciality varchar(100),
hospital varchar(50),
city varchar(50),
consultation_fee int
);

insert into doctors values
(1, 'Dr. Shashank', 'Ayurveda', 'Apollo Hospital', 'Bangalore', 2500),
(2, 'Dr. Abdul', 'Homeopathy', 'Fortis Hospital', 'Bangalore', 2000),
(3, 'Dr. Shwetha', 'Homeopathy', 'KMC Hospital', 'Manipal', 1000),
(4, 'Dr. Murphy', 'Dermatology', 'KMC Hospital', 'Manipal', 1500),
(5, 'Dr. Farhana', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1700),
(6, 'Dr. Maryam', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1500);

select * from doctors;

-- SOLUTION

SELECT D1.* 
FROM doctors D1
JOIN doctors D2
ON D1.hospital = D2.hospital AND D1.speciality <> D2.speciality


-- Q5) From the login_details table, fetch the users who logged in consecutively 3 or more times.

create table login_details(
login_id int primary key,
user_name varchar(50) not null,
login_date date);

delete from login_details;
insert into login_details values
(101, 'Michael', current_date),
(102, 'James', current_date),
(103, 'Stewart', current_date+1),
(104, 'Stewart', current_date+1),
(105, 'Stewart', current_date+1),
(106, 'Michael', current_date+2),
(107, 'Michael', current_date+2),
(108, 'Stewart', current_date+3),
(109, 'Stewart', current_date+3),
(110, 'James', current_date+4),
(111, 'James', current_date+4),
(112, 'James', current_date+5),
(113, 'James', current_date+6);

select * from login_details;
 
-- SOLUTION 

SELECT  DISTINCT repeated_name
FROM (
SELECT *, CASE WHEN user_name = LEAD(user_name) OVER() 
AND user_name = LEAD(user_name,2) OVER()
THEN user_name else NULL END AS repeated_name
FROM login_details) X
WHERE repeated_name IS NOT NULL


-- Q6) From the students table, write a SQL query to interchange the adjacent student names.

create table students
(
id int primary key,
student_name varchar(50) not null
);
insert into students values
(1, 'James'),
(2, 'Michael'),
(3, 'George'),
(4, 'Stewart'),
(5, 'Robin');

select * from students;

-- SOLUTION

SELECT *,
CASE WHEN id % 2 <> 0 THEN LEAD(student_name, 1, student_name) OVER(ORDER BY id)
WHEN id % 2 = 0 THEN LAG(student_name) OVER(ORDER BY id) END AS adj_name
FROM students


-- Q7) From the weather table, fetch all the records when London had extremely cold temperature for 3 consecutive days or more.

create table weather
(
id int,
city varchar(50),
temperature int,
day date
);
delete from weather;
insert into weather values
(1, 'London', -1, to_date('2021-01-01','yyyy-mm-dd')),
(2, 'London', -2, to_date('2021-01-02','yyyy-mm-dd')),
(3, 'London', 4, to_date('2021-01-03','yyyy-mm-dd')),
(4, 'London', 1, to_date('2021-01-04','yyyy-mm-dd')),
(5, 'London', -2, to_date('2021-01-05','yyyy-mm-dd')),
(6, 'London', -5, to_date('2021-01-06','yyyy-mm-dd')),
(7, 'London', -7, to_date('2021-01-07','yyyy-mm-dd')),
(8, 'London', 5, to_date('2021-01-08','yyyy-mm-dd'));

select * from weather;

-- SOLUTION

SELECT id, city, temperature, day 
FROM (
SELECT *, 
CASE WHEN temperature < 0 
AND LEAD(temperature) OVER() < 0 
AND LEAD(temperature,2) OVER() < 0 
THEN temperature 

WHEN temperature < 0 
AND LEAD(temperature) OVER() < 0 
AND LAG(temperature) OVER() < 0 
THEN temperature

WHEN temperature < 0 
AND LAG(temperature,2) OVER() < 0 
AND LAG(temperature) OVER() < 0 
THEN temperature END AS flag 

FROM weather
) X
WHERE flag IS NOT NULL


--Q8) Find the top 2 accounts with the maximum number of unique patients on a monthly basis.

create table patient_logs
(
  account_id int,
  date date,
  patient_id int
);

insert into patient_logs values (1, to_date('02-01-2020','dd-mm-yyyy'), 100);
insert into patient_logs values (1, to_date('27-01-2020','dd-mm-yyyy'), 200);
insert into patient_logs values (2, to_date('01-01-2020','dd-mm-yyyy'), 300);
insert into patient_logs values (2, to_date('21-01-2020','dd-mm-yyyy'), 400);
insert into patient_logs values (2, to_date('21-01-2020','dd-mm-yyyy'), 300);
insert into patient_logs values (2, to_date('01-01-2020','dd-mm-yyyy'), 500);
insert into patient_logs values (3, to_date('20-01-2020','dd-mm-yyyy'), 400);
insert into patient_logs values (1, to_date('04-03-2020','dd-mm-yyyy'), 500);
insert into patient_logs values (3, to_date('20-01-2020','dd-mm-yyyy'), 450);

select * from patient_logs;

-- SOLUTION

SELECT * FROM (
SELECT *, RANK() OVER (PARTITION BY month ORDER BY count DESC, account_id)
FROM (
SELECT account_id, month, COUNT(patient_id) FROM
(
SELECT account_id, date, patient_id, month
FROM(
SELECT *, ROW_NUMBER() OVER(PARTITION BY account_id, patient_id, month) as rn
FROM (
SELECT *, to_char(date, 'month') AS month
FROM patient_logs) X
) Y
WHERE rn = 1) Z
GROUP BY account_id, month
) X1 ) X2
WHERE rank <= 2