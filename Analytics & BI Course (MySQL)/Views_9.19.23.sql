-- VIEWS --
CREATE OR REPLACE VIEW v_dept_emp_latest_date AS
SELECT
emp_no, MAX(from_date) as from_date, MAX(to_date) as to_date
FROM dept_emp
GROUP BY emp_no;

SELECT * FROM employees.v_dept_emp_latest_date;

# Exercise 216: Create a view that will extract the average salary of all managers registered in the database. Round this value to the nearest cent. you should obtain the value of 66924.27.
CREATE OR REPLACE VIEW v_manager_avg_salary_9_19_23 AS
Select ROUND(AVG(s.salary), 2) as avg_salary
FROM salaries s
JOIN dept_manager m ON s.emp_no = m.emp_no;

SELECT * FROM employees.v_manager_avg_salary_9_19_23;