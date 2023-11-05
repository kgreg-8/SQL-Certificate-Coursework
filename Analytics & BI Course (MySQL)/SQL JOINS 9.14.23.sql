-- Intro to JOINS --
USE employees;

ALTER TABLE departments_dup
DROP COLUMN dept_manager;
-- DROP is used within the ALTER statment for specific drop actions, otherwise it can be used simply as DROP table_name --

SELECT * FROM departments_dup;

ALTER TABLE departments_dup
CHANGE COLUMN dept_no dept_no CHAR(4) NULL;

ALTER TABLE departments_dup
CHANGE COLUMN dept_name dept_name VARCHAR(40) NULL;

INSERT INTO departments_dup (dept_name)
VALUES ('Public Relations');

DELETE FROM departments_duo
WHERE dept_no = 'd002';
-- lesson: use DROP to remove a column. use DELETE FROM ... WHERE to remove specific rows --

-- Exercise 2 --
DROP TABLE IF EXISTS dept_manager_dup;
CREATE TABLE dept_manager_dup 
( 
	emp_no int(11) NOT NULL,
    dept_no CHAR(4) NULL,
    from_date date NOT NULL,
    to_date date NULL
);

INSERT INTO dept_manager_dup
select * from dept_manager;

select * from dept_manager_dup;

INSERT INTO dept_manager_dup (emp_no, from_date)
VALUES 
	(999904, '2017-01-01'),
    (999905, '2017-01-01'),
    (999906, '2017-01-01'),
    (999907, '2017-01-01'); 
-- lesson: each new row's values needs to be in (), not one big one --

DELETE FROM dept_manager_dup
WHERE dept_no = 'd001';

-- INNER JOIN --
select m.dept_no, m.emp_no, d.dept_name
from dept_manager_dup m -- the 'm' allows you to specify a shorthand name for this table (don't need to but can include the keyword AS --
inner join departments_dup d on m.dept_no = d.dept_no -- PRIMARY Key to join these tables--
ORDER BY m.dept_no; -- Only NON NULL values for dept_no appear

-- It can be easier to start a JOIN query by writing the FROM & JOIN statements first and then coming back to write the SELECT statement with the columns you want --

-- Exercise --
SELECT m.emp_no, e.first_name, e.last_name, m.dept_no, e.hire_date
FROM dept_manager m
INNER JOIN employees e ON m.emp_no = e.emp_no
ORDER BY m.emp_no;

-- QUESTION: how to know which table should be the table specified in the FROM statement vs  JOIN statement? Is there a difference if the order is mixed up? --
# the order does NOT matter in which you join tables
-- Handling Duplicate Records --
# adding duplicate records to these 2 tables
INSERT INTO dept_manager_dup
VALUES ('110228', 'd003', '1992-03-21', '9999-01-01');

INSERT INTO departments_dup
VALUES ('d009', 'Customer Service');

# test the join again and see there are more rows than the last time you ran this query (prior to adding the duplicate records)
select m.dept_no, m.emp_no, d.dept_name
from dept_manager_dup m 
inner join departments_dup d on m.dept_no = d.dept_no 
GROUP BY m.emp_no -- add GROUP BY (the field that differs the most) to consolidate the outputs and remove the duplicates --
ORDER BY m.dept_no;

-- LEFT JOIN --
# remove the duplicates you just added 
delete from dept_manager_dup where emp_no = '110228';
delete from departments_dup where dept_no = 'd009';

#b/c 2 rows were removed we want to add 1 version of each record back to the tables 
INSERT INTO dept_manager_dup
VALUES ('110228', 'd003', '1992-03-21', '9999-01-01');

INSERT INTO departments_dup
VALUES ('d009', 'Customer Service');

# Left Join 
SELECT 
    m.dept_no, m.emp_no, d.dept_name
FROM
    dept_manager_dup m
        LEFT JOIN
    departments_dup d ON m.dept_no = d.dept_no
ORDER BY m.dept_no;  -- returns 6 more rows than the inner join (includes non-matching values that have a NULL value for dept_no, hence there are 6 more rows -- 
# the order in which you do join tables for left joins matters
# RETRIEVE THE FIRST SELECTED COLUMN FROM THE FIRST SPECIFIED TABLE

-- HOW TO KNOW WHICH TABLE SHOULD COME FIRST??

-- Exercise --
SELECT e.emp_no, e.first_name, e.last_name, dm.dept_no, dm.from_date
FROM employees e
LEFT JOIN dept_manager dm ON e.emp_no = dm.emp_no
WHERE e.last_name = 'Markovitch'
ORDER BY dm.dept_no DESC AND e.emp_no;

# Old Syntax Exercise
SELECT e.emp_no, e.first_name, e.last_name, dm.dept_no, dm.from_date
FROM 
	employees e,
    dept_manager dm
WHERE e.emp_no = dm.emp_no;

-- JOIN & WHERE used together --
SELECT e.emp_no, e.first_name, e.last_name, s.salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
WHERE s.salary > 145000;

#Preventing Error Code 1055 (lecture 185)
set @@global.sql_mode := replace(@@global.sql_mode, 'ONLY_FULL_GROUP_BY', '');

-- Exercise --
SELECT e.emp_no, e.first_name, e.last_name, e.hire_date, t.title
FROM employees e
 JOIN titles t ON e.emp_no = t.emp_no
WHERE e.first_name = 'Margareta' AND e.last_name = 'Markovitch';

-- CROSS JOINS --
select dm.*, d.*
from dept_manager dm
cross join departments d
order by dm.emp_no, d.dept_no;

# Exercise
select dm.*, d.*
from dept_manager dm
cross join departments d
where d.dept_no = 'd009'
ORDER by d.dept_no;

# Exercise 2
select * from employees order by emp_no;

select e.*, de.*
from employees e
cross join dept_emp de
where de.emp_no in ('10001', '10002', '10003', '10004', '10005', '10006', '10007', '10008', '10009', '10010');

# Actual Solution
select e.*, d.*
from employees e
cross join departments d
where e.emp_no < 10011
order by e.emp_no, d.dept_no;

-- Joins with Aggregate Functions --
SELECT 
    e.gender, AVG(salary) AS average_salary
FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
GROUP BY gender; # Group By is essential to use when/if an aggregate function is used. (makes sense)

-- JOIN > 2 Tables --
SELECT
	e.first_name,
    e.last_name,
    e.hire_date,
    dm.from_date,
    d.dept_name
FROM
	employees e
		JOIN
	dept_manager dm ON e.emp_no = dm.emp_no
		JOIN
	departments d ON dm.dept_no = d.dept_no
;

# Exercise 195
# Select all managers' first & last names, hire dates, job titles, start dates and department names.
# need the employees, dept_manager, titles & departments tables
SELECT
	e.first_name,
    e.last_name,
    e.hire_date,
    t.title,
    dm.from_date,
    d.dept_name
FROM
	employees e
		JOIN
	titles t ON e.emp_no = t.emp_no
        JOIN
	dept_manager dm ON t.emp_no = dm.emp_no
		JOIN
	departments d ON dm.dept_no = d.dept_no
WHERE t.title = 'Manager'		
ORDER BY e.emp_no
; # 24 rows
	
-- Tips & Tricks for JOINS --
SELECT 
    d.dept_name, AVG(salary) AS avg_salary
FROM
    departments d
        JOIN
    dept_manager dm ON d.dept_no = dm.dept_no
        JOIN
    salaries s ON dm.emp_no = s.emp_no
GROUP BY d.dept_name -- Again GROUP BY is necessary b/c of the aggregated function, but also b/c without it, if the query runs successfully it will only return the first dept_name and avg salary as the result.alter --
ORDER BY avg_salary DESC;

# Exercise 198 - How many male & female managers do we have in the 'employees' dB?
# aggr. f(x) => COUNT
# tables: employees (gender), dept_manager (& titles)

/** 
SELECT
	e.gender, COUNT(title) as managers
FROM
	employees e
		JOIN
	dept_manager dm ON e.emp_no = dm.emp_no
		JOIN
	titles t ON dm.emp_no = t.emp_no
GROUP BY gender
; # M:23, F:31 -- INCORRECT!
**/

SELECT
	e.gender, COUNT(dm.emp_no) as managers
FROM
	employees e
		JOIN
	dept_manager dm ON e.emp_no = dm.emp_no
GROUP BY gender; # M:11, F:13

-- UNION vs UNION ALL --
CREATE TABLE employees_dup (
emp_no int(11) NOT NULL,
  birth_date date ,
  first_name varchar(14),
  last_name varchar(16),
  gender enum('M','F'),
  hire_date date
);
INSERT INTO employees_dup
SELECT e.*
FROM employees e
LIMIT 20;

select * from employees_dup;

INSERT INTO employees_dup
VALUES ('10001', '1953-09-02', 'Georgi', 'Facello', 'M', '1986-06-26');

# UNION ALL - used to combine a few SELECT statements in a single output (a tool that allows you to unify tables)
select
	e.emp_no,
    e.first_name,
    e.last_name,
    NULL AS dept_no,
    NULL AS from_date
FROM employees_dup e
WHERE e.emp_no = '10001'
UNION ALL SELECT
	NULL AS emp_no,
    NULL AS first_name,
    NULL AS last_name,
    m.dept_no,
    m.from_date
FROM dept_manager m;

# UNION
select
	e.emp_no,
    e.first_name,
    e.last_name,
    NULL AS dept_no,
    NULL AS from_date
FROM employees_dup e
WHERE e.emp_no = '10001'
UNION SELECT
	NULL AS emp_no,
    NULL AS first_name,
    NULL AS last_name,
    m.dept_no,
    m.from_date
FROM dept_manager m # returns one fewer row than UNION ALL (removes the duplicate record we added for emp_no 10001.
ORDER BY -a.emp_no DESC;

-- Subqueries & IN inside WHERE --
# select the fist & last namne from the employees table for the same emp_nos that can be foundin the dept_manager table
Select e.first_name, e.last_name
From employees e
WHERE e.emp_no IN (Select dm.emp_no
	From dept_manager dm);

# Exercise 204 - Extract the information about all department managers who were hired between the 1st of January 1990 and the 1st of January 1995.
# Tables needed: employees (hire_date), dept_manager
SELECT 
    e.*
FROM
    employees e
WHERE
    e.emp_no IN (SELECT 
            dm.emp_no
        FROM
            dept_manager dm)
        AND e.hire_date BETWEEN '1990-01-01' AND '1995-01-01'
; # 2 rows - 110420 Oscar G (hired on 1995-02-05) & 111877 Xiaobin S hired on 1991-08-17

# the course's code for the answer is below. I like mine, above, because it includes the name of the employee.
SELECT *
FROM dept_manager
WHERE emp_no IN (SELECT emp_no
		FROM employees
        WHERE hire_date BETWEEN '1990-01-01' AND '1995-01-01');


-- Subqueries & EXISTS --
# Select the entire information for all employees whose job title is “Assistant Engineer”. 
Select * 
FROM employees e
WHERE
	EXISTS(
		SELECT *
        FROM titles t
        WHERE t.emp_no = e.emp_no AND title = 'Assistant Engineer');
        
-- Subqueries nested in SELECT & FROM --
# Best practice: build subqueries off the simpler queries you want to start with
SELECT A.*
FROM
	(SELECT 
		e.emp_no AS Employee_ID,
		MIN(de.dept_no) AS Department_Code,
		(SELECT 
				emp_no
			FROM
				employees e
			WHERE
				emp_no = 110022) AS manager_ID
	FROM
		employees e
			JOIN
		dept_emp de ON e.emp_no = de.emp_no
	WHERE
		e.emp_no <= 10020
	GROUP BY e.emp_no
	ORDER BY e.emp_no) AS A
UNION SELECT
B.*
FROM
	(SELECT 
		e.emp_no AS Employee_ID,
		MIN(de.dept_no) AS Department_Code,
		(SELECT 
				emp_no
			FROM
				employees e
			WHERE
				emp_no = 110039) AS manager_ID
	FROM
		employees e
			JOIN
		dept_emp de ON e.emp_no = de.emp_no
	WHERE
		e.emp_no BETWEEN 10021 AND 10040
	GROUP BY e.emp_no
	ORDER BY e.emp_no) AS B
;

# Exercise 210 & 211: Starting your code with “DROP TABLE”, create a table called “emp_manager” (emp_no – integer of 11, not null; dept_no – CHAR of 4, null; manager_no – integer of 11, not null). 
DROP TABLE IF EXISTS emp_manager;
CREATE TABLE emp_manager 
	(emp_no int NOT NULL, dept_no CHAR NULL, manager_no int NOT NULL);

# Fill emp_manager with data about employees, the number of the department they are working in, and their managers
INSERT IGNORE INTO emp_manager SELECT
U.*
FROM
	(SELECT 
		A.*
	FROM
		(SELECT 
			e.emp_no as employee_ID,
			MIN(de.dept_no) as department_code,
			(SELECT 
					emp_no
				FROM
					employees e
				WHERE
					emp_no = 110022) AS manager_ID
		FROM
			employees e
		JOIN dept_emp de ON e.emp_no = de.emp_no
		WHERE
			e.emp_no <= 10020
		GROUP BY e.emp_no
		ORDER BY e.emp_no) AS A 
	UNION SELECT 
		B.*
	FROM
		(SELECT 
			e.emp_no as employee_ID,
			MIN(de.dept_no) as department_code,
			(SELECT 
					emp_no
				FROM
					employees e
				WHERE
					emp_no = 110039) AS manager_ID
		FROM
			employees e
		JOIN dept_emp de ON e.emp_no = de.emp_no
		WHERE
			e.emp_no BETWEEN 10021 AND 10040
		GROUP BY e.emp_no
		ORDER BY e.emp_no) AS B
	UNION SELECT
		C.*
	FROM
		(SELECT 
			e.emp_no as employee_ID,
			MIN(de.dept_no) as department_code,
			(SELECT 
					emp_no
				FROM
					employees e
				WHERE
					emp_no = 110039) AS manager_no
		FROM
			employees e
		JOIN dept_emp de ON e.emp_no = de.emp_no
		WHERE
			e.emp_no = 110022
		GROUP BY e.emp_no
		ORDER BY e.emp_no) AS C
	UNION SELECT
		D.*
	FROM 
		(SELECT 
			e.emp_no as employee_ID,
			MIN(de.dept_no) as department_code,
			(SELECT 
					emp_no
				FROM
					employees e
				WHERE
					emp_no = 110022) AS manager_no
		FROM
			employees e
		JOIN dept_emp de ON e.emp_no = de.emp_no
		WHERE
			e.emp_no = 110039
		GROUP BY e.emp_no
		ORDER BY e.emp_no) AS D
        ) AS U;

select * from emp_manager;

