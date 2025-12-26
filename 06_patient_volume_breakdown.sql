SELECT
    any_modification,
    COUNT(DISTINCT patient_id) AS patient_count
FROM patient_persistency
GROUP BY any_modification;
