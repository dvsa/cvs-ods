--liquibase formatted sql
--changeset liquibase:create -sysbench-tables:1 splitStatements:true endDelimiter:\nGO context:dev
CREATE TABLE IF NOT EXISTS `make_model_sysbench`
(
    `id`                   INT UNSIGNED NOT NULL AUTO_INCREMENT,
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
    `fingerprint`          VARCHAR(32)  NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE = InnoDB;
GO
CREATE TABLE IF NOT EXISTS `make_model_sysbench_fg`
(
    `id`                   INT UNSIGNED NOT NULL AUTO_INCREMENT,
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
    `fingerprint`          VARCHAR(32) GENERATED ALWAYS AS (md5(concat_ws('|',make, model,chassisMake,chassisModel,bodyModel,modelLiteral,bodyTypeCode,bodyTypeDescription,fuelPropulsionSystem))) STORED UNIQUE KEY,
    PRIMARY KEY (`id`)
)
    ENGINE = InnoDB;
GO
CREATE FUNCTION `f_upsert_make_model_sysbench`(in_make VARCHAR(30), in_model VARCHAR(30), in_chassisMake VARCHAR(20),
                                      in_chassisModel VARCHAR(20), in_bodyMake VARCHAR(20), in_bodyModel VARCHAR(20),
                                      in_modelLiteral VARCHAR(30), in_bodyTypeCode CHAR(1),
                                      in_bodyTypeDescription VARCHAR(17), in_fuelPropulsionSystem VARCHAR(12), in_dtpCode VARCHAR(6))
    RETURNS INT DETERMINISTIC
BEGIN
    DECLARE fp_id INT UNSIGNED;
    SELECT id
    INTO fp_id
    FROM make_model_sysbench
    WHERE fingerprint = md5(
            CONCAT_WS('|', in_make, in_model, in_chassisMake, in_chassisModel, in_bodyMake, in_bodyModel,
                      in_modelLiteral, in_bodyTypeCode, in_bodyTypeDescription, in_fuelPropulsionSystem, in_dtpCode));
    IF fp_id IS NULL THEN
        INSERT INTO make_model_sysbench (make, model, chassisMake, chassisModel, bodyMake, bodyModel, modelLiteral, bodyTypeCode,
                                bodyTypeDescription, fuelPropulsionSystem, dtpCode, fingerprint)
        VALUES (in_make, in_model, in_chassisMake, in_chassisModel, in_bodyMake, in_bodyModel, in_modelLiteral,
                in_bodyTypeCode, in_bodyTypeDescription, in_fuelPropulsionSystem, in_dtpCode, md5(
                        CONCAT_WS('|', in_make, in_model, in_chassisMake, in_chassisModel, in_bodyMake, in_bodyModel,
                                  in_modelLiteral, in_bodyTypeCode, in_bodyTypeDescription, in_fuelPropulsionSystem, in_dtpCode)));
        SELECT LAST_INSERT_ID() INTO fp_id;
    END IF;
    RETURN fp_id;
END
GO