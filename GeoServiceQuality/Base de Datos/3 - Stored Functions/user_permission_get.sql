CREATE OR REPLACE FUNCTION user_permission_get
(
   pUserID INT
)
RETURNS TABLE (UserID INT, UserGroupName VARCHAR(40), UserPermissionName VARCHAR(40)) AS $$

/************************************************************************************************************
** Name: user_permission_get
**
** Desc: Devuelve conjunto de permisos del usuario pasado por parametro
**
** 04/12/2016 Created
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

   -- Lista de datos personales y permisos sobre la herramienta
   RETURN QUERY
   SELECT u.UserID
      , g.Name AS UserGroupName
      , p.Name AS UserPermissionName
   FROM SystemUser u
   INNER JOIN UserGroup g ON g.UserGroupID = u.UserGroupID
   INNER JOIN GroupPermission pg ON pg.UserGroupID = g.UserGroupID
   INNER JOIN UserPermission p ON p.UserPermissionID = pg.UserPermissionID
   WHERE u.UserID = pUserID
   ORDER BY p.UserPermissionID;

END;
$$ LANGUAGE plpgsql;