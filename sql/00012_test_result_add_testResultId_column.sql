--liquibase formatted sql
--changeset liquibase:create -multiple-tables:1 splitStatements:true endDelimiter:; context:dev

ALTER TABLE test_result ADD COLUMN `testResultId` VARCHAR(44) NOT NULL, ALGORITHM=INPLACE, LOCK=NONE;