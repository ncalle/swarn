--DROP FUNCTION user_get(integer,character varying,character varying)
CREATE OR REPLACE FUNCTION user_get
(
    pUserID INT
    , pEmail VARCHAR(40)
    , pPassword VARCHAR(40)
) 
RETURNS TABLE (UserID INT, InstitutionID INT, InstitutionName VARCHAR(70), Email VARCHAR(40), UserGroupID INT, UserGroupName VARCHAR(40), FirstName VARCHAR(40), LastName VARCHAR(40), PhoneNumber BIGINT) AS $$

/************************************************************************************************************
** Name: user_get
**
** Desc: Devuelve los datos personales del usuario pasado por parametro segun mail y password
** Si no se pasan parametros de entrada, entonces devuelve la lista de usuarios entera.
** Si se pasan alguno de los parametros de entrada (ej: Email y Password, o ID) entonces busca con dichos criterios
**
** 02/12/2016 - Created
**
*************************************************************************************************************/
BEGIN
  
   -- Lista de datos personales y permisos sobre la herramienta
   RETURN QUERY
   SELECT u.UserID
      , i.InstitutionID
      , i.Name AS InstitutionName
      , u.Email
      , ug.UserGroupID
      , ug.Name AS UserGroupName
      , u.FirstName
      , u.LastName
      , u.PhoneNumber
   FROM SystemUser u
   LEFT JOIN Institution i ON i.InstitutionID = u.InstitutionID
   LEFT JOIN UserGroup ug ON ug.UserGroupID = u.UserGroupID
   WHERE u.Email = COALESCE(pEmail, u.Email)
      AND u.Password = COALESCE(pPassword, u.Password)
      AND u.UserID = COALESCE(pUserID, u.UserID)
   ORDER BY u.UserID ASC;
               
END;
$$ LANGUAGE plpgsql;