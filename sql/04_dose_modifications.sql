With patient_modifications AS (
    SELECT
        patient_id,

        MAX(dose_delay)     AS any_delay,
        MAX(dose_skip)      AS any_skip,
        MAX(dose_titration) AS any_titration,

        MIN(service_date) AS start_date,
        MAX(service_date) AS end_date,
        COUNT(*) AS total_doses
    FROM dose_flags
    GROUP BY patient_id
)
