--DROP FUNCTION ide_tree_structure_get(integer);
CREATE OR REPLACE FUNCTION ide_tree_structure_get
(
   pUserID INT
)
RETURNS TABLE 
   (
      IdeMeasurableObjectID INT
      , IdeID INT
      , IdeName VARCHAR(40)
      , IdeDescription VARCHAR(100)
      , InstitutionMeasurableObjectID INT
      , InstitutionID INT
      , InstitutionName VARCHAR(70)
      , InstitutionDescription VARCHAR(100)
      , NodeMeasurableObjectID INT
      , NodeID INT
      , NodeName VARCHAR(70)
      , NodeDescription VARCHAR(100)
 ) AS $$
/************************************************************************************************************
** Name: ide_tree_structure_get
**
** Desc: Devuelve la estructura conformada por las Ides disponibles en el sistema. Hasta los Nodos
**
** 19/03/2017 - Created
**
*************************************************************************************************************/
BEGIN
   
   -- validacion de usuario
   IF (pUserID IS NOT NULL)
      AND NOT EXISTS (SELECT 1 FROM SystemUser su WHERE su.UserID = pUserID)
   THEN
      RAISE EXCEPTION 'Error - El Usuario no existe.';
   END IF;

   -- Lista de objetos medibles
   RETURN QUERY
   SELECT 
      (SELECT moo.MeasurableObjectID FROM MeasurableObject moo WHERE moo.EntityType = 'Ide' AND moo.EntityID = ide.IdeID) AS IdeMeasurableObjectID
      , ide.IdeID
      , ide.Name AS IdeName
      , ide.Description AS IdeDescription
      , (SELECT moo.MeasurableObjectID FROM MeasurableObject moo WHERE moo.EntityType = 'Institución' AND moo.EntityID = ins.InstitutionID) AS InstitutionMeasurableObjectID
      , ins.InstitutionID
      , ins.Name AS InstitutionName
      , ins.Description AS InstitutionDescription
      , (SELECT moo.MeasurableObjectID FROM MeasurableObject moo WHERE moo.EntityType = 'Nodo' AND moo.EntityID = n.NodeID) AS NodeMeasurableObjectID      
      , n.NodeID
      , n.Name AS NodeName
      , n.Description AS NodeDescription
   FROM Ide ide
   LEFT JOIN Institution ins ON ins.IdeID = ide.IdeID
   LEFT JOIN Node n ON n.InstitutionID = ins.InstitutionID
   LEFT JOIN MeasurableObject mo ON 
      CASE
         WHEN mo.EntityType = 'Ide' THEN mo.EntityID = ide.IdeID
         WHEN mo.EntityType = 'Institución' THEN mo.EntityID = ins.InstitutionID
         WHEN mo.EntityType = 'Nodo' THEN mo.EntityID = n.NodeID
      END
   LEFT JOIN UserMeasurableObject umo ON umo.MeasurableObjectID = mo.MeasurableObjectID
   LEFT JOIN SystemUser u ON u.UserID = umo.UserID
   WHERE (CASE WHEN pUserID IS NOT NULL THEN u.UserID = pUserID ELSE TRUE END)
      AND (CASE WHEN pUserID IS NOT NULL THEN umo.CanMeasureFlag = TRUE ELSE TRUE END)
   GROUP BY mo.MeasurableObjectID
      , ide.IdeID
      , ide.Name
      , ide.Description
      , ins.InstitutionID
      , ins.Name
      , ins.Description
      , n.NodeID
      , n.Name
      , n.Description
   ORDER BY IdeID
      , InstitutionID
      , NodeID;
        
END;
$$ LANGUAGE plpgsql;