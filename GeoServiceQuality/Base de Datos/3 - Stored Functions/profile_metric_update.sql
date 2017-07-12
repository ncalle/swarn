--DROP FUNCTION profile_metric_update(integer,integer,boolean,integer,integer,character);
CREATE OR REPLACE FUNCTION profile_metric_update
(
   pMetricRangeID INT
   , pBooleanAcceptanceValue BOOLEAN
   , pPercentageAcceptanceValue INT
   , pIntegerAcceptanceValue INT
   , pEnumerateAcceptanceValue CHAR(1)
)
RETURNS VOID AS $$
/************************************************************************************************************
** Name: profile_metric_update()
**
** Desc: Actualiza datos de MetricRange (metricas asociadas a un perfil)
**
** 07/03/2017 - Created
**
*************************************************************************************************************/
DECLARE v_UnitID INT;

BEGIN

   -- parametros requeridos
   IF (pMetricRangeID IS NULL)
   THEN
      RAISE EXCEPTION 'Error - El parametros ID de Rango de Metrica es requerido.';
   END IF;

   -- validación de existencia de Rango Metrica
   IF NOT EXISTS (SELECT 1 FROM MetricRange mr WHERE mr.MetricRangeID = pMetricRangeID)
   THEN
      RAISE EXCEPTION 'Error - El Rango de Metrica no es correcto';
   END IF;
   
   SELECT m.UnitID INTO v_UnitID
   FROM MetricRange mr
   INNER JOIN Metric m ON m.MetricID = mr.MetricID
   WHERE mr.MetricRangeID = pMetricRangeID;

   -- Actualizar datos de Perfil
   IF (v_UnitID = 1)  --Boleano
   THEN
      UPDATE MetricRange
      SET BooleanAcceptanceValue = pBooleanAcceptanceValue
      WHERE MetricRangeID = pMetricRangeID;
   ELSIF (v_UnitID = 2)  --Porcentaje
   THEN
      UPDATE MetricRange
      SET PercentageAcceptanceValue = pPercentageAcceptanceValue
      WHERE MetricRangeID = pMetricRangeID;
   ELSIF (v_UnitID = 3 OR v_UnitID = 5)  --Milisegundos o Entero
   THEN
      UPDATE MetricRange
      SET IntegerAcceptanceValue = pIntegerAcceptanceValue
      WHERE MetricRangeID = pMetricRangeID;
   ELSIF (v_UnitID = 4)  --Basico-Intermedio-Completo
   THEN
      UPDATE MetricRange
      SET EnumerateAcceptanceValue = pEnumerateAcceptanceValue
      WHERE MetricRangeID = pMetricRangeID;
   END IF;
   
END;
$$ LANGUAGE plpgsql;