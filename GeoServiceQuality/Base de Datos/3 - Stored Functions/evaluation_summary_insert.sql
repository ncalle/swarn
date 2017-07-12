--DROP FUNCTION evaluation_summary_insert(integer,integer,integer,boolean,integer);
CREATE OR REPLACE FUNCTION evaluation_summary_insert
(
   pUserID INT
   , pProfileID INT
   , pMeasurableObjectID INT
   , pSuccessFlag BOOLEAN
   , pSuccessPercentage INT
)
RETURNS TABLE 
(
   EvaluationSummaryID INT
   , UserID INT	  
   , ProfileID INT
   , ProfileName VARCHAR(40)
   , MeasurableObjectID INT
   , EntityID INT
   , EntityType VARCHAR(11)
   , MeasurableObjectName VARCHAR(1024)
   , MeasurableObjectDescription VARCHAR(100)
   , SuccessFlag BOOLEAN
   , SuccessPercentage INT
) AS $$
/************************************************************************************************************
** Name: evaluation_summary_insert
**
** Desc: Ingreso de resumen de una evaluacion. Devuelde datos del resumen ingresado.
**
** 10/03/2017 - Created
**
*************************************************************************************************************/
DECLARE v_EvaluationSummaryID INT;

BEGIN
    
   -- parametros requeridos
   IF (pUserID IS NULL OR pProfileID IS NULL OR pMeasurableObjectID IS NULL)
   THEN
      RAISE EXCEPTION 'Error - Los parametros ID de Usuario, ID de Perfil, ID de Metrica e ID de Objeto Medible son requerido.';
   END IF;
    
   -- validacion de usuario
   IF NOT EXISTS (SELECT 1 FROM SystemUser u WHERE u.UserID = pUserID)
   THEN
      RAISE EXCEPTION 'Error - El ID de Usuario no es correcto.';
   END IF;
    
   -- validacion de perfil
   IF NOT EXISTS (SELECT 1 FROM Profile p WHERE p.ProfileID = pProfileID)
   THEN
      RAISE EXCEPTION 'Error - El ID de Perfil no es correcto.';
   END IF; 
   
   -- validacion de Objeto Medible
   IF NOT EXISTS (SELECT 1 FROM MeasurableObject mo WHERE mo.MeasurableObjectID = pMeasurableObjectID)
   THEN
      RAISE EXCEPTION 'Error - El ID de Objeto Medible no es correcto.';
   END IF; 

   INSERT INTO EvaluationSummary AS es
   (UserID, ProfileID, MeasurableObjectID, SuccessFlag, SuccessPercentage)
   VALUES
   (pUserID, pProfileID, pMeasurableObjectID, pSuccessFlag, pSuccessPercentage)
      RETURNING es.EvaluationSummaryID INTO v_EvaluationSummaryID;

   RETURN QUERY 
      SELECT es.EvaluationSummaryID
      , es.UserID	  
      , es.ProfileID
      , p.Name AS ProfileName
      , mo.MeasurableObjectID
      , mo.EntityID
      , mo.EntityType
      , CASE 
         WHEN gs.GeographicServicesID IS NOT NULL THEN gs.Url
         WHEN l.LayerID IS NOT NULL THEN l.Url
         WHEN n.NodeID IS NOT NULL THEN n.Name
         WHEN i.InstitutionID IS NOT NULL THEN i.Name
         WHEN ide.IdeID IS NOT NULL THEN ide.Name
      END AS MeasurableObjectName
      , CASE 
         WHEN gs.GeographicServicesID IS NOT NULL THEN gs.Description
      END AS MeasurableObjectDescription
      , es.SuccessFlag
      , es.SuccessPercentage
   FROM EvaluationSummary es
   INNER JOIN Profile p ON p.ProfileID = es.ProfileID
   INNER JOIN MeasurableObject mo ON mo.MeasurableObjectID = es.MeasurableObjectID
   LEFT JOIN UserMeasurableObject umo ON umo.MeasurableObjectID = mo.MeasurableObjectID
   LEFT JOIN GeographicServices gs ON gs.GeographicServicesID = mo.EntityID AND mo.EntityType = 'Servicio'
   LEFT JOIN Layer l ON l.LayerID = mo.EntityID AND mo.EntityType = 'Capa'
   LEFT JOIN Node n ON n.NodeID = mo.EntityID AND mo.EntityType = 'Nodo'
   LEFT JOIN Institution i ON i.InstitutionID = mo.EntityID AND mo.EntityType = 'Institución'
   LEFT JOIN Ide ide ON ide.IdeID = mo.EntityID AND mo.EntityType = 'Ide'
   WHERE es.EvaluationSummaryID = v_EvaluationSummaryID
   GROUP BY es.EvaluationSummaryID
      , es.UserID	  
      , es.ProfileID
      , p.Name
      , mo.MeasurableObjectID
      , mo.EntityID
      , mo.EntityType
      , gs.GeographicServicesID
      , l.LayerID
      , n.NodeID
      , i.InstitutionID
      , ide.IdeID
      , es.SuccessFlag
      , es.SuccessPercentage;

END;
$$ LANGUAGE plpgsql;