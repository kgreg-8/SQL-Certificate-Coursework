-- CASE Statements --
SELECT 
    emp_no,
    first_name,
    last_name,
    CASE
        WHEN gender = 'M' THEN 'Male'
        ELSE 'Female'
    END AS gender
FROM employees;

SELECT 
    dm.emp_no,
    e.first_name,
    e.last_name,
    MAX(s.salary) - MIN(s.salary) AS salary_difference,
    CASE
        WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'Salary was raised by more than $30,000'
        WHEN MAX(s.salary) - MIN(s.salary) BETWEEN 20000 AND 30000 THEN 'Salary was raised by more than $20,000, but less than $30,000'
        ELSE 'Salary was raised less than $20,000'
    END AS salary_increase
FROM
    dept_manager dm
        JOIN
    employees e ON dm.emp_no = e.emp_no
        JOIN
    salaries s ON e.emp_no = s.emp_no
GROUP BY s.emp_no;

# Exercise 251: Similar to the exercises done in the lecture, obtain a result set containing the employee number, first name, and last name of all employees with a number higher than 109990.
# Create a fourth column in the query, indicating whether this employee is also a manager, according to the data provided in the dept_manager table, or a regular employee. 
SELECT
	e.emp_no,
    e.first_name,
    e.last_name,
    CASE
		WHEN e.emp_no = dm.emp_no THEN 'Manager'
        ELSE 'Regular Employee'
	END AS emp_position
FROM employees e
	LEFT JOIN #This is the key to not only getting 'Managers' as a result b/c you want to prioritize returning people with emp_no > 109990 than just the matching emp_nos btwn employees and dept_manager
dept_manager dm ON e.emp_no = dm.emp_no
WHERE e.emp_no > 109990; #200038 rows

# Exercise 253: Extract a dataset containing the following information about the managers: employee number, first name, and last name. Add two columns at the end 
# – one showing the difference between the maximum and minimum salary of that employee, and another one saying whether this salary raise was higher than $30,000 or NOT.
SELECT 
    dm.emp_no,
    e.first_name,
    e.last_name,
    MAX(s.salary) - MIN(s.salary) AS salary_difference,
    CASE
        WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'Salary was raised by more than $30,000'
        ELSE 'Salary was raised less than $30,000'
    END AS salary_increase
FROM
    dept_manager dm
        JOIN
    employees e ON dm.emp_no = e.emp_no
        JOIN
    salaries s ON e.emp_no = s.emp_no
GROUP BY s.emp_no;
# Can also use just an IF vs CASE since there is one condition.

# Exercise 255: Extract the employee number, first name, and last name of the first 100 employees, and add a fourth column, called “current_employee” 
# saying “Is still employed” if the employee is still working in the company, or “Not an employee anymore” if they aren’t.
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    CASE
		WHEN de.to_date = '9999-01-01' THEN 'Is still employed'
        ELSE 'Not an employee anymore'
	END AS is_employee
FROM employees e
		JOIN
    dept_emp de ON e.emp_no = de.emp_no
LIMIT 100;