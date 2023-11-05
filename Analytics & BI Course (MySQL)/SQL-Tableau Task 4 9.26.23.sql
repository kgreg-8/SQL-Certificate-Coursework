/* 
TASK 4
Create an SQL stored procedure that will allow you to obtain the average male and female salary per department 
within a certain salary range. Let this range be defined by two values the user can insert when calling the procedure.

Finally, visualize the obtained result-set in Tableau as a double bar chart. 
*/

# Stored Procedure with 2 inputs (salary range)
# Data Needed:
   # Task 3, but transformed into a stored procedure
   
# Step 1: Simple version of stored procedure salary input

DROP PROCEDURE IF EXISTS SalariesInRange;

DELIMITER $$
# USE employees_mod;
CREATE PROCEDURE SalariesInRange(IN p_min_salary INT, IN p_max_salary INT)
BEGIN
	SELECT *
    FROM t_salaries
    WHERE salary BETWEEN min_salary AND max_salary;
END;
$$

DELIMITER ;

# Step 2: Incorporate Task 3 into stored procedure minus the part about years as time is irrelevant in this problem
DROP PROCEDURE IF EXISTS New_SalariesInRange;

DELIMITER $$
CREATE PROCEDURE New_SalariesInRange(IN p_min_salary INT, IN p_max_salary INT)
BEGIN
	SELECT
		d.dept_name,
		e.gender,
		ROUND(AVG(s.salary),2) as average_salary
	FROM
		t_employees e 
			JOIN
		t_salaries s ON e.emp_no = s.emp_no
			JOIN
		t_dept_emp de ON s.emp_no = de.emp_no
			JOIN
		t_departments d ON de.dept_no = d.dept_no
	WHERE s.salary BETWEEN p_min_salary AND p_max_salary
	GROUP BY d.dept_name, e.gender
	ORDER BY d.dept_name; 
END;
$$

DELIMITER ;

call employees_mod.New_SalariesInRange(62000, 62500);
CALL New_SalariesInRange(50000, 90000);
