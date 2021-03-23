--liquibase formatted sql
--changeset liquibase:create-multiple-functions:1 splitStatements:true dbms:mysql endDelimiter:\nGO context:dev


CREATE FUNCTION `f_upsert_additional_notes_guidance` ( in_guidanceNotes VARCHAR(25) )
    RETURNS INT DETERMINISTIC
BEGIN
    DECLARE fp_id INT UNSIGNED;
    SELECT id
    INTO fp_id
    FROM additional_notes_guidance
    WHERE fingerprint = md5(CONCAT_WS('|', in_guidanceNotes));
    IF fp_id IS NULL THEN
        INSERT INTO additional_notes_guidance ( guidanceNotes, fingerprint)
        VALUES ( in_guidanceNotes, md5(CONCAT_WS('|',  in_guidanceNotes)));
        SELECT LAST_INSERT_ID() INTO fp_id;
    END IF;
    RETURN fp_id;
END
GO
CREATE FUNCTION `f_upsert_additional_notes_number` ( in_number VARCHAR(3) )
    RETURNS INT DETERMINISTIC
BEGIN
    DECLARE fp_id INT UNSIGNED;
    SELECT id
    INTO fp_id
    FROM additional_notes_number
    WHERE fingerprint = md5(CONCAT_WS('|', in_number));
    IF fp_id IS NULL THEN
        INSERT INTO additional_notes_number ( number, fingerprint)
        VALUES ( in_number, md5(CONCAT_WS('|',  in_number)));
        SELECT LAST_INSERT_ID() INTO fp_id;
    END IF;
    RETURN fp_id;
END
GO
CREATE FUNCTION `f_upsert_dangerous_goods`(in_name VARCHAR(32))
    RETURNS INT DETERMINISTIC
BEGIN
    DECLARE fp_id INT UNSIGNED;
    SELECT id
    INTO fp_id
    FROM dangerous_goods
    WHERE fingerprint = md5(CONCAT_WS('|', in_name));
    IF fp_id IS NULL THEN
        INSERT INTO dangerous_goods (name, fingerprint)
        VALUES (in_name, md5(CONCAT_WS('|', in_name)));
        SELECT LAST_INSERT_ID() INTO fp_id;
    END IF;
    RETURN fp_id;
END
GO
CREATE FUNCTION `f_upsert_defects`(in_imNumber INT(10) UNSIGNED, in_imDescription VARCHAR(200),
                                   in_itemNumber INT(10) UNSIGNED, in_itemDescription VARCHAR(200),
                                   in_deficiencyRef VARCHAR(200), in_deficiencyId CHAR(1),
                                   in_deficiencySubId VARCHAR(7), in_deficiencyCategory VARCHAR(9),
                                   in_deficiencyText VARCHAR(1950), in_stdForProhibition TINYINT(1))
    RETURNS INT DETERMINISTIC
BEGIN
    DECLARE fp_id INT UNSIGNED;
    SELECT id
    INTO fp_id
    FROM defects
    WHERE fingerprint = md5(
            CONCAT_WS('|', in_imNumber, in_imDescription, in_itemNumber, in_itemDescription, in_deficiencyRef,
                      in_deficiencyId, in_deficiencySubId, in_deficiencyCategory, in_deficiencyText,
                      in_stdForProhibition));
    IF fp_id IS NULL THEN
        INSERT INTO defects (imNumber, imDescription, itemNumber, itemDescription, deficiencyRef, deficiencyId,
                             deficiencySubId, deficiencyCategory, deficiencyText, stdForProhibition, fingerprint)
        VALUES (in_imNumber, in_imDescription, in_itemNumber, in_itemDescription, in_deficiencyRef, in_deficiencyId,
                in_deficiencySubId, in_deficiencyCategory, in_deficiencyText, in_stdForProhibition, md5(
                        CONCAT_WS('|', in_imNumber, in_imDescription, in_itemNumber, in_itemDescription,
                                  in_deficiencyRef, in_deficiencyId, in_deficiencySubId, in_deficiencyCategory,
                                  in_deficiencyText, in_stdForProhibition)));
        SELECT LAST_INSERT_ID() INTO fp_id;
    END IF;
    RETURN fp_id;
END
GO
CREATE FUNCTION `f_upsert_fuel_emission`(in_modTypeCode CHAR(1), in_description VARCHAR(32),
                                         in_emissionStandard VARCHAR(21), in_fuelType VARCHAR(13))
    RETURNS INT DETERMINISTIC
BEGIN
    DECLARE fp_id INT UNSIGNED;
    SELECT id
    INTO fp_id
    FROM fuel_emission
    WHERE fingerprint = md5(CONCAT_WS('|', in_modTypeCode, in_description, in_emissionStandard, in_fuelType));
    IF fp_id IS NULL THEN
        INSERT INTO fuel_emission (modTypeCode, description, emissionStandard, fuelType, fingerprint)
        VALUES (in_modTypeCode, in_description, in_emissionStandard, in_fuelType,
                md5(CONCAT_WS('|', in_modTypeCode, in_description, in_emissionStandard, in_fuelType)));
        SELECT LAST_INSERT_ID() INTO fp_id;
    END IF;
    RETURN fp_id;
END
GO
CREATE FUNCTION `f_upsert_identity`(in_identityId VARCHAR(36), in_name VARCHAR(320))
    RETURNS INT DETERMINISTIC
BEGIN
    DECLARE fp_id INT UNSIGNED;
    SELECT id
    INTO fp_id
    FROM identity
    WHERE fingerprint = md5(CONCAT_WS('|', in_identityId, in_name));
    IF fp_id IS NULL THEN
        INSERT INTO identity (identityId, name, fingerprint)
        VALUES (in_identityId, in_name, md5(CONCAT_WS('|', in_identityId, in_name)));
        SELECT LAST_INSERT_ID() INTO fp_id;
    END IF;
    RETURN fp_id;
END
GO
CREATE FUNCTION `f_upsert_location`(in_vertical VARCHAR(5), in_horizontal VARCHAR(5), in_lateral VARCHAR(8),
                                    in_longitudinal VARCHAR(5), in_rowNumber TINYINT(3) UNSIGNED,
                                    in_seatNumber TINYINT(3) UNSIGNED, in_axleNumber TINYINT(3) UNSIGNED)
    RETURNS INT DETERMINISTIC
BEGIN
    DECLARE fp_id INT UNSIGNED;
    SELECT id
    INTO fp_id
    FROM location
    WHERE fingerprint = md5(
            CONCAT_WS('|', in_vertical, in_horizontal, in_lateral, in_longitudinal, in_rowNumber, in_seatNumber,
                      in_axleNumber));
    IF fp_id IS NULL THEN
        INSERT INTO location (vertical, horizontal, lateral, longitudinal, rowNumber, seatNumber, axleNumber,
                              fingerprint)
        VALUES (in_vertical, in_horizontal, in_lateral, in_longitudinal, in_rowNumber, in_seatNumber, in_axleNumber,
                md5(CONCAT_WS('|', in_vertical, in_horizontal, in_lateral, in_longitudinal, in_rowNumber, in_seatNumber,
                              in_axleNumber)));
        SELECT LAST_INSERT_ID() INTO fp_id;
    END IF;
    RETURN fp_id;
END
GO
CREATE FUNCTION `f_upsert_make_model`(in_make VARCHAR(30), in_model VARCHAR(30), in_chassisMake VARCHAR(20),
                                      in_chassisModel VARCHAR(20), in_bodyMake VARCHAR(20), in_bodyModel VARCHAR(20),
                                      in_modelLiteral VARCHAR(30), in_bodyTypeCode CHAR(1),
                                      in_bodyTypeDescription VARCHAR(17), in_fuelPropulsionSystem VARCHAR(12))
    RETURNS INT DETERMINISTIC
BEGIN
    DECLARE fp_id INT UNSIGNED;
    SELECT id
    INTO fp_id
    FROM make_model
    WHERE fingerprint = md5(
            CONCAT_WS('|', in_make, in_model, in_chassisMake, in_chassisModel, in_bodyMake, in_bodyModel,
                      in_modelLiteral, in_bodyTypeCode, in_bodyTypeDescription, in_fuelPropulsionSystem));
    IF fp_id IS NULL THEN
        INSERT INTO make_model (make, model, chassisMake, chassisModel, bodyMake, bodyModel, modelLiteral, bodyTypeCode,
                                bodyTypeDescription, fuelPropulsionSystem, fingerprint)
        VALUES (in_make, in_model, in_chassisMake, in_chassisModel, in_bodyMake, in_bodyModel, in_modelLiteral,
                in_bodyTypeCode, in_bodyTypeDescription, in_fuelPropulsionSystem, md5(
                        CONCAT_WS('|', in_make, in_model, in_chassisMake, in_chassisModel, in_bodyMake, in_bodyModel,
                                  in_modelLiteral, in_bodyTypeCode, in_bodyTypeDescription, in_fuelPropulsionSystem)));
        SELECT LAST_INSERT_ID() INTO fp_id;
    END IF;
    RETURN fp_id;
END
GO
CREATE FUNCTION `f_upsert_preparer`(in_preparerId VARCHAR(9), in_name VARCHAR(60))
    RETURNS INT DETERMINISTIC
BEGIN
    DECLARE fp_id INT UNSIGNED;
    SELECT id
    INTO fp_id
    FROM preparer
    WHERE fingerprint = md5(CONCAT_WS('|', in_preparerId, in_name));
    IF fp_id IS NULL THEN
        INSERT INTO preparer (preparerId, name, fingerprint)
        VALUES (in_preparerId, in_name, md5(CONCAT_WS('|', in_preparerId, in_name)));
        SELECT LAST_INSERT_ID() INTO fp_id;
    END IF;
    RETURN fp_id;
END
GO
CREATE FUNCTION `f_upsert_productListUnNo`(in_name VARCHAR(45))
    RETURNS INT DETERMINISTIC
BEGIN
    DECLARE fp_id INT UNSIGNED;
    SELECT id
    INTO fp_id
    FROM productListUnNo
    WHERE fingerprint = md5(CONCAT_WS('|', in_name));
    IF fp_id IS NULL THEN
        INSERT INTO productListUnNo (name, fingerprint)
        VALUES (in_name, md5(CONCAT_WS('|', in_name)));
        SELECT LAST_INSERT_ID() INTO fp_id;
    END IF;
    RETURN fp_id;
END
GO
CREATE FUNCTION `f_upsert_tester`(in_name VARCHAR(60), in_email_address VARCHAR(254))
    RETURNS INT DETERMINISTIC
BEGIN
    DECLARE fp_id INT UNSIGNED;
    SELECT id
    INTO fp_id
    FROM tester
    WHERE fingerprint = md5(CONCAT_WS('|', in_name, in_email_address));
    IF fp_id IS NULL THEN
        INSERT INTO tester (name, email_address, fingerprint)
        VALUES (in_name, in_email_address, md5(CONCAT_WS('|', in_name, in_email_address)));
        SELECT LAST_INSERT_ID() INTO fp_id;
    END IF;
    RETURN fp_id;
END
GO
CREATE FUNCTION `f_upsert_test_station`(in_pNumber VARCHAR(20), in_name VARCHAR(1000), in_type VARCHAR(4))
    RETURNS INT DETERMINISTIC
BEGIN
    DECLARE fp_id INT UNSIGNED;
    SELECT id
    INTO fp_id
    FROM test_station
    WHERE fingerprint = md5(CONCAT_WS('|', in_pNumber, in_name, in_type));
    IF fp_id IS NULL THEN
        INSERT INTO test_station (pNumber, name, type, fingerprint)
        VALUES (in_pNumber, in_name, in_type, md5(CONCAT_WS('|', in_pNumber, in_name, in_type)));
        SELECT LAST_INSERT_ID() INTO fp_id;
    END IF;
    RETURN fp_id;
END
GO
CREATE FUNCTION `f_upsert_test_type`(in_testTypeClassification VARCHAR(23), in_testTypeName VARCHAR(100))
    RETURNS INT DETERMINISTIC
BEGIN
    DECLARE fp_id INT UNSIGNED;
    SELECT id
    INTO fp_id
    FROM test_type
    WHERE fingerprint = md5(CONCAT_WS('|', in_testTypeClassification, in_testTypeName));
    IF fp_id IS NULL THEN
        INSERT INTO test_type (testTypeClassification, testTypeName, fingerprint)
        VALUES (in_testTypeClassification, in_testTypeName,
                md5(CONCAT_WS('|', in_testTypeClassification, in_testTypeName)));
        SELECT LAST_INSERT_ID() INTO fp_id;
    END IF;
    RETURN fp_id;
END
GO
CREATE FUNCTION `f_upsert_tire`(in_tyreSize VARCHAR(12), in_plyRating VARCHAR(2), in_fitmentCode VARCHAR(6),
                                in_dataTrAxles VARCHAR(45), in_speedCategorySymbol VARCHAR(2),
                                in_tyreCode INT(10) UNSIGNED)
    RETURNS INT DETERMINISTIC
BEGIN
    DECLARE fp_id INT UNSIGNED;
    SELECT id
    INTO fp_id
    FROM tire
    WHERE fingerprint = md5(
            CONCAT_WS('|', in_tyreSize, in_plyRating, in_fitmentCode, in_dataTrAxles, in_speedCategorySymbol,
                      in_tyreCode));
    IF fp_id IS NULL THEN
        INSERT INTO tire (tyreSize, plyRating, fitmentCode, dataTrAxles, speedCategorySymbol, tyreCode, fingerprint)
        VALUES (in_tyreSize, in_plyRating, in_fitmentCode, in_dataTrAxles, in_speedCategorySymbol, in_tyreCode, md5(
                CONCAT_WS('|', in_tyreSize, in_plyRating, in_fitmentCode, in_dataTrAxles, in_speedCategorySymbol,
                          in_tyreCode)));
        SELECT LAST_INSERT_ID() INTO fp_id;
    END IF;
    RETURN fp_id;
END
GO
CREATE FUNCTION `f_upsert_vehicle_class`(in_code CHAR(1), in_description VARCHAR(46), in_vehicleType VARCHAR(10),
                                         in_vehicleSize VARCHAR(5), in_vehicleConfiguration VARCHAR(20),
                                         in_euVehicleCategory VARCHAR(5))
    RETURNS INT DETERMINISTIC
BEGIN
    DECLARE fp_id INT UNSIGNED;
    SELECT id
    INTO fp_id
    FROM vehicle_class
    WHERE fingerprint = md5(
            CONCAT_WS('|', in_code, in_description, in_vehicleType, in_vehicleSize, in_vehicleConfiguration,
                      in_euVehicleCategory));
    IF fp_id IS NULL THEN
        INSERT INTO vehicle_class (code, description, vehicleType, vehicleSize, vehicleConfiguration, euVehicleCategory,
                                   fingerprint)
        VALUES (in_code, in_description, in_vehicleType, in_vehicleSize, in_vehicleConfiguration, in_euVehicleCategory,
                md5(CONCAT_WS('|', in_code, in_description, in_vehicleType, in_vehicleSize, in_vehicleConfiguration,
                              in_euVehicleCategory)));
        SELECT LAST_INSERT_ID() INTO fp_id;
    END IF;
    RETURN fp_id;
END
GO
CREATE FUNCTION `f_upsert_vehicle_subclass`(in_subclass VARCHAR(1))
    RETURNS INT DETERMINISTIC
BEGIN
    DECLARE fp_id INT UNSIGNED;
    SELECT id
    INTO fp_id
    FROM vehicle_subclass
    WHERE fingerprint = md5(CONCAT_WS('|', in_subclass));
    IF fp_id IS NULL THEN
        INSERT INTO vehicle_subclass (subclass, fingerprint)
        VALUES (in_subclass, md5(CONCAT_WS('|', in_subclass)));
        SELECT LAST_INSERT_ID() INTO fp_id;
    END IF;
    RETURN fp_id;
END
GO