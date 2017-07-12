CREATE OR REPLACE FUNCTION prototype_measurable_objects_get
(
   pUserID INT
)
RETURNS TABLE 
   (
      MeasurableObjectID INT
      , EntityID INT
      , EntityType VARCHAR(11)
      , MeasurableObjectName VARCHAR(70)
      , MeasurableObjectDescription VARCHAR(100)
      , MeasurableObjectURL VARCHAR(1024)
      , MeasurableObjectServicesType CHAR(3)
 ) AS $$
/************************************************************************************************************
** Name: prototype_measurable_objects_get
**
** Desc: Devuelve la lista de objetos medibles disponibles. Si se pasa el usuario, entonces se filtra por el mismo
** Se debe ampliar a otros objetos medibles.
**
** 02/12/2016 - Created
**
*************************************************************************************************************/
BEGIN

   -- Lista de objetos medibles sobre los cuales el usuario puede realizar evaluaciones
   RETURN QUERY
   SELECT mo.MeasurableObjectID
      , mo.EntityID
      , mo.EntityType
      , CASE
         --WHEN mo.EntityType = 'Ide' THEN ide.Name
         --WHEN mo.EntityType = 'Institución' THEN ins.Name
         --WHEN mo.EntityType = 'Nodo' THEN n.Name
         WHEN mo.EntityType = 'Capa' THEN l.Name
         WHEN mo.EntityType = 'Servicio' THEN NULL ::VARCHAR(70)
         END AS MeasurableObjectName
      , CASE
         --WHEN mo.EntityType = 'Ide' THEN ide.Description
         --WHEN mo.EntityType = 'Institución' THEN ins.Description
         --WHEN mo.EntityType = 'Nodo' THEN n.Description
         WHEN mo.EntityType = 'Capa' THEN l.Description
         WHEN mo.EntityType = 'Servicio' THEN sg.Description
         END AS MeasurableObjectDescription
      , CASE
         --WHEN mo.EntityType = 'Ide' THEN NULL
         --WHEN mo.EntityType = 'Institución' THEN NULL
         --WHEN mo.EntityType = 'Nodo' THEN NULL
         WHEN mo.EntityType = 'Capa' THEN l.Url
         WHEN mo.EntityType = 'Servicio' THEN sg.Url
         END AS MeasurableObjectURL
      , CASE
         --WHEN mo.EntityType = 'Ide' THEN NULL
         --WHEN mo.EntityType = 'Institución' THEN NULL
         --WHEN mo.EntityType = 'Nodo' THEN NULL
         WHEN mo.EntityType = 'Capa' THEN NULL
         WHEN mo.EntityType = 'Servicio' THEN sg.GeographicServicesType
         END AS MeasurableObjectServicesType
   FROM MeasurableObject mo
   INNER JOIN UserMeasurableObject umo ON umo.MeasurableObjectID = mo.MeasurableObjectID
   LEFT JOIN GeographicServices sg ON mo.EntityID = sg.GeographicServicesID AND mo.EntityType = 'Servicio'
   LEFT JOIN Layer l ON mo.EntityID = l.LayerID AND mo.EntityType = 'Capa'
   LEFT JOIN SystemUser u ON u.UserID = umo.UserID
   WHERE (CASE WHEN pUserID IS NOT NULL THEN u.UserID = pUserID ELSE TRUE END)
      AND (CASE WHEN pUserID IS NOT NULL THEN umo.CanMeasureFlag = TRUE ELSE TRUE END)
      AND (mo.EntityType = 'Servicio' OR mo.EntityType = 'Capa')
   GROUP BY mo.MeasurableObjectID
      , mo.EntityID
      , mo.EntityType
      --, ide.Name
      --, ins.Name
      --, n.Name
      , l.Name
      , l.Description
      , l.Url
      --, ide.Description
      --, ins.Description
      --, n.Description
      , sg.Description
      , sg.Url
      , sg.GeographicServicesType
   ORDER BY mo.MeasurableObjectID;
        
END;
$$ LANGUAGE plpgsql;