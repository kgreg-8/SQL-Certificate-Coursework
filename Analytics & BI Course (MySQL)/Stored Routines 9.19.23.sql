-- STORED PROCEDURES --
# lesson: return the first 1000 rows of the employees table
USE employees;

DROP PROCEDURE IF EXISTS select_employees;

DELIMITER $$
CREATE PROCEDURE select_employees()
BEGIN
select * from employees
limit 1000;
END $$
DELIMITER ;

CALL employees.select_employees();

# Exercise 222: Create a procedure that will provide the average salary of all employees. Then, call the procedure.
DELIMITER $$
CREATE PROCEDURE avgsalary_emp()
BEGIN
Select ROUND(AVG(s.salary), 2) as avg_salary
FROM salaries s
JOIN employees e ON s.emp_no = e.emp_no;
END $$
DELIMITER ;

CALL avgsalary_emp(); #63761.20

-- Stored Procedures w/ an INPUT PARAMETER --
DROP procedure IF EXISTS emp_salary;

DELIMITER $$
USE employees $$
CREATE PROCEDURE emp_salary(IN p_emp_no INTEGER)
BEGIN
	SELECT
		e.first_name, e.last_name, s.salary, s.from_date, s.to_date
	FROM
		employees e
		JOIN salaries s ON e.emp_no = s.emp_no
    WHERE e.emp_no = p_emp_no;
END$$
DELIMITER ;

-- Stored Procedures w/ an OUTPUT PARAMETER --
DELIMITER $$
USE employees $$
CREATE PROCEDURE AVG_emp_salary_out(IN p_emp_no INTEGER, OUT p_avg_salary DECIMAL(10,2))
BEGIN
	SELECT
		AVG(s.salary) INTO p_avg_salary
	FROM
		employees e
		JOIN salaries s ON e.emp_no = s.emp_no
    WHERE e.emp_no = p_emp_no;
END$$
DELIMITER ;

# Exercise 227: Create a procedure called ‘emp_info’ that uses as parameters the first and the last name of an individual, and returns their employee number.
DROP procedure IF EXISTS  emp_info;

DELIMITER $$
Use employees $$
CREATE PROCEDURE emp_info(IN p_first_name VARCHAR(255), IN p_last_name VARCHAR(255), OUT p_emp_no INT)
BEGIN
	SELECT e.emp_no INTO p_emp_no
    FROM employees e
    WHERE e.first_name = p_first_name AND e.last_name = p_last_name;
END $$
DELIMITER ;
# I was getting NULL value responses because i did not include the INTO portion!

-- VARIABLES --
SET @v_avg_salary = 0; # empty variable
CALL employees.AVG_emp_salary_out(11300, @v_avg_salary);
SELECT @v_avg_salary;

# Exercise 230: Create a variable, called ‘v_emp_no’, where you will store the output of the procedure you created in the last exercise.
# Call the same procedure, inserting the values ‘Aruna’ and ‘Journel’ as a first and last name respectively.
# Finally, select the obtained output.
SET @v_emp_no = 0;
CALL employees.emp_info('Aruna', 'Journel', @v_emp_no);
SELECT @v_emp_no; #10789


-- FUNCTIONS --
DELIMITER $$
CREATE FUNCTION fx_emp_avg_salary(p_emp_no INTEGER) RETURNS DECIMAL(10,2)
DETERMINISTIC # if you receive error code 1418, add DETERMINISTIC, NO SQL or READS SQL DATA before the BEGIN statement - each one has different characteristics. If using multiple, do not separate them by commas
BEGIN
DECLARE v_avg_salary DECIMAL(10,2);
	SELECT
		AVG(s.salary) INTO v_avg_salary
	FROM
		employees e
		JOIN salaries s ON e.emp_no = s.emp_no
    WHERE e.emp_no = p_emp_no;
    
RETURN v_avg_salary;
END$$
DELIMITER ;

SELECT fx_emp_avg_salary(11300);

# Exercise 234: Create a function called ‘emp_info’ that takes for parameters the first and last name of an employee, and returns the salary from the newest contract of that employee.
# Hint: In the BEGIN-END block of this program, you need to declare and use two variables – v_max_from_date that will be of the DATE type, and v_salary, that will be of the DECIMAL (10,2) type.
# Finally, select this function.
DROP FUNCTION fx_emp_info;

DELIMITER $$
CREATE FUNCTION fx_emp_info(p_first_name VARCHAR(255), p_last_name VARCHAR(255)) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
DECLARE v_max_from_date DATE;
DECLARE v_salary DECIMAL(10,2);

	SELECT MAX(s.from_date) INTO v_max_from_date
    FROM employees e
		JOIN salaries s ON e.emp_no = s.emp_no
    WHERE e.first_name = p_first_name AND e.last_name = p_last_name;
    
    SELECT s.salary INTO v_salary
    FROM employees e
		JOIN salaries s ON e.emp_no = s.emp_no
	WHERE e.first_name = p_first_name AND e.last_name = p_last_name AND s.from_date = v_max_from_date;
    
RETURN v_salary;
# RETURN concat_ws(' | ', v_max_from_date, v_salary); - a way to return both variables. The result displays in the error response message https://stackoverflow.com/questions/25568704/is-it-possible-to-return-multiple-values-from-mysql-function
# Actually, to return both variables, it would be better to use a procedure than a function
END $$
DELIMITER ;

SELECT fx_emp_info('Aruna', 'Journel'); #45709

