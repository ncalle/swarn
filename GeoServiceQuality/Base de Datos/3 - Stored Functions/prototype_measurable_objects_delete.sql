--DROP FUNCTION prototype_measurable_objects_delete(integer);
CREATE OR REPLACE FUNCTION prototype_measurable_objects_delete
(
   pMeasurableObjectID INT
)
RETURNS VOID AS $$
/************************************************************************************************************
** Name: prototype_measurable_objects_delete
**
** Desc: Borra un objeto medible
**
** 08/12/2016 Created
**
*************************************************************************************************************/
DECLARE v_EntityType VARCHAR(11);
DECLARE v_EntityID INT;

BEGIN

   -- parametros requeridos
   IF (pMeasurableObjectID IS NULL)
   THEN
      RAISE EXCEPTION 'Error - El parametro ID de Objeto Medible es requerido.';
   END IF;
    
   -- validacion de Objeto Medible
   IF NOT EXISTS 
      (
         SELECT 1 
         FROM UserMeasurableObject umo 
         WHERE MeasurableObjectID = pMeasurableObjectID
      )
   THEN
      RAISE EXCEPTION 'Error - El Objeto Medible que se intenta eliminar no existe.';
   END IF;
	
   SELECT mo.EntityType, mo.EntityID FROM MeasurableObject mo WHERE mo.MeasurableObjectID = pMeasurableObjectID INTO v_EntityType, v_EntityID;
	
   -- validacion Servicio Geografico
   IF (v_EntityType = 'Servicio')
      AND NOT EXISTS (SELECT 1 FROM GeographicServices sg WHERE sg.GeographicServicesID = v_EntityID)
   THEN
      RAISE EXCEPTION 'Error - El Servicio Geografico que se intenta eliminar no existe.';
   END IF;

   -- Borrado de registros dependientes del Objeto Medible
   DELETE FROM UserMeasurableObject
   WHERE MeasurableObjectID = pMeasurableObjectID;

   DELETE FROM PartialEvaluation pe
   USING EvaluationSummary es
      , Evaluation e
   WHERE e.EvaluationSummaryID = es.EvaluationSummaryID
      AND e.EvaluationID = pe.EvaluationID
      AND es.MeasurableObjectID = pMeasurableObjectID;

   DELETE FROM Evaluation e
   USING EvaluationSummary es
   WHERE es.EvaluationSummaryID = e.EvaluationSummaryID
      AND es.MeasurableObjectID = pMeasurableObjectID;

   DELETE FROM EvaluationSummary
   WHERE MeasurableObjectID = pMeasurableObjectID;   
   
   IF v_EntityType = 'Servicio'
   THEN
      DELETE FROM GeographicServices
      WHERE GeographicServicesID = v_EntityID;
   END IF;
         
END;
$$ LANGUAGE plpgsql;