/* SQL <> TABLEAU TASK 1:
Create a visual that provides a breakdown between the male and female employees working in 
the company each year, starting from 1990. */
# Output: looking for 3 columns - year, gender, total number of employees that year.
# JOIN dept_emp with employees to know which employees were working in each year
USE employees_mod;

SELECT * FROM t_dept_emp;
SELECT DISTINCT * FROM t_dept_emp;

# Get total employees per year since 1990
SELECT
	YEAR(de.from_date) as calendar_year,
    COUNT(*) as total_employees
FROM
	t_dept_emp de
GROUP BY calendar_year
HAVING calendar_year >= '1990' 
ORDER BY calendar_year;

# Get gender breakdown
SELECT
	gender,
    COUNT(emp_no)
FROM 
	t_employees
GROUP BY gender;

#Answer
SELECT
	YEAR(de.from_date) as calendar_year,
    e.gender,
    COUNT(e.emp_no) as number_of_employees
FROM
	t_dept_emp de
		JOIN
	t_employees e ON de.emp_no = e.emp_no AND de.from_date > '1990-01-01'
GROUP BY calendar_year, e.gender #GROUP BY GENDER TOO!
# HAVING calendar_year >= '1990' 
ORDER BY calendar_year;