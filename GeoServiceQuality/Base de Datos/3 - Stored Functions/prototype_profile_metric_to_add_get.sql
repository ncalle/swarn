--DROP FUNCTION prototype_profile_metric_to_add_get(integer);
CREATE OR REPLACE FUNCTION prototype_profile_metric_to_add_get
(
   pProfileID INT
)
RETURNS TABLE (
   MetricID INT
   , MetricFactorID INT	  
   , MetricName VARCHAR(100)
   , MetricAgrgegationFlag BOOLEAN
   , MetricUnitID INT
   , MetricGranurality VARCHAR(11)
   , MetricDescription VARCHAR(100)
) AS $$
/************************************************************************************************************
** Name: prototype_profile_metric_to_add_get
**
** Desc: Lista las metricas que se pueden asociar al Perfil, que aun no han sido asociadas
**
** 05/03/2017 Created
**
*************************************************************************************************************/

BEGIN

   -- parametros requeridos
   IF (pProfileID IS NULL)
   THEN
      RAISE EXCEPTION 'Error - El parametro ID de Perfil es requerido.';
   END IF;
    
   -- validacion Usuario
   IF NOT EXISTS (SELECT 1 FROM Profile p WHERE p.ProfileID = pProfileID)
   THEN
      RAISE EXCEPTION 'Error - El Perfil seleccionado no es correcto.';
   END IF;
   
   -- Lista de metricas que pueden ser asociadas al Perfil
   RETURN QUERY
   SELECT m.MetricID
      , m.FactorID
      , m.Name
      , m.AgrgegationFlag
      , m.UnitID
      , m.Granurality
      , m.Description
   FROM Metric m
   LEFT JOIN MetricRange mr ON mr.MetricID = m.MetricID AND mr.ProfileID = pProfileID
   WHERE mr.MetricRangeID IS NULL
   GROUP BY m.MetricID
      , m.FactorID
      , m.Name
      , m.AgrgegationFlag
      , m.UnitID
      , m.Granurality
      , m.Description;

END;
$$ LANGUAGE plpgsql;