--liquibase formatted sql
--changeset liquibase:create -multiple-tables:1 splitStatements:true endDelimiter:; context:dev

ALTER TABLE test_result ADD  `testtype_fingerprint`  VARCHAR(32) GENERATED ALWAYS AS (md5(
            CONCAT_WS('|', IFNULL(`testCode`, ''), IFNULL(`testNumber`, ''), IFNULL(`certificateNumber`, ''), IFNULL(`secondaryCertificateNumber`, ''),
                IFNULL(`testExpiryDate`, ''), IFNULL(`testAnniversaryDate`, ''), IFNULL(`testTypeStartTimestamp`, ''), IFNULL(`testTypeEndTimestamp`, ''), 
                IFNULL(`numberOfSeatbeltsFitted`, ''), IFNULL(`lastSeatbeltInstallationCheckDate`, ''), IFNULL(`seatbeltInstallationCheckDate`, ''),
                IFNULL(`testResult`, ''), IFNULL(`reasonForAbandoning`, ''), IFNULL(`additionalNotesRecorded`, ''), IFNULL(`additionalCommentsForAbandon`, ''), 
                IFNULL(`particulateTrapFitted`, ''), IFNULL(`particulateTrapSerialNumber`, ''), IFNULL(`modificationTypeUsed`, ''),
                IFNULL(`smokeTestKLimitApplied`, '')))) STORED NOT NULL;