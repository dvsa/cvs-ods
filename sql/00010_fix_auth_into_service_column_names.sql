--liquibase formatted sql
--changeset liquibase:modifyDataType -multiple-tables:1 splitStatements:true endDelimiter:; context:dev

ALTER TABLE auth_into_service CHANGE dateReceived dateReceived_old DATETIME;
ALTER TABLE auth_into_service CHANGE dateAuthorised dateAuthorised_old DATETIME;
ALTER TABLE auth_into_service CHANGE dateReceived_old dateAuthorised DATETIME DEFAULT NULL;
ALTER TABLE auth_into_service CHANGE dateAuthorised_old dateReceived DATETIME DEFAULT NULL;