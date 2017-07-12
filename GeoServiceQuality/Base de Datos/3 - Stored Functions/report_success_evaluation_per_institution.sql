--DROP FUNCTION report_success_evaluation_per_institution();
CREATE OR REPLACE FUNCTION report_success_evaluation_per_institution ()
RETURNS TABLE (InstitutionID INT, InstitutionName VARCHAR(70), InstitutionCount BIGINT, InstitutionPercentage NUMERIC, InstitutionSuccessPercentage BIGINT) AS $$
/************************************************************************************************************
** Name: report_success_evaluation_per_institution
**
** Desc: Devuelve la cantidad y el porcentaje de exitos por institucion
**
** 2017/03/11 - Created
**
*************************************************************************************************************/
DECLARE v_TotalEvaluationSummary BIGINT;
DECLARE v_InstitutionsCount INT;

BEGIN
  
   SELECT COUNT(*) FROM EvaluationSummary es INTO v_TotalEvaluationSummary;

   CREATE TEMP TABLE InstitutionsAux
   (
      InstitutionID INT
      , InstitutionName VARCHAR(70)
      , SummaryInstitutionSuccessPercentage BIGINT
   );

   INSERT INTO InstitutionsAux
   (InstitutionID, InstitutionName, SummaryInstitutionSuccessPercentage)
   SELECT i.InstitutionID
      , i.Name AS InstitutionName
      , CASE WHEN COUNT(es.EvaluationSummaryID) = 0 THEN 0 ELSE ((SELECT SUM(ies.SuccessPercentage) FROM EvaluationSummary ies WHERE ies.MeasurableObjectID = mo.MeasurableObjectID) / COUNT(i.InstitutionID)) END AS SummaryInstitutionSuccessPercentage
   FROM EvaluationSummary es
   INNER JOIN MeasurableObject mo ON mo.MeasurableObjectID = es.MeasurableObjectID
   INNER JOIN GeographicServices gs ON gs.GeographicServicesID = mo.EntityID AND mo.EntityType = 'Servicio'
   INNER JOIN Node n ON n.NodeID = gs.NodeID
   INNER JOIN Institution i ON i.InstitutionID = n.InstitutionID
   GROUP BY i.InstitutionID
      , i.Name
      , mo.MeasurableObjectID;

   SELECT COUNT(DISTINCT ia.InstitutionID) FROM InstitutionsAux ia INTO v_InstitutionsCount;

   RETURN QUERY
   SELECT ia.InstitutionID
      , ia.InstitutionName
      , COUNT(ia.InstitutionID) AS InstitutionCount
      , COUNT(ia.InstitutionID) / (v_InstitutionsCount) :: NUMERIC AS InstitutionPercentage
      , CASE WHEN COUNT(ia.SummaryInstitutionSuccessPercentage) = 0 THEN 0 ELSE (SELECT SUM(ia.SummaryInstitutionSuccessPercentage) / (COUNT(ia.InstitutionID))) END :: BIGINT AS InstitutionSuccessPercentage
   FROM InstitutionsAux ia
   GROUP BY ia.InstitutionID
      , ia.InstitutionName
   ORDER BY ia.InstitutionName DESC;

   DROP TABLE InstitutionsAux;
               
END;
$$ LANGUAGE plpgsql;