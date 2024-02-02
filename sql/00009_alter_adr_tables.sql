--liquibase formatted sql
--changeset liquibase:modifyDataType -multiple-tables:1 splitStatements:true endDelimiter:; context:dev

/* 
    CB2-10564
    Add adr_ prefix to adr tables 
*/
RENAME TABLE    `adr`                           TO `adr_details`;
RENAME TABLE    `additional_notes_guidance`     TO `adr_additional_notes_guidance`;
RENAME TABLE    `additional_notes_number`       TO `adr_additional_notes_number`;
RENAME TABLE    `dangerous_goods`               TO `adr_dangerous_goods_list`;
RENAME TABLE    `permitted_dangerous_goods`     TO `adr_permitted_dangerous_goods`;
RENAME TABLE    `productListUnNo`               TO `adr_productListUnNo_list`;

/* 
    CB2-10566
    Add adr_id column as foreign key
*/

ALTER TABLE `adr_additional_notes_guidance`
    DROP FOREIGN KEY adr_additional_notes_guidance_ibfk_1,
    
    MODIFY COLUMN   `id` 
        BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,    
    
    ADD COLUMN      `adr_details_id`    
        BIGINT UNSIGNED NOT NULL,
    
    ADD CONSTRAINT  `fk_adr_additional_notes_guidance_adr_details_id`
        FOREIGN KEY (`adr_details_id`)                 
        REFERENCES  `adr_details`(`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION;


ALTER TABLE `adr_additional_notes_number`
	DROP FOREIGN KEY adr_additional_notes_number_ibfk_1,
    
    MODIFY COLUMN   `id` 
        BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    
    ADD COLUMN      `adr_details_id`    
        BIGINT UNSIGNED NOT NULL,
    
    ADD CONSTRAINT  `fk_adr_additional_notes_number_adr_details_id`
        FOREIGN KEY (`adr_details_id`)                 
        REFERENCES  `adr_details`(`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION;

/* 
    CB2-10568
    Fix datatype mismatches
*/

ALTER TABLE `adr_details`
    MODIFY COLUMN `adrTypeApprovalNo`       VARCHAR(40),
    MODIFY COLUMN `brakeDeclarationIssuer`  VARCHAR(500),
    MODIFY COLUMN `brakeDeclarationsSeen`   BOOLEAN,
    MODIFY COLUMN `brakeEndurance`          BOOLEAN,
    MODIFY COLUMN `compatibilityGroupJ`     VARCHAR(1),
    MODIFY COLUMN `declarationsSeen`        BOOLEAN,
    MODIFY COLUMN `listStatementApplicable` BOOLEAN,
    MODIFY COLUMN `weight`                  DOUBLE(10, 2),
    MODIFY COLUMN `tankTypeAppNo`           VARCHAR(65),
    MODIFY COLUMN `yearOfManufacture`       SMALLINT; 

ALTER TABLE `adr_productListUnNo_list`
    MODIFY COLUMN `name`                    VARCHAR(1500); 

/* 
    CB2-10569
    Create new tables
*/

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
        ON UPDATE NO ACTION
)
    ENGINE = InnoDB;

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
        ON UPDATE NO ACTION
)
    ENGINE = InnoDB;

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
        ON UPDATE NO ACTION
)
    ENGINE = InnoDB;



