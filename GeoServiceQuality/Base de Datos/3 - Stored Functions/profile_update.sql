--DROP FUNCTION profile_update();
CREATE OR REPLACE FUNCTION profile_update
(
   pProfileID INT
   , pName VARCHAR(40)
   , pGranurality VARCHAR(11) -- 'Ide', 'Institución', 'Nodo', 'Capa', 'Servicio',
   , pIsWeightedFlag BOOLEAN
)
RETURNS VOID AS $$
/************************************************************************************************************
** Name: profile_update()
**
** Desc: Actualiza datos de Perfil
**
** 04/03/2017 - Created
**
*************************************************************************************************************/
DECLARE v_wasWeightedFlag BOOLEAN;

BEGIN
   
   -- parametros requeridos
   IF (pProfileID IS NULL)
   THEN
      RAISE EXCEPTION 'Error - El parametroe ID de Perfil es requerido.';
   END IF;

   -- validación de existencia de Perfil
   IF NOT EXISTS (SELECT 1 FROM Profile p WHERE p.ProfileID = pProfileID)
   THEN
      RAISE EXCEPTION 'Error - El Perfil de ID: % no existe.', pProfileID;
   END IF;
   
   SELECT IsWeightedFlag
   FROM Profile p
   WHERE p.ProfileID = pProfileID
   INTO v_wasWeightedFlag;
   
   -- Actualizar datos de Perfil
   UPDATE Profile
   SET Name = pName
      , Granurality = pGranurality
      , IsWeightedFlag = pIsWeightedFlag
   WHERE ProfileID = pProfileID;
   
   IF (pIsWeightedFlag != v_wasWeightedFlag)
   THEN
      -- de ponderado a no ponderado
      IF (pIsWeightedFlag = FALSE)
      THEN
         DELETE
         FROM Weighing
         WHERE ProfileID = pProfileID;     
      
	  -- de no ponderado a ponderado
      ELSE
         CREATE TEMP TABLE MetricKeys
         (
            MetricID INT
         );

         INSERT INTO MetricKeys
         (MetricID)
         SELECT m.MetricID
         FROM MetricRange mr
         INNER JOIN Metric m ON m.MetricID = mr.MetricID
         WHERE mr.ProfileID = pProfileID
         GROUP BY m.MetricID;
       
         -- Carga de pesos para los rangos de metricas
         INSERT INTO Weighing
         (
           ProfileID
           , ElementID -- DimensionID, FactorID, MetricID, MetricRangeID
           , ElementType -- 'D' = Dimension, 'F' = Factor, 'M' = Metrica, 'R' = Rango
           , NumeratorValue
           , DenominatorValue
         )
         SELECT
           pProfileID
           , mr.MetricRangeID
           , 'R'
           , 0
           , NULL
         FROM MetricKeys mk
         INNER JOIN MetricRange mr ON mr.MetricID = mk.MetricID
         WHERE mr.ProfileID = pProfileID
         GROUP BY
           pProfileID
           , mr.MetricRangeID;
         
         -- Carga de pesos para las metricas
         INSERT INTO Weighing
         (
           ProfileID
           , ElementID -- DimensionID, FactorID, MetricID, MetricRangeID
           , ElementType -- 'D' = Dimension, 'F' = Factor, 'M' = Metrica, 'R' = Rango
           , NumeratorValue
           , DenominatorValue
         )
         SELECT
           pProfileID
           , m.MetricID
           , 'M'
           , 0
           , NULL
         FROM MetricKeys mk
         INNER JOIN MetricRange mr ON mr.MetricID = mk.MetricID
         INNER JOIN Metric m ON m.MetricID = mr.MetricID
         WHERE mr.ProfileID = pProfileID
         GROUP BY
           pProfileID
           , m.MetricID;

         -- Carga de pesos para los factores
         INSERT INTO Weighing
         (
           ProfileID
           , ElementID -- DimensionID, FactorID, MetricID, MetricRangeID
           , ElementType -- 'D' = Dimension, 'F' = Factor, 'M' = Metrica, 'R' = Rango
           , NumeratorValue
           , DenominatorValue
         )
         SELECT
           pProfileID
           , f.FactorID
           , 'F'
           , 0
           , NULL
         FROM MetricKeys mk
         INNER JOIN MetricRange mr ON mr.MetricID = mk.MetricID
         INNER JOIN Metric m ON m.MetricID = mr.MetricID
         INNER JOIN Factor f ON f.FactorID = m.FactorID
         WHERE mr.ProfileID = pProfileID
         GROUP BY
           pProfileID
          , f.FactorID;
          
         -- Carga de pesos para las dimensiones
         INSERT INTO Weighing
         (
           ProfileID
           , ElementID -- DimensionID, FactorID, MetricID, MetricRangeID
           , ElementType -- 'D' = Dimension, 'F' = Factor, 'M' = Metrica, 'R' = Rango
           , NumeratorValue
           , DenominatorValue
         )
         SELECT
           pProfileID
           , d.DimensionID
           , 'D'
           , 0
           , NULL
         FROM MetricKeys mk
         INNER JOIN MetricRange mr ON mr.MetricID = mk.MetricID
         INNER JOIN Metric m ON m.MetricID = mr.MetricID
         INNER JOIN Factor f ON f.FactorID = m.FactorID
         INNER JOIN Dimension d ON d.DimensionID = f.DimensionID
         WHERE mr.ProfileID = pProfileID
         GROUP BY
           pProfileID
           , d.DimensionID;       
           
         -- Carga de pesos para las dimensiones
         INSERT INTO Weighing
         (
           ProfileID
           , ElementID -- QualityModelID, DimensionID, FactorID, MetricID, MetricRangeID
           , ElementType -- 'Q' = QualityModel, 'D' = Dimension, 'F' = Factor, 'M' = Metrica, 'R' = Rango
           , NumeratorValue
           , DenominatorValue
         )
         SELECT
           pProfileID
           , q.QualityModelID
           , 'Q'
           , 0
           , NULL
         FROM MetricKeys mk
         INNER JOIN MetricRange mr ON mr.MetricID = mk.MetricID
         INNER JOIN Metric m ON m.MetricID = mr.MetricID
         INNER JOIN Factor f ON f.FactorID = m.FactorID
         INNER JOIN Dimension d ON d.DimensionID = f.DimensionID
         INNER JOIN QualityModel q ON q.QualityModelID = d.QualityModelID
         WHERE mr.ProfileID = pProfileID
         GROUP BY
           pProfileID
           , q.QualityModelID;     
      END IF;
   END IF;
    
END;
$$ LANGUAGE plpgsql;
