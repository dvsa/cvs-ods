CREATE VIEW evl_view AS 
    SELECT MAX(testExpiryDate) AS testExpiryDate, vrm_trm, certificateNumber
    FROM test_result t
    LEFT JOIN (SELECT MAX(createdAt), id, vrm_trm 
        FROM vehicle 
        WHERE
            LENGTH(vrm_trm) < 8 AND 
            vrm_trm NOT REGEXP '^[0-9]{6}[zZ]$'
            GROUP BY id, vrm_trm
    ) SubQ ON SubQ.id=t.vehicle_id
    WHERE 
        t.testExpiryDate > DATE(NOW() - INTERVAL 3 DAY) AND 
        (t.certificateNumber IS NOT NULL AND 
        .certificateNumber != '' AND 
        NOT LOCATE(' ', t.certificateNumber) > 0) AND
        SubQ.vrm_trm NOT REGEXP '^[a-zA-Z][0-9]{6}$'
    GROUP BY vrm_trm, certificateNumber;