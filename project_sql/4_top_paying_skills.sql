/*
Question: What are the top skills based on salary?
    1. Look at the average salary assocaited with each skill for the jobs researched
       a. Focus will be on skills that appear to be in most demand (query 3 - overall analysis)
    2. Focus on roles with specific salaries - regardless of location - and posted in 2025
    3. Reveals how differnt skills impact salary levels for data professions and helps identify the most
        functionally rewarding skills to acquire or improve
*/


SELECT
    skills,
    ROUND(AVG(salary_year_avg),0) AS avg_salary_$
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short IN ('Data Analyst', 'Data Engineer', 'Data Scientist', 'Business Analyst') AND
    skills IN ('sql', 'python', 'aws', 'tableau', 'azure') AND
    salary_year_avg IS NOT NULL AND
    job_posted_date >= '2025-01-01'
    -- AND job_work_from_home = TRUE -- uncomment to filter for remote jobs only
GROUP BY
    skills
ORDER BY
    avg_salary_$ DESC
LIMIT 25;