--DROP FUNCTION report_top_best_worst_measurable_object_get(integer, boolean, boolean);
CREATE OR REPLACE FUNCTION report_top_best_worst_measurable_object_get
(
    pTop INT
    , pMeasurableObjectSuccessPercentageDesc BOOLEAN
    , pMeasurableObjectSuccessPercentageAsc BOOLEAN
)
RETURNS TABLE 
   (
      MeasurableObjectID INT
      , EntityID INT
      , EntityType VARCHAR(11)
      , MeasurableObjectDescription VARCHAR(100)
      , MeasurableObjectURL VARCHAR(1024)
      , MeasurableObjectServicesType CHAR(3)
      , MeasurableObjectSuccessPercentage NUMERIC
 ) AS $$
/************************************************************************************************************
** Name: report_top_best_worst_measurable_object_get
**
** Desc: Devuelve una cierta cantidad (pTop) de servicios ordenados por algúno de los criterios pasados por parametro.
**
** 03/13/2017 - Created
**
*************************************************************************************************************/
DECLARE v_TotalEvaluationCount BIGINT;

BEGIN

   SELECT COUNT(*)
   FROM Evaluation e
   INTO v_TotalEvaluationCount;

   IF (pMeasurableObjectSuccessPercentageAsc = TRUE)
   THEN
      RETURN QUERY
      SELECT es.MeasurableObjectID
         , mo.EntityID
         , mo.EntityType 
         , gs.Description AS MeasurableObjectDescription
         , gs.Url AS MeasurableObjectURL
         , gs.GeographicServicesType AS MeasurableObjectServicesType
         , CASE WHEN v_TotalEvaluationCount = 0 THEN 0 
              ELSE ((COUNT(e.EvaluationID) * 100.00) / 
                (
                   SELECT COUNT(ei.EvaluationID) 
                   FROM Evaluation ei 
                   INNER JOIN EvaluationSummary esi ON esi.EvaluationSummaryID = ei.EvaluationSummaryID
                   WHERE esi.MeasurableObjectID = es.MeasurableObjectID
                )
           ) END AS MeasurableObjectSuccessPercentage
      FROM Evaluation e
      INNER JOIN EvaluationSummary es ON es.EvaluationSummaryID = e.EvaluationSummaryID
      INNER JOIN MeasurableObject mo ON mo.MeasurableObjectID = es.MeasurableObjectID
      INNER JOIN GeographicServices gs ON gs.GeographicServicesID = mo.EntityID
      WHERE mo.EntityType = 'Servicio'
          AND e.SuccessFlag = TRUE
      GROUP BY es.MeasurableObjectID
         , mo.EntityID
         , mo.EntityType
         , gs.Description
         , gs.Url
         , gs.GeographicServicesType
         , e.SuccessFlag
      ORDER BY MeasurableObjectSuccessPercentage ASC
      LIMIT pTop;
   
   ELSE
      RETURN QUERY
      SELECT es.MeasurableObjectID
         , mo.EntityID
         , mo.EntityType 
         , gs.Description AS MeasurableObjectDescription
         , gs.Url AS MeasurableObjectURL
         , gs.GeographicServicesType AS MeasurableObjectServicesType
         , CASE WHEN v_TotalEvaluationCount = 0 THEN 0 
              ELSE ((COUNT(e.EvaluationID) * 100.00) / 
                (
                   SELECT COUNT(ei.EvaluationID) 
                   FROM Evaluation ei 
                   INNER JOIN EvaluationSummary esi ON esi.EvaluationSummaryID = ei.EvaluationSummaryID
                   WHERE esi.MeasurableObjectID = es.MeasurableObjectID
                )
           ) END AS MeasurableObjectSuccessPercentage
      FROM Evaluation e
      INNER JOIN EvaluationSummary es ON es.EvaluationSummaryID = e.EvaluationSummaryID
      INNER JOIN MeasurableObject mo ON mo.MeasurableObjectID = es.MeasurableObjectID
      INNER JOIN GeographicServices gs ON gs.GeographicServicesID = mo.EntityID
      WHERE mo.EntityType = 'Servicio'
          AND e.SuccessFlag = TRUE
      GROUP BY es.MeasurableObjectID
         , mo.EntityID
         , mo.EntityType
         , gs.Description
         , gs.Url
         , gs.GeographicServicesType
         , e.SuccessFlag
      ORDER BY MeasurableObjectSuccessPercentage DESC
      LIMIT pTop;
   END IF;

END;
$$ LANGUAGE plpgsql;