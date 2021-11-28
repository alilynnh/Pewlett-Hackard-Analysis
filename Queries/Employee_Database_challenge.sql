-- DELIVERABLE 1 --------------------------------------------------------------
-- Create retirement titles table
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	ti.title,
	ti.from_date,
	ti.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;

-- create retiring titles table and sum
SELECT COUNT(emp_no), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count(title) DESC;

SELECT COUNT(emp_no)
FROM unique_titles;

--DELIVERABLE 2 --------------------------------------------------------------
-- Create mentorship eligibility table and sum
SELECT DISTINCT ON (emp_no)
    e.emp_no,
    e.first_name,
    e.last_name,
    e.birth_date,
    de.from_date,
    de.to_date,
    ti.title
INTO mentorship_eligibility
FROM employees AS e
INNER JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
INNER JOIN titles AS ti
ON (e.emp_no = ti.emp_no)
WHERE (de.to_date = '9999-01-01')
    AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;

SELECT COUNT(emp_no)
FROM mentorship_eligibility;

-- DELIVERABLE 3 --------------------------------------------------------------
-- table of retirees who are current employees and their titles (and total sum)
SELECT ut.emp_no,
	ut.title
INTO current_retiring
FROM unique_titles as ut
INNER JOIN dept_emp as de
ON (ut.emp_no = de.emp_no)
INNER JOIN departments as d
ON (de.dept_no = d.dept_no)
WHERE de.to_date = '9999-01-01'
ORDER BY ut.emp_no;

SELECT COUNT(emp_no)
FROM current_retiring;

--retiree counts per title 
SELECT COUNT(emp_no), 
	title
INTO current_retiring_titles
FROM current_retiring
GROUP BY title
ORDER BY count(title) DESC;

-- table of retirees who are current employees and their departments
SELECT ut.emp_no,
	d.dept_name
INTO retire_dept_name
FROM unique_titles as ut
INNER JOIN dept_emp as de
ON (ut.emp_no = de.emp_no)
INNER JOIN departments as d
ON (de.dept_no = d.dept_no)
WHERE de.to_date = '9999-01-01'
ORDER BY ut.emp_no;

-- retiree counts per department
SELECT COUNT(emp_no), 
	dept_name
INTO dept_retirees
FROM retire_dept_name
GROUP BY dept_name
ORDER BY count(dept_name) DESC;

-- table of mentors and their departments
SELECT me.emp_no,
	d.dept_name
INTO mentor_dept_name
FROM mentorship_eligibility as me
INNER JOIN dept_emp as de
ON (me.emp_no = de.emp_no)
INNER JOIN departments as d
ON (de.dept_no = d.dept_no)
WHERE de.to_date = '9999-01-01'
ORDER BY me.emp_no;

--mentor counts per department
SELECT COUNT(emp_no), 
	dept_name
INTO dept_mentors
FROM mentor_dept_name
GROUP BY dept_name
ORDER BY count(dept_name) DESC;