--DROP FUNCTION profile_delete (integer);
CREATE OR REPLACE FUNCTION profile_delete
(
   pProfileID INT
)
RETURNS VOID AS $$
/************************************************************************************************************
** Name: profile_delete
**
** Desc: Elimina el Perfil pasado por parametro así como los registros en MetricRange asociados al Perfil
**
** 04/03/2017 - Created
**
*************************************************************************************************************/
BEGIN
   
   -- parametros requeridos
   IF (pProfileID IS NULL)
   THEN
      RAISE EXCEPTION 'Error - El parametro ID de Perfil es requerido.';
   END IF;
   
   -- validación de existencia de Perfil
   IF NOT EXISTS (SELECT 1 FROM Profile p WHERE p.ProfileID = pProfileID)
   THEN
      RAISE EXCEPTION 'Error - El Perfil de ID: % no existe.', pProfileID;
   END IF;

   -- Borrado de registros dependientes del Perfil
   DELETE FROM PartialEvaluation pe
   USING EvaluationSummary es
      , Evaluation e
   WHERE e.EvaluationSummaryID = es.EvaluationSummaryID
      AND e.EvaluationID = pe.EvaluationID
      AND es.ProfileID = pProfileID;

   DELETE FROM Evaluation e
   USING EvaluationSummary es
   WHERE es.EvaluationSummaryID = e.EvaluationSummaryID
      AND ProfileID = pProfileID;

   DELETE FROM EvaluationSummary
   WHERE ProfileID = pProfileID;
   
   DELETE FROM Weighing
   WHERE ProfileID = pProfileID;

   DELETE FROM MetricRange
   WHERE ProfileID = pProfileID;
       
   -- Borrado del Perfil de la tabla Profile
   DELETE FROM Profile
   WHERE ProfileID = pProfileID;
    
END;
$$ LANGUAGE plpgsql;