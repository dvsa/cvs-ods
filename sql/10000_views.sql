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

WITH na_test_type_id AS (
	SELECT	id
	FROM 	CVSNOP.test_type
	WHERE 	testTypeName LIKE '%notifiable alteration%'
    AND		(testTypeName LIKE '%VTG10%' OR testTypeName LIKE '%VTG790%')
),

ranked_tests AS
(
	SELECT	vehicle_id,
			createdAt,
			RANK() OVER(partition by vehicle_id order by createdAt desc) sort_order
	FROM	CVSNOP.test_result
	WHERE	test_type_id IN (SELECT id FROM na_test_type_id)
    AND		testResult = 'pass'
),

most_recent_test AS (
	SELECT	*
	FROM 	ranked_tests
	WHERE	sort_order = 1
),

tech_records_before_test AS (
	SELECT	tech.id,
			tech.vehicle_id,
			tech.createdAt,
            tech.grossGbWeight,
            tech.trainGbWeight,
            vc.vehicleConfiguration,
			RANK() OVER(PARTITION BY vehicle_id ORDER BY tech.createdAt DESC) tech_sort_order_before_test
	FROM	technical_record AS tech
	JOIN	vehicle_class AS vc
	ON 		tech.vehicle_class_id = vc.id
	JOIN 	most_recent_test AS mrt
	ON		tech.vehicle_id = mrt.vehicle_id
	WHERE	tech.statusCode in ('current','archived')
	AND		tech.createdAt < mrt.createdAt
),

vehicle_timeline AS (
	SELECT	mrt.vehicle_id,
			mrt.createdAt 							AS test_result_createdAt,

            init.id 								AS initial_tech_record_id,
            init.createdAt 							AS initial_tech_record_createdAt,
			COALESCE(init.grossGbWeight,0)			AS initial_grossGbWeight,
            COALESCE(init.trainGbWeight,0)			AS initial_trainGbWeight,

            prov.id 								AS provisional_tech_record_id,
			prov.createdAt 							AS provisional_tech_record_createdAt,
			COALESCE(prov.grossGbWeight,0)			AS provisional_grossGbWeight,
            COALESCE(prov.trainGbWeight,0)			AS provisional_trainGbWeight,
			prov.vehicleConfiguration				AS provisional_vehicleConfiguration
	FROM	most_recent_test mrt
	JOIN	tech_records_before_test init 			ON mrt.vehicle_id = init.vehicle_id
													AND init.tech_sort_order_before_test = 2
	JOIN	tech_records_before_test prov 			ON mrt.vehicle_id = prov.vehicle_id
													AND prov.tech_sort_order_before_test = 1
),

final_dataset AS(
	SELECT 	v.vrm_trm,
			NULL AS make,
			NULL AS model,
			NULL as wheelplan,
			CASE
				WHEN provisional_vehicleConfiguration = 'rigid' THEN initial_grossGbWeight
				WHEN provisional_vehicleConfiguration = 'articulated' THEN initial_trainGbWeight
			END AS gross_weight_before_test,
			CASE
				WHEN provisional_vehicleConfiguration = 'rigid' THEN provisional_grossGbWeight
				WHEN provisional_vehicleConfiguration = 'articulated' THEN provisional_trainGbWeight
			END AS gross_weight_after_test,
			'1111' AS DOE_reference,
			NULL AS date_of_plating,
			provisional_tech_record_createdAt AS tech_record_creation_date
	FROM 	vehicle_timeline vt
	JOIN	vehicle v on vt.vehicle_id = v.id

	WHERE
			CASE
				WHEN provisional_vehicleConfiguration = 'rigid'
						AND initial_grossGbWeight <> provisional_grossGbWeight
						THEN TRUE
				WHEN provisional_vehicleConfiguration = 'articulated'
						AND initial_trainGbWeight <> provisional_trainGbWeight
						THEN TRUE
				ELSE FALSE
			END = TRUE
	order by test_result_createdAt desc
)

SELECT *
FROM final_dataset;