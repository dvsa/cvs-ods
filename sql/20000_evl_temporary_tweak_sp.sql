--liquibase formatted sql
--changeset liquibase:3 splitStatements:true endDelimiter:; context:dev runOnChange:true

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS PrepareVTDataForEVL()
/* Prepares valid test certificates from VT
for combination with the CVS EVL feed during
the interim time period that data remediation
work is ongoing.*/

BEGIN
	-- Get all the system numbers in CVS that have a valid certificate
	-- This will be used later as a way to exclude VT certificates for
	-- vehicles that already have one in CVS.
	CREATE TABLE IF NOT EXISTS UNMANAGED_DATA.vt_evl_00_cvs_system_numbers 
    (
		system_number INT PRIMARY KEY
	);

	DELETE FROM UNMANAGED_DATA.vt_evl_00_cvs_system_numbers;

	INSERT INTO UNMANAGED_DATA.vt_evl_00_cvs_system_numbers
        SELECT 
            v.system_number
        FROM CVSNOP.test_result t
        JOIN CVSNOP.test_type tt ON t.test_type_id = tt.id
        JOIN CVSNOP.vehicle v ON t.vehicle_id = v.id
        WHERE 
            t.testExpiryDate > DATE(NOW() - INTERVAL 3 DAY)
            AND t.testStatus != 'cancelled'
            AND tt.testTypeClassification = 'Annual With Certificate'
            AND 
            (
                t.certificateNumber IS NOT NULL
                AND t.certificateNumber != ''
                AND NOT LOCATE(' ', t.certificateNumber) > 0
            )
        GROUP BY v.system_number
	;


	-- Get all of the valid certificates from VT, including extra
	-- information about the vehicle to be used for matching
	-- purposes.
	CREATE TABLE IF NOT EXISTS UNMANAGED_DATA.vt_evl_01_static_set 
    (
		vrm 				VARCHAR(20)
		,vrm_test_record 	VARCHAR(20)
		,system_number 		INT
		,vin 				VARCHAR(21)
		,certificateNumber 	VARCHAR(12)
		,testStartDate 		DATETIME
		,testExpiryDate 	DATETIME
	);

	DELETE FROM UNMANAGED_DATA.vt_evl_01_static_set;

	INSERT INTO UNMANAGED_DATA.vt_evl_01_static_set 
        SELECT 
            IFNULL(v.CURR_REGMK, v.TRAILER_ID) as vrm
            ,vt.VEHICLE_ID AS vrm_test_record
            ,v.SYSTEM_NUMBER AS system_number
            ,v.VIN AS vin
            ,vt.TEST_CERTIFICATE_S as certificateNumber
            ,MAX(vt.DATE0) as testStartDate 
            ,MAX(vt.CERT_EXPIRY_DATE) as testExpiryDate
        FROM VICP1DBA.VEHICLE_TEST vt
        JOIN VICP1DBA.VEHICLE v ON (vt.FK_VEH_SYS_NUM = v.SYSTEM_NUMBER)
        JOIN VICP1DBA.APPLICATION_TYPE appl ON vt.APPL_TYPE=appl.APPL_TYPE
        WHERE 
            vt.CERT_EXPIRY_DATE > now()
            AND TRIM(vt.TEST_CERTIFICATE_S) <> ' '
            AND TRIM(vt.TEST_CERTIFICATE_S) IS NOT NULL
            AND NOT LOCATE(' ', vt.TEST_CERTIFICATE_S) > 0
            AND vt.CERT_EXPIRY_DATE > NOW()
            AND appl.DESC0 LIKE '%annual%'
            AND IFNULL(v.CURR_REGMK, v.TRAILER_ID) <> ' '
            AND IFNULL(v.CURR_REGMK, v.TRAILER_ID) IS NOT NULL
            AND LENGTH(IFNULL(v.CURR_REGMK, v.TRAILER_ID)) < 8
            AND IFNULL(v.CURR_REGMK, v.TRAILER_ID) NOT REGEXP '^[a-zA-Z][0-9]{6}$'
            AND IFNULL(v.CURR_REGMK, v.TRAILER_ID) NOT REGEXP '^[0-9]{6}[zZ]$'
        GROUP BY 
            IFNULL(v.CURR_REGMK, v.TRAILER_ID)
            ,vt.VEHICLE_ID
            ,v.SYSTEM_NUMBER
            ,v.VIN
            ,vt.TEST_CERTIFICATE_S
	;


	-- Take the valid certificates from vt_evl_01_static_set that
	-- are assigned to system numbers that DO NOT have a valid
	-- certificate in CVS.
	CREATE TABLE IF NOT EXISTS UNMANAGED_DATA.vt_evl_02_cvs_removed 
    (
		vrm 				VARCHAR(20)
		,vrm_test_record 	VARCHAR(20)
		,system_number 		INT
		,vin 				VARCHAR(21)
		,certificateNumber 	VARCHAR(12)
		,testStartDate 		DATETIME
		,testExpiryDate 	DATETIME
	);

	DELETE FROM UNMANAGED_DATA.vt_evl_02_cvs_removed;

	INSERT INTO UNMANAGED_DATA.vt_evl_02_cvs_removed 
        SELECT
            vt.vrm
            ,vt.vrm_test_record
            ,vt.system_number
            ,vt.vin
            ,vt.certificateNumber
            ,vt.testStartDate
            ,vt.testExpiryDate
        FROM UNMANAGED_DATA.vt_evl_01_static_set vt
        LEFT JOIN UNMANAGED_DATA.vt_evl_00_cvs_system_numbers cvs ON vt.system_number = cvs.system_number
        WHERE
            cvs.system_number IS NULL
            AND vt.testExpiryDate > DATE(NOW() - INTERVAL 3 DAY)
	;


	-- Keep the certificates from vt_evl_02_cvs_removed that are
	-- assigned to system numbers that HAVE NOT had a failed annual
	-- test in CVS with a more recent test date.
	CREATE TABLE IF NOT EXISTS UNMANAGED_DATA.vt_evl_03_failures_removed 
    (
		vrm 				VARCHAR(20)
		,vrm_test_record 	VARCHAR(20)
		,system_number 		INT
		,vin 				VARCHAR(21)
		,certificateNumber 	VARCHAR(12)
		,testStartDate 		DATETIME
		,testExpiryDate 	DATETIME
	);

	DELETE FROM UNMANAGED_DATA.vt_evl_03_failures_removed;

	INSERT INTO UNMANAGED_DATA.vt_evl_03_failures_removed 
        SELECT
            vt.vrm
            ,vt.vrm_test_record
            ,vt.system_number
            ,vt.vin
            ,vt.certificateNumber
            ,vt.testStartDate
            ,vt.testExpiryDate
        FROM UNMANAGED_DATA.vt_evl_02_cvs_removed vt
        LEFT JOIN 
        (
            SELECT 
                v.system_number
                ,DATE(MAX(tr.testTypeStartTimestamp)) AS testTypeStartTimestamp
            FROM CVSNOP.test_result tr
            JOIN CVSNOP.test_type tt ON tr.test_type_id = tt.id
            JOIN CVSNOP.vehicle v ON tr.vehicle_id = v.id
            WHERE 
                tr.testResult = 'fail' 
                AND tt.testTypeClassification = 'Annual With Certificate'
                AND tr.testTypeStartTimestamp >= DATE(NOW() - INTERVAL 1 YEAR)
            GROUP BY v.system_number
        ) fails ON vt.system_number = fails.system_number
        WHERE 
            fails.system_number IS NULL OR fails.testTypeStartTimestamp < vt.testStartDate
	;

END

DELIMITER ;