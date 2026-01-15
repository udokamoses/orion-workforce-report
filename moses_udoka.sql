-- Orion Workforce Analysis
USE capstone;
DELIMITER $$
CREATE PROCEDURE run_orion()
BEGIN
	SELECT * FROM countries;
    SELECT * FROM departments;
    SELECT * FROM employees;
    SELECT * FROM jobs;
END $$
DELIMITER ;

CALL run_orion();

-- 1. Workforce Distribution
SELECT 
    d.department_id,
    d.department_name,
    COUNT(e.employee_id) AS total_employees
FROM
    employees AS e
        INNER JOIN
    departments AS d ON e.department_id = d.department_id
GROUP BY d.department_id , d.department_name
ORDER BY total_employees DESC;


-- 2. Salary Comparison
SELECT 
    d.department_id,
    d.department_name,
    ROUND(AVG(salary), 0) AS avg_salary
FROM
    employees AS e
        INNER JOIN
    departments AS d ON e.department_id = d.department_id
GROUP BY d.department_id , d.department_name
ORDER BY avg_salary DESC;
 

-- 3. Salary bands for employees
SELECT 
CASE
	WHEN salary < 5000 THEN 'Low'
    WHEN salary BETWEEN 5000 AND 10000 THEN 'Medium'
    ELSE 'High'
END AS salary_band,
COUNT(*) AS total_employees
FROM employees
GROUP BY salary_band;


-- 4. Country-Level Analysis
SELECT 
    c.country_name, COUNT(e.department_id) AS total_departments
FROM
    employees AS e
        INNER JOIN
    countries AS c ON e.country_id = c.country_id
GROUP BY c.country_name;


-- 5. High Earners
SELECT 
    emp_name, salary
FROM
    employees
WHERE
    salary > (SELECT 
            AVG(salary)
        FROM
            employees);
            
            
-- 6. Job role analysis
WITH job_avg AS (
	SELECT job_id, ROUND(AVG(salary),0) AS avg_salary
    FROM employees
    GROUP BY job_id)
SELECT j.job_title, ja.avg_salary
FROM job_avg AS ja
INNER JOIN jobs AS j
ON ja.job_id = j.job_id
HAVING ja.avg_salary > 12000;


-- 7. Salary growth trend
SELECT 
    c.country_name, SUM(e.salary) AS total_salary
FROM
    employees AS e
        INNER JOIN
    countries AS c ON e.country_id = c.country_id
GROUP BY c.country_name
ORDER BY total_salary DESC;


-- 8. Workforce gaps
SELECT 
    j.job_id, j.job_title
FROM
    jobs AS j
        LEFT JOIN
    employees AS e ON j.job_id = e.job_id
WHERE
    e.job_id IS NULL;
-- All job roles have employees assigned. 
            







