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

-- 2) Create a table of current employees eligble for the mentorship program born 1965
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

-- Additional Queries

-- 3) Determine the number of potential mentees by title born in 1965
SELECT COUNT(me1.emp_no), me1.title
INTO mentee_titles
FROM mentorship_elig as me1
GROUP BY me1.title
ORDER BY me1.count DESC;

SELECT * FROM mentee_titles;

-- 4) Create a table of current employees eligble for the mentorship program born 1961-1971
SELECT DISTINCT ON (e.emp_no)
    e.emp_no, 
    e.first_name,
    e.last_name,
    e.birth_date,
    de.from_date,
    de.to_date,
    t.title
INTO mentorship_elig2
FROM employees as e
INNER JOIN dept_employee as de
    ON e.emp_no = de.emp_no
INNER JOIN titles as t
    ON e.emp_no = t.emp_no
WHERE (de.to_date = '9999-01-01')
    AND (e.birth_date BETWEEN '1961-01-01' AND '1971-12-31')
ORDER BY e.emp_no, t.to_date DESC;

SELECT * FROM mentorship_elig2;

-- 5) Determine the number of potential mentees by title by expanding criteria born 1961-1971
SELECT COUNT(me2.emp_no), me2.title
INTO mentee_titles2
FROM mentorship_elig2 as me2
GROUP BY me2.title
ORDER BY me2.count DESC;

SELECT * FROM mentee_titles2;

-- 6) Create a table of current employees eligble for the mentorship program born after 1955
SELECT DISTINCT ON (e.emp_no)
    e.emp_no, 
    e.first_name,
    e.last_name,
    e.birth_date,
    de.from_date,
    de.to_date,
    t.title
INTO mentorship_elig3
FROM employees as e
INNER JOIN dept_employee as de
    ON e.emp_no = de.emp_no
INNER JOIN titles as t
    ON e.emp_no = t.emp_no
WHERE (de.to_date = '9999-01-01')
    AND (e.birth_date > '1955-12-31')
ORDER BY e.emp_no, t.to_date DESC;

SELECT * FROM mentorship_elig3;

-- 7) Determine the number of potential mentees by title born after 1955.
SELECT COUNT(me3.emp_no), me3.title
INTO mentee_titles3
FROM mentorship_elig3 as me3
GROUP BY me3.title
ORDER BY me3.count DESC;

SELECT * FROM mentee_titles3;
