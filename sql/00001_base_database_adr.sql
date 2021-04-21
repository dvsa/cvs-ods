--liquibase formatted sql
--changeset liquibase:create -multiple-tables:1 splitStatements:true endDelimiter:; context:dev

SET @OLD_UNIQUE_CHECKS = @@UNIQUE_CHECKS, UNIQUE_CHECKS = 0;
SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS = 0;
SET @OLD_SQL_MODE = @@SQL_MODE, SQL_MODE =
        'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';


CREATE TABLE IF NOT EXISTS `adr`
(
    `id`                        BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `technical_record_id`       BIGINT UNSIGNED NOT NULL,
    `type`                      VARCHAR(45),
    `approvalDate`              DATE,
    `listStatementApplicable`   TINYINT(1),
    `batteryListNumber`         VARCHAR(8),
    `declarationsSeen`          TINYINT(1),
    `brakeDeclarationsSeen`     TINYINT(1),
    `brakeDeclarationIssuer`    TINYINT(1),
    `brakeEndurance`            TINYINT(1),
    `weight`                    VARCHAR(8),
    `compatibilityGroupJ`       TINYINT(1),
    `additionalExaminerNotes`   VARCHAR(1024),
    `applicantDetailsName`      VARCHAR(150),
    `street`                    VARCHAR(150),
    `town`                      VARCHAR(100),
    `city`                      VARCHAR(100),
    `postcode`                  VARCHAR(25),
    `memosApply`                VARCHAR(45),
    `adrTypeApprovalNo`         VARCHAR(45),
    `adrCertificateNotes`       VARCHAR(1500),
    `tankManufacturer`          VARCHAR(70),
    `yearOfManufacture`         DATE,
    `tankCode`                  VARCHAR(30),
    `specialProvisions`         VARCHAR(1024),
    `tankManufacturerSerialNo`  VARCHAR(50),
    `tankTypeAppNo`             VARCHAR(30),
    `tc2Type`                   VARCHAR(45),
    `tc2IntermediateApprovalNo` VARCHAR(70),
    `tc2IntermediateExpiryDate` DATE,
    `substancesPermitted`       VARCHAR(45),
    `statement`                 VARCHAR(1500),
    `productListRefNo`          VARCHAR(45),
    `productList`               VARCHAR(1500),
    PRIMARY KEY (`id`),

    FOREIGN KEY (`technical_record_id`)
        REFERENCES `technical_record` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    INDEX `idx_fk_technical_record_id` (`technical_record_id` ASC)
)
    ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `additional_notes_number`
(
    `id`          BIGINT UNSIGNED NOT NULL,
    `number`      VARCHAR(3)   NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`id`)
        REFERENCES `adr` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
    ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `additional_notes_guidance`
(
    `id`            BIGINT UNSIGNED NOT NULL,
    `guidanceNotes` VARCHAR(25)  NOT NULL,
    `fingerprint` VARCHAR(32) GENERATED ALWAYS AS (md5( guidanceNotes )) STORED UNIQUE KEY NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`id`)
        REFERENCES `adr` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
    ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `dangerous_goods`
(
    `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name`        VARCHAR(32),
    `fingerprint` VARCHAR(32) GENERATED ALWAYS AS (md5( name )) STORED UNIQUE KEY NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `permitted_dangerous_goods`
(
    `id`                 BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `adr_id`             BIGINT UNSIGNED NOT NULL,
    `dangerous_goods_id` BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `idx_adr_id` (`adr_id` ASC),
    INDEX `idx_dangerous_goods_id` (`dangerous_goods_id` ASC),

    FOREIGN KEY (`adr_id`)
        REFERENCES `adr` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    FOREIGN KEY (`dangerous_goods_id`)
        REFERENCES `dangerous_goods` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
    ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `productListUnNo`
(
    `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name`        VARCHAR(45),
    `fingerprint` VARCHAR(32) GENERATED ALWAYS AS (md5( name )) STORED UNIQUE KEY NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `adr_productListUnNo`
(
    `id`                 BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `adr_id`             BIGINT UNSIGNED NULL,
    `productListUnNo_id` BIGINT UNSIGNED NULL,
    PRIMARY KEY (`id`),
    INDEX `idx_productListUnNo` (`productListUnNo_id` ASC),
    INDEX `idx_adr` (`adr_id` ASC),

    FOREIGN KEY (`productListUnNo_id`)
        REFERENCES `productListUnNo` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    FOREIGN KEY (`adr_id`)
        REFERENCES `adr` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
    ENGINE = InnoDB;

SET SQL_MODE = @OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS = @OLD_UNIQUE_CHECKS;