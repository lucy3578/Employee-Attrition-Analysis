-- Male vs female numbers 
SELECT hr_employee_data.gender, COUNT(hr_employee_data.gender)
FROM hr_employee_data
GROUP BY hr_employee_data.gender;

-- Effect of marital status on business trips
SELECT 
	hr_employee_data.business_travel,
	COUNT(hr_employee_data.business_travel)
FROM hr_employee_data
WHERE hr_employee_data.marital_status = 'Single'
GROUP BY hr_employee_data.business_travel;

SELECT 
	hr_employee_data.business_travel,
	COUNT(hr_employee_data.business_travel)
FROM hr_employee_data
WHERE hr_employee_data.marital_status = 'Married'
GROUP BY hr_employee_data.business_travel;

SELECT 
	hr_employee_data.business_travel,
	COUNT(hr_employee_data.business_travel)
FROM hr_employee_data
WHERE hr_employee_data.marital_status = ‘Divorced’
GROUP BY hr_employee_data.business_travel;

Work life balance vs job involvement
SELECT work_life_balance, job_involvement
FROM hr_employee_data;

-- Relationship satisfaction female vs male
WITH female_relationship AS (
    SELECT 
        relationship_satisfaction,
        COUNT(*) AS female_count
    FROM hr_employee_data
    WHERE gender = 'Female'
    GROUP BY relationship_satisfaction
),
male_relationship AS (
    SELECT 
        relationship_satisfaction,
        COUNT(*) AS male_count
    FROM hr_employee_data
    WHERE gender = 'Male'
    GROUP BY relationship_satisfaction
),
total_relationship AS (
    SELECT DISTINCT relationship_satisfaction FROM hr_employee_data
)
SELECT 
    t.relationship_satisfaction,
    COALESCE(f.female_count, 0) AS female_count,
    COALESCE(m.male_count, 0) AS male_count,
    ROUND(100.0 * COALESCE(f.female_count, 0) / NULLIF(SUM(f.female_count) OVER (), 0), 2) AS female_percentage,
    ROUND(100.0 * COALESCE(m.male_count, 0) / NULLIF(SUM(m.male_count) OVER (), 0), 2) AS male_percentage
FROM total_relationship t
LEFT JOIN female_relationship f ON t.relationship_satisfaction = f.relationship_satisfaction
LEFT JOIN male_relationship m ON t.relationship_satisfaction = m.relationship_satisfaction
ORDER BY t.relationship_satisfaction;


-- Overtime work and job satisfaction
SELECT 
	hr_employee_data.job_satisfaction,
	COUNT(hr_employee_data.job_satisfaction)
FROM hr_employee_data
WHERE hr_employee_data.overtime = 'Yes'
GROUP BY hr_employee_data.job_satisfaction
ORDER BY hr_employee_data.job_satisfaction;

SELECT 
	hr_employee_data.job_satisfaction,
	COUNT(hr_employee_data.job_satisfaction)
FROM hr_employee_data
WHERE hr_employee_data.overtime = ‘No’
GROUP BY hr_employee_data.job_satisfaction
ORDER BY hr_employee_data.job_satisfaction;

-- Effect of pay amount on job satisfaction
SELECT job_satisfaction,
       AVG(monthly_income) AS average_monthly_income
FROM hr_employee_data
GROUP BY job_satisfaction;

-- Effect of job satisfaction on attrition rate
SELECT job_satisfaction,
       COUNT(*) AS total_employees,
       SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
       ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate
FROM hr_employee_data
GROUP BY job_satisfaction;

Effect of environment satisfaction on attrition rate
SELECT environment_satisfaction,
       COUNT(*) AS total_employees,
       SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
       ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate
FROM hr_employee_data
GROUP BY environment_satisfaction
ORDER BY environment_satisfaction;


-- Year since last promotion vs attrition rate
SELECT year_since_last_promotion,
       COUNT(*) AS total_employees,
       SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
       ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate
FROM hr_employee_data
GROUP BY year_since_last_promotion
ORDER BY year_since_last_promotion;


-- Age range vs attrition rate
SELECT CASE
           WHEN age BETWEEN 18 AND 25 THEN '18-25'
           WHEN age BETWEEN 26 AND 35 THEN '26-35'
           WHEN age BETWEEN 36 AND 45 THEN '36-45'
           WHEN age BETWEEN 46 AND 55 THEN '46-55'
           ELSE '56+'
       END AS age_range,
       COUNT(*) AS total_employees,
       SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
       ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_percentage
FROM hr_employee_data
GROUP BY age_range
ORDER BY age_range;


Distance from home vs attrition
SELECT distance_from_home,
       COUNT(*) AS total_employees,
       SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
       ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate
FROM hr_employee_data
GROUP BY distance_from_home
ORDER BY distance_from_home;


