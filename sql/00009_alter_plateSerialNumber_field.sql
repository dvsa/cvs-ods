--liquibase formatted sql
--changeset liquibase:modifyDataType -multiple-tables:1 splitStatements:true endDelimiter:; context:dev

ALTER TABLE plate MODIFY plateSerialNumber VARCHAR(50), ALGORITHM=INPLACE, LOCK=NONE;
