/* 
TASK 3
Compare the average salary of female versus male employees in the entire company until year 2002, and add a filter allowing you to see that per each department.
*/

-- 1. How to visualize this? --
    # ChatGPT recommended different versions of bar charts with a dropdown filter
   
-- 2. Data needed --
	# avg_salary_male, avg_salary_female, calendar_year (subquery?), department, gender, **how to determine what year a salary is from?** - from_date & to_date from salaries? - think of the ACTIVE column!
    # Tables - t_employees, t_departments, t_salaries & t_dept_emp
    # limit calendar_year to 2002 

# Explore the tables
SELECT YEAR(hire_date) as calendar_year from t_employees GROUP BY calendar_year ORDER BY calendar_year;
SELECT * from t_employees ORDER BY hire_date DESC LIMIT 5;
SELECT * from t_salaries; # ORDER BY from_date DESC LIMIT 5;

# Step 1: Find overall average salary of male and females
SELECT
	e.gender,
    ROUND(AVG(s.salary),2) as average_salary
FROM
	t_employees e 
		JOIN
	t_salaries s ON e.emp_no = s.emp_no
GROUP BY e.gender; # M: $60,486.98 & F: $57,664.21

# Step 2: Find average salary by gender per calendar year
SELECT
	e.gender,
    ROUND(AVG(s.salary),2) as average_salary,
    YEAR(e.hire_date) as calendar_year
FROM
	t_employees e 
		JOIN
	t_salaries s ON e.emp_no = s.emp_no
GROUP BY calendar_year, e.gender
ORDER BY calendar_year;

-- VS. --
# This is likely the better query:
SELECT
	e.gender,
    ROUND(AVG(s.salary),2) as average_salary,
    YEAR(s.from_date) as salary_year #main difference is in using the from_date in the salaries table vs hire_date
FROM
	t_employees e 
		JOIN
	t_salaries s ON e.emp_no = s.emp_no
WHERE YEAR(s.from_date) BETWEEN '1990-01-01' AND '2002'
GROUP BY salary_year, e.gender
ORDER BY salary_year; 

# Step 3: Incorporate department
SELECT
	d.dept_name,
    e.gender,
    ROUND(AVG(s.salary),2) as average_salary,
    YEAR(s.from_date) as salary_year 
FROM
	t_employees e 
		JOIN
	t_salaries s ON e.emp_no = s.emp_no
		JOIN
	t_dept_emp de ON s.emp_no = de.emp_no
		JOIN
	t_departments d ON de.dept_no = d.dept_no
#WHERE YEAR(s.from_date) BETWEEN '1990-01-01' AND '2002'
GROUP BY d.dept_name, salary_year, e.gender
HAVING salary_year <= 2002
ORDER BY salary_year, d.dept_name; 


