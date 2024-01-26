--liquibase formatted sql
--changeset liquibase:modifyDataType -multiple-tables:1 splitStatements:true endDelimiter:; context:dev

/* 
    CB2-10564
    Add tables for new dynamo fields
*/
RENAME TABLE    `adr`                           TO `adr_details`;
RENAME TABLE    `additional_notes_guidance`     TO `adr_additional_notes_guidance`;
RENAME TABLE    `additional_notes_number`       TO `adr_additional_notes_number`;
RENAME TABLE    `dangerous_goods`               TO `adr_dangerous_goods_list`;
RENAME TABLE    `permitted_dangerous_goods`     TO `adr_permitted_dangerous_goods`;
RENAME TABLE    `productListUnNo`               TO `adr_productListUnNo_list`;