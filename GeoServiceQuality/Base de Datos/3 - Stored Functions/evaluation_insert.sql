--DROP FUNCTION evaluation_insert (integer, integer, boolean);
CREATE OR REPLACE FUNCTION evaluation_insert
(
   pEvaluationSummaryID INT
   , pMetricID INT
   , pSuccessFlag BOOLEAN
)
RETURNS VOID AS $$
/************************************************************************************************************
** Name: evaluation_insert
**
** Desc: Ingreso de evaluacion
**
** 11/12/2016 - Created
**
*************************************************************************************************************/
BEGIN
    
   -- parametros requeridos
   IF (pEvaluationSummaryID IS NULL OR pMetricID IS NULL)
   THEN
      RAISE EXCEPTION 'Error - Los parametros ID de EvaluacionSummary, ID de Metrica son requerido.';
   END IF;
          
   -- validacion de Metrica
   IF NOT EXISTS (SELECT 1 FROM Metric m WHERE m.MetricID = pMetricID)
   THEN
      RAISE EXCEPTION 'Error - El ID de Metrica no es correcto.';
   END IF;    
   
   -- validacion de EvaluationSummaryID
   IF NOT EXISTS (SELECT 1 FROM EvaluationSummary es WHERE es.EvaluationSummaryID = pEvaluationSummaryID)
   THEN
      RAISE EXCEPTION 'Error - El ID de EvaluationSummary no es correcto.';
   END IF; 

   -- Ingreso de Evaluacion
   INSERT INTO Evaluation
   (EvaluationSummaryID, MetricID, StartDate, EndDate, IsEvaluationCompletedFlag, SuccessFlag)
   VALUES
   (pEvaluationSummaryID, pMetricID, CURRENT_DATE, CURRENT_DATE, TRUE, pSuccessFlag);

END;
$$ LANGUAGE plpgsql;