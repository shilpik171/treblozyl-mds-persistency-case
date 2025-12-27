With patient_persistency AS (
    SELECT
        patient_id,
        any_delay,
        any_skip,
        any_titration,
        total_doses,

        DATE_DIFF(end_date, start_date, DAY) AS persistency_days,

        CASE
            WHEN any_delay = 1
              OR any_skip = 1
              OR any_titration = 1
            THEN 1 ELSE 0
        END AS any_modification
    FROM patient_modifications
)
