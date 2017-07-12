--DROP FUNCTION measurable_objects_insert(character varying,integer,character varying,character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION measurable_objects_insert
(
   pEntityType VARCHAR(11) -- 'Ide', 'Institución', 'Nodo', 'Capa', 'Servicio'
   , pFatherEntityID INT
   , pMeasurableObjectName VARCHAR(70)
   , pMeasurableObjectDescription VARCHAR(100)
   , pMeasurableObjectURL VARCHAR(1024)
   , pMeasurableObjectServicesType VARCHAR(3)
)
RETURNS VOID AS $$
/************************************************************************************************************
** Name: measurable_objects_insert
**
** Desc: Agrega un objeto medible al sistema
**
** 22/03/2017 Created
**
*************************************************************************************************************/
DECLARE EntityID INT;
DECLARE MOID INT;

BEGIN

   IF (pEntityType IS NULL)
   THEN
      RAISE EXCEPTION 'Error - El ID de Entidad es requerido.';
   END IF;
   
   -- validacion NodoID
   IF pEntityType = 'Servicio' AND NOT EXISTS (SELECT 1 FROM Node n WHERE n.NodeID = pFatherEntityID)
   THEN
      RAISE EXCEPTION 'Error - El Nodo que se intenta asociar al Servicio no existe.';
   END IF;

   IF pEntityType = 'Ide'
   THEN
      INSERT INTO Ide
      (Name, Description)
      VALUES
      (pMeasurableObjectName, pMeasurableObjectDescription)
         RETURNING IdeID INTO EntityID;

      INSERT INTO MeasurableObject
      (EntityID, EntityType)
      VALUES
      (EntityID, pEntityType)
         RETURNING MeasurableObjectID INTO MOID;
   END IF;

   IF pEntityType = 'Institución'
   THEN
      INSERT INTO Institution
      (IdeID, Name, Description)
      VALUES
      (pFatherEntityID, pMeasurableObjectName, pMeasurableObjectDescription)
         RETURNING InstitutionID INTO EntityID;

      INSERT INTO MeasurableObject
      (EntityID, EntityType)
      VALUES
      (EntityID, pEntityType)
         RETURNING MeasurableObjectID INTO MOID;
   END IF;

   IF pEntityType = 'Nodo'
   THEN
      INSERT INTO Node
      (InstitutionID, Name, Description)
      VALUES
      (pFatherEntityID, pMeasurableObjectName, pMeasurableObjectDescription)
         RETURNING NodeID INTO EntityID;

      INSERT INTO MeasurableObject
      (EntityID, EntityType)
      VALUES
      (EntityID, pEntityType)
         RETURNING MeasurableObjectID INTO MOID;
   END IF;

   IF pEntityType = 'Capa'
   THEN
      INSERT INTO Layer
      (NodeID, Name, Url, Description)
      VALUES
      (pFatherEntityID, pMeasurableObjectName, pMeasurableObjectURL, pMeasurableObjectDescription)
         RETURNING LayerID INTO EntityID;

      INSERT INTO MeasurableObject
      (EntityID, EntityType)
      VALUES
      (EntityID, pEntityType)
         RETURNING MeasurableObjectID INTO MOID;
   END IF;

   IF pEntityType = 'Servicio'
   THEN
      INSERT INTO GeographicServices
      (NodeID, Url, GeographicServicesType, Description)
      VALUES
      (pFatherEntityID, pMeasurableObjectURL, pMeasurableObjectServicesType, pMeasurableObjectDescription)
         RETURNING GeographicServicesID INTO EntityID;

      INSERT INTO MeasurableObject
      (EntityID, EntityType)
      VALUES
      (EntityID, pEntityType)
         RETURNING MeasurableObjectID INTO MOID;
   END IF;
   
   --Se asocia el objeto medible a todos los usuario, dejandolo por defecto como NO disponible para medir
   INSERT INTO UserMeasurableObject
   (UserID, MeasurableObjectID, CanMeasureFlag)
   SELECT su.UserID, MOID, FALSE
   FROM SystemUser su;
         
END;
$$ LANGUAGE plpgsql;