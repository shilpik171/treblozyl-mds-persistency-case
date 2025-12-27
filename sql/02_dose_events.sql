 WITH daily_dose AS (
    SELECT
        patient_id,
        service_date,
        SUM(vials) AS total_vials
     FROM  `gcp-project-232108.GCP_Shilpi.mds`
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

SELECT *
FROM dose_events;
