--DROP FUNCTION quality_model_update();
CREATE OR REPLACE FUNCTION quality_model_update
(
   pElementID INT --QualityModelID, DimensionID, FactorID, MetricID
   , pElementType CHAR(1) --'Q' = QualityModel, 'D' = Dimension, 'F' = Factor, 'M' = Metrica
   , pName VARCHAR(100)
)
RETURNS VOID AS $$
/************************************************************************************************************
** Name: quality_model_update()
**
** Desc: Actualiza datos del modelo de calidad
**
** 17/05/2017 - Created
**
*************************************************************************************************************/
BEGIN
   
   -- parametros requeridos
   IF (pElementID IS NULL)
   THEN
      RAISE EXCEPTION 'Error - El ID del elemento no puede ser nulo.';
   END IF;
       
   IF (pElementType = 'Q')
   THEN
      UPDATE QualityModel
      SET Name = pName
      WHERE QualityModelID = pElementID;
   ELSIF (pElementType = 'D')
   THEN
      UPDATE Dimension
      SET Name = pName
      WHERE DimensionID = pElementID;
   ELSIF (pElementType = 'F')
   THEN
      UPDATE Factor
      SET Name = pName
      WHERE FactorID = pElementID;
   ELSIF (pElementType = 'M')
   THEN
      UPDATE Metric
      SET Name = pName
      WHERE MetricID = pElementID;		
   END IF;
    
END;
$$ LANGUAGE plpgsql;