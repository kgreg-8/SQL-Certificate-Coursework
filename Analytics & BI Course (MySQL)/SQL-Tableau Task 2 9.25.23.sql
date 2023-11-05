-- SQL <> TABLEAU Task 2 --
/* Compare the number of active male managers to the number of active female managers from different departments for each year, starting from 1990. Visualize with an area chart*/

-- The lecturer recommends thinking about how you want to visualize the data first and then thinking about the data you need (i.e. columns) --

# Layer on the manager comparison to Task #1

# Step 1: Find managers based on gender
SELECT
	COUNT(DISTINCT dm.emp_no),
    e.gender
FROM t_dept_manager dm
		JOIN
	t_employees e ON dm.emp_no = e.emp_no
GROUP BY e.gender;

# Step 2: Now layer on the distinction of departments 
SELECT
	d.dept_name,
    e.gender,
    COUNT(DISTINCT dm.emp_no),
    dm.from_date,
    dm.to_date
FROM t_dept_manager dm
		JOIN
	t_employees e ON dm.emp_no = e.emp_no
		JOIN
	t_departments d ON d.dept_no = dm.dept_no
GROUP BY d.dept_name,e.gender, dm.from_date, dm.to_date;

# Step 2B: Just doing SELECT * allows for an easier way to confirm you got the FROM & JOINs correct
SELECT
	*
FROM 
	(SELECT
		YEAR(hire_date) as calendar_year
	FROM t_employees
	GROUP BY calendar_year) e # add the group by here to reduce query time. The purpose of this subquery is to workaround the GROUP BY error if the YEAR(hire_date) was in the outer query.
		CROSS JOIN
	t_dept_manager dm
		JOIN
	t_departments d ON d.dept_no = dm.dept_no
    		JOIN
	t_employees ee ON dm.emp_no = ee.emp_no #AND ee.hire_date >= '1990-01-01' - unnecessary for some reason
ORDER BY dm.emp_no, calendar_year;

# Step 3: Create the ACTIVE column
SELECT
	d.dept_name,
    ee.gender,
    dm.emp_no,
    dm.from_date,
    dm.to_date,
    e.calendar_year,
    CASE 
		WHEN YEAR(dm.to_date) >= e.calendar_year AND YEAR(dm.from_date) <= e.calendar_year THEN 1 # you initially had the to & from date variables switched around
        ELSE 0 
	END AS active
FROM 
	(SELECT
		YEAR(hire_date) as calendar_year
	FROM t_employees
	GROUP BY calendar_year) e # add the group by here to reduce query time. The purpose of this subquery is to workaround the GROUP BY error if the YEAR(hire_date) was in the outer query.
		CROSS JOIN
	t_dept_manager dm
		JOIN
	t_departments d ON d.dept_no = dm.dept_no
    		JOIN
	t_employees ee ON dm.emp_no = ee.emp_no #AND ee.hire_date >= '1990-01-01' - unnecessary for some reason
ORDER BY dm.emp_no, calendar_year;
	

