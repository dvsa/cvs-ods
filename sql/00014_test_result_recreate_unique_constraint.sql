--liquibase formatted sql
--changeset liquibase:create -multiple-tables:1 splitStatements:true endDelimiter:; context:dev
ALTER TABLE `test_result` DROP INDEX `idx_comp_test_result_uq`;
ALTER TABLE `test_result` ADD UNIQUE `idx_comp_test_result_uq` (`vehicle_id`, `testResultId`, `fuel_emission_id`, `testtype_fingerprint`);