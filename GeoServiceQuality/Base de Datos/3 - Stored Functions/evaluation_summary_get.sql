--DROP FUNCTION evaluation_summary_get(integer);
CREATE OR REPLACE FUNCTION evaluation_summary_get
(
   pUserID INT --no requerido
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
** Name: evaluation_summary_get
**
** Desc: Devuelve el resumen de las Evaluaciones
**       Si se le pasa el usuario, entonces se devuelven solo el resumen de las evaluaciones correspondientes a el mismo.
**
** 11/02/2017 Created
**
*************************************************************************************************************/
DECLARE v_canUserMeasureAble BOOLEAN;

BEGIN

   -- validacion de usuario
   IF (pUserID IS NOT NULL)
      AND NOT EXISTS (SELECT 1 FROM SystemUser su WHERE su.UserID = pUserID)
   THEN
      RAISE EXCEPTION 'Error - El Usuario no existe.';
   END IF;
   
   IF (pUserID IS NOT NULL)
   THEN
      SELECT TRUE INTO v_canUserMeasureAble;
   ELSE
      SELECT FALSE INTO v_canUserMeasureAble;
   END IF;
	
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
         WHEN l.LayerID IS NOT NULL THEN l.Url
         WHEN n.NodeID IS NOT NULL THEN n.Name
         WHEN i.InstitutionID IS NOT NULL THEN i.Name
         WHEN ide.IdeID IS NOT NULL THEN ide.Name
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
   WHERE umo.UserID = COALESCE(pUserID, umo.UserID)
      AND (CASE WHEN v_canUserMeasureAble = TRUE THEN umo.CanMeasureFlag = TRUE ELSE TRUE END)
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
      , es.SuccessPercentage
   ORDER BY es.EvaluationSummaryID;
         
END;
$$ LANGUAGE plpgsql;