 WITH daily_dose AS (
    SELECT
        patient_id,
        service_date,
        SUM(vials) AS total_vials
     FROM  `gcp-project-232108.GCP_Shilpi.mds`
    GROUP BY patient_id, service_date
)
SELECT * 
FROM daily_dose;
