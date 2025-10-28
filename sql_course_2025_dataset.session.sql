SELECT
    sd.skill_id,
    sd.skills,
    COUNT(sjd.job_id) AS skill_count
FROM
    skills_dim AS sd
    LEFT JOIN
    skills_job_dim AS sjd ON sd.skill_id = sjd.skill_id
GROUP BY
    sd.skill_id,
    sd.skills
ORDER BY
    skill_count DESC;