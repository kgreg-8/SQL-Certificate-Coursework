-- TEMPORARY TABLES --
# Find the highest salaries for females in the company:
CREATE TEMPORARY TABLE f_highest_salaries
SELECT
	s.emp_no,
    MAX(s.salary) as f_highest_salary
FROM
	salaries s
		JOIN
	employees e ON s.emp_no = e.emp_no AND e.gender = 'F'
GROUP BY s.emp_no;

# Proving the temporary table was created
Select * 
From f_highest_salaries;

# If want/need to, can drop temporary tables
DROP TABLE IF EXISTS f_highest_salaries; # OR DROP TEMPORARY TABLE IF EXISTS f_highest_salaries

/* Exercise 296
Part 1 - Store the highest contract salary values of all male employees in a temporary table called male_max_salaries.
*/
CREATE TEMPORARY TABLE male_max_salaries
SELECT
	s.emp_no,
    MAX(s.salary) as m_highest_salary
FROM
	salaries s
		JOIN
	employees e ON s.emp_no = e.emp_no AND e.gender = 'M'
GROUP BY
	emp_no;

/* 
Part 2 - Write a query that, upon execution, allows you to check the result set contained in the male_max_salaries temporary table you created in the previous exercise.
*/
SELECT *
FROM male_max_salaries;


-- Lesson 298 --
# Create this table again and store only the first 10 results
CREATE TEMPORARY TABLE f_highest_salaries
SELECT
	s.emp_no,
    MAX(s.salary) as f_highest_salary
FROM
	salaries s
		JOIN
	employees e ON s.emp_no = e.emp_no AND e.gender = 'F'
GROUP BY s.emp_no
LIMIT 10;

# Ex: Self-JOIN
WITH cte AS (SELECT
	s.emp_no,
    MAX(s.salary) as f_highest_salary
FROM
	salaries s
		JOIN
	employees e ON s.emp_no = e.emp_no AND e.gender = 'F'
GROUP BY s.emp_no
LIMIT 10) 
SELECT * 
FROM f_highest_salaries
		JOIN
	cte c
;

# Ex: UNION
WITH cte AS (SELECT
	s.emp_no,
    MAX(s.salary) as f_highest_salary
FROM
	salaries s
		JOIN
	employees e ON s.emp_no = e.emp_no AND e.gender = 'F'
GROUP BY s.emp_no
LIMIT 10) 
SELECT * 
FROM f_highest_salaries
		UNION ALL SELECT * FROM cte;

# Ex: Showing why CTEs are not a completely foolproof way to use Temporary Tables for Self-Joins & UNIONs
CREATE TEMPORARY TABLE dates
SELECT
	NOW() as current_date_and_time,
    DATE_sub(NOW(), INTERVAL 1 MONTH) AS a_month_earlier,
    DATE_ADD(NOW(), INTERVAL 1 YEAR) AS a_year_later; # OR DATE_SUB(NOW(), INTERVAL -1 YEAR)

SELECT * FROM dates;

SELECT * 
FROM dates d1
	JOIN
    dates d2; # Doesn't work

# Trying the workaround
WITH cte AS (SELECT
	NOW() as current_date_and_time,
    DATE_sub(NOW(), INTERVAL 1 MONTH) AS a_month_earlier,
    DATE_ADD(NOW(), INTERVAL 1 YEAR) AS a_year_later)
SELECT 
	*
FROM 
	dates d1
		JOIN
	cte c;


/* Exercise 299
Part 1 - Create a temporary table called dates containing the following three columns:
- one displaying the current date and time,
- another one displaying two months earlier than the current date and time, and a
- third column displaying two years later than the current date and time. */
DROP TEMPORARY TABLE IF EXISTS dates;
CREATE TEMPORARY TABLE dates
SELECT
	NOW() as current_date_and_time,
    DATE_sub(NOW(), INTERVAL 2 MONTH) AS 2_months_earlier,
    DATE_ADD(NOW(), INTERVAL 2 YEAR) AS 2_years_later;

/* Part 2 - Write a query that, upon execution, allows you to check the result set contained in the dates 
temporary table you created in the previous exercise. */
SELECT * 
FROM dates;

/* Part 3 - Create a query joining the result sets from the dates temporary table you created during the previous 
lecture with a new Common Table Expression (CTE) containing the same columns. Let all columns in the result set appear on the same row. */
# Meaning a JOIN should be used - leads to adding columns
DROP TEMPORARY TABLE IF EXISTS dates;

WITH cte AS (SELECT
	NOW() as current_date_and_time,
    DATE_sub(NOW(), INTERVAL 1 MONTH) AS a_month_earlier,
    DATE_ADD(NOW(), INTERVAL 1 YEAR) AS a_year_later)
SELECT 
	*
FROM 
	dates d1
		JOIN
	cte c;

/* Part 4 - Again, create a query joining the result sets from the dates temporary table you created during the previous lecture 
with a new Common Table Expression (CTE) containing the same columns. This time, combine the two sets vertically. */
# When combining vertically, you want to use UNION
WITH cte AS (SELECT
	NOW() as current_date_and_time,
    DATE_sub(NOW(), INTERVAL 1 MONTH) AS a_month_earlier,
    DATE_ADD(NOW(), INTERVAL 1 YEAR) AS a_year_later)
SELECT * 
FROM dates
	UNION ALL SELECT 
		*	
	FROM
	cte c;

/* Part 5 - Drop the male_max_salaries and dates temporary tables you recently created. */
DROP TEMPORARY TABLE IF EXISTS male_max_salaries;
DROP TEMPORARY TABLE IF EXISTS dates;


    