--liquibase formatted sql
--changeset liquibase:3 -multiple-tables:1 splitStatements:true endDelimiter:; context:dev
CREATE OR REPLACE VIEW evl_view AS
SELECT testExpiryDate, vrm_trm, certificateNumber 
FROM (
	SELECT testExpiryDate, vrm_trm, certificateNumber, IF(@prev <> vrm_trm, @rn:=0,@rn) as row_number_over_partition, @prev:=vrm_trm, @rn:=@rn+1 AS rn
	FROM ( 
		SELECT MAX(testExpiryDate) AS testExpiryDate,
			SubQ.vrm_trm,
			t.certificateNumber,
			t.testTypeEndTimeStamp
		FROM test_result as t
			JOIN test_type tt ON t.test_type_id = tt.id
			JOIN (
				SELECT MAX(createdAt),
					id,
					vrm_trm
				FROM vehicle
				WHERE LENGTH(vrm_trm) < 8
					AND vrm_trm NOT REGEXP '^[a-zA-Z][0-9]{6}$'
					AND vrm_trm NOT REGEXP '^[0-9]{6}[zZ]$'
				GROUP BY id,
					vrm_trm
			) SubQ ON SubQ.id = t.vehicle_id
		WHERE t.testExpiryDate > DATE(NOW() - INTERVAL 3 DAY)
            AND (
                t.certificateNumber IS NOT NULL
                AND t.certificateNumber != ''
                AND NOT LOCATE(' ', t.certificateNumber) > 0
            )
			AND tt.testTypeClassification = 'Annual With Certificate'
		GROUP BY SubQ.vrm_trm,
			t.certificateNumber,
			t.testTypeEndTimeStamp
		ORDER BY vrm_trm, testExpiryDate DESC, t.testTypeEndTimeStamp DESC
	) as SubQ2
) as SubQ3
WHERE row_number_over_partition = 0