-- COMMON TABLE EXPRESSIONS --
# Exercise 287: Part 1 - Use a CTE (a Common Table Expression) and a SUM() function in the SELECT statement in a query to find out 
# how many male employees have never signed a contract with a salary value higher than or equal to the all-time company salary average.

# Step 1: Find out the average company salary.
SELECT ROUND(AVG(salary), 2)
FROM salaries; # $63,761.28

# Step 2: CTE creation time
WITH cte_male_avgsal AS (SELECT ROUND(AVG(salary), 2) AS avg_salary FROM salaries)
SELECT
    SUM(CASE 
		WHEN s.salary > c.avg_salary THEN 1 ELSE 0 END) as no_m_salaries_above_avg,
	COUNT(s.salary) as no_contracts_men
FROM 
	salaries s
		JOIN
	employees e ON s.emp_no = e.emp_no AND e.gender = 'M'
		CROSS JOIN
	cte_male_avgsal c;
    
# Part 2 - Use a CTE (a Common Table Expression) and (at least one) COUNT() function in the SELECT statement of a query to find out 
# how many male employees have never signed a contract with a salary value higher than or equal to the all-time company salary average.
WITH cte_male_avgsal AS (SELECT ROUND(AVG(salary), 2) AS avg_salary FROM salaries)
SELECT
    COUNT(CASE 
		WHEN s.salary < c.avg_salary THEN s.salary ELSE NULL END) as no_m_salaries_below_avg,
	COUNT(s.salary) as no_contracts_men
FROM 
	salaries s
		JOIN
	employees e ON s.emp_no = e.emp_no AND e.gender = 'M'
		CROSS JOIN
	cte_male_avgsal c;
    
# Part 3 - Use MySQL joins (and don’t use a Common Table Expression) in a query to find out how many male employees have never signed a 
# contract with a salary value higher than or equal to the all-time company salary average (i.e. to obtain the same result as in the previous exercise).
	SELECT
		COUNT(CASE 
			WHEN s.salary < a.avg_salary THEN s.salary ELSE NULL END) as no_m_salaries_below_avg,
		COUNT(s.salary) as no_contracts_men
	FROM 
		(SELECT ROUND(AVG(salary), 2) AS avg_salary FROM salaries) a 
			JOIN
        salaries s
			JOIN
		employees e ON s.emp_no = e.emp_no AND e.gender = 'M';

# Part 4 - Use a cross join in a query to find out how many male employees have never signed a contract with a salary value higher 
# than or equal to the all-time company salary average (i.e. to obtain the same result as in the previous exercise).
SELECT
    COUNT(CASE 
		WHEN s.salary < a.avg_salary THEN s.salary ELSE NULL END) as no_m_salaries_below_avg,
	COUNT(s.salary) as no_contracts_men
FROM 
	salaries s
		JOIN
	employees e ON s.emp_no = e.emp_no AND e.gender = 'M'
		CROSS JOIN
	(SELECT ROUND(AVG(salary), 2) AS avg_salary FROM salaries) a;

/* 
CTEs with Multiple Subclauses (aka Multiple CTEs within a query)
*/
# Exercise 291: Part 1 - Use two common table expressions and a SUM() function in the SELECT statement of a query to obtain the 
# number of male employees whose highest salaries have been below the all-time average.
-- Step 1: obtain list of highest contract salaries for all male employees --
SELECT emp_no, MAX(salary) FROM salaries GROUP BY emp_no;

-- Step 2: piece it together --
WITH cte1 AS (SELECT ROUND(AVG(salary), 2) AS avg_salary FROM salaries),
cte2 AS (SELECT emp_no, MAX(salary) AS m_highest_salary FROM salaries GROUP BY emp_no) 
SELECT
	SUM(CASE 
		WHEN c2.m_highest_salary < c1.avg_salary THEN 1 ELSE 0 END) as no_m_highest_salaries_below_avg
FROM 
	employees e 
		JOIN
	cte2 c2 ON c2.emp_no = e.emp_no AND e.gender = 'M'
		CROSS JOIN
	cte1 c1;

# Part 2 - Use two common table expressions and a COUNT() function in the SELECT statement of a query to obtain the 
# number of male employees whose highest salaries have been below the all-time average.
WITH cte1 AS (SELECT ROUND(AVG(salary), 2) AS avg_salary FROM salaries),
cte2 AS (SELECT emp_no, MAX(salary) AS m_highest_salary FROM salaries GROUP BY emp_no) 
SELECT
	COUNT(CASE 
		WHEN c2.m_highest_salary < c1.avg_salary THEN c2.m_highest_salary ELSE NULL END) as no_m_highest_salaries_below_avg
FROM 
	employees e 
		JOIN
	cte2 c2 ON c2.emp_no = e.emp_no AND e.gender = 'M'
		CROSS JOIN
	cte1 c1; #41,343

# Part 3 - Does the result from the previous exercise change if you used the Common Table Expression (CTE) 
# for the male employees' highest salaries in a FROM clause, as opposed to in a join?
WITH cte1 AS (SELECT ROUND(AVG(salary), 2) AS avg_salary FROM salaries)
SELECT
	COUNT(CASE 
		WHEN c2.m_highest_salary < c1.avg_salary THEN c2.m_highest_salary ELSE NULL END) as no_m_highest_salaries_below_avg
FROM 
(SELECT emp_no, MAX(salary) AS m_highest_salary FROM salaries GROUP BY emp_no)c2
		JOIN
	employees e ON c2.emp_no = e.emp_no AND e.gender = 'M'
		CROSS JOIN
	cte1 c1;
/* The result does not change */



