
CREATE VIEW evl_view AS 
    SELECT testExpiryDate, vrm_trm, certificateNumber
    FROM test_result
    LEFT JOIN vehicle_class ON vehicle_class.id=test_result.vehicle_class_id
    LEFT JOIN vehicle ON vehicle.id=test_result.vehicle_id
    WHERE (testExpiryDate != '0001-01-01');