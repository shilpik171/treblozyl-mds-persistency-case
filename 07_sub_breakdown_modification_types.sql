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
