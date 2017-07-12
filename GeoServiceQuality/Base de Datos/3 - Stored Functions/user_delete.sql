--DROP FUNCTION user_delete (integer)
CREATE OR REPLACE FUNCTION user_delete
(
   pUserID INT
)
RETURNS VOID AS $$
/************************************************************************************************************
** Name: user_delete
**
** Desc: Quita el Usuario de UsuarioID de la tabla Usuario
**
** 04/12/2016 - Created
**
*************************************************************************************************************/
-- TODO: Asegurarse desde el codigo o BD que al solicitar un borrado, no se llamen a posibles instancias pendientes de evaluacion para el usuario eliminado
BEGIN
   
   -- parametros requeridos
   IF (pUserID IS NULL)
   THEN
      RAISE EXCEPTION 'Error - El parametro ID de usuario es requerido.';
   END IF;
    
   IF NOT EXISTS (SELECT 1 FROM SystemUser u WHERE u.UserID = pUserID)
   THEN
      RAISE EXCEPTION 'Error - El usuario de ID: % no existe.', pUserID;
   END IF;

   -- Borrado de registros dependientes del usuario  
   DELETE FROM UserMeasurableObject
   WHERE UserID = pUserID;

   DELETE FROM PartialEvaluation pe
   USING EvaluationSummary es
      , Evaluation e
   WHERE e.EvaluationSummaryID = es.EvaluationSummaryID
      AND e.EvaluationID = pe.EvaluationID
      AND es.UserID = pUserID;

   DELETE FROM Evaluation e
   USING EvaluationSummary es
   WHERE es.EvaluationSummaryID = e.EvaluationSummaryID
      AND es.UserID = pUserID;

   DELETE FROM EvaluationSummary
   WHERE UserID = pUserID;   
    
   -- Borrado del usuario de la tabla Usuario
   DELETE FROM SystemUser
   WHERE UserID = pUserID;
    
END;
$$ LANGUAGE plpgsql;