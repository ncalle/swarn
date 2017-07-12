CREATE OR REPLACE FUNCTION user_update
(
   pUserID INT
   , pEmail VARCHAR(40)
   , pUserGroupID INT
   , pFirstName VARCHAR(40)
   , pLastName VARCHAR(40)
   , pPhoneNumber BIGINT
   , pInstitutionID INT
)
RETURNS VOID AS $$
/************************************************************************************************************
** Name: user_update
**
** Desc: Actualiza datos del Usuario con ID = pUserID
**
** 12/02/2017 - Created
**
*************************************************************************************************************/
BEGIN
   
   -- parametros requeridos
   IF (pUserID IS NULL)
   THEN
      RAISE EXCEPTION 'Error - El parametro ID de usuario es requerido.';
   END IF;
    
   IF NOT EXISTS (SELECT 1 FROM SystemUser u WHERE u.UserID = pUserID)
   THEN
      RAISE EXCEPTION 'Error - El usuario de ID: % no existe.', pUserID;
   END IF;

   -- Borrado del usuario de la tabla Usuario
   UPDATE SystemUser
   SET Email = pEmail
      , UserGroupID = pUserGroupID
      , FirstName = pFirstName
      , LastName = pLastName
      , PhoneNumber = pPhoneNumber
      , InstitutionID = pInstitutionID
   WHERE UserID = pUserID;
    
END;
$$ LANGUAGE plpgsql;