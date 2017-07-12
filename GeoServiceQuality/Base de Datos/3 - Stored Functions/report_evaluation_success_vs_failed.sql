--DROP FUNCTION report_evaluation_success_vs_failed();
CREATE OR REPLACE FUNCTION report_evaluation_success_vs_failed ()
RETURNS TABLE (SuccessCount BIGINT, FailCount BIGINT, SuccessPercentage NUMERIC, FailPercentage NUMERIC, TotalEvaluationCount BIGINT) AS $$
/************************************************************************************************************
** Name: report_evaluation_success_vs_failed
**
** Desc: Devuelve la cantidad de exitos sobre la cantidad fracasos del total de evaluaciones.
**
** 2017/03/09 - Created
**
*************************************************************************************************************/
DECLARE v_SuccessCount BIGINT;
DECLARE v_FailCount BIGINT;
DECLARE v_SuccessPercentage NUMERIC;
DECLARE v_FailPercentage NUMERIC;
DECLARE v_TotalEvaluationCount BIGINT;

BEGIN
  
   SELECT COUNT(*)
   FROM Evaluation e
   WHERE e.SuccessFlag = TRUE
   INTO v_SuccessCount;

   SELECT COUNT(*)
   FROM Evaluation e
   WHERE e.SuccessFlag = FALSE
   INTO v_FailCount;

   SELECT COUNT(*)
   FROM Evaluation e
   INTO v_TotalEvaluationCount;

   SELECT CASE WHEN v_TotalEvaluationCount = 0 THEN 0 ELSE (v_SuccessCount * 100.00 ) / v_TotalEvaluationCount END
   INTO v_SuccessPercentage;

   SELECT CASE WHEN v_TotalEvaluationCount = 0 THEN 0 ELSE (v_FailCount * 100.00) / v_TotalEvaluationCount END
   INTO v_FailPercentage;

   RETURN QUERY
   SELECT
      v_SuccessCount
      , v_FailCount
      , v_SuccessPercentage
      , v_FailPercentage
      , v_TotalEvaluationCount;
END;
$$ LANGUAGE plpgsql;