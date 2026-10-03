USE employees;

#1. Find the current department of each employee
#(where to_date = '9999-01-01')
SELECT 
	e.emp_no,
    e.first_name,
    e.last_name,
    d.dept_name
FROM employees e
JOIN dept_emp de
	ON e.emp_no=de.emp_no
JOIN departments d
	ON d.dept_no=de.dept_no
WHERE de.to_date = '9999-01-01';

#2. Top 5 Highest-Paid Employees by Department and Gender (with Average Comparison)
#(hint: use window functions, CTEs, joins and aggregation)
WITH rank_salary AS(
SELECT
	e.emp_no,
	e.first_name,
	e.last_name,
     d.dept_name,
     e.gender,
     s.salary,
     AVG(s.salary) OVER(PARTITION BY de.dept_no,e.gender) AS avg_salary,
     s.salary-AVG(s.salary) OVER(PARTITION BY de.dept_no,e.gender) AS diff_from_avg,
     DENSE_RANK() OVER(PARTITION BY de.dept_no,e.gender ORDER BY s.salary DESC)AS salary_rank
FROM employees e
JOIN salaries s
	ON e.emp_no=s.emp_no
JOIN dept_emp de
	ON de.emp_no=e.emp_no
JOIN departments d
	ON d.dept_no=de.dept_no
WHERE de.to_date = '9999-01-01' 
      AND s.to_date = '9999-01-01'
)

SELECT
	dept_name,
    gender,
    emp_no,
    first_name,
    last_name,
    salary,
    salary_rank,
    ROUND(avg_salary,2) AS avg_salary,
    ROUND(diff_from_avg,2)AS diff_from_avg
FROM rank_salary
WHERE salary_rank<=5;

#3. Find departments with average salary above 70,000
SELECT
	d.dept_name,
    AVG(s.salary)
FROM departments d
JOIN dept_emp de
	ON d.dept_no=de.dept_no
JOIN salaries s
	ON s.emp_no=de.emp_no
GROUP BY d.dept_name
HAVING AVG(s.salary) >70000;

#4. Find the most common job title for each department
#(hint: use JOIN, GROUP BY, Window Function (RANK)
SELECT
	dept_name,
    title AS most_common_job,
    emp_count
FROM(
SELECT
	d.dept_no,
	d.dept_name,
    t.title,
    COUNT(de.emp_no) AS emp_count,
    RANK() OVER(PARTITION BY d.dept_no ORDER BY COUNT(de.emp_no) DESC) AS title_rank
FROM departments d
JOIN dept_emp de
	ON de.dept_no=d.dept_no
JOIN titles t
	ON t.emp_no=de.emp_no
GROUP BY d.dept_no,d.dept_name,t.title)AS title_counts
WHERE title_rank=1;

#5. Find employees who have changed departments more than 1 time
#(hint: use Subquery, COUNT, GROUP BY, HAVING)
SELECT
	e.emp_no,
    CONCAT(e.first_name," ",e.last_name) AS Emp_Name,
    COUNT(DISTINCT de.dept_no) AS dept_count
FROM employees e
JOIN dept_emp de
	ON e.emp_no=de.emp_no
GROUP BY e.emp_no
HAVING COUNT(DISTINCT de.dept_no)>2;

#6. Calculate salary growth percentage for each employee
#(hint: Window Function, CTE)
WITH salaryStates AS(
SELECT DISTINCT
	emp_no,
    FIRST_VALUE(salary) OVER (
            PARTITION BY emp_no 
            ORDER BY from_date ASC
        ) AS initial_salary,
        FIRST_VALUE(salary) OVER (
            PARTITION BY emp_no 
            ORDER BY from_date DESC
        ) AS current_salary
FROM salaries)

SELECT
	 CONCAT(e.first_name," ",e.last_name) AS Emp_Name,
     ss.initial_salary,
     ss.current_salary,
     ((ss.current_salary-ss.initial_salary)/ss.initial_salary)*100 AS salary_growth_percentage
FROM employees e
JOIN salaryStates ss
	ON e.emp_no=ss.emp_no
ORDER BY salary_growth_percentage DESC;

#7. Find departments with the most gender diversity (the count of male to female employees per department)
#(hint: CASE, Aggregation, GROUP BY)

 SELECT
	d.dept_name,
    SUM(CASE WHEN e.gender="M" THEN 1 ELSE 0 END) AS male_count,
    SUM(CASE WHEN e.gender="F" THEN 1 ELSE 0 END ) AS female_count,
    COUNT(e.emp_no) AS total_emp,
	ROUND((SUM(CASE WHEN e.gender="F" THEN 1 ELSE 0 END )/SUM(CASE WHEN e.gender="M" THEN 1 ELSE 0 END)),2) AS female_to_male_ratio,
    (SUM(CASE WHEN e.gender="M" THEN 1 ELSE 0 END )-SUM(CASE WHEN e.gender="F" THEN 1 ELSE 0 END) )AS gender_gap
 FROM departments d
 JOIN dept_emp de
	ON de.dept_no=d.dept_no
JOIN employees e
	ON e.emp_no=de.emp_no 	
 GROUP BY d.dept_name;

#8. Find each department manager’s average managed salary
#(hint: JOIN, GROUP BY)
SELECT
	dm.emp_no,
    d.dept_name,
    ROUND(AVG(s.salary),2) AS average_managed_salary
FROM dept_manager dm
JOIN departments d
	ON dm.dept_no = d.dept_no
JOIN salaries s
	ON 	dm.emp_no = s.emp_no
GROUP BY dm.emp_no,d.dept_name;


#9. Create a view of current employees with salary info, then a procedure to get department-level summary.
#(hint: Create View, Stored Procedure with parameters)
CREATE VIEW current_employees AS 
SELECT
	s.emp_no,
	CONCAT(e.first_name," ",e.last_name) AS Emp_Name,
    e.gender,
    s.salary,
    d.dept_no,
    d.dept_name,
    t.title
FROM employees e
JOIN salaries s
	ON e.emp_no=s.emp_no
JOIN titles t
	ON t.emp_no=e.emp_no
JOIN dept_emp de
	ON de.emp_no=e.emp_no
JOIN departments d
	ON d.dept_no=de.dept_no
WHERE s.to_date="9999-01-01";

DELIMITER $$
CREATE PROCEDURE departmentSummary (
	IN dept_no char(4)
)
BEGIN
	SELECT
		dept_no,
		dept_name,
		COUNT(emp_no) AS total_employees,
		ROUND(AVG(salary),2) AS avg_salary,
		MIN(salary) AS min_salary,
		MAX(salary) AS max_salary
	FROM current_employees c
	WHERE dept_no=c.dept_no
    GROUP BY dept_no,dept_name;
END $$
DELIMITER ;

CALL departmentSummary('d001');
