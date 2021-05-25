--liquibase formatted sql
--changeset liquibase:2 -multiple-tables:1 endDelimiter:;
ALTER TABLE technical_record MODIFY approvalType VARCHAR(6), ALGORITHM=INPLACE, LOCK=NONE;