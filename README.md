# treblozyl-mds-persistency-case
SQL analysis of dose modification impact on Treblozyl persistency in MDS

## Treblozyl Persistency Analysis (MDS)

This case study evaluates whether real-world dose modifications
(delay, skip, titration) are associated with higher treatment
persistency for Treblozyl in 2L MDS patients.

### Methods
- Claims-based dose normalization
- Window functions to detect dose changes
- Persistency defined as time from first to last infusion
- SQL-first analytics with BigQuery-compatible syntax

### Key Insight
Patients with dose modifications demonstrate longer persistency,
suggesting active physician management improves therapy continuation.


01_daily_dose.sql
- Aggregates same-day Treblozyl claims to normalize dosing events

02_dose_modifications.sql
- Identifies dose delays, skips, and titrations using window functions

03_patient_persistency.sql
- Calculates duration of therapy and modification flags
   



