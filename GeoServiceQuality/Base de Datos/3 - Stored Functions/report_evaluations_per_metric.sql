--DROP FUNCTION report_evaluations_per_metric();
CREATE OR REPLACE FUNCTION report_evaluations_per_metric ()
RETURNS TABLE (MetricID INT, MetricName VARCHAR(100), EvaluationPerMetricCount BIGINT, EvaluationPerMetricPercentage NUMERIC) AS $$
/************************************************************************************************************
** Name: report_evaluations_per_metric
**
** Desc: Devuelve la cantidad de evaluaciones realizadas por metrica
**
** 2017/03/09 - Created
**
*************************************************************************************************************/
DECLARE v_TotalEvaluationCount BIGINT;
BEGIN

   SELECT COUNT(*)
   FROM Evaluation e
   INTO v_TotalEvaluationCount;
  
   RETURN QUERY
   SELECT e.MetricID
      , m.Name
      , COUNT(e.MetricID) AS EvaluationPerMetricCount
      , CASE WHEN v_TotalEvaluationCount = 0 THEN 0 ELSE ((COUNT(e.MetricID) * 100.00) / v_TotalEvaluationCount) END AS EvaluationPerMetricPercentage
   FROM Evaluation e
   INNER JOIN Metric m ON m.MetricID = e.MetricID
   GROUP BY e.MetricID
      , m.Name
   ORDER BY COUNT(e.MetricID) DESC;
               
END;
$$ LANGUAGE plpgsql;