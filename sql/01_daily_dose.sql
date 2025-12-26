 WITH daily_dose AS (
    SELECT
        patient_id,
        service_date,
        SUM(vials) AS total_vials
     FROM  `peerless-summit-311611.peerless.patient`
    GROUP BY patient_id, service_date
)
