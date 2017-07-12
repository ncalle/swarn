--DROP FUNCTION profile_get();
CREATE OR REPLACE FUNCTION profile_get()
RETURNS TABLE 
   (
      ProfileID INT
      , ProfileName VARCHAR(40)
      , ProfileGranurality VARCHAR(11)
      , ProfileIsWeightedFlag BOOLEAN
   ) AS $$
/************************************************************************************************************
** Name: profile_get
**
** Desc: Devuelve el conunto de Perfiles disponibles
**
** 08/12/2016 Created
**
*************************************************************************************************************/
BEGIN

   RETURN QUERY
   SELECT p.ProfileID
      , p.Name
      , p.Granurality
      , p.IsWeightedFlag
   FROM Profile p
   ORDER BY p.ProfileID;
         
END;
$$ LANGUAGE plpgsql;