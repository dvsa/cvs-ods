--liquibase formatted sql
--changeset liquibase:create -multiple-tables:1 splitStatements:true endDelimiter:; context:dev

ALTER TABLE test_result ADD  `testtype_fingerprint`  VARCHAR(32) GENERATED ALWAYS AS (md5(
            CONCAT_WS('|', IFNULL(`testNumber`, ''), IFNULL(`testTypeEndTimestamp`, '')))) STORED NOT NULL;