--liquibase formatted sql
--changeset liquibase:1 -multiple-tables:1 endDelimiter:;
ALTER TABLE axle_spacing MODIFY axles VARCHAR(25), ALGORITHM=INPLACE, LOCK=NONE;