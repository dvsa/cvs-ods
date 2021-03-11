-- liquibase formatted sql

-- changeset liquibase:1
CREATE TABLE adr (id INT UNSIGNED AUTO_INCREMENT NOT NULL, technical_record_id INT UNSIGNED NOT NULL, type VARCHAR(45) NULL, approvalDate date NULL, listStatementApplicable BIT(1) NULL, batteryListNumber VARCHAR(8) NULL, declarationsSeen BIT(1) NULL, brakeDeclarationsSeen BIT(1) NULL, brakeDeclarationIssuer BIT(1) NULL, brakeEndurance BIT(1) NULL, weight VARCHAR(8) NULL, compatibilityGroupJ BIT(1) NULL, additionalExaminerNotes VARCHAR(1024) NULL, applicantDetailsName VARCHAR(150) NULL, street VARCHAR(150) NULL, town VARCHAR(100) NULL, city VARCHAR(100) NULL, postcode VARCHAR(25) NULL, memosApply VARCHAR(45) NULL, adrTypeApprovalNo VARCHAR(45) NULL, adrCertificateNotes VARCHAR(1500) NULL, tankManufacturer VARCHAR(70) NULL, yearOfManufacture date NULL, tankCode VARCHAR(30) NULL, specialProvisions VARCHAR(1024) NULL, tankManufacturerSerialNo VARCHAR(50) NULL, tankTypeAppNo VARCHAR(30) NULL, tc2Type VARCHAR(45) NULL, tc2IntermediateApprovalNo VARCHAR(70) NULL, tc2IntermediateExpiryDate date NULL, substancesPermitted VARCHAR(45) NULL, statement VARCHAR(1500) NULL, productListRefNo VARCHAR(45) NULL, productList VARCHAR(1500) NULL, CONSTRAINT PK_ADR PRIMARY KEY (id));

-- changeset liquibase:2
CREATE TABLE adr_productListUnNo (id INT UNSIGNED AUTO_INCREMENT NOT NULL, adr_id INT UNSIGNED NULL, productListUnNo_id INT UNSIGNED NULL, CONSTRAINT PK_ADR_PRODUCTLISTUNNO PRIMARY KEY (id));

-- changeset liquibase:3
CREATE TABLE applicant_details (id INT UNSIGNED AUTO_INCREMENT NOT NULL, name VARCHAR(150) NULL, address1 VARCHAR(60) NULL, address2 VARCHAR(60) NULL, postTown VARCHAR(60) NULL, address3 VARCHAR(60) NULL, postCode VARCHAR(12) NULL, emailAddress VARCHAR(255) NULL, telephoneNumber VARCHAR(25) NULL, fingerprint VARCHAR(32) NOT NULL, CONSTRAINT PK_APPLICANT_DETAILS PRIMARY KEY (id));

-- changeset liquibase:4
CREATE TABLE axle_spacing (id INT UNSIGNED AUTO_INCREMENT NOT NULL, technical_record_id INT UNSIGNED NULL, axles VARCHAR(199) NULL, value MEDIUMINT UNSIGNED NULL, CONSTRAINT PK_AXLE_SPACING PRIMARY KEY (id));

-- changeset liquibase:5
CREATE TABLE axles (id INT UNSIGNED AUTO_INCREMENT NOT NULL, technical_record_id INT UNSIGNED NOT NULL, axleNumber INT NOT NULL, parkingBrakeMrk BIT(1) NULL, kerbWeight INT UNSIGNED NULL, ladenWeight INT UNSIGNED NULL, gbWeight INT UNSIGNED NULL, eecWeight INT UNSIGNED NULL, designWeight INT UNSIGNED NULL, tyreSize VARCHAR(12) NULL, plyRating VARCHAR(2) NULL, fitmentCode VARCHAR(6) NULL, dataTrAxles VARCHAR(45) NULL, speedCategorySymbol VARCHAR(2) NULL, tyreCode INT UNSIGNED NULL, brakeActuator INT UNSIGNED NULL, leverLength INT UNSIGNED NULL, springBrakeParking INT UNSIGNED NULL, CONSTRAINT PK_AXLES PRIMARY KEY (id));

-- changeset liquibase:6
CREATE TABLE brakes (id INT UNSIGNED AUTO_INCREMENT NOT NULL, brakeCodeOriginal VARCHAR(3) NULL, brakeCode VARCHAR(6) NULL, dataTrBrakeOne VARCHAR(60) NULL, dataTrBrakeTwo VARCHAR(60) NULL, dataTrBrakeThree VARCHAR(60) NULL, retarderBrakeOne VARCHAR(9) NULL, retarderBrakeTwo VARCHAR(9) NULL, dtpNumber VARCHAR(6) NULL, loadSensingValve BIT(1) NULL, antilockBrakingSystem BIT(1) NULL, serviceBrakeForceA MEDIUMINT UNSIGNED NULL, secondaryBrakeForceA MEDIUMINT UNSIGNED NULL, parkingBrakeForceA MEDIUMINT UNSIGNED NULL, serviceBrakeForceB MEDIUMINT UNSIGNED NULL, secondaryBrakeForceB MEDIUMINT UNSIGNED NULL, parkingBrakeForceB MEDIUMINT UNSIGNED NULL, CONSTRAINT PK_BRAKES PRIMARY KEY (id));

-- changeset liquibase:7
CREATE TABLE custom_defect (id INT UNSIGNED AUTO_INCREMENT NOT NULL, test_record_id INT UNSIGNED NOT NULL, referenceNumber VARCHAR(10) NULL, defectName VARCHAR(200) NULL, defectNotes VARCHAR(200) NULL, CONSTRAINT PK_CUSTOM_DEFECT PRIMARY KEY (id));

-- changeset liquibase:8
CREATE TABLE dangerous_goods (id INT UNSIGNED AUTO_INCREMENT NOT NULL, name VARCHAR(32) NULL, fingerprint VARCHAR(32) NOT NULL, CONSTRAINT PK_DANGEROUS_GOODS PRIMARY KEY (id));

-- changeset liquibase:9
CREATE TABLE defects (id INT UNSIGNED AUTO_INCREMENT NOT NULL, imNumber INT UNSIGNED NULL, imDescription VARCHAR(200) NULL, itemNumber INT UNSIGNED NULL, itemDescription VARCHAR(200) NULL, deficiencyRef VARCHAR(200) NULL, deficiencyId VARCHAR(1) NULL, deficiencySubId VARCHAR(7) NULL, fingerprint VARCHAR(32) NOT NULL, CONSTRAINT PK_DEFECTS PRIMARY KEY (id));

-- changeset liquibase:10
CREATE TABLE fuel_emission (id INT UNSIGNED AUTO_INCREMENT NOT NULL, modTypeCode CHAR(1) NULL, `description` VARCHAR(32) NULL, emissionStandard VARCHAR(21) NULL, fuelType VARCHAR(13) NULL, fingerprint VARCHAR(32) NOT NULL, CONSTRAINT PK_FUEL_EMISSION PRIMARY KEY (id));

-- changeset liquibase:11
CREATE TABLE identity (id INT UNSIGNED AUTO_INCREMENT NOT NULL, identityId VARCHAR(199) NULL, name VARCHAR(199) NULL, fingerprint VARCHAR(32) NOT NULL, CONSTRAINT PK_IDENTITY PRIMARY KEY (id));

-- changeset liquibase:12
CREATE TABLE location (id INT UNSIGNED AUTO_INCREMENT NOT NULL, vertical VARCHAR(5) NULL, horizontal VARCHAR(5) NULL, lateral VARCHAR(8) NULL, longitudinal VARCHAR(5) NULL, rowNumber TINYINT(3) UNSIGNED NULL, seatNumber TINYINT(3) UNSIGNED NULL, axleNumber TINYINT(3) UNSIGNED NULL, fingerprint VARCHAR(32) NOT NULL, CONSTRAINT PK_LOCATION PRIMARY KEY (id), UNIQUE (fingerprint));

-- changeset liquibase:13
CREATE TABLE make_model (id INT UNSIGNED AUTO_INCREMENT NOT NULL, make VARCHAR(30) NULL, model VARCHAR(30) NULL, chassisMake VARCHAR(20) NULL, chassisModel VARCHAR(20) NULL, bodyMake VARCHAR(20) NULL, bodyModel VARCHAR(20) NULL, modelLiteral VARCHAR(30) NULL, bodyTypeCode VARCHAR(1) NULL, bodyTypeDescription VARCHAR(17) NULL, fuelPropulsionSystem VARCHAR(5) NULL, approvalType VARCHAR(3) NULL, approvalTypeNumber VARCHAR(25) NULL, variantNumber VARCHAR(25) NULL, fingerprint VARCHAR(32) NOT NULL, CONSTRAINT PK_MAKE_MODEL PRIMARY KEY (id), UNIQUE (fingerprint));

-- changeset liquibase:14
CREATE TABLE manufacturer_detail (id INT UNSIGNED AUTO_INCREMENT NOT NULL, name VARCHAR(150) NULL, address1 VARCHAR(60) NULL, address2 VARCHAR(60) NULL, postTown VARCHAR(60) NULL, address3 VARCHAR(60) NULL, postCode VARCHAR(12) NULL, emailAddress VARCHAR(255) NULL, telephoneNumber VARCHAR(25) NULL, faxNumber VARCHAR(25) NULL, manufacturerNotes VARCHAR(1024) NULL, fingerprint VARCHAR(32) NOT NULL, CONSTRAINT PK_MANUFACTURER_DETAIL PRIMARY KEY (id));

-- changeset liquibase:15
CREATE TABLE microfilm (id INT UNSIGNED AUTO_INCREMENT NOT NULL, technical_record_id INT UNSIGNED NULL, microfilmDocumentType VARCHAR(31) NULL, microfilmRollNumber VARCHAR(5) NULL, microfilmSerialNumber VARCHAR(4) NULL, CONSTRAINT PK_MICROFILM PRIMARY KEY (id));

-- changeset liquibase:16
CREATE TABLE permitted_dangerous_goods (id INT UNSIGNED AUTO_INCREMENT NOT NULL, adr_id INT UNSIGNED NOT NULL, dangerous_goods_id INT UNSIGNED NOT NULL, CONSTRAINT PK_PERMITTED_DANGEROUS_GOODS PRIMARY KEY (id));

-- changeset liquibase:17
CREATE TABLE plate (id INT UNSIGNED AUTO_INCREMENT NOT NULL, technical_record_id INT UNSIGNED NULL, plateSerialNumber VARCHAR(12) NULL, plateIssueDate date NULL, plateReasonForIssue VARCHAR(16) NULL, plateIssuer VARCHAR(150) NULL, CONSTRAINT PK_PLATE PRIMARY KEY (id));

-- changeset liquibase:18
CREATE TABLE preparer (id INT UNSIGNED AUTO_INCREMENT NOT NULL, preparerId VARCHAR(9) NULL, name VARCHAR(60) NULL, fingerprint VARCHAR(32) NOT NULL, CONSTRAINT PK_PREPARER PRIMARY KEY (id));

-- changeset liquibase:19
CREATE TABLE productListUnNo (id INT UNSIGNED AUTO_INCREMENT NOT NULL, name VARCHAR(45) NULL, fingerprint VARCHAR(32) NOT NULL, CONSTRAINT PK_PRODUCTLISTUNNO PRIMARY KEY (id));

-- changeset liquibase:20
CREATE TABLE purchaser_detail (id INT UNSIGNED AUTO_INCREMENT NOT NULL, name VARCHAR(150) NULL, address1 VARCHAR(60) NULL, address2 VARCHAR(60) NULL, postTown VARCHAR(60) NULL, address3 VARCHAR(60) NULL, postCode VARCHAR(12) NULL, emailAddress VARCHAR(255) NULL, telephoneNumber VARCHAR(25) NULL, faxNumber VARCHAR(25) NULL, purchaserNotes VARCHAR(1024) NULL, fingerprint VARCHAR(32) NOT NULL, CONSTRAINT PK_PURCHASER_DETAIL PRIMARY KEY (id), UNIQUE (fingerprint));

-- changeset liquibase:21
CREATE TABLE technical_record (id INT UNSIGNED AUTO_INCREMENT NOT NULL, vehicle_id INT UNSIGNED NOT NULL, recordCompleteness VARCHAR(8) NULL, createdAt datetime NULL, lastUpdatedAt datetime NULL, make_model_id INT UNSIGNED NULL, functionCode VARCHAR(1) NULL, offRoad BIT(1) NULL, numberOfWheelsDriven INT NULL, emissionsLimit VARCHAR(45) NULL, departmentalVehicleMarker BIT(1) NULL, alterationMarker BIT(1) NULL, vehicle_class_id INT UNSIGNED NULL, technical_recordcol VARCHAR(45) NULL, variantVersionNumber VARCHAR(35) NULL, grossEecWeight MEDIUMINT UNSIGNED NULL, trainEecWeight MEDIUMINT UNSIGNED NULL, maxTrainEecWeight MEDIUMINT UNSIGNED NULL, applicant_detail_id INT UNSIGNED NULL, purchaser_detail_id INT UNSIGNED NULL, manufacturer_detail_id INT UNSIGNED NULL, manufactureYear YEAR(4) NULL, regnDate date NULL, firstUseDate date NULL, coifDate date NULL, ntaNumber VARCHAR(40) NULL, coifSerialNumber VARCHAR(8) NULL, coifCertifierName VARCHAR(20) NULL, conversionRefNo VARCHAR(10) NULL, seatsLowerDeck SMALLINT UNSIGNED NULL, seatsUpperDeck TINYINT(3) UNSIGNED NULL, standingCapacity SMALLINT UNSIGNED NULL, speedRestriction TINYINT(3) UNSIGNED NULL, speedLimiterMrk BIT(1) NULL, tachoExemptMrk BIT(1) NULL, dispensations VARCHAR(160) NULL, remarks VARCHAR(1024) NULL, reasonForCreation VARCHAR(100) NULL, statusCode VARCHAR(11) NULL, unladenWeight MEDIUMINT UNSIGNED NULL, grossKerbWeight MEDIUMINT UNSIGNED NULL, grossLadenWeight MEDIUMINT UNSIGNED NULL, grossGbWeight MEDIUMINT UNSIGNED NULL, grossDesignWeight MEDIUMINT UNSIGNED NULL, trainGbWeight MEDIUMINT UNSIGNED NULL, trainDesignWeight MEDIUMINT UNSIGNED NULL, maxTrainGbWeight MEDIUMINT UNSIGNED NULL, maxTrainDesignWeight MEDIUMINT UNSIGNED NULL, maxLoadOnCoupling MEDIUMINT UNSIGNED NULL, frameDescription VARCHAR(15) NULL, tyreUseCode VARCHAR(2) NULL, roadFriendly BIT(1) NULL, drawbarCouplingFitted BIT(1) NULL, euroStandard VARCHAR(2) NULL, suspensionType VARCHAR(1) NULL, couplingType VARCHAR(1) NULL, length MEDIUMINT UNSIGNED NULL, height MEDIUMINT UNSIGNED NULL, width MEDIUMINT UNSIGNED NULL, frontAxleTo5thWheelMin MEDIUMINT UNSIGNED NULL, frontAxleTo5thWheelMax MEDIUMINT UNSIGNED NULL, frontAxleTo5thWheelCouplingMin MEDIUMINT UNSIGNED NULL, frontAxleTo5thWheelCouplingMax MEDIUMINT UNSIGNED NULL, frontAxleToRearAxle MEDIUMINT UNSIGNED NULL, rearAxleToRearTrl MEDIUMINT UNSIGNED NULL, couplingCenterToRearAxleMin MEDIUMINT UNSIGNED NULL, couplingCenterToRearAxleMax MEDIUMINT UNSIGNED NULL, couplingCenterToRearTrlMin MEDIUMINT UNSIGNED NULL, couplingCenterToRearTrlMax MEDIUMINT UNSIGNED NULL, centreOfRearmostAxleToRearOfTrl MEDIUMINT UNSIGNED NULL, notes VARCHAR(199) NULL, noOfAxles BIT(1) NULL, brakeCode VARCHAR(6) NULL, createdBy_Id INT UNSIGNED NULL, lastUpdatedBy_Id INT UNSIGNED NULL, updateType VARCHAR(16) NULL, numberOfSeatbelts VARCHAR(99) NULL, seatbeltInstallationApprovalDate date NULL, brakes_id INT UNSIGNED NULL, CONSTRAINT PK_TECHNICAL_RECORD PRIMARY KEY (id));

-- changeset liquibase:22
CREATE TABLE test_defect (id INT UNSIGNED AUTO_INCREMENT NOT NULL, test_record_id INT UNSIGNED NULL, defect_id INT UNSIGNED NULL, location_id INT UNSIGNED NULL, notes VARCHAR(500) NULL, deficiencyCategory VARCHAR(9) NULL, deficiencyText VARCHAR(45) NULL, stdForProhibition BIT(1) NULL, prs BIT(1) NULL, prohibitionIssued BIT(1) NULL, CONSTRAINT PK_TEST_DEFECT PRIMARY KEY (id));

-- changeset liquibase:23
CREATE TABLE test_record (id INT UNSIGNED AUTO_INCREMENT NOT NULL, technical_record_id INT UNSIGNED NOT NULL, vehicle_id INT UNSIGNED NOT NULL, fuel_emission_id INT UNSIGNED NULL, test_station_id INT UNSIGNED NOT NULL, tester_id INT UNSIGNED NOT NULL, preparer_id INT UNSIGNED NOT NULL, vehicle_class_id INT UNSIGNED NOT NULL, test_type_id INT UNSIGNED NOT NULL, testStatus VARCHAR(9) NULL, reasonForCancellation VARCHAR(500) NULL, numberOfSeats INT NULL, odometerReading INT UNSIGNED NULL, odometerReadingUnits VARCHAR(10) NULL, countryOfRegistration VARCHAR(56) NULL, noOfAxles TINYINT(3) UNSIGNED NULL, regnDate date NULL, firstUseDate date NULL, createdAt datetime NULL, lastUpdatedAt datetime NULL, testCode VARCHAR(3) NULL, testNumber VARCHAR(45) NULL, certificateNumber VARCHAR(45) NULL, secondaryCertificateNumber VARCHAR(199) NULL, certificateLink VARCHAR(45) NULL, testExpiryDate date NULL, testAnniversaryDate date NULL, testTypeStartTimestamp datetime NULL, testTypeEndTimestamp datetime NULL, numberOfSeatbeltsFitted TINYINT(3) UNSIGNED NULL, lastSeatbeltInstallationCheckDate date NULL, seatbeltInstallationCheckDate VARCHAR(45) NULL, testResult VARCHAR(9) NULL, reasonForAbandoning VARCHAR(45) NULL, additionalNotesRecorded VARCHAR(500) NULL, additionalCommentsForAbandon VARCHAR(500) NULL, particulateTrapFitted VARCHAR(100) NULL, particulateTrapSerialNumber VARCHAR(100) NULL, modificationTypeUsed VARCHAR(100) NULL, smokeTestKLimitApplied VARCHAR(100) NULL, createdBy_Id INT UNSIGNED NULL, lastUpdatedBy_Id INT UNSIGNED NULL, CONSTRAINT PK_TEST_RECORD PRIMARY KEY (id));

-- changeset liquibase:24
CREATE TABLE test_station (id INT UNSIGNED AUTO_INCREMENT NOT NULL, pNumber VARCHAR(20) NULL, name VARCHAR(1000) NULL, type VARCHAR(4) NULL, fingerprint VARCHAR(32) NOT NULL, CONSTRAINT PK_TEST_STATION PRIMARY KEY (id));

-- changeset liquibase:25
CREATE TABLE test_type (id INT UNSIGNED AUTO_INCREMENT NOT NULL, testTypeClassification VARCHAR(23) NULL, testTypeName VARCHAR(199) NULL, fingerprint VARCHAR(32) NOT NULL, CONSTRAINT PK_TEST_TYPE PRIMARY KEY (id), UNIQUE (fingerprint));

-- changeset liquibase:26
CREATE TABLE tester (id INT UNSIGNED AUTO_INCREMENT NOT NULL, staff_id VARCHAR(9) NULL, name VARCHAR(60) NULL, email_address VARCHAR(254) NULL, fingerprint VARCHAR(32) NOT NULL, CONSTRAINT PK_TESTER PRIMARY KEY (id));

-- changeset liquibase:27
CREATE TABLE vehicle (id INT UNSIGNED AUTO_INCREMENT NOT NULL, system_number VARCHAR(30) NOT NULL, vin VARCHAR(21) NULL, vrm_trm VARCHAR(9) NULL, trailer_id VARCHAR(8) NULL, effective_from date NOT NULL, effect_to date NULL, CONSTRAINT PK_VEHICLE PRIMARY KEY (id));

-- changeset liquibase:28
CREATE TABLE vehicle_class (id INT UNSIGNED AUTO_INCREMENT NOT NULL, code VARCHAR(1) NULL, `description` VARCHAR(46) NULL, vehicleType VARCHAR(10) NULL, vehicleSize VARCHAR(5) NULL, vehicleConfiguration VARCHAR(20) NULL, euVehicleCategory VARCHAR(5) NULL, fingerprint VARCHAR(32) NOT NULL, CONSTRAINT PK_VEHICLE_CLASS PRIMARY KEY (id));

-- changeset liquibase:29
CREATE TABLE vehicle_history (id INT UNSIGNED AUTO_INCREMENT NOT NULL, timestamp datetime NOT NULL, system_number VARCHAR(30) NOT NULL, vrm_trm VARCHAR(9) NULL, trailer_id VARCHAR(8) NULL, effective_from date NOT NULL, effect_to date NULL, CONSTRAINT PK_VEHICLE_HISTORY PRIMARY KEY (id, timestamp));

-- changeset liquibase:30
CREATE TABLE vehicle_subclass (id INT AUTO_INCREMENT NOT NULL, vehicle_class_id INT UNSIGNED NULL, subclass VARCHAR(199) NULL, fingerprint VARCHAR(32) NOT NULL, CONSTRAINT PK_VEHICLE_SUBCLASS PRIMARY KEY (id));

-- changeset liquibase:31
CREATE INDEX applicant_detail_id ON technical_record(applicant_detail_id);

-- changeset liquibase:32
CREATE INDEX brakes_id ON technical_record(brakes_id);

-- changeset liquibase:33
CREATE INDEX createdBy_Id ON test_record(createdBy_Id);

-- changeset liquibase:34
CREATE INDEX idx_adr ON adr_productListUnNo(adr_id);

-- changeset liquibase:35
CREATE INDEX idx_adr_id ON permitted_dangerous_goods(adr_id);

-- changeset liquibase:36
CREATE INDEX idx_createdBy_Id ON technical_record(createdBy_Id);

-- changeset liquibase:37
CREATE INDEX idx_dangerous_goods_id ON permitted_dangerous_goods(dangerous_goods_id);

-- changeset liquibase:38
CREATE INDEX idx_defect_id ON test_defect(defect_id);

-- changeset liquibase:39
CREATE UNIQUE INDEX idx_fingerprint_uq ON applicant_details(fingerprint);

-- changeset liquibase:40
CREATE UNIQUE INDEX idx_fingerprint_uq ON defects(fingerprint);

-- changeset liquibase:41
CREATE UNIQUE INDEX idx_fingerprint_uq ON fuel_emission(fingerprint);

-- changeset liquibase:42
CREATE UNIQUE INDEX idx_fingerprint_uq ON identity(fingerprint);

-- changeset liquibase:43
CREATE UNIQUE INDEX idx_fingerprint_uq ON manufacturer_detail(fingerprint);

-- changeset liquibase:44
CREATE UNIQUE INDEX idx_fingerprint_uq ON preparer(fingerprint);

-- changeset liquibase:45
CREATE UNIQUE INDEX idx_fingerprint_uq ON productListUnNo(fingerprint);

-- changeset liquibase:46
CREATE UNIQUE INDEX idx_fingerprint_uq ON tester(fingerprint);

-- changeset liquibase:47
CREATE UNIQUE INDEX idx_fingerprint_uq ON vehicle_class(fingerprint);

-- changeset liquibase:48
CREATE UNIQUE INDEX idx_fingerprint_uq ON vehicle_subclass(fingerprint);

-- changeset liquibase:49
CREATE INDEX idx_fk_technical_record_id ON adr(technical_record_id);

-- changeset liquibase:50
CREATE INDEX idx_fuel_emission_id ON test_record(fuel_emission_id);

-- changeset liquibase:51
CREATE INDEX idx_lastUpdatedBy_Id ON technical_record(lastUpdatedBy_Id);

-- changeset liquibase:52
CREATE INDEX idx_location_id ON test_defect(location_id);

-- changeset liquibase:53
CREATE INDEX idx_make_model_id ON technical_record(make_model_id);

-- changeset liquibase:54
CREATE INDEX idx_name ON identity(name);

-- changeset liquibase:55
CREATE INDEX idx_preparer_id ON test_record(preparer_id);

-- changeset liquibase:56
CREATE INDEX idx_productListUnNo ON adr_productListUnNo(productListUnNo_id);

-- changeset liquibase:57
CREATE UNIQUE INDEX idx_system_number_uq ON vehicle(system_number);

-- changeset liquibase:58
CREATE UNIQUE INDEX idx_system_number_uq ON vehicle_history(system_number);

-- changeset liquibase:59
CREATE INDEX idx_technical_record_id ON axle_spacing(technical_record_id);

-- changeset liquibase:60
CREATE INDEX idx_technical_record_id ON axles(technical_record_id);

-- changeset liquibase:61
CREATE INDEX idx_technical_record_id ON custom_defect(test_record_id);

-- changeset liquibase:62
CREATE INDEX idx_technical_record_id ON microfilm(technical_record_id);

-- changeset liquibase:63
CREATE INDEX idx_technical_record_id ON plate(technical_record_id);

-- changeset liquibase:64
CREATE INDEX idx_technical_record_id ON test_record(technical_record_id);

-- changeset liquibase:65
CREATE INDEX idx_test_record_id ON test_defect(test_record_id);

-- changeset liquibase:66
CREATE INDEX idx_test_station_id ON test_record(test_station_id);

-- changeset liquibase:67
CREATE INDEX idx_tester_id ON test_record(tester_id);

-- changeset liquibase:68
CREATE INDEX idx_vehicle_class_id ON technical_record(vehicle_class_id);

-- changeset liquibase:69
CREATE INDEX idx_vehicle_class_id ON test_record(vehicle_class_id);

-- changeset liquibase:70
CREATE INDEX idx_vehicle_id ON technical_record(vehicle_id);

-- changeset liquibase:71
CREATE INDEX idx_vehicle_id ON test_record(vehicle_id);

-- changeset liquibase:72
CREATE INDEX lastUpdatedBy_Id ON test_record(lastUpdatedBy_Id);

-- changeset liquibase:73
CREATE INDEX manufacturer_detail_id ON technical_record(manufacturer_detail_id);

-- changeset liquibase:74
CREATE INDEX purchaser_detail_id ON technical_record(purchaser_detail_id);

-- changeset liquibase:75
CREATE INDEX test_type_id ON test_record(test_type_id);

-- changeset liquibase:76
CREATE INDEX vehicle_class_id ON vehicle_subclass(vehicle_class_id);

-- changeset liquibase:77
ALTER TABLE adr ADD CONSTRAINT adr_ibfk_1 FOREIGN KEY (technical_record_id) REFERENCES technical_record (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:78
ALTER TABLE adr_productListUnNo ADD CONSTRAINT adr_productListUnNo_ibfk_1 FOREIGN KEY (productListUnNo_id) REFERENCES productListUnNo (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:79
ALTER TABLE adr_productListUnNo ADD CONSTRAINT adr_productListUnNo_ibfk_2 FOREIGN KEY (adr_id) REFERENCES adr (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:80
ALTER TABLE axle_spacing ADD CONSTRAINT axle_spacing_ibfk_1 FOREIGN KEY (technical_record_id) REFERENCES technical_record (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:81
ALTER TABLE axles ADD CONSTRAINT axles_ibfk_1 FOREIGN KEY (technical_record_id) REFERENCES technical_record (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:82
ALTER TABLE custom_defect ADD CONSTRAINT custom_defect_ibfk_1 FOREIGN KEY (test_record_id) REFERENCES test_record (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:83
ALTER TABLE microfilm ADD CONSTRAINT microfilm_ibfk_1 FOREIGN KEY (technical_record_id) REFERENCES technical_record (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:84
ALTER TABLE permitted_dangerous_goods ADD CONSTRAINT permitted_dangerous_goods_ibfk_1 FOREIGN KEY (adr_id) REFERENCES adr (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:85
ALTER TABLE permitted_dangerous_goods ADD CONSTRAINT permitted_dangerous_goods_ibfk_2 FOREIGN KEY (dangerous_goods_id) REFERENCES dangerous_goods (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:86
ALTER TABLE plate ADD CONSTRAINT plate_ibfk_1 FOREIGN KEY (technical_record_id) REFERENCES technical_record (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:87
ALTER TABLE technical_record ADD CONSTRAINT technical_record_ibfk_1 FOREIGN KEY (vehicle_id) REFERENCES vehicle (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:88
ALTER TABLE technical_record ADD CONSTRAINT technical_record_ibfk_2 FOREIGN KEY (applicant_detail_id) REFERENCES applicant_details (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:89
ALTER TABLE technical_record ADD CONSTRAINT technical_record_ibfk_3 FOREIGN KEY (purchaser_detail_id) REFERENCES purchaser_detail (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:90
ALTER TABLE technical_record ADD CONSTRAINT technical_record_ibfk_4 FOREIGN KEY (manufacturer_detail_id) REFERENCES manufacturer_detail (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:91
ALTER TABLE technical_record ADD CONSTRAINT technical_record_ibfk_5 FOREIGN KEY (make_model_id) REFERENCES make_model (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:92
ALTER TABLE technical_record ADD CONSTRAINT technical_record_ibfk_6 FOREIGN KEY (vehicle_class_id) REFERENCES vehicle_class (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:93
ALTER TABLE technical_record ADD CONSTRAINT technical_record_ibfk_7 FOREIGN KEY (createdBy_Id) REFERENCES identity (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:94
ALTER TABLE technical_record ADD CONSTRAINT technical_record_ibfk_8 FOREIGN KEY (lastUpdatedBy_Id) REFERENCES identity (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:95
ALTER TABLE technical_record ADD CONSTRAINT technical_record_ibfk_9 FOREIGN KEY (brakes_id) REFERENCES brakes (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:96
ALTER TABLE test_defect ADD CONSTRAINT test_defect_ibfk_1 FOREIGN KEY (test_record_id) REFERENCES test_record (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:97
ALTER TABLE test_defect ADD CONSTRAINT test_defect_ibfk_2 FOREIGN KEY (defect_id) REFERENCES defects (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:98
ALTER TABLE test_defect ADD CONSTRAINT test_defect_ibfk_3 FOREIGN KEY (location_id) REFERENCES location (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:99
ALTER TABLE test_record ADD CONSTRAINT test_record_ibfk_1 FOREIGN KEY (technical_record_id) REFERENCES technical_record (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:100
ALTER TABLE test_record ADD CONSTRAINT test_record_ibfk_10 FOREIGN KEY (lastUpdatedBy_Id) REFERENCES identity (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:101
ALTER TABLE test_record ADD CONSTRAINT test_record_ibfk_2 FOREIGN KEY (vehicle_id) REFERENCES vehicle (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:102
ALTER TABLE test_record ADD CONSTRAINT test_record_ibfk_3 FOREIGN KEY (fuel_emission_id) REFERENCES fuel_emission (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:103
ALTER TABLE test_record ADD CONSTRAINT test_record_ibfk_4 FOREIGN KEY (test_station_id) REFERENCES test_station (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:104
ALTER TABLE test_record ADD CONSTRAINT test_record_ibfk_5 FOREIGN KEY (tester_id) REFERENCES tester (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:105
ALTER TABLE test_record ADD CONSTRAINT test_record_ibfk_6 FOREIGN KEY (vehicle_class_id) REFERENCES vehicle_class (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:106
ALTER TABLE test_record ADD CONSTRAINT test_record_ibfk_7 FOREIGN KEY (test_type_id) REFERENCES test_type (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:107
ALTER TABLE test_record ADD CONSTRAINT test_record_ibfk_8 FOREIGN KEY (preparer_id) REFERENCES preparer (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:108
ALTER TABLE test_record ADD CONSTRAINT test_record_ibfk_9 FOREIGN KEY (createdBy_Id) REFERENCES identity (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:109
ALTER TABLE vehicle_history ADD CONSTRAINT vehicle_history_ibfk_1 FOREIGN KEY (id) REFERENCES vehicle (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- changeset liquibase:110
ALTER TABLE vehicle_subclass ADD CONSTRAINT vehicle_subclass_ibfk_1 FOREIGN KEY (vehicle_class_id) REFERENCES vehicle_class (id) ON UPDATE RESTRICT ON DELETE RESTRICT;