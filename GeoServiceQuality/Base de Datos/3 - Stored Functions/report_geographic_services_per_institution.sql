--DROP FUNCTION report_geographic_services_per_institution();
CREATE OR REPLACE FUNCTION report_geographic_services_per_institution ()
RETURNS TABLE (InstitutionID INT, InstitutionName VARCHAR(70), GeographicServicesCount BIGINT, GeographicServicesPercentage NUMERIC) AS $$
/************************************************************************************************************
** Name: report_geographic_services_per_institution
**
** Desc: Devuelve la cantidad de servicios geograficos presentes por institucion
**
** 2017/03/09 - Created
**
*************************************************************************************************************/
DECLARE v_TotalGeographicServices BIGINT;

BEGIN
  
   SELECT COUNT(*) FROM GeographicServices gs INTO v_TotalGeographicServices;

   RETURN QUERY
   SELECT i.InstitutionID
      , i.Name
      , COUNT(gs.GeographicServicesID) AS GeographicServicesCount
      , CASE WHEN v_TotalGeographicServices = 0 THEN 0 ELSE ((COUNT(gs.GeographicServicesID) * 100.00) / v_TotalGeographicServices) END AS GeographicServicesPercentage
   FROM Institution i
   INNER JOIN Node n ON n.InstitutionID = i.InstitutionID
   INNER JOIN GeographicServices gs ON gs.NodeID = n.NodeID
   GROUP BY i.InstitutionID
      , i.Name
   ORDER BY COUNT(gs.GeographicServicesID) DESC;
               
END;
$$ LANGUAGE plpgsql;