/*
Question: What skills are required for the top paying jobs from the job titles selected?
    1. Return the top 10 highest-paying Data Analyst roles available remotely.
    2. Focus on job postings that specify salaries (removes null values).
    3. Include required skills for these roles.
*/

WITH top_paying_jobs AS (
    SELECT
        job_id,
        name AS company_name,
        job_title,
        TO_CHAR(ROUND(salary_year_avg, 0), '999,999,999') AS average_yearly_salary_$
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
    job_title_short IN ('Data Analyst', 'Data Scientist', 'Business Analyst', 'Data Engineer') AND --filter if opportunities should be split up
    salary_year_avg IS NOT NULL AND
    job_posted_date >= '2025-01-01'
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM 
    top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id;