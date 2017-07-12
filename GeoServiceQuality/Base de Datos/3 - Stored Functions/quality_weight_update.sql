--DROP FUNCTION quality_weight_update();
CREATE OR REPLACE FUNCTION quality_weight_update
(
   pNominator INT
   , pDenominator INT
   , pWeighingID INT
)
RETURNS VOID AS $$
/************************************************************************************************************
** Name: quality_weight_update()
**
** Desc: Actualiza datos de Objetos Medibles
**
** 26/04/2017 - Created
**
*************************************************************************************************************/
BEGIN
   
   -- parametros requeridos
   IF (pWeighingID IS NULL)
   THEN
      RAISE EXCEPTION 'Error - El ID de ponderación no puede ser nulo.';
   END IF;
   
   -- validacion de ponderación
   IF (NOT EXISTS (SELECT 1 FROM Weighing w WHERE w.WeighingID = pWeighingID))
   THEN
      RAISE EXCEPTION 'Error - El ID de ponderción pasado por parametro es incorrecto.';
   END IF;
       
   UPDATE Weighing
   SET NumeratorValue = pNominator
      , DenominatorValue = pDenominator
   WHERE WeighingID = pWeighingID; 
    
END;
$$ LANGUAGE plpgsql;