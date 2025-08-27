/*

Question: What are the most in-demand skills for Data Engineer?
    1. Join job postings to inner join table similar to query 2
    2. Identify the top 5 in-demand skills for a data engineer
    3. Focus on all job postings in 2025 that are remote (work from home)
    4. This query will retrieve the top 5 skills for the positions
    5. This query is one of four different queries based on the analyzed job titles

*/

SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Engineer' AND
    job_work_from_home = TRUE AND
    job_posted_date >= '2025-01-01'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;