--DROP FUNCTION profile_insert (character varying, character varying, boolean, text);
CREATE OR REPLACE FUNCTION profile_insert
(
   pName VARCHAR(40)
   , pGranurality VARCHAR(11)
   , pIsWeightedFlag BOOLEAN
   , pMetricKeys TEXT -- Lista de enteros separada por coma, que representa los IDs de las metricas
)
RETURNS VOID AS $$
/************************************************************************************************************
** Name: profile_insert
**
** Desc: se agrega un Perfil a la lista de perfiles disponibles, al que se le asocian las metricas pasadas por parametros con los Rangos
**
** 10/12/2016 Created
**
*************************************************************************************************************/
DECLARE LastProfileID INT;

BEGIN
    
   -- parametros requeridos
   IF (pName IS NULL OR pGranurality IS NULL OR pIsWeightedFlag IS NULL)
   THEN
      RAISE EXCEPTION 'Error - Los parametros nombre de perfil, granularidad y ponderación son requeridos.';
   END IF;
    
   -- validacion
   IF (pMetricKeys IS NULL)
   THEN
      RAISE EXCEPTION 'Error - La lista de Metricas no puede ser vacia.';
   END IF;

   
   CREATE TEMP TABLE MetricKeys
   (
      MetricID INT
   );

   INSERT INTO MetricKeys
   (MetricID)
   SELECT CAST(regexp_split_to_table(pMetricKeys, E',') AS INT);
      
   -- Ingreso de Perfil
   INSERT INTO Profile
   (Name, Granurality, IsWeightedFlag)
   VALUES
   (pName, pGranurality, pIsWeightedFlag)
      RETURNING ProfileID INTO LastProfileID;
    
    -- Insert de Rangos asociados a las Metricas y Perfil
    
   -- Metricas boleanas
   INSERT INTO MetricRange
   (
      MetricID
      , ProfileID
      , BooleanFlag
      , BooleanAcceptanceValue
      , PercentageFlag
      , PercentageAcceptanceValue
      , IntegerFlag
      , IntegerAcceptanceValue
      , EnumerateFlag
      , EnumerateAcceptanceValue
   )
   SELECT 
      m.MetricID
      , LastProfileID
      , TRUE --Boleano
      , TRUE --Por defecto en TRUE
      , FALSE
      , NULL
      , FALSE
      , NULL
      , FALSE
      , NULL
   FROM Metric m
   WHERE m.MetricID IN (SELECT mb.MetricID FROM MetricKeys mb)
      AND m.UnitID = 1; --Boleano

   -- Metricas Porcentaje
   INSERT INTO MetricRange
   (
      MetricID
      , ProfileID
      , BooleanFlag
      , BooleanAcceptanceValue
      , PercentageFlag
      , PercentageAcceptanceValue
      , IntegerFlag
      , IntegerAcceptanceValue
      , EnumerateFlag
      , EnumerateAcceptanceValue
   )
   SELECT 
      m.MetricID
      , LastProfileID
      , FALSE
      , NULL
      , TRUE --Porcentaje
      , 50 --Por defecto en 50%
      , FALSE
      , NULL
      , FALSE
      , NULL
   FROM Metric m
   WHERE m.MetricID IN (SELECT mb.MetricID FROM MetricKeys mb)
      AND m.UnitID = 2; --Porcentaje

   -- Metricas Milisegundos
   INSERT INTO MetricRange
   (
      MetricID
      , ProfileID
      , BooleanFlag
      , BooleanAcceptanceValue
      , PercentageFlag
      , PercentageAcceptanceValue
      , IntegerFlag
      , IntegerAcceptanceValue
      , EnumerateFlag
      , EnumerateAcceptanceValue
   )
   SELECT 
      m.MetricID
      , LastProfileID
      , FALSE
      , NULL
      , FALSE
      , NULL
      , TRUE --Milisegundos
      , 10000 --Por defecto en 10 segundos
      , FALSE
      , NULL
   FROM Metric m
   WHERE m.MetricID IN (SELECT mb.MetricID FROM MetricKeys mb)
      AND m.UnitID = 3; --Milisegundos

   -- Metricas Basico-Intermedio-Completo
   INSERT INTO MetricRange
   (
      MetricID
      , ProfileID
      , BooleanFlag
      , BooleanAcceptanceValue
      , PercentageFlag
      , PercentageAcceptanceValue
      , IntegerFlag
      , IntegerAcceptanceValue
      , EnumerateFlag
      , EnumerateAcceptanceValue
   )
   SELECT 
      m.MetricID
      , LastProfileID
      , FALSE
      , NULL
      , FALSE
      , NULL
      , FALSE
      , NULL
      , TRUE --Basico-Intermedio-Completo
      , 'I' -- 'B' = Basico, 'I' = Intermedio, 'C' = Completo
   FROM Metric m
   WHERE m.MetricID IN (SELECT mb.MetricID FROM MetricKeys mb)
      AND m.UnitID = 4; --Basico-Intermedio-Completo

   -- Metricas Entero
   INSERT INTO MetricRange
   (
      MetricID
      , ProfileID
      , BooleanFlag
      , BooleanAcceptanceValue
      , PercentageFlag
      , PercentageAcceptanceValue
      , IntegerFlag
      , IntegerAcceptanceValue
      , EnumerateFlag
      , EnumerateAcceptanceValue
   )
   SELECT 
      m.MetricID
      , LastProfileID
      , FALSE
      , NULL
      , FALSE
      , NULL
      , TRUE --Entero
      , 1 --Por defecto en 1
      , FALSE
      , NULL
   FROM Metric m
   WHERE m.MetricID IN (SELECT mb.MetricID FROM MetricKeys mb)
      AND m.UnitID = 5; --Entero

   -- Carga de valores de peso en 0 por defecto al dar de alta un perfil ponderado  
   IF (pIsWeightedFlag = TRUE)
   THEN
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
         LastProfileID
         , mr.MetricRangeID
         , 'R'
         , 0
         , NULL
      FROM MetricKeys mk
      INNER JOIN MetricRange mr ON mr.MetricID = mk.MetricID
      WHERE mr.ProfileID = LastProfileID
      GROUP BY
         LastProfileID
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
         LastProfileID
         , m.MetricID
         , 'M'
         , 0
         , NULL
      FROM MetricKeys mk
      INNER JOIN MetricRange mr ON mr.MetricID = mk.MetricID
      INNER JOIN Metric m ON m.MetricID = mr.MetricID
      WHERE mr.ProfileID = LastProfileID
      GROUP BY
         LastProfileID
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
         LastProfileID
         , f.FactorID
         , 'F'
         , 0
         , NULL
      FROM MetricKeys mk
      INNER JOIN MetricRange mr ON mr.MetricID = mk.MetricID
      INNER JOIN Metric m ON m.MetricID = mr.MetricID
      INNER JOIN Factor f ON f.FactorID = m.FactorID
      WHERE mr.ProfileID = LastProfileID
      GROUP BY
         LastProfileID
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
         LastProfileID
         , d.DimensionID
         , 'D'
         , 0
         , NULL
      FROM MetricKeys mk
      INNER JOIN MetricRange mr ON mr.MetricID = mk.MetricID
      INNER JOIN Metric m ON m.MetricID = mr.MetricID
      INNER JOIN Factor f ON f.FactorID = m.FactorID
      INNER JOIN Dimension d ON d.DimensionID = f.DimensionID
      WHERE mr.ProfileID = LastProfileID
      GROUP BY
         LastProfileID
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
         LastProfileID
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
      WHERE mr.ProfileID = LastProfileID
      GROUP BY
         LastProfileID
         , q.QualityModelID;
   END IF;
   
END;
$$ LANGUAGE plpgsql;