--liquibase formatted sql
--changeset liquibase:3 -multiple-tables:1 splitStatements:true endDelimiter:; context:dev runOnChange:true
-- Refactor to use ROW_NUMBER() OVER(PARTITION ...) ONCE MIGRATED TO MYSQL 8.0+
CREATE OR REPLACE VIEW evl_view AS 
SELECT MAX(testExpiryDate) AS testExpiryDate,
    SubQ.vrm_trm,
    t.certificateNumber
FROM test_result t
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
    AND NOT EXISTS (
        SELECT 1 FROM test_result
        WHERE t.vehicle_id = test_result.vehicle_id AND t.certificateNumber < test_result.certificateNumber
    )
    AND (testExpiryDate, vrm_trm, testTypeEndTimestamp) IN (
        SELECT DISTINCT testExpiryDate, vrm_trm, MAX(testTypeEndTimeStamp) AS testTypeEndTimeStamp
            FROM test_result tr
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
            ) SubQ ON SubQ.id = tr.vehicle_id
            WHERE (vrm_trm, testExpiryDate) IN (
                SELECT vrm_trm, MAX(t.testExpiryDate) AS testExpiryDate
                FROM test_result t
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
                GROUP BY vrm_trm
            )
        GROUP BY vrm_trm, testExpiryDate
    )    
GROUP BY SubQ.vrm_trm,
    t.certificateNumber;