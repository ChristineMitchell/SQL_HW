--RETIREMENT ELIGIBILITY
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

--RETIREMENT ELIGIBILITY +
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- NUMBER OF EMPLOYEES RETIRING
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--RETIREMENT ELIGIBILITY + AND IMPORT INTO ITS OWN TABLE CALLED retirement_info
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

-- CREATE A NEW TABLE OF RETIREES SO THAT WE CAN JOIN TABLES WITH THE dept_emp table
DROP TABLE retirement_info;
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- JOINING departments AND dept_manager TABLES
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- OOPS! THE RETIREMENT TABLE PROVIDES ALL EMPLOYEES WHO HAVE EVER WORKED THERE AND THAT IS WHAT WE USED TO GET OUR RETIREMENT TABLE.
-- SO, WE WANT TO REMOVE ALL THOSE WHO ARE NO LONGER WITH THE COMPANY
-- Our current retirement_info is already filtered to list only the employees born and hired within the correct time frame. 
-- The dept_emp table has the last bit. We'll need to perform a join to get this information into one spot. 

-- JOINING retirement_info AND dept_emp 
SELECT retirement_info.emp_no,
    retirement_info.first_name,
    retirement_info.last_name,
    dept_employee.to_date
FROM retirement_info
LEFT JOIN dept_employee
ON retirement_info.emp_no = dept_employee.emp_no;

-- ALIASES
-- JOINING retirement_info AND dept_emp TABLES WITH ALIASES
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
    de.to_date
FROM retirement_info as ri
LEFT JOIN dept_employee as de
ON ri.emp_no = de.emp_no;

-- JOINING departments AND dept_manager TABLES WITH ALIASES
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- JOINING retirement_info AND dept_employee TABLES WITH ALIASES TO
-- CREATE A CURRENT EMPLOYEE TABLE WHO ARE ELIGIBLE TO RETIRE
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
    de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

SELECT * FROM current_emp;

-- COUNT will count the rows of data in a dataset, and we can use GROUP BY to group our data by type. 
-- If the boss were to ask Bobby how many employees are retiring from the Sales department, we would use both of these
-- functions together with joins to generate an answer.
-- We can also arrange the data so it presents itself in descending or ascending order by using another function: ORDER BY

-- Bobby's boss asked for a list of how many employees per department were leaving, so the only columns we really needed for
-- this list were the employee number and the department number.

-- EMPLOYEE COUNT BY DEPARTMENT NUMBER
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_employee as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- EMPLOYEE COUNT BY DEPARTMENT NUMBER AND PUT IN ITS OWN TABLE: dept_retirees
SELECT COUNT(ce.emp_no), de.dept_no
INTO dept_retirees
FROM current_emp as ce
LEFT JOIN dept_employee as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM dept_retirees;

-- Dive into the potential retirees more...
-- 1) Employee Information: A list of employees containing their unique employee number, their last name, first name, gender, and salary
-- 2) Management: A list of managers for each department, including the department number, name, and the manager's employee number, last name,
-- first name, and the starting and ending employment dates
-- 3) Department Retirees: An updated current_emp list that includes everything it currently has, but also the employee's departments

-- 1) TAKE 1! For Empl Info, we want unique employee number, their last name, first name, gender, and salary.
-- So, we need to get info from Salaries, Employees, and Dept_Employee

-- find the most recent salary by sorting the to_date in descending order
SELECT * FROM salaries
ORDER BY to_date DESC;

-- the only problem is this is not the most employment date but the start date for that employee at their salary
-- lets use our old create the retirement_info table query and add the gender...but now we need to create a new, temporary table emp_info
-- for the retirees.
SELECT emp_no, first_name, last_name, gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM emp_info;

-- now that the employees table has been filtered and saved into the temp table, emp_info, we need to join it to the salaries table
-- to add the to_date and salary columns
SELECT e.emp_no,
    e.first_name,
    e.last_name,
    e.gender,
    s.salary,
    de.to_date
-- continue to use the emp_info table when we want to add the salary and to_date
-- INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
-- so now we have selected col from 3 tables, create a new temp table, add aliases, and joined 2/3 tables
-- lets join the third table...
INNER JOIN dept_employee as de
ON (e.emp_no = de.emp_no)
-- almost there, we have all the joins however we need to make sure all of the filters are in place
-- https://www.postgresqltutorial.com/postgresql-inner-join/
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
-- The last filter we need is the to_date of 999-01-01 from the dept_emp table. To add another filter to our current WHERE clause,
-- we will use AND again. In the query editor, add this last line:
     AND (de.to_date = '9999-01-01');


-- lets clean above without all of the comments but comment out the part to create a table (line 173) so that we can be sure it works:
SELECT e.emp_no,
    e.first_name,
    e.last_name,
    e.gender,
    s.salary,
    de.to_date
-- INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_employee as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
     AND (de.to_date = '9999-01-01');

-- It worked, so lets create that temporary table:

-- 1) TAKE 2! For Empl Info, we want unique employee number, their last name, first name, gender, and salary.
-- So, we need to get info from Salaries, Employees, and Dept_Employee
SELECT e.emp_no,
    e.first_name,
    e.last_name,
    e.gender,
    s.salary,
    de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_employee as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
     AND (de.to_date = '9999-01-01');

-- quick tip when coding: CTRL + forward slash, /, to quickly comment

-- The next list to work on involves the management side of the business. Many employees retiring are part of the management team,
-- and these positions require training, so Bobby is creating this list to reflect the upcoming departures.
-- We want the manager's employee number, first name, last name, and their starting and ending employment dates.
-- So, we need info from Departments, Employees, and Managers Remember, we're still using our filtered Employees table, current_emp,
-- for this query.

-- List of managers per department (comment out the INTO manager_info to see output displayed)
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);

-- The result of this query looks even more strange than the salaries. How can only five departments have active managers? 
-- This is another question Bobby will need to ask his manager.

-- 3) The final list needs only to have the departments added to the current_emp table. The Dept_Emp and Departments tables each have a
--  portion of the data.inner joins on the current_emp, departments, and dept_emp to include the list of columns we need:
--  emp_no, first_name, last_name, dept_name
SELECT ce.emp_no,
    ce.first_name,
    ce.last_name,
    d.dept_name
-- INTO dept_info
FROM current_emp as ce
INNER JOIN dept_employee AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);
-- Ugh, a few folks are appearing twice...we need to ask the Manager the following:
-- 1. What's going on with the salaries?
-- 2. Why are there only five active managers for nine departments?
-- 3. Why are some employees appearing twice?
-- To help Bobby find these answers, we're going to create tailored lists.

-- Create a query that will return only the information relevant to the Sales team. The requested list includes:
-- Recreate the Retirement_Info Table for the Sales Team with the following  info:
    -- Employee numbers
    -- Employee first name
    -- Employee last name
    -- Employee department name

SELECT ce.emp_no,
	   ce.first_name, 
	   ce.last_name,
	   d.dept_name
INTO sales_retirees
FROM current_emp as ce
INNER JOIN dept_employee AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no)
WHERE (d.dept_name = 'Sales');

SELECT * FROM sales_retirees;

-- Create a query that will return the same information as above for both the Sales and Development. My first inclination was to 
-- do a group by, however they want us to only return the data for Sales and Development, so we need to use the 
-- IN condition which is necessary because you're creating two items in the same column. 
-- Hint: You'll need to use the IN condition with the WHERE clause. See the PostgreSQL documentation 
-- (https://www.techonthenet.com/postgresql/in.php.) for additional information.

-- Examples:
-- SELECT *
-- FROM suppliers
-- WHERE supplier_name IN ('Apple', 'Samsung', 'RIM');

-- is equivalent to:
-- SELECT *
-- FROM suppliers
-- WHERE supplier_name = 'Apple'
-- OR supplier_name = 'Samsung'
-- OR supplier_name = 'RIM';

SELECT ce.emp_no,
	   ce.first_name, 
	   ce.last_name,
	   d.dept_name
INTO mentor_proj
FROM current_emp as ce
INNER JOIN dept_employee AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no)
WHERE d.dept_name IN ('Sales','Development')
ORDER BY d.dept_name;

SELECT * FROM mentor_proj;
