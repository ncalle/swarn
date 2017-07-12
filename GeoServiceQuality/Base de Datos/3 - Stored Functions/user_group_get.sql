--DROP FUNCTION user_group_get()
CREATE OR REPLACE FUNCTION user_group_get
(
    pUserGroupID INT
) 
RETURNS TABLE (UserGroupID INT, Name VARCHAR(40), Description VARCHAR(100)) AS $$

/************************************************************************************************************
** Name: user_group_get
**
** Desc: Devuelve los grupos de usuarios disponibles. Tipos de administradores
**
** 02/16/2016 - Created
**
*************************************************************************************************************/
BEGIN
  
   -- Lista los tipos de usuarios administradores
   RETURN QUERY
   SELECT ug.UserGroupID
      , ug.Name
      , ug.Description
   FROM UserGroup ug
   WHERE ug.UserGroupID = COALESCE(pUserGroupID,ug.UserGroupID)
   ORDER BY ug.UserGroupID ASC;
               
END;
$$ LANGUAGE plpgsql;