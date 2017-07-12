--DROP FUNCTION quality_weight_tree_sctucture(integer);
CREATE OR REPLACE FUNCTION quality_weight_tree_sctucture
(
   pProfileID INT
)
RETURNS TABLE
(
   WeighingID INT
   , ProfileID INT
   , ElementID INT -- QualityModelID, DimensionID, FactorID, MetricID, MetricRangeID
   , ElementName VARCHAR(40)
   , ElementType CHAR(1) -- 'Q' = QualityModel, 'D' = Dimension, 'F' = Factor, 'M' = etrica, 'R' = Rango
   , NumeratorValue INT
   , DenominatorValue INT
   , FatherElementyID INT
) AS $$
/************************************************************************************************************
** Name: quality_weight_tree_sctucture
**
** Desc: Devuelve la estructura del modelo de calidad, asociado a las metricas correspondientes al perfil pasado por parametro
**
** 23/04/2017 - Created
**
*************************************************************************************************************/
BEGIN
   
   -- validacion de perfil
   IF (pProfileID IS NOT NULL)
      AND NOT EXISTS (SELECT 1 FROM Profile p WHERE p.ProfileID = pProfileID)
   THEN
      RAISE EXCEPTION 'Error - El Perfil seleccionado no existe.';
   END IF;
   
   RETURN QUERY
   SELECT
      w.WeighingID
	  , w.ProfileID
	  , w.ElementID
	  , qm.Name AS ElementName
	  , w.ElementType
	  , w.NumeratorValue
	  , w.DenominatorValue
	  , NULL :: INT
   FROM Weighing w
   INNER JOIN QualityModel qm ON qm.QualityModelID = w.ElementID
   WHERE w.ProfileID = pProfileID
      AND w.ElementType = 'Q'

   UNION
   
   SELECT
      w.WeighingID
	  , w.ProfileID
	  , w.ElementID
	  , d.Name AS ElementName
	  , w.ElementType
	  , w.NumeratorValue
	  , w.DenominatorValue
	  , d.QualityModelID
   FROM Weighing w
   INNER JOIN Dimension d ON d.DimensionID = w.ElementID
   WHERE w.ProfileID = pProfileID
      AND w.ElementType = 'D'

   UNION
   
   SELECT
      w.WeighingID
	  , w.ProfileID
	  , w.ElementID
	  , f.Name AS ElementName
	  , w.ElementType
	  , w.NumeratorValue
	  , w.DenominatorValue
	  , f.DimensionID
   FROM Weighing w
   INNER JOIN Factor f ON f.FactorID = w.ElementID
   WHERE w.ProfileID = pProfileID
      AND w.ElementType = 'F'

   UNION
   
   SELECT
      w.WeighingID
	  , w.ProfileID
	  , w.ElementID
	  , m.Name AS ElementName
	  , w.ElementType
	  , w.NumeratorValue
	  , w.DenominatorValue
	  , m.FactorID
   FROM Weighing w
   INNER JOIN Metric m ON m.MetricID = w.ElementID
   WHERE w.ProfileID = pProfileID
      AND w.ElementType = 'M'

   UNION
   
   SELECT
      w.WeighingID
	  , w.ProfileID
	  , w.ElementID
	  , NULL :: VARCHAR(40)
	  , w.ElementType
	  , w.NumeratorValue
	  , w.DenominatorValue
	  , mr.MetricID
   FROM Weighing w
   INNER JOIN MetricRange mr ON mr.MetricRangeID = w.ElementID
   WHERE w.ProfileID = pProfileID
      AND w.ElementType = 'R';
	  
END;
$$ LANGUAGE plpgsql;