--DROP FUNCTION quality_model_insert(character,integer,character varying, boolean, character varying, character varying, integer, boolean, character varaying);
CREATE OR REPLACE FUNCTION quality_model_insert
(
   pElementType CHAR(1) -- 'Q' = QualityModel, 'D' = Dimension, 'F' = Factor, 'M' = Metrica
   , pFatherElementyID INT
   , pElementName VARCHAR(100)
   , pAggregationFlag BOOLEAN
   , pGranularity VARCHAR(11)
   , pUnit VARCHAR(40)
   , pMetricUnitID INT
   , pMetricIsManual BOOLEAN
   , pMetricDescription VARCHAR(100)
)
RETURNS VOID AS $$
/************************************************************************************************************
** Name: quality_model_insert
**
** Desc: Agrega un entidad a los modelos de calidad
**
** 20/05/2017 Created
**
*************************************************************************************************************/
BEGIN

   IF (pElementType IS NULL)
   THEN
      RAISE EXCEPTION 'Error - El tipo de Entidad es requerido.';
   END IF;
   
   -- validacion padre
   IF pElementType = 'M' AND NOT EXISTS (SELECT 1 FROM Factor f WHERE f.FactorID = pFatherElementyID)
   THEN
      RAISE EXCEPTION 'Error - El factor seleccionado no existe.';
   END IF;
   -- validacion padre
   IF pElementType = 'F' AND NOT EXISTS (SELECT 1 FROM Dimension d WHERE d.DimensionID = pFatherElementyID)
   THEN
      RAISE EXCEPTION 'Error - La dimension seleccionada no existe.';
   END IF;
   -- validacion padre
   IF pElementType = 'D' AND NOT EXISTS (SELECT 1 FROM QualityModel qm WHERE qm.QualityModelID = pFatherElementyID)
   THEN
      RAISE EXCEPTION 'Error - El modelo de calidad seleccionado no existe.';
   END IF; 

   IF pElementType = 'Q'
   THEN
      INSERT INTO QualityModel
      (Name)
      VALUES
      (pElementName);
   END IF;

   IF pElementType = 'D'
   THEN
      INSERT INTO Dimension
      (Name, QualityModelID)
      VALUES
      (pElementName, pFatherElementyID);
   END IF;

   IF pElementType = 'F'
   THEN
      INSERT INTO Factor
      (Name, DimensionID)
      VALUES
      (pElementName, pFatherElementyID);
   END IF;

   IF pElementType = 'M'
   THEN
      INSERT INTO Metric
      (Name, FactorID, AgrgegationFlag, Granurality, UnitID, IsManual, Description)
      VALUES
      (pElementName, pFatherElementyID, pAggregationFlag, pGranularity, pMetricUnitID, pMetricIsManual, pMetricDescription);
   END IF;
         
END;
$$ LANGUAGE plpgsql;