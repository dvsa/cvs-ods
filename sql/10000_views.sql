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

-- Getting list of distinct system numbers of vehicles that have been tested since CVS introduction
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

-- Getting list of distinct system numbers from tec since CVS introduction
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
),

-- Union together with an origin for lineage
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
	final_dataset;


CREATE OR REPLACE VIEW vw_dvla_ants AS

-- Get the test IDs of the specific tests we're interested in
WITH na_test_type_id AS (
	SELECT	id
	FROM 	test_type
	WHERE 	testTypeName LIKE '%notifiable alteration%'
	OR      testTypeName LIKE '%VTG10%'
	OR      testTypeName LIKE '%VTG790%'
),

-- Get the test results for these test types, also add a rank to them in the event there are multiple
ranked_tests AS
(
	SELECT	vehicle_id,
			createdAt,
			RANK() OVER(partition by vehicle_id order by createdAt desc) sort_order
	FROM	test_result
	WHERE	test_type_id IN (SELECT id FROM na_test_type_id)
    AND		LOWER(testResult) IN ('pass', 'prs')
),

-- Getting the most recent test
most_recent_test AS (
	SELECT	*
	FROM 	ranked_tests
	WHERE	sort_order = 1
),

-- identifying the history of the vehicle before the test occured
tech_records_before_test AS (
	SELECT	tech.id,
			tech.vehicle_id,
			tech.createdAt,
            tech.grossGbWeight,
            tech.trainGbWeight,
			RANK() OVER(PARTITION BY vehicle_id ORDER BY tech.createdAt DESC) tech_sort_order_before_test
	FROM	technical_record AS tech
	JOIN 	most_recent_test AS mrt
	ON		tech.vehicle_id = mrt.vehicle_id
	WHERE	tech.statusCode = 'archived'
	AND		tech.createdAt < mrt.createdAt
),

-- identifying the history of the vehicle after the test occured
tech_records_after_test AS (
	SELECT	tech.id,
			tech.vehicle_id,
			tech.createdAt,
            tech.grossGbWeight,
            tech.trainGbWeight,
            vc.vehicleConfiguration,
            mm.make,
            mm.model,
            CASE
				WHEN vc.vehicleConfiguration IS NOT NULL
                AND noOfAxles IS NOT NULL
                THEN CONCAT(SUBSTRING(vc.vehicleConfiguration,1,1), tech.noOfAxles)
                ELSE NULL
			END AS wheelplan,
			RANK() OVER(PARTITION BY vehicle_id ORDER BY tech.createdAt ASC) tech_sort_order_after_test
	FROM	technical_record AS tech
	JOIN	vehicle_class AS vc
	ON 		tech.vehicle_class_id = vc.id
	JOIN 	most_recent_test AS mrt
	ON		tech.vehicle_id = mrt.vehicle_id
    JOIN	make_model AS mm
    ON		tech.make_model_id = mm.id
	WHERE	tech.statusCode in ('current','archived')
	AND		tech.createdAt > mrt.createdAt
),

-- Join the tech record either side of the test
vehicle_timeline AS (
	SELECT	mrt.vehicle_id,
			mrt.createdAt 							AS test_result_createdAt,

            prov.id 								AS provisional_tech_record_id,
			prov.createdAt 							AS provisional_tech_record_createdAt,
			COALESCE(prov.grossGbWeight,0)			AS provisional_grossGbWeight,
            COALESCE(prov.trainGbWeight,0)			AS provisional_trainGbWeight,
			aft.id 									AS tested_tech_record_id,
			aft.createdAt 							AS tested_tech_record_createdAt,
			COALESCE(aft.grossGbWeight,0)			AS tested_grossGbWeight,
            COALESCE(aft.trainGbWeight,0)			AS tested_trainGbWeight,
            aft.make								AS tested_make,
            aft.model								AS tested_model,
			aft.vehicleConfiguration				AS tested_vehicleConfiguration,
            aft.wheelplan							AS tested_wheelplan
	FROM	most_recent_test mrt
	JOIN	tech_records_before_test 				AS prov
			ON mrt.vehicle_id = prov.vehicle_id
			AND prov.tech_sort_order_before_test = 2 -- tech record before the provisional
	JOIN	tech_records_after_test 				AS aft
			ON mrt.vehicle_id = aft.vehicle_id
			AND aft.tech_sort_order_after_test = 1 -- tech record after test
),

-- Only include records where the weight is different between the tech records
final_dataset AS(
	SELECT 	v.vrm_trm,
			tested_make 					AS make,
			tested_model 					AS model,
			UPPER(tested_wheelplan) 		AS wheelplan,
			CASE
				WHEN tested_vehicleConfiguration = 'rigid'
					THEN provisional_grossGbWeight
				WHEN tested_vehicleConfiguration = 'articulated'
					THEN provisional_trainGbWeight
			END 							AS weight_before_test,
			CASE
				WHEN tested_vehicleConfiguration = 'rigid'
					THEN tested_grossGbWeight
				WHEN tested_vehicleConfiguration = 'articulated'
					THEN tested_trainGbWeight
			END 							AS weight_after_test,
			'1111' 							AS DOE_reference,
			NULL 							AS date_of_plating,
            provisional_tech_record_createdAt,
            test_result_createdAt,
			tested_tech_record_createdAt
	FROM 	vehicle_timeline vt
	JOIN	vehicle v on vt.vehicle_id = v.id
	WHERE
			CASE
				WHEN tested_vehicleConfiguration = 'rigid'
				AND provisional_grossGbWeight <> tested_grossGbWeight
					THEN TRUE
				WHEN tested_vehicleConfiguration = 'articulated'
				AND provisional_trainGbWeight <> tested_trainGbWeight
					THEN TRUE
				ELSE FALSE
			END = TRUE
)

SELECT 		*
FROM 		final_dataset
ORDER BY 	tested_tech_record_createdAt ASC