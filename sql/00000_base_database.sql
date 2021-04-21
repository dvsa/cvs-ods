--liquibase formatted sql
--changeset liquibase:create -multiple-tables:1 splitStatements:true endDelimiter:; context:dev

SET @OLD_UNIQUE_CHECKS = @@UNIQUE_CHECKS, UNIQUE_CHECKS = 0;
SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS = 0;
SET @OLD_SQL_MODE = @@SQL_MODE, SQL_MODE =
        'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';


CREATE TABLE IF NOT EXISTS `vehicle`
(
    `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `system_number` VARCHAR(30)  NOT NULL,
    `vin`           VARCHAR(21),
    `vrm_trm`       VARCHAR(9),
    `trailer_id`    VARCHAR(8),
    `createdAt`     DATETIME,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `idx_system_number_vin_uq` (`system_number` ASC, `vin` ASC),
    INDEX `idx_vehicle_vin` (`vin` ASC),
    INDEX `idx_vehicle_vrm_trm` (`vrm_trm` ASC),
    INDEX `idx_vehicle_trailer_id` (`trailer_id` ASC)
)
    ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `make_model`
(
    `id`                   BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `make`                 VARCHAR(30),
    `model`                VARCHAR(30),
    `chassisMake`          VARCHAR(20),
    `chassisModel`         VARCHAR(20),
    `bodyMake`             VARCHAR(20),
    `bodyModel`            VARCHAR(20),
    `modelLiteral`         VARCHAR(30),
    `bodyTypeCode`         CHAR(1),
    `bodyTypeDescription`  VARCHAR(17),
    `fuelPropulsionSystem` VARCHAR(12),
    `dtpCode`              VARCHAR(6),
    `fingerprint`          VARCHAR(32) GENERATED ALWAYS AS (md5(
            concat_ws('|', IFNULL(`make`, ''), IFNULL(`model`, ''), IFNULL(`chassisMake`, ''),
                      IFNULL(`chassisModel`, ''), IFNULL(`bodyMake`, ''), IFNULL(`bodyModel`, ''),
                      IFNULL(`modelLiteral`, ''), IFNULL(`bodyTypeCode`, ''), IFNULL(`bodyTypeDescription`, ''),
                      IFNULL(`fuelPropulsionSystem`, ''), IFNULL(`dtpCode`, '')))) STORED UNIQUE KEY NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `vehicle_class`
(
    `id`                   BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `code`                 CHAR(1),
    `description`          VARCHAR(46),
    `vehicleType`          VARCHAR(10),
    `vehicleSize`          VARCHAR(5),
    `vehicleConfiguration` VARCHAR(20),
    `euVehicleCategory`    VARCHAR(5),
    `fingerprint`          VARCHAR(32) GENERATED ALWAYS AS (md5(
            concat_ws('|', IFNULL(`code`, ''), IFNULL(`description`, ''), IFNULL(`vehicleType`, ''),
                      IFNULL(`vehicleSize`, ''), IFNULL(`vehicleConfiguration`, ''),
                      IFNULL(`euVehicleCategory`, '')))) STORED UNIQUE KEY NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `vehicle_subclass`
(
    `id`               BIGINT          NOT NULL AUTO_INCREMENT,
    `vehicle_class_id` BIGINT UNSIGNED NOT NULL,
    `subclass`         VARCHAR(1),
    `fingerprint` VARCHAR(32) GENERATED ALWAYS AS (md5(
            concat_ws('|', IFNULL(`vehicle_class_id`, ''), IFNULL(`subclass`, '')))) STORED UNIQUE KEY NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`vehicle_class_id`)
        REFERENCES `vehicle_class` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    INDEX `idx_vehicle_class_id` (`vehicle_class_id` ASC)
)
    ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `identity`
(
    `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `identityId`  VARCHAR(36),
    `name`        VARCHAR(320),
    `fingerprint` VARCHAR(32) GENERATED ALWAYS AS (md5(
            concat_ws('|', IFNULL(`identityId`, ''), IFNULL(`name`, '')))) STORED UNIQUE KEY NOT NULL,
    PRIMARY KEY (`id`),

    INDEX `idx_identity_name` (`name` ASC)
)
    ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `contact_details`
(
    `id`              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name`            VARCHAR(150),
    `address1`        VARCHAR(60),
    `address2`        VARCHAR(60),
    `postTown`        VARCHAR(60),
    `address3`        VARCHAR(60),
    `postCode`        VARCHAR(12),
    `emailAddress`    VARCHAR(255),
    `telephoneNumber` VARCHAR(25),
    `faxNumber`       VARCHAR(25),
    `fingerprint` VARCHAR(32) GENERATED ALWAYS AS (md5(
            concat_ws('|', IFNULL(`name`, ''), IFNULL(`address1`, ''), IFNULL(`address2`, ''), IFNULL(`postTown`, ''),
                      IFNULL(`address3`, ''), IFNULL(`postCode`, ''), IFNULL(`emailAddress`, ''),
                      IFNULL(`telephoneNumber`, ''), IFNULL(`faxNumber`, '')))) STORED UNIQUE KEY NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `technical_record`
(
    `id`                               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `vehicle_id`                       BIGINT UNSIGNED NOT NULL,
    `recordCompleteness`               VARCHAR(8),
    `createdAt`                        DATETIME,
    `lastUpdatedAt`                    DATETIME,
    `make_model_id`                    BIGINT UNSIGNED NOT NULL,
    `functionCode`                     CHAR(1),
    `offRoad`                          TINYINT(1),
    `numberOfWheelsDriven`             INT,
    `emissionsLimit`                   VARCHAR(45),
    `departmentalVehicleMarker`        TINYINT(1),
    `alterationMarker`                 TINYINT(1),
    `vehicle_class_id`                 BIGINT UNSIGNED NOT NULL,
    `variantVersionNumber`             VARCHAR(35),
    `grossEecWeight`                   MEDIUMINT UNSIGNED,
    `trainEecWeight`                   MEDIUMINT UNSIGNED,
    `maxTrainEecWeight`                MEDIUMINT UNSIGNED,
    `applicant_detail_id`              BIGINT UNSIGNED NOT NULL,
    `purchaser_detail_id`              BIGINT UNSIGNED NOT NULL,
    `manufacturer_detail_id`           BIGINT UNSIGNED NOT NULL,
    `manufactureYear`                  YEAR,
    `regnDate`                         DATE,
    `firstUseDate`                     DATE,
    `coifDate`                         DATE,
    `ntaNumber`                        VARCHAR(40),
    `coifSerialNumber`                 VARCHAR(8),
    `coifCertifierName`                VARCHAR(20),
    `approvalType`                     VARCHAR(3),
    `approvalTypeNumber`               VARCHAR(25),
    `variantNumber`                    VARCHAR(25),
    `conversionRefNo`                  VARCHAR(10),
    `seatsLowerDeck`                   SMALLINT UNSIGNED,
    `seatsUpperDeck`                   TINYINT UNSIGNED,
    `standingCapacity`                 SMALLINT UNSIGNED,
    `speedRestriction`                 TINYINT UNSIGNED,
    `speedLimiterMrk`                  TINYINT(1),
    `tachoExemptMrk`                   TINYINT(1),
    `dispensations`                    VARCHAR(160),
    `remarks`                          VARCHAR(1024),
    `reasonForCreation`                VARCHAR(100),
    `statusCode`                       VARCHAR(11),
    `unladenWeight`                    MEDIUMINT UNSIGNED,
    `grossKerbWeight`                  MEDIUMINT UNSIGNED,
    `grossLadenWeight`                 MEDIUMINT UNSIGNED,
    `grossGbWeight`                    MEDIUMINT UNSIGNED,
    `grossDesignWeight`                MEDIUMINT UNSIGNED,
    `trainGbWeight`                    MEDIUMINT UNSIGNED,
    `trainDesignWeight`                MEDIUMINT UNSIGNED,
    `maxTrainGbWeight`                 MEDIUMINT UNSIGNED,
    `maxTrainDesignWeight`             MEDIUMINT UNSIGNED,
    `maxLoadOnCoupling`                MEDIUMINT UNSIGNED,
    `frameDescription`                 VARCHAR(15),
    `tyreUseCode`                      VARCHAR(2),
    `roadFriendly`                     TINYINT(1),
    `drawbarCouplingFitted`            TINYINT(1),
    `euroStandard`                     VARCHAR(9),
    `suspensionType`                   CHAR(1),
    `couplingType`                     CHAR(1),
    `length`                           MEDIUMINT UNSIGNED,
    `height`                           MEDIUMINT UNSIGNED,
    `width`                            MEDIUMINT UNSIGNED,
    `frontAxleTo5thWheelMin`           MEDIUMINT UNSIGNED,
    `frontAxleTo5thWheelMax`           MEDIUMINT UNSIGNED,
    `frontAxleTo5thWheelCouplingMin`   MEDIUMINT UNSIGNED,
    `frontAxleTo5thWheelCouplingMax`   MEDIUMINT UNSIGNED,
    `frontAxleToRearAxle`              MEDIUMINT UNSIGNED,
    `rearAxleToRearTrl`                MEDIUMINT UNSIGNED,
    `couplingCenterToRearAxleMin`      MEDIUMINT UNSIGNED,
    `couplingCenterToRearAxleMax`      MEDIUMINT UNSIGNED,
    `couplingCenterToRearTrlMin`       MEDIUMINT UNSIGNED,
    `couplingCenterToRearTrlMax`       MEDIUMINT UNSIGNED,
    `centreOfRearmostAxleToRearOfTrl`  MEDIUMINT UNSIGNED,
    `notes`                            VARCHAR(800),
    `purchaserNotes`                   VARCHAR(1024),
    `manufacturerNotes`                VARCHAR(1024),
    `noOfAxles`                        TINYINT(1),
    `brakeCode`                        VARCHAR(6),
    `brakes_dtpNumber`                 VARCHAR(6),
    `brakes_loadSensingValve`          TINYINT(1),
    `brakes_antilockBrakingSystem`     TINYINT(1),
    `createdBy_Id`                     BIGINT UNSIGNED NOT NULL,
    `lastUpdatedBy_Id`                 BIGINT UNSIGNED NOT NULL,
    `updateType`                       VARCHAR(16),
    `numberOfSeatbelts`                VARCHAR(99),
    `seatbeltInstallationApprovalDate` DATE,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`vehicle_id`)
        REFERENCES `vehicle` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    FOREIGN KEY (`applicant_detail_id`)
        REFERENCES `contact_details` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    FOREIGN KEY (`purchaser_detail_id`)
        REFERENCES `contact_details` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    FOREIGN KEY (`manufacturer_detail_id`)
        REFERENCES `contact_details` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    FOREIGN KEY (`make_model_id`)
        REFERENCES `make_model` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    FOREIGN KEY (`vehicle_class_id`)
        REFERENCES `vehicle_class` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    FOREIGN KEY (`createdBy_Id`)
        REFERENCES `identity` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    FOREIGN KEY (`lastUpdatedBy_Id`)
        REFERENCES `identity` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    UNIQUE INDEX `idx_vehicle_id_createdAt_uq` (`vehicle_id` ASC, `createdAt` ASC),

    INDEX `idx_vehicle_id` (`vehicle_id` ASC),
    INDEX `idx_applicant_detail_id` (`applicant_detail_id` ASC),
    INDEX `idx_purchaser_detail_id` (`purchaser_detail_id` ASC),
    INDEX `idx_manufacturer_detail_id` (`manufacturer_detail_id` ASC),
    INDEX `idx_make_model_id` (`make_model_id` ASC),
    INDEX `idx_vehicle_class_id` (`vehicle_class_id` ASC),
    INDEX `idx_createdBy_Id` (`createdBy_Id` ASC),
    INDEX `idx_lastUpdatedBy_Id` (`lastUpdatedBy_Id` ASC)
)
    ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `psv_brakes`
(
    `id`                   BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `technical_record_id`  BIGINT UNSIGNED NOT NULL,
    `brakeCodeOriginal`    VARCHAR(3),
    `brakeCode`            VARCHAR(6),
    `dataTrBrakeOne`       VARCHAR(60),
    `dataTrBrakeTwo`       VARCHAR(60),
    `dataTrBrakeThree`     VARCHAR(60),
    `retarderBrakeOne`     VARCHAR(9),
    `retarderBrakeTwo`     VARCHAR(9),
    `serviceBrakeForceA`   MEDIUMINT UNSIGNED,
    `secondaryBrakeForceA` MEDIUMINT UNSIGNED,
    `parkingBrakeForceA`   MEDIUMINT UNSIGNED,
    `serviceBrakeForceB`   MEDIUMINT UNSIGNED,
    `secondaryBrakeForceB` MEDIUMINT UNSIGNED,
    `parkingBrakeForceB`   MEDIUMINT UNSIGNED,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`technical_record_id`)
        REFERENCES `technical_record` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    UNIQUE INDEX `idx_psv_brakes_technical_record_id_uq` (`technical_record_id` ASC)
)
    ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `axle_spacing`
(
    `id`                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `technical_record_id` BIGINT UNSIGNED NOT NULL,
    `axles`               VARCHAR(5),
    `value`               MEDIUMINT UNSIGNED,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`technical_record_id`)
        REFERENCES `technical_record` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    UNIQUE INDEX `idx_technical_record_axles_id_uq` (`technical_record_id` ASC, `axles` ASC)
)
    ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `microfilm`
(
    `id`                    BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `technical_record_id`   BIGINT UNSIGNED NOT NULL,
    `microfilmDocumentType` VARCHAR(31),
    `microfilmRollNumber`   VARCHAR(5),
    `microfilmSerialNumber` VARCHAR(4),
    PRIMARY KEY (`id`),
    FOREIGN KEY (`technical_record_id`)
        REFERENCES `technical_record` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    UNIQUE INDEX `idx_technical_record_id_uq` (`technical_record_id` ASC)
)
    ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `plate`
(
    `id`                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `technical_record_id` BIGINT UNSIGNED NOT NULL,
    `plateSerialNumber`   VARCHAR(12),
    `plateIssueDate`      DATE,
    `plateReasonForIssue` VARCHAR(16),
    `plateIssuer`         VARCHAR(150),
    PRIMARY KEY (`id`),
    FOREIGN KEY (`technical_record_id`)
        REFERENCES `technical_record` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    UNIQUE INDEX `idx_technical_record_id_plateSerialNumber_plateIssueDate_uq` (`technical_record_id` ASC,
                                                                                `plateSerialNumber` ASC,
                                                                                `plateIssueDate` ASC)
)
    ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `axles`
(
    `id`                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `technical_record_id` BIGINT UNSIGNED NOT NULL,
    `tyre_id`             BIGINT UNSIGNED NOT NULL,
    `axleNumber`          INT             NOT NULL,
    `parkingBrakeMrk`     TINYINT(1),
    `kerbWeight`          INT UNSIGNED,
    `ladenWeight`         INT UNSIGNED,
    `gbWeight`            INT UNSIGNED,
    `eecWeight`           INT UNSIGNED,
    `designWeight`        INT UNSIGNED,
    `brakeActuator`       INT UNSIGNED,
    `leverLength`         INT UNSIGNED,
    `springBrakeParking`  TINYINT(1) UNSIGNED,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`technical_record_id`)
        REFERENCES `technical_record` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    FOREIGN KEY (`tyre_id`)
        REFERENCES `tyre` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    UNIQUE INDEX `idx_technical_record_tyre_id_axleNumber_id_uq` (`technical_record_id` ASC, `tyre_id` ASC, `axleNumber` ASC),
    INDEX `idx_tyre_id` (`tyre_id` ASC)
)
    ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `tyre`
(
    `id`                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `tyreSize`            VARCHAR(12),
    `plyRating`           VARCHAR(2),
    `fitmentCode`         VARCHAR(6),
    `dataTrAxles`         VARCHAR(45),
    `speedCategorySymbol` VARCHAR(2),
    `tyreCode`            INT UNSIGNED,
    `fingerprint` VARCHAR(32) GENERATED ALWAYS AS (md5(
            concat_ws('|', IFNULL(`tyreSize`, ''), IFNULL(`plyRating`, ''), IFNULL(`fitmentCode`, ''),
                      IFNULL(`dataTrAxles`, ''), IFNULL(`speedCategorySymbol`, ''),
                      IFNULL(`tyreCode`, '')))) STORED UNIQUE KEY NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `fuel_emission`
(
    `id`               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `modTypeCode`      CHAR(1),
    `description`      VARCHAR(32),
    `emissionStandard` VARCHAR(21),
    `fuelType`         VARCHAR(13),
    `fingerprint` VARCHAR(32) GENERATED ALWAYS AS (md5(
            concat_ws('|', IFNULL(`modTypeCode`, ''), IFNULL(`description`, ''), IFNULL(`emissionStandard`, ''),
                      IFNULL(`fuelType`, '')))) STORED UNIQUE KEY NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `test_station`
(
    `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `pNumber`     VARCHAR(20),
    `name`        VARCHAR(1000),
    `type`        VARCHAR(4),
    `fingerprint` VARCHAR(32) GENERATED ALWAYS AS (md5(
            concat_ws('|', IFNULL(`pNumber`, ''), IFNULL(`name`, ''), IFNULL(`type`, '')))) STORED UNIQUE KEY NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `preparer`
(
    `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `preparerId`  VARCHAR(9),
    `name`        VARCHAR(60),
    `fingerprint` VARCHAR(32) GENERATED ALWAYS AS (md5(
            concat_ws('|', IFNULL(`preparerId`, ''), IFNULL(`name`, '')))) STORED UNIQUE KEY NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `tester`
(
    `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `staffId`       VARCHAR(9),
    `name`          VARCHAR(60),
    `email_address` VARCHAR(254),
    `fingerprint` VARCHAR(32) GENERATED ALWAYS AS (md5(concat_ws('|', IFNULL(`staffId`, ''), IFNULL(`name`, ''),
                                                                 IFNULL(`email_address`, '')))) STORED UNIQUE KEY NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `test_type`
(
    `id`                     BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `testTypeClassification` VARCHAR(23),
    `testTypeName`           VARCHAR(100),
    `fingerprint` VARCHAR(32) GENERATED ALWAYS AS (md5(concat_ws('|', IFNULL(`testTypeClassification`, ''),
                                                                 IFNULL(`testTypeName`, '')))) STORED UNIQUE KEY NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS test_result
(
    `id`                                BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `vehicle_id`                        BIGINT UNSIGNED NOT NULL,
    `fuel_emission_id`                  BIGINT UNSIGNED NOT NULL,
    `test_station_id`                   BIGINT UNSIGNED NOT NULL,
    `tester_id`                         BIGINT UNSIGNED NOT NULL,
    `preparer_id`                       BIGINT UNSIGNED NOT NULL,
    `vehicle_class_id`                  BIGINT UNSIGNED NOT NULL,
    `test_type_id`                      BIGINT UNSIGNED NOT NULL,
    `testStatus`                        VARCHAR(9),
    `reasonForCancellation`             VARCHAR(500),
    `numberOfSeats`                     INT,
    `odometerReading`                   INT UNSIGNED,
    `odometerReadingUnits`              VARCHAR(10),
    `countryOfRegistration`             VARCHAR(56),
    `noOfAxles`                         TINYINT UNSIGNED,
    `regnDate`                          DATE,
    `firstUseDate`                      DATE,
    `createdAt`                         DATETIME,
    `lastUpdatedAt`                     DATETIME,
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
    `createdBy_Id`                      BIGINT UNSIGNED NOT NULL,
    `lastUpdatedBy_Id`                  BIGINT UNSIGNED NOT NULL,

    PRIMARY KEY (`id`),
    FOREIGN KEY (`vehicle_id`)
        REFERENCES `vehicle` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    FOREIGN KEY (`fuel_emission_id`)
        REFERENCES `fuel_emission` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    FOREIGN KEY (`test_station_id`)
        REFERENCES `test_station` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    FOREIGN KEY (`tester_id`)
        REFERENCES `tester` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    FOREIGN KEY (`vehicle_class_id`)
        REFERENCES `vehicle_class` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    FOREIGN KEY (`test_type_id`)
        REFERENCES `test_type` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    FOREIGN KEY (`preparer_id`)
        REFERENCES `preparer` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    FOREIGN KEY (`createdBy_Id`)
        REFERENCES `identity` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    FOREIGN KEY (`lastUpdatedBy_Id`)
        REFERENCES `identity` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    UNIQUE INDEX `idx_comp_test_result_uq` (`vehicle_id` ASC,`test_type_id` ASC, `createdAt` ASC),

    INDEX `idx_vehicle_id` (`vehicle_id` ASC),
    INDEX `idx_test_number_id` (`testNumber` ASC),
    INDEX `idx_fuel_emission_id` (`fuel_emission_id` ASC),
    INDEX `idx_test_station_id` (`test_station_id` ASC),
    INDEX `idx_tester_id` (`tester_id` ASC),
    INDEX `idx_vehicle_class_id` (`vehicle_class_id` ASC),
    INDEX `idx_preparer_id` (`preparer_id` ASC)
)
    ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `custom_defect`
(
    `id`              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `test_result_id`  BIGINT UNSIGNED NOT NULL,
    `referenceNumber` VARCHAR(10),
    `defectName`      VARCHAR(200),
    `defectNotes`     VARCHAR(200),
    PRIMARY KEY (`id`),
    INDEX `idx_technical_record_id` (`test_result_id` ASC),

    FOREIGN KEY (`test_result_id`)
        REFERENCES test_result (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
    ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `defect`
(
    `id`                 BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `imNumber`           INT UNSIGNED,
    `imDescription`      VARCHAR(200),
    `itemNumber`         INT UNSIGNED,
    `itemDescription`    VARCHAR(200),
    `deficiencyRef`      VARCHAR(200),
    `deficiencyId`       CHAR(1),
    `deficiencySubId`    VARCHAR(7),
    `deficiencyCategory` VARCHAR(9),
    `deficiencyText`     VARCHAR(1950),
    `stdForProhibition`  TINYINT(1),
    `fingerprint` VARCHAR(32) GENERATED ALWAYS AS (md5(
            concat_ws('|', IFNULL(`imNumber`, ''), IFNULL(`imDescription`, ''), IFNULL(`itemNumber`, ''),
                      IFNULL(`itemDescription`, ''), IFNULL(`deficiencyRef`, ''), IFNULL(`deficiencyId`, ''),
                      IFNULL(`deficiencySubId`, ''), IFNULL(`deficiencyCategory`, ''), IFNULL(`deficiencyText`, ''),
                      IFNULL(`stdForProhibition`, '')))) STORED UNIQUE KEY NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `location`
(
    `id`           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `vertical`     VARCHAR(5),
    `horizontal`   VARCHAR(5),
    `lateral`      VARCHAR(8),
    `longitudinal` VARCHAR(5),
    `rowNumber`    TINYINT UNSIGNED,
    `seatNumber`   TINYINT UNSIGNED,
    `axleNumber`   TINYINT UNSIGNED,
    `fingerprint` VARCHAR(32) GENERATED ALWAYS AS (md5(
            concat_ws('|', IFNULL(`vertical`, ''), IFNULL(`horizontal`, ''), IFNULL(`lateral`, ''),
                      IFNULL(`longitudinal`, ''), IFNULL(`rowNumber`, ''), IFNULL(`seatNumber`, ''),
                      IFNULL(`axleNumber`, '')))) STORED UNIQUE KEY NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `test_defect`
(
    `id`                BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `test_result_id`    BIGINT UNSIGNED NOT NULL,
    `defect_id`         BIGINT UNSIGNED NOT NULL,
    `location_id`       BIGINT UNSIGNED NOT NULL,
    `notes`             VARCHAR(500),
    `prs`               TINYINT(1),
    `prohibitionIssued` TINYINT(1),
    PRIMARY KEY (`id`),

    FOREIGN KEY (`test_result_id`)
        REFERENCES test_result (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    FOREIGN KEY (`defect_id`)
        REFERENCES defect (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    FOREIGN KEY (`location_id`)
        REFERENCES `location` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    UNIQUE INDEX `idx_test_result_id_defect_id_location_id_uq` (`test_result_id` ASC, `defect_id` ASC, `location_id` ASC),

    INDEX `idx_defect_id` (`defect_id` ASC),
    INDEX `idx_location_id` (`location_id` ASC)
)
    ENGINE = InnoDB;


SET SQL_MODE = @OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS = @OLD_UNIQUE_CHECKS;