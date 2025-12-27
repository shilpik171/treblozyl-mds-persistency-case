SELECT
    any_modification,
    COUNT(DISTINCT patient_id) AS patients,
    AVG(persistency_days) AS avg_persistency_days,
    PERCENTILE_CONT(0.5) 
        WITHIN GROUP (ORDER BY persistency_days) AS median_persistency_days
FROM patient_persistency
GROUP BY any_modification;
