--DROP FUNCTION institution_get()
CREATE OR REPLACE FUNCTION institution_get
(
    pInstitutionID INT
) 
RETURNS TABLE (InstitutionID INT, Name VARCHAR(70), Description VARCHAR(100)) AS $$

/************************************************************************************************************
** Name: institution_get
**
** Desc: Devuelve lista de Instituciones existentes registradas en la BD.
**
** 02/18/2016 - Created
**
*************************************************************************************************************/
BEGIN
  
   -- Lista las instituciones
   RETURN QUERY
   SELECT i.InstitutionID
      , i.Name
      , i.Description
   FROM Institution i
   WHERE i.InstitutionID = COALESCE(pInstitutionID,i.InstitutionID)
   ORDER BY i.InstitutionID ASC;
               
END;
$$ LANGUAGE plpgsql;