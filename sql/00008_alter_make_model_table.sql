--liquibase formatted sql
--changeset liquibase:modifyDataType -multiple-tables:1 splitStatements:true endDelimiter:; context:dev

ALTER TABLE make_model MODIFY make VARCHAR(50), ALGORITHM=INPLACE, LOCK=NONE;
ALTER TABLE make_model MODIFY chassisMake VARCHAR(50), ALGORITHM=INPLACE, LOCK=NONE;