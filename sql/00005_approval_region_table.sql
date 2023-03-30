--liquibase formatted sql
--changeset liquibase:create -multiple-tables:1 splitStatements:true endDelimiter:; context:dev

CREATE TABLE IF NOT EXISTS `approval_region` (
  `id`                  bigint unsigned NOT NULL AUTO_INCREMENT,
  `approvalType`        varchar(50) NOT NULL,
  `approvalregion`      varchar(50) NOT NULL,
  `fromDate`            date,
  `toDate`              date,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;