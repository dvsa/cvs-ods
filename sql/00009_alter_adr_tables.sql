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
