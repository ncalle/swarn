--DROP FUNCTION prototype_user_measurable_object_to_add_get(integer);
CREATE OR REPLACE FUNCTION prototype_user_measurable_object_to_add_get
(
   pUserID INT
)
RETURNS TABLE (
   MeasurableObjectID INT
   , EntityID INT
   , EntityType VARCHAR(11)
   , MeasurableObjectName VARCHAR(70)
   , MeasurableObjectDescription VARCHAR(100)
   , MeasurableObjectURL VARCHAR(1024)
   , MeasurableObjectServicesType CHAR(3)
) AS $$
/************************************************************************************************************
** Name: prototype_user_measurable_object_to_add_get
**
** Desc: Lista los objetos medibles que el usuario puede agregar a su lista de objetos que actualmente puede medir
**
** 21/02/2016 Created
**
*************************************************************************************************************/

BEGIN

   -- parametros requeridos
   IF (pUserID IS NULL)
   THEN
      RAISE EXCEPTION 'Error - El parametro ID de usuario es requerido.';
   END IF;
    
   -- validacion Usuario
   IF NOT EXISTS (SELECT 1 FROM SystemUser u WHERE u.UserID = pUserID)
   THEN
      RAISE EXCEPTION 'Error - El Usuario seleccionado no es correcto.';
   END IF;
   
   -- Lista de objetos medibles sobre los cuales el usuario puede realizar evaluaciones
   RETURN QUERY
   SELECT mo.MeasurableObjectID
      , mo.EntityID
      , mo.EntityType
      , CASE
         --WHEN mo.EntityType = 'Ide' THEN ide.Name
         --WHEN mo.EntityType = 'Institución' THEN ins.Name
         --WHEN mo.EntityType = 'Nodo' THEN n.Name
         --WHEN mo.EntityType = 'Capa' THEN l.Name
         WHEN mo.EntityType = 'Servicio' THEN NULL ::VARCHAR(70)
         END AS MeasurableObjectName
      , CASE
         --WHEN mo.EntityType = 'Ide' THEN ide.Description
         --WHEN mo.EntityType = 'Institución' THEN ins.Description
         --WHEN mo.EntityType = 'Nodo' THEN n.Description
         --WHEN mo.EntityType = 'Capa' THEN NULL
         WHEN mo.EntityType = 'Servicio' THEN sg.Description
         END AS MeasurableObjectDescription
      , CASE
         --WHEN mo.EntityType = 'Ide' THEN NULL
         --WHEN mo.EntityType = 'Institución' THEN NULL
         --WHEN mo.EntityType = 'Nodo' THEN NULL
         --WHEN mo.EntityType = 'Capa' THEN l.Url
         WHEN mo.EntityType = 'Servicio' THEN sg.Url
         END AS MeasurableObjectURL
      , CASE
         --WHEN mo.EntityType = 'Ide' THEN NULL
         --WHEN mo.EntityType = 'Institución' THEN NULL
         --WHEN mo.EntityType = 'Nodo' THEN NULL
         --WHEN mo.EntityType = 'Capa' THEN NULL
         WHEN mo.EntityType = 'Servicio' THEN sg.GeographicServicesType
         END AS MeasurableObjectServicesType
   FROM GeographicServices sg
   INNER JOIN MeasurableObject mo ON mo.EntityID = sg.GeographicServicesID AND mo.EntityType = 'Servicio'
   INNER JOIN UserMeasurableObject umo ON umo.MeasurableObjectID = mo.MeasurableObjectID
   WHERE mo.EntityType = 'Servicio'
      AND umo.UserID = pUserID
      AND umo.CanMeasureFlag = FALSE -- indica si el usuario puede evaluar el objeto en cuestion
   GROUP BY mo.MeasurableObjectID
      , mo.EntityID
      , mo.EntityType
      --, ide.Name
      --, ins.Name
      --, n.Name
      --, l.Name
      --, ide.Description
      --, ins.Description
      --, n.Description
      --, l.Url
      , sg.Description
      , sg.Url
      , sg.GeographicServicesType;
         
END;
$$ LANGUAGE plpgsql;