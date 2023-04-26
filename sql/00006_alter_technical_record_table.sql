--liquibase formatted sql
--changeset liquibase:modifyDataType -multiple-tables:1 splitStatements:true endDelimiter:; context:dev

ALTER TABLE technical_record MODIFY approvalType VARCHAR(25)