--liquibase formatted sql
--changeset liquibase:3 -multiple-tables:1 splitStatements:true endDelimiter:; context:dev runOnChange:true
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
GROUP BY SubQ.vrm_trm,
    t.certificateNumber;
ORDER BY vrm_trm, testExpiryDate desc, t.testTypeEndTimeStamp desc