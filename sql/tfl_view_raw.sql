--liquibase formatted sql
--changeset liquibase:tfl_raw -endDelimiter:; runOnChange:true
CREATE OR REPLACE VIEW tfl_view_raw AS
SELECT CONCAT(
       v.vrm_trm,","
      ,v.vin,","
      ,tr.certificateNumber,","
      ,IFNULL(fe.modTypeCode,""),","
      ,IFNULL(fe.emissionStandard,""),","
	  ,CASE SUBSTR(tr.certificateNumber,1,2)
		WHEN 'LF' THEN '02'
		WHEN 'LP' THEN
          CASE IFNULL(fe.emissionStandard,"")
           WHEN '0.16 g/kWh Euro 3 PM' THEN '01,09,'
           WHEN '0.08 g/kWh Euro 3 PM' THEN '01,09,'
           WHEN '0.03 g/kWh Euro IV PM' THEN '01,10,'      
           WHEN '0.10 g/kWh Euro 3 PM' THEN '01,04,'
           WHEN 'Gas Euro IV PM' THEN '01,12,'
           ELSE 'UNK'
          END  
		ELSE 'UNK'
	   END,","
      ,DATE_FORMAT(tr.testTypeStartTimestamp, '%Y-%m-%d'),","
      ,IFNULL(DATE_FORMAT(tr.testExpiryDate, '%Y-%m-%d'),""),","
	  ,ts.pNumber,","
      ,DATE_FORMAT(tr.testTypeStartTimestamp, '%Y-%m-%d'))
  FROM CVSNOP.test_type tt
  JOIN CVSNOP.test_result tr
    ON (tt.id = tr.test_type_id)
  JOIN CVSNOP.vehicle v
    ON (v.id = tr.vehicle_id)
  JOIN CVSNOP.test_station ts
	ON (ts.id = tr.test_station_id)
  JOIN CVSNOP.fuel_emission fe
	ON (fe.id = tr.fuel_emission_id)
 WHERE SUBSTR(tr.certificateNumber,1,2) IN ('LP', 'LF')
   AND tt.testTypeName LIKE '%LEC%';