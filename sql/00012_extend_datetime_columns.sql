--liquibase formatted sql
--changeset liquibase:2 -multiple-tables:1 endDelimiter:;
ALTER TABLE vehicle
    MODIFY createdAt DATETIME(6), ALGORITHM=COPY, LOCK=SHARED;

ALTER TABLE technical_record
    MODIFY createdAt DATETIME(6),
    MODIFY lastUpdatedAt DATETIME(6), ALGORITHM=COPY, LOCK=SHARED;

ALTER TABLE test_result
    MODIFY createdAt DATETIME(6),
    MODIFY lastUpdatedAt DATETIME(6),
    MODIFY testTypeStartTimestamp DATETIME(6),
    MODIFY testTypeEndTimestamp DATETIME(6), ALGORITHM=COPY, LOCK=SHARED;