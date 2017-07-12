--DROP FUNCTION report_success_evaluation_per_node();
CREATE OR REPLACE FUNCTION report_success_evaluation_per_node ()
RETURNS TABLE (NodeID INT, NodeName VARCHAR(70), NodeCount BIGINT, NodePercentage NUMERIC, NodeSuccessPercentage BIGINT) AS $$
/************************************************************************************************************
** Name: report_success_evaluation_per_node
**
** Desc: Devuelve la cantidad y el porcentaje de exitos por institucion
**
** 2017/03/11 - Created
**
*************************************************************************************************************/
DECLARE v_TotalEvaluationSummary BIGINT;
DECLARE v_NodesCount INT;

BEGIN
  
   SELECT COUNT(*) FROM EvaluationSummary es INTO v_TotalEvaluationSummary;

   CREATE TEMP TABLE NodesAux
   (
      NodeID INT
      , NodeName VARCHAR(70)
      , SummaryNodeSuccessPercentage BIGINT
   );

   INSERT INTO NodesAux
   (NodeID, NodeName, SummaryNodeSuccessPercentage)
   SELECT n.NodeID
      , n.Name AS NodeName
      , CASE WHEN COUNT(es.EvaluationSummaryID) = 0 THEN 0 ELSE ((SELECT SUM(ies.SuccessPercentage) FROM EvaluationSummary ies WHERE ies.MeasurableObjectID = mo.MeasurableObjectID) / COUNT(n.NodeID)) END AS SummaryNodeSuccessPercentage
   FROM EvaluationSummary es
   INNER JOIN MeasurableObject mo ON mo.MeasurableObjectID = es.MeasurableObjectID
   INNER JOIN GeographicServices gs ON gs.GeographicServicesID = mo.EntityID AND mo.EntityType = 'Servicio'
   INNER JOIN Node n ON n.NodeID = gs.NodeID
   GROUP BY n.NodeID
      , n.Name
      , mo.MeasurableObjectID;

   SELECT COUNT(DISTINCT na.NodeID) FROM NodesAux na INTO v_NodesCount;

   RETURN QUERY
   SELECT na.NodeID
      , na.NodeName
      , COUNT(na.NodeID) AS NodeCount
      , COUNT(na.NodeID) / (v_NodesCount) :: NUMERIC AS NodePercentage
      , CASE WHEN COUNT(na.SummaryNodeSuccessPercentage) = 0 THEN 0 ELSE (SELECT SUM(na.SummaryNodeSuccessPercentage) / (COUNT(na.NodeID))) END :: BIGINT AS NodeSuccessPercentage
   FROM NodesAux na
   GROUP BY na.NodeID
      , na.NodeName
   ORDER BY na.NodeName DESC;

   DROP TABLE NodesAux;
               
END;
$$ LANGUAGE plpgsql;