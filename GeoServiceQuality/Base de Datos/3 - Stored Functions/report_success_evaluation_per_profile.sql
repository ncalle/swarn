--DROP FUNCTION report_success_evaluation_per_profile();
CREATE OR REPLACE FUNCTION report_success_evaluation_per_profile ()
RETURNS TABLE (ProfileID INT, ProfileName VARCHAR(70), ProfileCount BIGINT, ProfilePercentage NUMERIC, ProfileSuccessPercentage BIGINT) AS $$
/************************************************************************************************************
** Name: report_success_evaluation_per_profile
**
** Desc: Devuelve la cantidad y el porcentaje de exitos por perfil
**
** 2017/03/11 - Created
**
*************************************************************************************************************/
DECLARE v_TotalEvaluationSummary BIGINT;

BEGIN
  
   SELECT COUNT(*) FROM EvaluationSummary es INTO v_TotalEvaluationSummary;

   RETURN QUERY
   SELECT p.ProfileID
      , p.Name AS ProfileName
      , COUNT(es.EvaluationSummaryID) AS ProfileCount
      , CASE WHEN v_TotalEvaluationSummary = 0 THEN 0 ELSE ((COUNT(es.EvaluationSummaryID) * 100.00) / v_TotalEvaluationSummary) END AS ProfilePercentage
      , CASE WHEN COUNT(es.EvaluationSummaryID) = 0 THEN 0 ELSE ((SELECT SUM(ies.SuccessPercentage) FROM EvaluationSummary ies WHERE ies.ProfileID = p.ProfileID) / COUNT(es.EvaluationSummaryID)) END AS ProfileSuccessPercentage
   FROM EvaluationSummary es
   INNER JOIN Profile p ON es.ProfileID = p.ProfileID
   GROUP BY p.ProfileID
      , p.Name
   ORDER BY COUNT (es.EvaluationSummaryID) DESC;
               
END;
$$ LANGUAGE plpgsql;