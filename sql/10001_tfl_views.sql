--liquibase formatted sql
--changeset liquibase:3 splitStatements:true endDelimiter:; context:dev runOnChange:true
CREATE OR REPLACE VIEW tfl_view AS
SELECT 
    v.vrm_trm as VRM,
    v.vin     as VIN,
    tr.certificateNumber as SerialNumberOfCertificate,
    IFNULL(fe.modTypeCode,"p") as CertificationModificationType,
    1 AS TestStatus,
    CASE IFNULL(fe.emissionStandard,"")
        WHEN 'Pre-Euro'                 THEN 1        
        WHEN 'Euro 1'                   THEN 2        
        WHEN 'Euro 2'                   THEN 3
        WHEN 'Euro 3'                   THEN 4
        WHEN '0.08 g/kWh Euro 3 PM'     THEN 4
        WHEN '0.10 g/kWh Euro 3 PM'     THEN 4
        WHEN '0.16 g/kWh Euro 3 PM'     THEN 4
        WHEN 'Euro 4'                   THEN 5
        WHEN '0.03 g/kWh Euro 4 PM'     THEN 5
        WHEN 'Euro 5'                   THEN 6
        WHEN 'Euro I'                   THEN 7
        WHEN 'Euro II'                  THEN 8
        WHEN '0.32 g/kWh Euro II PM'    THEN 8
        WHEN 'Euro III'                 THEN 9
        WHEN 'Euro IV'                  THEN 10
        WHEN '0.03 g/kWh Euro IV PM'    THEN 10
        WHEN 'Euro V'                   THEN 11
        WHEN 'N/A (non diesel)'         THEN 12
        ELSE 13
    END AS PMEuropeanEmissionClassificationCode,
    DATE_FORMAT(tr.testTypeStartTimestamp, '%Y-%m-%d') as ValidFromDate,
    CASE
        WHEN tr.testExpiryDate IS NOT NULL 
            THEN DATE_FORMAT(LAST_DAY(tr.testExpiryDate), '%Y-%m-%d')
        WHEN tr.testExpiryDate IS NULL AND tr.testTypeStartTimestamp IS NOT NULL 
            THEN DATE_FORMAT(LAST_DAY(DATE_ADD(tr.testTypeStartTimestamp, INTERVAL 1 YEAR)), '%Y-%m-%d')
        WHEN tr.testExpiryDate IS NULL AND tr.testTypeStartTimestamp IS NULL AND tr.testTypeEndTimestamp IS NOT NULL
            THEN DATE_FORMAT(LAST_DAY(DATE_ADD(tr.testTypeEndTimestamp, INTERVAL 1 YEAR)), '%Y-%m-%d')
        ELSE
            ""
    END AS ExpiryDate,
	ts.pNumber AS IssuedBy,
    CASE
        WHEN tr.createdAt IS NOT NULL 
            THEN DATE_FORMAT(tr.createdAt, '%Y-%m-%d') 
        WHEN tr.createdAt IS NULL AND tr.testTypeStartTimestamp IS NOT NULL 
            THEN DATE_FORMAT(tr.testTypeStartTimestamp, '%Y-%m-%d')
        WHEN tr.createdAt IS NULL AND tr.testTypeStartTimestamp IS NULL AND tr.testTypeEndTimestamp IS NOT NULL
            THEN DATE_FORMAT(tr.testTypeEndTimestamp, '%Y-%m-%d')
        ELSE
            ""
    END AS IssueDate,
    CASE
        WHEN tr.createdAt IS NOT NULL 
            THEN tr.createdAt
        WHEN tr.createdAt IS NULL AND tr.testTypeStartTimestamp IS NOT NULL 
            THEN tr.testTypeStartTimestamp
        WHEN tr.createdAt IS NULL AND tr.testTypeStartTimestamp IS NULL AND tr.testTypeEndTimestamp IS NOT NULL
            THEN tr.testTypeEndTimestamp
        ELSE
            NULL
    END AS IssueDateTime
FROM 
    test_type tt
JOIN
    test_result tr
    ON (tt.id = tr.test_type_id)
JOIN
    vehicle v
    ON (v.id = tr.vehicle_id)
JOIN
    test_station ts
    ON (ts.id = tr.test_station_id)
JOIN
    fuel_emission fe
    ON (fe.id = tr.fuel_emission_id)
WHERE
    SUBSTR(tr.certificateNumber,1,2) = 'LP'
    AND LOWER(tr.testCode) IN ('lbp','lcp','ldv','lev','lez','lnp','lnv','lnz')