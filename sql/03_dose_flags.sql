With dose_flags AS (
    SELECT
        patient_id,
        service_date,
        total_vials,

        CASE
            WHEN gap_days > 35 THEN 1 ELSE 0
        END AS dose_delay,

        CASE
            WHEN prev_vials IS NOT NULL
             AND total_vials <> prev_vials THEN 1 ELSE 0
        END AS dose_titration,

        CASE
            WHEN gap_days > 56 THEN 1 ELSE 0
        END AS dose_skip
    FROM dose_events
)
