-- 1a) Create a table of upcoming retirees and their associated titles
SELECT e.emp_no, 
    e.first_name,
    e.last_name,
    t.title,
    t.from_date,
    t.to_date
INTO retiree_titles
FROM employees as e
LEFT JOIN titles as t
    ON e.emp_no = t.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

SELECT * FROM retiree_titles;

-- 1b) Use DISTINT with ORDERBY to remove duplicate rows in the retiree_titles tables so that it returns the latest
-- title an upcoming retiree holds (to ensure we select the first row of the retiree, we need to sort the to_date in desc order)
SELECT DISTINCT ON (rt.emp_no)  
	rt.emp_no,  
    rt.first_name,
    rt.last_name,
    rt.title
INTO unique_titles
FROM retiree_titles as rt
ORDER BY rt.emp_no, rt.to_date DESC;

SELECT * FROM unique_titles;

-- 1c) Determine the number of upcoming retirees by title
SELECT COUNT(ut.emp_no), ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY ut.count DESC;

SELECT * FROM retiring_titles;

-- 2) Create a table of current employees eligble for the mentorship program
SELECT DISTINCT ON (e.emp_no)
    e.emp_no, 
    e.first_name,
    e.last_name,
    e.birth_date,
    de.from_date,
    de.to_date,
    t.title
INTO mentorship_elig
FROM employees as e
INNER JOIN dept_employee as de
    ON e.emp_no = de.emp_no
INNER JOIN titles as t
    ON e.emp_no = t.emp_no
WHERE (de.to_date = '9999-01-01')
    AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no, t.to_date DESC;

SELECT * FROM mentorship_elig;
