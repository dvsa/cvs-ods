--liquibase formatted sql
--changeset liquibase:3 -multiple-tables:1 splitStatements:true endDelimiter:; context:dev runOnChange:true
CREATE OR REPLACE VIEW evl_view AS
    SELECT
        vrm_trm
        ,certificateNumber
        ,testExpiryDate
    FROM (
        SELECT
            vrm_trm
            ,certificateNumber
            ,testExpiryDate
            ,ROW_NUMBER() OVER (PARTITION BY vrm_trm ORDER BY testExpiryDate DESC) AS rownumber
        FROM (
            SELECT
                SubQ.vrm_trm
                ,t.certificateNumber
                ,t.testExpiryDate
            FROM test_result t
            JOIN test_type tt ON t.test_type_id = tt.id
            JOIN (
                SELECT MAX(createdAt),
                    id
                    ,vrm_trm
                FROM vehicle
                WHERE 
                    LENGTH(vrm_trm) < 8
                    AND vrm_trm NOT REGEXP '^[a-zA-Z][0-9]{6}$'
                    AND vrm_trm NOT REGEXP '^[0-9]{6}[zZ]$'
                GROUP BY 
                    id
                    ,vrm_trm
            ) SubQ ON SubQ.id = t.vehicle_id
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
            UNION ALL
            SELECT
                vrm_trm
                ,certificateNumber
                ,testExpiryDate
            FROM vt_evl_additions
        ) vt_cvs_union
    ) windowed_evl_data
    WHERE rownumber = 1
    ORDER BY
        vrm_trm
;

CREATE OR REPLACE VIEW vw_active_vehicles AS

WITH test_results_since_cvs AS (
	SELECT
		DISTINCT v.system_number
	FROM
		test_result tr
	JOIN
		vehicle v
		ON tr.vehicle_id = v.id
	WHERE
		testTypeStartTimestamp BETWEEN '2023-03-01' AND DATE_ADD(NOW(), INTERVAL 1 DAY)
),

tech_record_created_since_cvs AS (
	SELECT
		DISTINCT v.system_number
	FROM
		technical_record tech
	JOIN
		vehicle v
		ON tech.vehicle_id = v.id
	WHERE
		tech.statusCode IN ('current', 'provisional') AND
		tech.createdAt BETWEEN '2023-03-01' AND DATE_ADD(NOW(), INTERVAL 1 DAY)
	GROUP BY
		v.system_number
    HAVING
		MIN(tech.createdAt BETWEEN '2023-03-01' AND DATE_ADD(NOW(), INTERVAL 1 DAY))
),

final_dataset AS (
	SELECT
	  system_number
	, 'test-result' origin
	FROM
	  test_results_since_cvs
	UNION
	SELECT
	  system_number
	, 'tech-record' origin
	FROM
	  tech_record_created_since_cvs
)

SELECT
	*
FROM
	final_dataset