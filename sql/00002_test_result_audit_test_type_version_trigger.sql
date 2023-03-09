--liquibase formatted sql
--changeset liquibase:create -multiple-tables:1 splitStatements:true endDelimiter:// context:dev
CREATE TRIGGER check_tt_version_delete AFTER DELETE ON `test_result`
    FOR EACH ROW
    BEGIN
        INSERT INTO `testtype_version`
            (`test_result_id`, `vehicle_id`, `fuel_emission_id`, `test_station_id`, 
            `tester_id`, `preparer_id`, `vehicle_class_id`, `test_type_id`, `testStatus`, 
            `testResultId`, `reasonForCancellation`, `numberOfSeats`, `odometerReading`, 
            `odometerReadingUnits`, `countryOfRegistration`, `noOfAxles`, 
            `regnDate`, `firstUseDate`, `createdAt`, `lastUpdatedAt`,
            `testCode`, `testNumber`, `certificateNumber`, 
            `secondaryCertificateNumber`, `testExpiryDate`, `testAnniversaryDate`, 
            `testTypeStartTimestamp`, `testTypeEndTimestamp`, `numberOfSeatbeltsFitted`, 
            `lastSeatbeltInstallationCheckDate`, `seatbeltInstallationCheckDate`, 
            `testResult`, `reasonForAbandoning`, `additionalNotesRecorded`, 
            `additionalCommentsForAbandon`, `particulateTrapFitted`, 
            `particulateTrapSerialNumber`, `modificationTypeUsed`, 
            `smokeTestKLimitApplied`, `nopInsertedAt`, `triggerType`)
        VALUES
            ( OLD.`id`, OLD.`vehicle_id`, OLD.`fuel_emission_id`,
            OLD.`test_station_id`, OLD.`tester_id`, OLD.`preparer_id`, OLD.`vehicle_class_id`,
            OLD.`test_type_id`, OLD.`testStatus`, OLD.`testResultId`,
            OLD.`reasonForCancellation`, OLD.`numberOfSeats`, OLD.`odometerReading`, 
            OLD.`odometerReadingUnits`, OLD.`countryOfRegistration`, OLD.`noOfAxles`, 
            OLD.`regnDate`, OLD.`firstUseDate`, OLD.`createdAt`, OLD.`lastUpdatedAt`,
            OLD.`testCode`, OLD.`testNumber`, OLD.`certificateNumber`, 
            OLD.`secondaryCertificateNumber`, OLD.`testExpiryDate`, OLD.`testAnniversaryDate`, 
            OLD.`testTypeStartTimestamp`, OLD.`testTypeEndTimestamp`, OLD.`numberOfSeatbeltsFitted`, 
            OLD.`lastSeatbeltInstallationCheckDate`, OLD.`seatbeltInstallationCheckDate`, 
            OLD.`testResult`, OLD.`reasonForAbandoning`, OLD.`additionalNotesRecorded`, 
            OLD.`additionalCommentsForAbandon`, OLD.`particulateTrapFitted`, 
            OLD.`particulateTrapSerialNumber`, OLD.`modificationTypeUsed`, 
            OLD.`smokeTestKLimitApplied`, OLD.`nopInsertedAt`, 'DELETE');
    END;