--DROP FUNCTION metric_get()
CREATE OR REPLACE FUNCTION metric_get()
RETURNS TABLE 
   (
      MetricID INT
      , MetricFactorID INT	  
      , MetricName VARCHAR(100)
      , MetricAgrgegationFlag BOOLEAN
      , MetricUnitID INT
      , MetricGranurality VARCHAR(11)
      , MetricDescription VARCHAR(100)
   ) AS $$
/************************************************************************************************************
** Name: metric_get
**
** Desc: Devuelve el conunto de Metricas disponibles
**
** 08/02/2017 Created
**
*************************************************************************************************************/
BEGIN

   RETURN QUERY
   SELECT m.MetricID
      , m.FactorID	  
      , m.Name
      , m.AgrgegationFlag
      , m.UnitID
      , m.Granurality
      , m.Description
   FROM Metric m
   ORDER BY m.MetricID;
         
END;
$$ LANGUAGE plpgsql;