--liquibase formatted sql
--changeset liquibase:3 -multiple-tables:1 splitStatements:true endDelimiter:; context:dev runOnChange:true
CREATE OR REPLACE VIEW tfl_view AS
SELECT 
    v.vrm_trm as registrationMark,
    v.vin     as vehicleIdentificationNumber,
    tr.certificateNumber as certificateNumber,
    IFNULL(fe.modTypeCode,"") as modTypeCode,
    CASE SUBSTR(tr.certificateNumber,1,2)
        WHEN 'LF' THEN '02'
        WHEN 'LP' THEN
            CASE IFNULL(fe.emissionStandard,"")
                WHEN '0.16 g/kWh Euro 3 PM' THEN '01,09,' -- 'A'
                WHEN '0.08 g/kWh Euro 3 PM' THEN '01,09,' -- 'B'
                WHEN '0.03 g/kWh Euro IV PM' THEN '01,10,' -- 'D'           
                WHEN '0.10 g/kWh Euro 3 PM' THEN '01,04,' -- 'E'
                WHEN 'Gas Euro IV PM' THEN '01,12,' -- 'X'            
                ELSE 'UNK'
            END  
        ELSE 'UNK'
    END as emissionCode,
    DATE_FORMAT(tr.testTypeStartTimestamp, '%Y-%m-%d') as testStartDate,
    CASE
        WHEN tr.testExpiryDate IS NOT NULL 
            THEN DATE_FORMAT(tr.testExpiryDate, '%Y-%m-%d')
        WHEN tr.testExpiryDate IS NULL AND tr.testTypeStartTimestamp IS NOT NULL 
            THEN DATE_FORMAT(LAST_DAY(DATE_ADD(tr.testTypeStartTimestamp, INTERVAL 1 YEAR)), '%Y-%m-%d')
        WHEN tr.testExpiryDate IS NULL AND tr.testTypeStartTimestamp IS NULL AND tr.testtypeendtimestamp IS NOT NULL
            THEN DATE_FORMAT(LAST_DAY(DATE_ADD(tr.testtypeendtimestamp, INTERVAL 1 YEAR)), '%Y-%m-%d')
        ELSE
            ""
    END as testExpiryDate, 
	ts.pNumber as premise
FROM 
    CVSNOP.test_type tt
JOIN
    CVSNOP.test_result tr
    ON (tt.id = tr.test_type_id)
JOIN
    CVSNOP.vehicle v
    ON (v.id = tr.vehicle_id)
JOIN
    CVSNOP.test_station ts
    ON (ts.id = tr.test_station_id)
JOIN
    CVSNOP.fuel_emission fe
    ON (fe.id = tr.fuel_emission_id)
WHERE
    SUBSTR(tr.certificateNumber,1,2) IN ('LP', 'LF')
    AND tt.testTypeName LIKE '%LEC%';

CREATE OR REPLACE VIEW tfl_view_raw AS
SELECT
    CONCAT(
        registrationMark,
        ",",
        vehicleIdentificationNumber,
        ",",
        certificateNumber,
        ",",
        modTypeCode,
        ",",
        emissionCode,
        ",",
        testStartDate,
        ",",
        testExpiryDate, 
        ",",
        premise
    ) as  tfl_str,
    testStartDate
FROM tfl_view;