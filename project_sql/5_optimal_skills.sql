/*

Question: What are the most optimal skills to learn (high demand and high paying skills)
    1. Identify skills in high demand and associated with high average salaries for the researched job roles in 2025
    2. Concentrates on remote postions with specified salaries
    3. Targets skills that offer job security (high demand) and financial benefits (high salaries),
        offering strategic insignts for career development in data analysis

*/


WITH skills_demand AS (
  SELECT
    skills_dim.skill_id,
		skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
  FROM
    job_postings_fact
	  INNER JOIN
	    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
	  INNER JOIN
	    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
  WHERE
    job_postings_fact.job_title_short IN ('Data Analyst', 'Data Engineer', 'Data Scientist', 'Business Analyst')
		AND job_postings_fact.salary_year_avg IS NOT NULL
    AND job_postings_fact.job_work_from_home = True AND
    job_postings_fact.job_posted_date >= '2025-01-01'
  GROUP BY
    skills_dim.skill_id
),

average_salary AS (
  SELECT
    skills_job_dim.skill_id,
    AVG(job_postings_fact.salary_year_avg) AS avg_salary
  FROM
    job_postings_fact
	  INNER JOIN
	    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
  WHERE
    job_postings_fact.job_title_short IN ('Data Analyst', 'Data Engineer', 'Data Scientist', 'Business Analyst')
		AND job_postings_fact.salary_year_avg IS NOT NULL
    AND job_postings_fact.job_work_from_home = True AND
    job_postings_fact.job_posted_date >= '2025-01-01'
  GROUP BY
    skills_job_dim.skill_id
)

SELECT
  skills_demand.skills,
  skills_demand.demand_count,
  (ROUND(average_salary.avg_salary, 0)) AS avg_salary_$
FROM
  skills_demand
	INNER JOIN
	  average_salary ON skills_demand.skill_id = average_salary.skill_id
ORDER BY
  demand_count DESC, 
	avg_salary DESC
LIMIT 5; 