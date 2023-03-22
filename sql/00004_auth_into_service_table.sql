--liquibase formatted sql
--changeset liquibase:create -multiple-tables:1 splitStatements:true endDelimiter:; context:dev
CREATE TABLE `auth_into_service` (
  `id`                  bigint unsigned NOT NULL AUTO_INCREMENT,
  `technical_record_id` bigint unsigned NOT NULL,
  `cocIssueDate`        datetime DEFAULT NULL,
  `dateReceived`        datetime DEFAULT NULL,
  `datePending`         datetime DEFAULT NULL,
  `dateAuthorised`      datetime DEFAULT NULL,
  `dateRejected`        datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_technical_record_auth_into_service_id_uq` (`technical_record_id`),
  CONSTRAINT `auth_into_service_ibfk_1`
    FOREIGN KEY (`technical_record_id`)
    REFERENCES `technical_record` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB