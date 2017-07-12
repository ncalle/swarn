INSERT INTO SystemUser (Email, Password, UserGroupID, FirstName, LastName, PhoneNumber, InstitutionID) VALUES 
('mgomez@mail.com', 'mgomez', 2, 'Micaela', 'Gomez', '099336253', 2),
('crodriguez@mail.com', 'crodriguez', 2, 'Celso', 'Rodriguez', '099532253', 3),
('cgutierrez@mail.com', 'cgutierrez', 3, 'Carlos', 'Gutierrez', '098962253', 4),
('jalamo@mail.com', 'jalamo', 3, 'Juan', 'Alamo', '098332253', 5),
('lilenfeld@mail.com', 'lilenfeld', 4, 'Luciana', 'Ilenfeld', '091332253', 6),
('jrodriguez@mail.com', 'jrodriguez', 4, 'Javier', 'Rodriguez', '099332253', 7),
('lsimaldone@mail.com', 'lsimaldone', 4, 'Luciano', 'Simaldone', '098715432', 8);

--Se cargan todos los objetos medibles existentes
INSERT INTO MeasurableObject (EntityID, EntityType)
SELECT gs.GeographicServicesID AS EntityID, 'Servicio' AS EntityType
FROM GeographicServices gs
UNION
SELECT l.LayerID AS EntityID, 'Capa' AS EntityType
FROM Layer l
UNION
SELECT n.NodeID AS EntityID, 'Nodo' AS EntityType
FROM Node n
UNION
SELECT i.InstitutionID AS EntityID, 'Institución' AS EntityType
FROM Institution i
UNION
SELECT ide.IdeID AS EntityID, 'Ide' AS EntityType
FROM Ide ide;

--Dar permisos de evaluación sobre todos los objetos medible existentes a los usuarios ncalle y rsanchez
INSERT INTO UserMeasurableObject (UserID, MeasurableObjectID, CanMeasureFlag)
SELECT u.UserID, mo.MeasurableObjectID, TRUE
FROM MeasurableObject mo
CROSS JOIN 
   (
      SELECT su.UserID
      FROM SystemUser su
      WHERE su.UserID IN (1,2)
   ) u;

--Negar permisos de evaluación sobre todos los objetos medible existentes a los usuarios que no sean ncalle o rsanchez
INSERT INTO UserMeasurableObject (UserID, MeasurableObjectID, CanMeasureFlag)
SELECT u.UserID, mo.MeasurableObjectID, FALSE
FROM MeasurableObject mo
CROSS JOIN 
   (
      SELECT su.UserID
      FROM SystemUser su
      WHERE su.UserID NOT IN (1,2)
   ) u;