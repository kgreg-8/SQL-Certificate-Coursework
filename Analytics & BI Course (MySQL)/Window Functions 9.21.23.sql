-- WINDOW FUNCTIONS --
USE employees;
select
	emp_no,
    salary,
    ROW_NUMBER() OVER(PARTITION BY emp_no ORDER BY salary DESC) AS row_num
from salaries;

# Exercise 259: Part 1 - Write a query that upon execution, assigns a row number to all managers we have information for in the "employees" database (regardless of their department).
# Let the numbering disregard the department the managers have worked in. Also, let it start from the value of 1. Assign that value to the manager with the lowest employee number.
Select 
	ROW_NUMBER() OVER(ORDER BY emp_no ASC) AS row_id,
    emp_no,
    dept_no
From dept_manager;

# 259 Part 2 - Write a query that upon execution, assigns a sequential number for each employee number registered in the "employees" table. 
# Partition the data by the employee's first name and order it by their last name in ascending order (for each partition).
SELECT
	ROW_NUMBER() OVER(partition by first_name order by last_name ASC) as row_id,
    emp_no,
    first_name,
    last_name
FROM
	employees;

# Using multiple window functions in a query
# Exercise 262: Part 1 
Select
	ROW_NUMBER() OVER(partition by emp_no ORDER BY s.salary) as row_id,
    dm.emp_no,
    s.salary,
    ROW_NUMBER() OVER(partition by dm.emp_no order by s.salary DESC) as salary_groups
FROM
	dept_manager dm
		JOIN
	salaries s ON dm.emp_no = s.emp_no;
    
# 262 Part 2
Select
    dm.emp_no,
    s.salary,
	ROW_NUMBER() OVER() as row_1,
    ROW_NUMBER() OVER(partition by dm.emp_no order by s.salary DESC) as row_2
FROM
	dept_manager dm
		JOIN
	salaries s ON dm.emp_no = s.emp_no
ORDER BY row_1, emp_no, salary;

# Exercise 265: Write a query that provides row numbers for all workers from the "employees" table, partitioning the data by their 
# first names and ordering each partition by their employee number in ascending order.
SELECT
	*,
    ROW_NUMBER() OVER w AS row_num
FROM 
	employees
WINDOW w AS (PARTITION BY first_name ORDER BY emp_no);

-- PARTITION BY vs GROUP BY --
Select emp_no, MAX(salary) as max_salary
FROM salaries
GROUP BY emp_no;

Select * from salaries where emp_no = '10001';

SELECT 
	a.emp_no,
    MAX(salary) as max_salary
FROM (
	SELECT emp_no, salary 
    FROM salaries) a
GROUP BY emp_no;

# Exercise 268: Part 1 - Find out the lowest salary value each employee has ever signed a contract for. To obtain the desired output, 
# use a subquery containing a window function, as well as a window specification introduced with the help of the WINDOW keyword.

# Simplified version to check the outcome
SELECT 
	emp_no,
    MIN(salary) as lowest_sal_ever
FROM salaries
GROUP BY emp_no;

# version with subquery
SELECT 
	a.emp_no,
    MIN(salary) as lowest_sal_ever FROM (
    SELECT emp_no, salary, ROW_NUMBER() OVER w AS row_num
    FROM salaries
    WINDOW w AS (PARTITION BY emp_no ORDER BY salary ASC)) a
GROUP BY emp_no;

# Part 2 - Again, find out the lowest salary value each employee has ever signed a contract for. Once again, to obtain the desired output, 
# use a subquery containing a window function. This time, however, introduce the window specification in the field list of the given subquery.
SELECT 
	a.emp_no,
    MIN(salary) as lowest_sal_ever FROM (
    SELECT emp_no, salary, ROW_NUMBER() OVER(PARTITION BY emp_no ORDER BY salary ASC) AS row_num
    FROM salaries) a
GROUP BY emp_no;

# Part 3 - Once again, find out the lowest salary value each employee has ever signed a contract for. This time, to obtain the desired output, 
# avoid using a window function. Just use an aggregate function and a subquery.
SELECT 
	a.emp_no,
    MIN(salary) as lowest_sal_ever
FROM (SELECT emp_no, salary FROM salaries) a
GROUP BY emp_no;

# Part 4 - Once more, find out the lowest salary value each employee has ever signed a contract for. To obtain the desired output, use a subquery
# containing a window function, as well as a window specification introduced with the help of the WINDOW keyword. Moreover, obtain the output 
# without using a GROUP BY clause in the outer query.
SELECT 
	a.emp_no,
    a.salary as min_salary FROM (
    SELECT emp_no, salary, ROW_NUMBER() OVER w AS row_num
    FROM salaries
    WINDOW w AS (PARTITION BY emp_no ORDER BY salary ASC)) a
WHERE a.row_num = 1;

# Part 5 - Obtain the 2nd lowest salary.
SELECT 
	a.emp_no,
    a.salary as min_salary FROM (
    SELECT emp_no, salary, ROW_NUMBER() OVER w AS row_num
    FROM salaries
    WINDOW w AS (PARTITION BY emp_no ORDER BY salary ASC)) a
WHERE a.row_num = 2;

# Exercise 271: Part 1 - Write a query containing a window function to obtain all salary values that employee number 10560 has ever signed a contract for.
# Order and display the obtained salary values from highest to lowest.
Select
	emp_no,
    salary,
    ROW_NUMBER() OVER(ORDER BY salary DESC) as row_num
FROM 
	salaries
WHERE emp_no = 10560;

# Part 2 - Write a query that upon execution, displays the number of salary contracts that each manager has ever signed while working in the company.
SELECT dm.emp_no, COUNT(salary) as no_of_salary_contracts
FROM dept_manager dm
		JOIN
    salaries s ON dm.emp_no = s.emp_no
GROUP BY emp_no;

# Part 3 - Write a query that upon execution retrieves a result set containing all salary values that employee 10560 has ever signed a contract for. 
# Use a window function to rank all salary values from highest to lowest in a way that equal salary values bear the same rank and that gaps in the 
# obtained ranks for subsequent rows are allowed.
Select
	emp_no,
    salary,
    RANK() OVER(ORDER BY salary DESC) as row_num
FROM 
	salaries
WHERE emp_no = 10560;

# Part 4 - Write a query that upon execution retrieves a result set containing all salary values that employee 10560 has ever signed a contract for. 
# Use a window function to rank all salary values from highest to lowest in a way that equal salary values bear the same rank and that gaps in the 
# obtained ranks for subsequent rows are not allowed.
Select
	emp_no,
    salary,
    DENSE_RANK() OVER(ORDER BY salary DESC) as row_num
FROM 
	salaries
WHERE emp_no = 10560;

-- Lesson 273: Ranking Window Functions & Joins --
# Create a query that will complete all the following subtasks at once:
  # Obtain data only about the managers
  # Partition the relevant information by the department where the managers have worked in
  # Arrange the partitions by the managers' salary contract values in DESC
  # Rank the mgrs based on salaries in a certain dept (keep track of the # of salary contracts signed within each dept
  # Display the start & end dates of each salary contract
  # Display the first & last date in which an employee has been a manager (dept_manager table)
  
-- Step 1: Setup the joins --
-- Step 2: Create the Window alias since you know the partitions and order by --
-- Step 3: Complete the field list (what fields do you want in the result - specify in SELECT)
SELECT
	d.dept_no,
    d.dept_name,
    dm.emp_no,
    RANK() OVER w AS dept_sal_ranking,
    s.salary,
    s.from_date as salary_from_date,
    s.to_date as salary_to_date,
    dm.from_date AS dept_manager_from_date,
    dm.to_date AS dept_manager_to_date
FROM
	dept_manager dm
		JOIN
	salaries s ON dm.emp_no = s.emp_no
		AND s.from_date BETWEEN dm.from_date AND dm.to_date
		JOIN
	departments d ON dm.dept_no = d.dept_no
WINDOW w AS (PARTITION BY d.dept_no ORDER BY s.salary DESC);

# Exercise 274: Part 1 - Write a query that ranks the salary values in descending order of all contracts signed by employees numbered between 
# 10500 and 10600 inclusive. Let equal salary values for one and the same employee bear the same rank. Also, allow gaps in the ranks obtained for their subsequent rows.
SELECT
	RANK() OVER w AS rank_num,
    e.emp_no,
    e.first_name,
    e.last_name,
    s.salary,
    e.hire_date as hire_date,
    s.from_date as salary_from_date,
    s.to_date as salary_to_date
FROM 
	employees e
		JOIN
	salaries s ON e.emp_no = s.emp_no AND s.from_date BETWEEN dm.from_date AND dm.to_date
WHERE e.emp_no BETWEEN 10500 AND 10600 AND s.from_date 
WINDOW w AS (partition by emp_no order by salary DESC)
;

# Simple check for Part 1 
Select emp_no, salary from salaries where emp_no BETWEEN 10500 AND 10600 ORDER BY salary DESC;

# Part 2 - rank salary values in DESC based on 1) contracts are signed by employees 10500-10600 2) contracts were signed 4 years after the emp was hired
# 3) equal salary values for a certain employee bear the same rank w/ no gaps (DENSE_RANK())
SELECT
	DENSE_RANK() OVER w AS rank_num,
    e.emp_no,
    e.first_name,
    e.last_name,
    s.salary,
    e.hire_date as hire_date,
    s.from_date as salary_from_date,
    s.to_date as salary_to_date,
    (YEAR(s.from_date) - YEAR(e.hire_date)) AS years_from_start
FROM 
	employees e
		JOIN
	salaries s ON e.emp_no = s.emp_no AND YEAR(s.from_date) - YEAR(e.hire_date) >=5
WHERE e.emp_no BETWEEN 10500 AND 10600  
WINDOW w AS (partition by emp_no order by salary DESC)
;


-- LAG() & LEAD() -- 
SELECT
	emp_no,
    salary,
    LAG(salary) OVER w AS previous_salary,
    LEAD(salary) OVER w AS next_salary,
    salary - LAG(salary) OVER w AS diff_salary_current_previous,
    LEAD(salary) OVER w - salary AS diff_salary_next_current
FROM
	salaries
WHERE emp_no = 10001
WINDOW w AS (ORDER BY salary);

# Exercise 277: Part 1
SELECT
	emp_no,
    salary,
    LAG(salary) OVER w AS previous_salary,
    LEAD(salary) OVER w AS next_salary,
	salary - LAG(salary) OVER w AS diff_salary_current_previous,
    LEAD(salary) OVER w - salary AS diff_salary_next_current
FROM
	salaries
WHERE emp_no BETWEEN 10500 AND 10600 AND salary > 80000
WINDOW w AS (partition by emp_no order by salary);

# Part 2
SELECT
	emp_no,
    salary,
    LAG(salary) OVER w AS previous_salary,
    LAG(salary,2) OVER w AS before_prev_salary,
    LEAD(salary) OVER w AS next_salary,
	LEAD(salary,2) OVER w AS after_next_salary
FROM
	salaries
WINDOW w AS (partition by emp_no order by salary)
LIMIT 1000;


/***
AGGREGATE WINDOW FUNCTIONS
***/
/* LESSON 279 & 282 - Extract all currently employed workers registered in the dept_emp table with the output containing:
1) emp_no
2) dept they are working in
3) their current salary (salary specified in their latest contract)
4) the all-time average salary paid in the dept the emp is currently working in */
# Final Answer - Rows 293 - 328 (see below for how this was derived)
SELECT
	de2.emp_no, d.dept_name, s2.salary, AVG(s2.salary) OVER w as avg_salary_per_department # converting the AVG aggr. fx to a window function
FROM 
	(SELECT
    de.emp_no, de.dept_no, de.from_date, de.to_date
    FROM
		dept_emp de
			JOIN
		(SELECT
			emp_no, MAX(from_date) AS from_date
		FROM
			dept_emp
		GROUP BY emp_no) de1 ON de1.emp_no = de.emp_no
	WHERE 
		de.to_date > SYSDATE()
			AND de.from_date = de1.from_date) de2
			JOIN
		(SELECT
			s1.emp_no, s.salary, s.from_date, s.to_date
        FROM
			salaries s
				JOIN
			(SELECT
				emp_no, MAX(from_date) AS from_date
			FROM
				salaries
			GROUP BY emp_no) s1 ON s.emp_no = s1.emp_no
		WHERE
			s.to_date > SYSDATE()
				AND s.from_date = s1.from_date) s2 ON s2.emp_no = de2.emp_no
		JOIN
	departments d ON de2.dept_no = d.dept_no
GROUP BY de2.emp_no, d.dept_name
WINDOW w AS (PARTITION BY de2.dept_no)
ORDER BY de2.emp_no
; 

# Derivation steps for the above lesson:

Select SYSDATE();
# Find the employees that have contracts that expire after today
SELECT
	emp_no, salary, from_date, to_date
FROM salaries
WHERE to_date > SYSDATE(); # what if an employee signed multiple indefinite contracts during their current tenure? - must self join via a subquery to handle the MAX function and not get an error)

-- Pitfall #1: emp signed multiple indefinite contracts --
# Specify the latest contract an employee has actually signed
SELECT
	s1.emp_no, s.salary, s.from_date, s.to_date
FROM 
	salaries s
		JOIN
	(SELECT emp_no, MAX(from_date) as from_date
    FROM salaries
    GROUP BY emp_no) s1 ON s1.emp_no = s.emp_no
WHERE 
	s.to_date > SYSDATE()
		AND s.from_date = s1.from_date;

-- Pitfall #2: emp has worked in multiple departments -- # pitfalls are found by reviewing/familiarizing yourself with the data
# Run a similar query to the one to ensure the latest contract is actually used
SELECT
	de1.emp_no, de.dept_no, de.from_date, de.to_date
FROM 
	dept_emp de
		JOIN
	(SELECT emp_no, MAX(from_date) as from_date
    FROM dept_emp
    GROUP BY emp_no) de1 ON de1.emp_no = de.emp_no
WHERE 
	de.to_date > SYSDATE()
		AND de.from_date = de1.from_date;
        
# AVG salary of the department they are working in
   # This is done when you piece the derivatives together and create your outer query with a window function.


# Exercise 280: Create a query that upon execution returns a result set containing the employee numbers, contract salary values, start, and 
# end dates of the first ever contracts that each employee signed for the company.
SELECT
	s1.emp_no,
    s.salary,
    s.from_date,
    s.to_date
FROM salaries s
	# Self Join so that you can workaround not having to add from_date to a GROUP BY clause in the outer query - this will throw an error 1055 as the columns of aggregate functions are required to be in a GROUP BY -  https://database.guide/6-ways-to-fix-error-1055-expression-of-select-list-is-not-in-group-by-clause-and-contains-nonaggregated-column-in-mysql/#:~:text=MySQL%20error%201055%20is%20a,in%20the%20GROUP%20BY%20clause. 
		JOIN (
	SELECT emp_no, MIN(from_date) as from_date
    FROM salaries
    GROUP BY emp_no) s1 ON s.emp_no = s1.emp_no
WHERE s.from_date = s1.from_date; # Initially didn't add the WHERE clause, so it returned all contracts for each emp_no instead of only the first contract.
# The WHERE is how you get just the first contract.

# Exercise 283: Take what was done in the lecture videos and find the employees contracts that have been SIGNED AFTER 1/1/2000 AND TERMINATED BEFORE 1/1/2002
#STEP 1
SELECT
	emp_no, salary, from_date, to_date
FROM salaries
WHERE from_date > '2000-01-01' AND to_date < '2002-01-01'
ORDER BY from_date DESC;

#STEP 2
SELECT
	s1.emp_no, s.salary, s.from_date, s.to_date
FROM 
	salaries s
		JOIN
	(SELECT emp_no, MAX(from_date) as from_date
    FROM salaries
    GROUP BY emp_no) s1 ON s1.emp_no = s.emp_no
WHERE 
	s.from_date > '2000-01-01' AND s.to_date < '2002-01-01'
		AND s.from_date = s1.from_date;
        
# STEP 3 - Do Step 2 for dept_emp 
SELECT
	de1.emp_no, de.dept_no, de.from_date, de.to_date
FROM 
	dept_emp de
		JOIN
	(SELECT emp_no, MAX(from_date) as from_date
    FROM dept_emp
    GROUP BY emp_no) de1 ON de1.emp_no = de.emp_no
WHERE 
	de.from_date > '2000-01-01' AND de.to_date < '2002-01-01'
		AND de.from_date = de1.from_date;

# STEP 4 - Put it together and add the Aggr. Window Function
SELECT
	de2.emp_no, d.dept_name, s2.salary, AVG(s2.salary) OVER w as avg_salary_per_department
FROM
	(SELECT
	de1.emp_no, de.dept_no, de.from_date, de.to_date
FROM 
	dept_emp de
		JOIN
	(SELECT emp_no, MAX(from_date) as from_date
    FROM dept_emp
    GROUP BY emp_no) de1 ON de1.emp_no = de.emp_no
WHERE 
	de.from_date > '2000-01-01' AND de.to_date < '2002-01-01'
		AND de.from_date = de1.from_date) de2
        JOIN
     (SELECT
	s1.emp_no, s.salary, s.from_date, s.to_date
FROM 
	salaries s
		JOIN
	(SELECT emp_no, MAX(from_date) as from_date
    FROM salaries
    GROUP BY emp_no) s1 ON s1.emp_no = s.emp_no
WHERE 
	s.from_date > '2000-01-01' AND s.to_date < '2002-01-01'
		AND s.from_date = s1.from_date) s2 ON s2.emp_no = de2.emp_no
		JOIN
	departments d ON de2.dept_no = d.dept_no
GROUP BY de2.emp_no, d.dept_name
WINDOW w AS (PARTITION BY de2.dept_no)
ORDER BY de2.emp_no
; 



