CREATE VIEW evl_view AS 
    SELECT MAX(testExpiryDate), vrm_trm, certificateNumber, vehicle_class_id
    FROM test_result t
    LEFT JOIN (SELECT MAX(createdAt), id, vrm_trm 
        FROM vehicle 
        GROUP BY createdAt, id
    ) SubQ
    ON SubQ.id=t.vehicle_id
    WHERE 
        t.testExpiryDate != '0001-01-01' and 
        length(SubQ.vrm_trm) != 8 and 
        UPPER(LEFT(SubQ.vrm_trm,7)) != 'Z' and 
        (t.certificateNumber != '' or NOT LOCATE(' ', t.certificateNumber) > 0) and 
        SubQ.vrm_trm NOT REGEXP '^[a-zA-Z][0-9]{6}$'
    GROUP BY t.testExpiryDate, SubQ.vrm_trm;