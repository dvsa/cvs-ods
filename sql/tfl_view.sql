--liquibase formatted sql
--changeset liquibase:tfl_raw -endDelimiter:; runOnChange:true
CREATE OR REPLACE VIEW tfl_view AS
SELECT 
       v.vrm_trm
      ,v.vin
      ,tr.certificateNumber
      ,IFNULL(fe.modTypeCode,"")
      ,IFNULL(fe.emissionStandard,"")
	  ,CASE SUBSTR(tr.certificateNumber,1,2)
		WHEN 'LF' THEN '02'
		WHEN 'LP' THEN
          CASE IFNULL(fe.emissionStandard,"")
           WHEN '0.16 g/kWh Euro 3 PM' THEN '01,09,' -- 'A'
           WHEN '0.08 g/kWh Euro 3 PM' THEN '01,09,' -- 'B'
           WHEN '0.03 g/kWh Euro IV PM' THEN '01,10,' -- 'D'           
           WHEN '0.10 g/kWh Euro 3 PM' THEN '01,04,' -- 'E'
           WHEN 'Gas Euro IV PM' THEN '01,12,' -- 'X'            
--           WHEN 'C' THEN '' -- 'C'           
--           WHEN 'F' THEN '' -- 'F'  
--           WHEN 'G' THEN '01,05,' -- 'G'  
--           WHEN 'H' THEN '' -- 'H'    
-- 		     WHEN '0.32 g/kWh Euro II PM' THEN '' -- 'I'   
--           WHEN 'Euro VI' THEN '' -- 'J'   
--           WHEN 'Euro 3' THEN '' -- 'M'   
--           WHEN 'Euro 4' THEN '' -- 'N'   
--           WHEN 'Euro 6' THEN '' -- 'O'   
--           WHEN 'Full Electric' THEN '' -- 'P'          
           ELSE 'UNK'
          END  
		ELSE 'UNK'
	   END
      ,DATE_FORMAT(tr.testTypeStartTimestamp, '%Y-%m-%d')
      ,DATE_FORMAT(tr.testExpiryDate, '%Y-%m-%d')
	  ,ts.pNumber
      ,DATE_FORMAT(tr.testTypeStartTimestamp, '%Y-%m-%d')
      ,tt.testTypeName
      ,tt.testTypeClassification
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
   