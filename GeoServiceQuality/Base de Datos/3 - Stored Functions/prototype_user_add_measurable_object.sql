--DROP FUNCTION prototype_user_add_measurable_object(integer, integer)
CREATE OR REPLACE FUNCTION prototype_user_add_measurable_object
(
   pUserID INT
   , pMeasurableObjectID INT
)
RETURNS VOID AS $$
/************************************************************************************************************
** Name: prototype_user_add_measurable_object
**
** Desc: Asocia al usario un objeto medible a la lista de objetos medibles que este puede evaluar
**
** 21/02/2016 Created
**
*************************************************************************************************************/

BEGIN

   -- parametros requeridos
   IF (pUserID IS NULL OR pMeasurableObjectID IS NULL)
   THEN
      RAISE EXCEPTION 'Error - Los parametros ID de usuario e ID de Objeto Medible son requerido.';
   END IF;
    
   -- validacion Usuario
   IF NOT EXISTS (SELECT 1 FROM SystemUser u WHERE u.UserID = pUserID)
   THEN
      RAISE EXCEPTION 'Error - El Usuario seleccionado no es correcto.';
   END IF;
   
   -- validación de no existencia de relacion
   IF EXISTS 
      (
         SELECT 1 
         FROM UserMeasurableObject umo 
         WHERE umo.MeasurableObjectID = pMeasurableObjectID
            AND umo.UserID = pUserID
            AND umo.CanMeasureFlag = TRUE
      )
   THEN
      RAISE EXCEPTION 'Error - El Servicio Geografico ya puede ser evaluado por el usuario.';
   END IF;

   UPDATE UserMeasurableObject
   SET CanMeasureFlag = TRUE
   WHERE MeasurableObjectID = pMeasurableObjectID
      AND UserID = pUserID
      AND CanMeasureFlag = FALSE;
         
END;
$$ LANGUAGE plpgsql;