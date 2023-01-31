--liquibase formatted sql
--changeset liquibase:create -multiple-tables:1 splitStatements:true endDelimiter:; context:dev
CREATE TABLE IF NOT EXISTS `testtype_version`
(
    `id`                                BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `test_result_id`                    BIGINT,
    `testCode`                          VARCHAR(3),
    `testNumber`                        VARCHAR(45),
    `certificateNumber`                 VARCHAR(9),
    `secondaryCertificateNumber`        VARCHAR(9),
    `testExpiryDate`                    DATE,
    `testAnniversaryDate`               DATE,
    `testTypeStartTimestamp`            DATETIME,
    `testTypeEndTimestamp`              DATETIME,
    `numberOfSeatbeltsFitted`           TINYINT UNSIGNED,
    `lastSeatbeltInstallationCheckDate` DATE,
    `seatbeltInstallationCheckDate`     TINYINT(1),
    `testResult`                        VARCHAR(9),
    `reasonForAbandoning`               VARCHAR(45),
    `additionalNotesRecorded`           VARCHAR(500),
    `additionalCommentsForAbandon`      VARCHAR(500),
    `particulateTrapFitted`             VARCHAR(100),
    `particulateTrapSerialNumber`       VARCHAR(100),
    `modificationTypeUsed`              VARCHAR(100),
    `smokeTestKLimitApplied`            VARCHAR(100),
    `testType_version`                  BIGINT DEFAULT 0,
    PRIMARY KEY (`id`)
)
    ENGINE = InnoDB;