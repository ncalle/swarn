--DROP FUNCTION profile_remove_metric (integer, integer);
CREATE OR REPLACE FUNCTION profile_remove_metric
(
   pProfileID INT
   , pMetricID INT
)
RETURNS VOID AS $$
/************************************************************************************************************
** Name: profile_remove_metric
**
** Desc: Remueve la metrica de la lista de metricas disponibles para el perfil de ID pProfileID
**
** 04/03/2017 Created
**
*************************************************************************************************************/

BEGIN

   -- parametros requeridos
   IF (pProfileID IS NULL OR pMetricID IS NULL)
   THEN
      RAISE EXCEPTION 'Error - Los parametros ID de Perfil e ID de Metrica son requeridos.';
   END IF;
    
   -- validación de existencia de Perfil
   IF NOT EXISTS (SELECT 1 FROM Profile p WHERE p.ProfileID = pProfileID)
   THEN
      RAISE EXCEPTION 'Error - El Perfil de ID: % no existe.', pProfileID;
   END IF;

   -- validación de existencia de Metrica
   IF NOT EXISTS (SELECT 1 FROM Metric m WHERE m.MetricID = pMetricID)
   THEN
      RAISE EXCEPTION 'Error - La Metrica de ID: % no existe.', pMetricID;
   END IF;

   -- validación de Metrica asociada al Perfil
   IF NOT EXISTS (SELECT 1 FROM MetricRange mr WHERE mr.MetricID = pMetricID AND mr.ProfileID = pProfileID)
   THEN
      RAISE EXCEPTION 'Error - La Metrica de ID: % no se encuentra asociada al Perfil de ID: %.', pMetricID, pProfileID;
   END IF;
   
   DELETE FROM MetricRange
   WHERE MetricID = pMetricID
      AND ProfileID = pProfileID;

END;
$$ LANGUAGE plpgsql;