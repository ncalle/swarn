--DROP FUNCTION prototype_user_remove_measurable_object(integer, integer);
CREATE OR REPLACE FUNCTION prototype_user_remove_measurable_object
(
   pUserID INT
   , pMeasurableObjectID INT
)
RETURNS VOID AS $$
/************************************************************************************************************
** Name: prototype_user_remove_measurable_object
**
** Desc: Remueve el objeto medible (Servicio Geografico) de la lista de objetos medibles disponibles para el usuario de ID pUserID
**
** 19/02/2016 Created
**
*************************************************************************************************************/
DECLARE v_EntityType VARCHAR(11);
DECLARE v_EntityID INT;

BEGIN

   -- parametros requeridos
   IF (pUserID IS NULL OR pMeasurableObjectID IS NULL)
   THEN
      RAISE EXCEPTION 'Error - Los parametros ID de usuario, Measurable ObjectID son requerido.';
   END IF;
    
   -- validacion Usuario
   IF NOT EXISTS (SELECT 1 FROM SystemUser u WHERE u.UserID = pUserID)
   THEN
      RAISE EXCEPTION 'Error - El Usuario que intenta eliminar el Servicio no es correcto.';
   END IF;
   
   SELECT mo.EntityType, mo.EntityID FROM MeasurableObject mo WHERE mo.MeasurableObjectID = pMeasurableObjectID INTO v_EntityType, v_EntityID;

   -- validacion Servicio Geografico
   IF (v_EntityType = 'Servicio')
      AND NOT EXISTS (SELECT 1 FROM GeographicServices sg WHERE sg.GeographicServicesID = v_EntityID)
   THEN
      RAISE EXCEPTION 'Error - El Servicio Geografico que se intenta eliminar no existe.';
   END IF;
   
   -- validacion de medicion de objeto
   IF EXISTS 
      (
         SELECT 1 
         FROM UserMeasurableObject umo 
         WHERE umo.MeasurableObjectID = pMeasurableObjectID
            AND umo.UserID = pUserID
            AND umo.CanMeasureFlag = FALSE
      )
   THEN
      RAISE EXCEPTION 'Error - El Servicio Geografico que se intenta remover ya no se encuentra habilitado para ser evaluado por el usuario.';
   END IF;

   UPDATE UserMeasurableObject
   SET CanMeasureFlag = FALSE
   WHERE MeasurableObjectID = pMeasurableObjectID
      AND UserID = pUserID
      AND CanMeasureFlag = TRUE;
         
END;
$$ LANGUAGE plpgsql;