# Introduction

As an aspiring Data Storyteller, I believe in Aristotle's idea of "we learn by doing" - which inspired this project as a hands-on practice with SQL and Python skills to analyze current job skill demands and compensation patterns in the field I aspire to enter. This project will analyze the data job market as of June 2025 examining salary information, skill requirements, and remote work opportunities.

# Background

Driven by a quest to understand the current job market more effectively, this project was created to identify top-paid and in-demand skills, helping streamline the job search process for aspiring data professionals, such as myself. The data derives from [Luke Barousse's SQL Course](https://www.lukebarousse.com/sql). Luke's guidance, lessons, and data inspired me to build a project that not only develops SQL skills but applies these skills to answer real-world questions for aspiring data professionals like me.

### The following questions were answered through my SQL Queries:

1. What are the top paying data jobs (data analyst, data scientist, business analyst, and data engineer)?
2. What skills are required for these top-paying data roles?
3. What skills are most in demand for these data positions?
4. Which skills are associated with higher salaries in the data field?
5. What are the most optimal skills to learn for aspiring data professionals?

# Tools I Used

For my analysis, I used several powerful tools:

- **SQL**: The foundation of my analysis, allowing me to query the database for critical insights
- **PostgreSQL**: The database management system that was chosen for this project to handle the job posting data
- **Python**: The programming language used for data visualization, utilizing libraries such as pandas and matplotlib
- **Visual Studio Code**: The code editor used to execute the queries and build the visuals
- **Git and GitHub**: Essential for version control and sharing my project for collaboration and project tracking

# The Analysis

The presentation of this project is available in the [project_presentation]() folder of this repository. Each query in this project was aimed to investigate specific aspects of data positions I have interest in. Here is how I approached each question:

### Top Paying Data Jobs in 2025

```sql
SELECT
    job_id,
    name AS company_name,
    job_title_short AS position,
    job_title AS full_job_title,
    job_location,
    ROUND(salary_year_avg, 0)  average_yearly_salary_$,
    EXTRACT(YEAR FROM job_posted_date) AS year_posted
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short IN ('Data Analyst', 'Data Scientist', 'Business Analyst', 'Data Engineer') AND --filter if opportunities should be split up
    salary_year_avg IS NOT NULL AND
    job_posted_date >= '2025-01-01'
    -- AND job_location = 'Anywhere' -- uncomment this line for remote jobs
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

### Skills for Top Paying Jobs in 2025

```sql
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
```

### In-Demand Skills for Data Professionals in 2025

```sql
SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short IN ('Data Scientist', 'Data Engineer', 'Data Analyst', 'Business Analyst') AND
    job_work_from_home = TRUE AND
    job_posted_date >= '2025-01-01'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
```

### Skills based on Salary in 2025

```sql
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
```

### Optimal Skills and Salary for Remote Positions in 2025

```sql

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
```

# What I learned

This experience allowed me to go full steam into my aspirations to be a data professional with the following takeaways from the project:

1.	Craft complex SQL queries including: <br>
     a.	CTEs and Subqueries <br>
     b.	Left- and Inner-Joins <br>
     c.	Date Functions
2.	Use data aggregation so I can find counts and averages of skills and salaries
3.	Utilize powerful Python libraries and functions to build visuals for my presentation
4.	Refresh my skills and knowledge in: <br>
     a.	Juypter Notebook <br>
     b.	VSCode<br>
     c.	Git and GitHub
5.	Use critical-thinking and problem-solving, turning real-world questions into actionable, insightful queries and visualizations

# Conclusions

### Insights

1.	As of 2025, Netflix was looking for data professionals, offering salaries from $410,000 to $680,000
2.	High-paying skills needed to work at the top paying Netflix data positions were Python and SQL – showing the two programming languages are critical for success in the role, as well as significantly paying data professionals for their skills in those positions
3.	SQL and Python, overall, appear to be the top demanded skills for data professionals in 2025
4.	While SQL and Python compensate for six-figure salaries on average, having specialized skills in Azure and AWS appear to pay more
5.	For remote positions, SQL and Python lead the charge in both in-demand skills and average salaries
6.	Overall, skills in programming languages, cloud-based technologies, and visualization tools provide data professionals with an idea of what companies look for when hiring for data roles.

### Closing Remarks

This exercise has provided me with an ability to learn a language that not only sought-after but provided me with the capability to discover other skills that are in demand as well as compensation for knowing these skills. Aspiring data professionals, such as I, can take this information and better position ourselves in a competitive job market. Constant learning and practice are important for aspiring data professionals to grow in the world of data.
