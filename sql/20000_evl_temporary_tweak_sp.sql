--liquibase formatted sql
--changeset liquibase:3 splitStatements:true endDelimiter:// context:dev runOnChange:true

DROP PROCEDURE IF EXISTS PrepareVTDataForEVL //
CREATE DEFINER=CURRENT_USER PROCEDURE PrepareVTDataForEVL()
/* 
    Prepares valid test certificates from VT for combination with the CVS EVL
    feed during the interim time period that data remediation work is ongoing.
*/
BEGIN
	/* 
        Get all the system numbers in CVS that have a valid certificate
	    This will be used later as a way to exclude VT certificates for
	    vehicles that already have one in CVS.
    */
	TRUNCATE `vt_evl_00_cvs_system_numbers`;
	INSERT INTO `vt_evl_00_cvs_system_numbers`
        SELECT 
            v.`system_number`
        FROM `test_result` AS t
        JOIN `test_type` AS tt ON t.`test_type_id` = tt.`id`
        JOIN `vehicle` AS v ON t.`vehicle_id` = v.`id`
        WHERE 
            t.`testExpiryDate` > DATE(NOW() - INTERVAL 3 DAY)
            AND t.`testStatus` != 'cancelled'
            AND tt.`testTypeClassification` = 'Annual With Certificate'
            AND 
            (
                t.`certificateNumber` IS NOT NULL
                AND t.`certificateNumber` != ''
                AND NOT LOCATE(' ', t.`certificateNumber`) > 0
            )
        GROUP BY v.`system_number`
	;

    /*
	    Get all of the valid certificates from VT, including extra
	    information about the vehicle to be used for matching
	    purposes.
    */
	TRUNCATE `vt_evl_01_static_set`;
	INSERT INTO `vt_evl_01_static_set`
        SELECT 
            IFNULL(v.`CURR_REGMK`, v.`TRAILER_ID`)  AS vrm
            ,vt.`VEHICLE_ID`                        AS vrm_test_record
            ,v.`SYSTEM_NUMBER`                      AS system_number
            ,v.`VIN`                                AS vin
            ,vt.`TEST_CERTIFICATE_S`                AS certificateNumber
            ,vt.`DATE0`                             AS testStartDate 
            ,vt.`CERT_EXPIRY_DATE`                  AS testExpiryDate
        FROM `VICP1DBA`.`VEHICLE_TEST` AS vt
        JOIN `VICP1DBA`.`VEHICLE` AS v ON (vt.`FK_VEH_SYS_NUM` = v.`SYSTEM_NUMBER`)
        JOIN `VICP1DBA`.`APPLICATION_TYPE` AS appl ON vt.`APPL_TYPE` = appl.`APPL_TYPE`
        WHERE 
            DATE(vt.`CERT_EXPIRY_DATE`) > NOW()
            AND DATE(vt.`CERT_EXPIRY_DATE`) != '01-01-0001'
            AND TRIM(vt.`TEST_CERTIFICATE_S`) <> ' '
            AND TRIM(vt.`TEST_CERTIFICATE_S`) IS NOT NULL
            AND NOT LOCATE(' ', vt.`TEST_CERTIFICATE_S`) > 0
            AND 
            (
                -- From investigations into the legacy ETL codebase it seems
                -- that these are commonly chosen as filters for "annual" tests
                appl.`APPL_TYPE` IN ('aal','aas','aav','aat','rpv','rpt')
                OR appl.`DESC0` LIKE '%annual%'
            ) 
            AND IFNULL(v.`CURR_REGMK`, v.`TRAILER_ID`) <> ' '
            AND IFNULL(v.`CURR_REGMK`, v.`TRAILER_ID`) IS NOT NULL
            AND LENGTH(IFNULL(v.`CURR_REGMK`, v.`TRAILER_ID`)) < 8
            AND IFNULL(v.`CURR_REGMK`, v.`TRAILER_ID`) NOT REGEXP '^[a-zA-Z][0-9]{6}$'
            AND IFNULL(v.`CURR_REGMK`, v.`TRAILER_ID`) NOT REGEXP '^[0-9]{6}[zZ]$'
	;

	/*
        Take the valid certificates from vt_evl_01_static_set that
	    are assigned to system numbers that DO NOT have a valid
	    certificate in CVS.
	*/
	TRUNCATE `vt_evl_02_cvs_removed`;
	INSERT INTO `vt_evl_02_cvs_removed`
        SELECT
            vt.`vrm`
            ,vt.`vrm_test_record`
            ,vt.`system_number`
            ,vt.`vin`
            ,vt.`certificateNumber`
            ,vt.`testStartDate`
            ,vt.`testExpiryDate`
        FROM `vt_evl_01_static_set` AS vt
        LEFT JOIN `vt_evl_00_cvs_system_numbers` AS cvs ON vt.`system_number` = cvs.`system_number`
        WHERE
            cvs.`system_number` IS NULL
            AND vt.`testExpiryDate` > DATE(NOW() - INTERVAL 3 DAY)
	;

	/*
        Keep the certificates from vt_evl_02_cvs_removed that are
	    assigned to system numbers that HAVE NOT had a failed annual
	    test in CVS with a more recent test date.
	*/
	TRUNCATE `vt_evl_03_failures_removed`;
	INSERT INTO `vt_evl_03_failures_removed` 
        SELECT
            vt.`vrm`
            ,vt.`vrm_test_record`
            ,vt.`system_number`
            ,vt.`vin`
            ,vt.`certificateNumber`
            ,vt.`testStartDate`
            ,vt.`testExpiryDate`
        FROM `vt_evl_02_cvs_removed` AS vt
        LEFT JOIN 
        (
            SELECT 
                v.`system_number`
                ,DATE(MAX(tr.`testTypeStartTimestamp`)) AS testTypeStartTimestamp
            FROM `test_result` tr
            JOIN `test_type` tt ON tr.`test_type_id` = tt.`id`
            JOIN `vehicle` v ON tr.`vehicle_id` = v.`id`
            WHERE 
                tr.`testResult` = 'fail' 
                AND tt.`testTypeClassification` = 'Annual With Certificate'
                AND tr.`testTypeStartTimestamp` >= DATE(NOW() - INTERVAL 1 YEAR)
            GROUP BY v.`system_number`
        ) AS fails ON vt.`system_number` = fails.`system_number`
        WHERE 
            fails.`system_number` IS NULL OR fails.`testTypeStartTimestamp` < vt.`testStartDate`
	;

	/*
        Insert only the fields required to the final table ready for union
        with the CVS data in the evl_view. 
        Final table (vt_evl_additions) has been excluded from the numbered naming
        convention in case more processing steps are added in the future. Less rework
        will be required.
        This step should be used to apply any business rule logic deemed
        appropriate.
	*/
	TRUNCATE `vt_evl_additions`;
	INSERT INTO `vt_evl_additions` 
        SELECT
            vt.`vrm`
            ,vt.`certificateNumber`
            ,vt.`testExpiryDate`
        FROM `vt_evl_03_failures_removed` AS vt
	;

END

//