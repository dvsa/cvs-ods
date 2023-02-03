--liquibase formatted sql
--changeset liquibase:2 -multiple-tables:1 endDelimiter:;

ALTER TABLE test_result
    MODIFY testCode VARCHAR(4), ALGORITHM=COPY, LOCK=SHARED;