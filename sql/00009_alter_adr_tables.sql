--liquibase formatted sql
--changeset liquibase:modifyDataType -multiple-tables:1 splitStatements:true endDelimiter:; context:dev


--  CHANGES TO ADR TABLE
RENAME TABLE `adr` TO `adr_details`;

ALTER TABLE `adr_details`
    MODIFY COLUMN   `adrTypeApprovalNo`         VARCHAR(40),
    MODIFY COLUMN   `brakeDeclarationIssuer`    VARCHAR(500),
    MODIFY COLUMN   `brakeDeclarationsSeen`     BOOLEAN,
    MODIFY COLUMN   `brakeEndurance`            BOOLEAN,
    MODIFY COLUMN   `compatibilityGroupJ`       VARCHAR(1),
    MODIFY COLUMN   `declarationsSeen`          BOOLEAN,
    MODIFY COLUMN   `listStatementApplicable`   BOOLEAN,
    MODIFY COLUMN   `weight`                    DOUBLE(10, 2),
    MODIFY COLUMN   `tankTypeAppNo`             VARCHAR(65),
    MODIFY COLUMN   `yearOfManufacture`         SMALLINT,

    ADD COLUMN      `m145Statement`             BOOLEAN,

    DROP COLUMN     `memosApply`,
    DROP COLUMN     `additionalExaminerNotes`,
    
    DROP INDEX      `idx_fk_technical_record_id`,
    
    ADD INDEX       `idx_adr_details_technical_record_id`   (`technical_record_id` ASC); 


--  CHANGES TO ADDITIONAL_NOTES_GUIDANCE TABLE
RENAME TABLE `additional_notes_guidance` TO `adr_additional_notes_guidance`;

ALTER TABLE `adr_additional_notes_guidance`
    DROP FOREIGN KEY `adr_additional_notes_guidance_ibfk_1`,
    
    DROP COLUMN `fingerprint`,

    MODIFY COLUMN `id`                
        BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,       
    
    ADD COLUMN `adr_details_id`    
        BIGINT UNSIGNED NOT NULL,
    
    ADD CONSTRAINT  `fk_adr_additional_notes_guidance_adr_details_id`
        FOREIGN KEY (`adr_details_id`)                 
        REFERENCES  `adr_details`(`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION;


--  CHANGES TO ADDITIONAL_NOTES_NUMBER TABLE
RENAME TABLE `additional_notes_number` TO `adr_additional_notes_number`;

ALTER TABLE `adr_additional_notes_number`
	DROP FOREIGN KEY `adr_additional_notes_number_ibfk_1`,
    
    MODIFY COLUMN   `id` 
        BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    
    ADD COLUMN      `adr_details_id`    
        BIGINT UNSIGNED NOT NULL,
    
    ADD CONSTRAINT  `fk_adr_additional_notes_number_adr_details_id`
        FOREIGN KEY (`adr_details_id`)                 
        REFERENCES  `adr_details`(`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION;


--  CHANGES TO DANGEROUS_GOODS TABLE
RENAME TABLE `dangerous_goods` TO `adr_dangerous_goods_list`;

ALTER TABLE `adr_dangerous_goods_list`
    DROP COLUMN `fingerprint`;


--  CHANGES TO PERMITTED_DANGEROUS_GOODS TABLE
RENAME TABLE `permitted_dangerous_goods` TO `adr_permitted_dangerous_goods`;

ALTER TABLE `adr_permitted_dangerous_goods`
	DROP FOREIGN KEY `adr_permitted_dangerous_goods_ibfk_1`,
    DROP FOREIGN KEY `adr_permitted_dangerous_goods_ibfk_2`,

    CHANGE COLUMN `adr_id`              `adr_details_id`                BIGINT UNSIGNED NOT NULL,
    CHANGE COLUMN `dangerous_goods_id`  `adr_dangerous_goods_list_id`   BIGINT UNSIGNED NOT NULL,
    
    ADD CONSTRAINT  `fk_adr_permitted_dangerous_goods_adr_details_id`
        FOREIGN KEY (`adr_details_id`)                 
        REFERENCES  `adr_details`(`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
        
    ADD CONSTRAINT  `fk_adr_permitted_dangerous_goods_adr_dangerous_goods_list_id`
        FOREIGN KEY (`adr_dangerous_goods_list_id`)                 
        REFERENCES  `adr_dangerous_goods_list`(`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    
    DROP INDEX  `idx_adr_id`,
    DROP INDEX  `idx_dangerous_goods_id`,

    ADD INDEX   `idx_adr_permitted_dangerous_goods_adr_details_id`
        (`adr_details_id` ASC),
    ADD INDEX   `idx_adr_permitted_dangerous_goods_adr_dangerous_goods_list_id`
        (`adr_dangerous_goods_list_id` ASC);


--  CHANGES TO PRODUCTLISTUNNO TABLE
RENAME TABLE `productListUnNo` TO `adr_productListUnNo_list`;

ALTER TABLE `adr_productListUnNo_list`
    DROP COLUMN `fingerprint`,

    MODIFY COLUMN `name` VARCHAR(1500); 


--  CHANGES TO PRODUCTLISTUNNO TABLE
ALTER TABLE `adr_productListUnNo`
	DROP FOREIGN KEY    `adr_productListUnNo_ibfk_1`,
    DROP FOREIGN KEY    `adr_productListUnNo_ibfk_2`,
          
    CHANGE COLUMN       `adr_id`              `adr_details_id`                BIGINT UNSIGNED NOT NULL,
    CHANGE COLUMN       `productListUnNo_id`  `adr_productListUnNo_list_id`   BIGINT UNSIGNED NULL,
    
    ADD CONSTRAINT  `fk_adr_productListUnNo_adr_details_id`
        FOREIGN KEY (`adr_details_id`)                 
        REFERENCES  `adr_details`(`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
        
    ADD CONSTRAINT  `fk_adr_productListUnNo_adr_productListUnNo_id`
        FOREIGN KEY (`adr_productListUnNo_list_id`)                 
        REFERENCES  `adr_productListUnNo_list`(`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    DROP INDEX `idx_adr`,
    DROP INDEX `idx_productListUnNo`,

    ADD INDEX  `idx_adr_productListUnNo_adr_details_id`
        (`adr_details_id` ASC),
    ADD INDEX  `idx_adr_productListUnNo_adr_productListUnNo_list_id`
        (`adr_productListUnNo_list_id` ASC);


--  CREATING ADR_ADDITIONAL_EXAMINER_NOTES TABLE
CREATE TABLE IF NOT EXISTS `adr_additional_examiner_notes`
(
    `id`            	BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `adr_details_id` 	BIGINT UNSIGNED NOT NULL,
    `note`				VARCHAR(1024),
    `createdAtDate`		DATE,
    `lastUpdatedBy`		VARCHAR(250),		 
    
    PRIMARY KEY (`id`),
    
    CONSTRAINT  `fk_adr_additional_examiner_notes_adr_details_id`
        FOREIGN KEY (`adr_details_id`)                 
        REFERENCES  `adr_details`(`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    
    INDEX `idx_adr_additional_examiner_notes_adr_details_id` 
        (`adr_details_id` ASC)
)
    ENGINE = InnoDB;


--  CREATING ADR_MEMOS_APPLY TABLE
CREATE TABLE IF NOT EXISTS `adr_memos_apply`
(
    `id`            	BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `adr_details_id` 	BIGINT UNSIGNED NOT NULL,
    `memo`				VARCHAR(250),		 
    
    PRIMARY KEY (`id`),
    
    CONSTRAINT  `fk_adr_memos_apply_adr_details_id`
        FOREIGN KEY (`adr_details_id`)                 
        REFERENCES  `adr_details`(`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    
    INDEX `idx_adr_memos_apply_adr_details_id` (`adr_details_id` ASC)
)
    ENGINE = InnoDB;


--  CREATING ADR_TC3DETAILS TABLE
CREATE TABLE IF NOT EXISTS `adr_tc3Details`
(
    `id`            	    BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `adr_details_id` 	    BIGINT UNSIGNED NOT NULL,
    `tc3Type`			    VARCHAR(250),
    `tc3PeriodicNumber`     VARCHAR(75),
    `tc3PeriodicExpiryDate` DATE,
    
    PRIMARY KEY (`id`),
    
    CONSTRAINT  `fk_adr_tc3Details_adr_details_id`
        FOREIGN KEY (`adr_details_id`)                 
        REFERENCES  `adr_details`(`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    
    INDEX `idx_adr_tc3Details_adr_details_id` (`adr_details_id` ASC)
)
    ENGINE = InnoDB;