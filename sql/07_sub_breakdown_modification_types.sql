WITH daily_dose AS (
    SELECT
        patient_id,
        service_date,
        SUM(vials) AS total_vials
     FROM  `peerless-summit-311611.peerless.patient`
    GROUP BY patient_id, service_date
)
,dose_events AS (
    SELECT
        patient_id,
        service_date,
        total_vials,

        LAG(service_date) OVER (
            PARTITION BY patient_id
            ORDER BY service_date
        ) AS prev_service_date,

        LAG(total_vials) OVER (
            PARTITION BY patient_id
            ORDER BY service_date
        ) AS prev_vials,

        DATE_DIFF(
            service_date,
            LAG(service_date) OVER (
                PARTITION BY patient_id
                ORDER BY service_date
            ),
            DAY
        ) AS gap_days
    FROM daily_dose
)

,dose_flags AS (
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
 ,patient_dose_modifications AS (
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
,patient_persistency AS (
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
    FROM patient_dose_modifications
)


    
SELECT
    CASE
        WHEN any_delay = 1
         AND any_skip = 0
         AND any_titration = 0 THEN 'Delay Only'

        WHEN any_delay = 0
         AND any_skip = 1
         AND any_titration = 0 THEN 'Skip Only'

        WHEN any_delay = 0
         AND any_skip = 0
         AND any_titration = 1 THEN 'Titration Only'

        WHEN (any_delay + any_skip + any_titration) >= 2
         THEN 'Combination'

        ELSE 'No Modification'
    END AS modification_type,

    COUNT(DISTINCT patient_id) AS patients
FROM patient_persistency
GROUP BY modification_type;
