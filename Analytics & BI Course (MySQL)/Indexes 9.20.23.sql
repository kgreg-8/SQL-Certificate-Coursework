-- MYSQL INDEXES --
Select * from employees 
where hire_date > '2000-01-01'; #0.355 seconds to return result
#when rerun after creating the index: 0.0025 seconds to return result

CREATE INDEX i_hire_date ON employees(hire_date);

#Exercise 246: Drop the ‘i_hire_date’ index.
DROP index i_hire_date ON employees; # OR ALTER TABLE employees DROP INDEX i_hire_date;

#Exercise 248: Select all records from the ‘salaries’ table of people whose salary is higher than $89,000 per annum.
# Then, create an index on the ‘salary’ column of that table, and check if it has sped up the search of the same SELECT statement.

Select * from salaries 
Where salary > 89000; #0.0083 seconds before index
#0.0023 seconds after index

CREATE INDEX i_salary ON salaries(salary);