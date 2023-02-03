--liquibase formatted sql
--changeset liquibase:create -multiple-tables:1 splitStatements:true endDelimiter:; context:dev
DROP TRIGGER IF EXISTS check_tt_version;