--liquibase formatted sql
--changeset liquibase:create -multiple-tables:1 splitStatements:true endDelimiter:; context:dev

SET @OLD_UNIQUE_CHECKS = @@UNIQUE_CHECKS, UNIQUE_CHECKS = 0;
SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS = 0;
SET @OLD_SQL_MODE = @@SQL_MODE, SQL_MODE =
        'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';


CREATE TABLE IF NOT EXISTS `activity`
(
    `id`              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `test_station_id` BIGINT UNSIGNED NOT NULL,
    `tester_id`       BIGINT UNSIGNED NOT NULL,
    `activityId`      VARCHAR(36),
    `parentId`        VARCHAR(36),
    `activityType`    VARCHAR(18),
    `startTime`       DATETIME,
    `endTime`         DATETIME,
    `notes`           VARCHAR(500),
    PRIMARY KEY (`id`),

    FOREIGN KEY (`test_station_id`)
        REFERENCES `test_station` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    FOREIGN KEY (`tester_id`)
        REFERENCES `tester` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    INDEX `idx_test_station_id` (`test_station_id` ASC),
    INDEX `idx_tester_id` (`tester_id` ASC),
    INDEX `idx_activityId` (`activityId` ASC),
    INDEX `idx_parentId` (`parentId` ASC)
)
    ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `wait_reason`
(
    `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `activity_id` BIGINT UNSIGNED NOT NULL,
    `reason`      VARCHAR(19),
    PRIMARY KEY (`id`),
    FOREIGN KEY (`activity_id`)
        REFERENCES `activity` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    INDEX `idx_activity_id` (`activity_id` ASC)
)
    ENGINE = InnoDB;


SET SQL_MODE = @OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS = @OLD_UNIQUE_CHECKS;