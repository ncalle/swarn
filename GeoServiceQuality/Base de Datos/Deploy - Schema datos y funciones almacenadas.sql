/* ****************************************************************************************************** */
/* 1 - SCHEMA TABLES                                                                                      */
/*        Se crean 22 tablas                                                                              */
/* 2 - DATOS DE CASO DE ESTUDIO                                                                           */
/*        Carga datos correspondientes al caso de estudio - IdeUy                                         */
/* 3 - DATOS DE PRUEBA                                                                                    */
/*        Carga datos de prueba                                                                           */
/* 4 - STORED FUNCTIONS                                                                                   */
/*        Se aplican 30 funciones almacenadas                                                             */
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
/*                                          1 - SCHEMA TABLES                                             */
/* ****************************************************************************************************** */ 
-- Contiene los distintos grupos de usuarios
DROP TABLE IF EXISTS UserGroup CASCADE;
CREATE TABLE UserGroup
(
    UserGroupID SERIAL NOT NULL,
    Name VARCHAR(40) NOT NULL,
    Description VARCHAR(100) NULL,
    
    PRIMARY KEY (UserGroupID),
    UNIQUE (Name)
);

-- Contiene una lista de los permisos de uso dentro de la aplicacion
DROP TABLE IF EXISTS UserPermission CASCADE;
CREATE TABLE UserPermission
(
    UserPermissionID SERIAL NOT NULL,
    Name VARCHAR(40) NOT NULL,
    Description VARCHAR(100) NULL,
    
    PRIMARY KEY (UserPermissionID),
    UNIQUE (Name)
);

-- Contiene los permisos habilitados para los grupos de usuarios
DROP TABLE IF EXISTS GroupPermission CASCADE;
CREATE TABLE GroupPermission
(
    UserPermissionID SMALLINT NOT NULL,
    UserGroupID INT NOT NULL,
    
    PRIMARY KEY (UserPermissionID, UserGroupID),
    FOREIGN KEY (UserPermissionID) REFERENCES UserPermission(UserPermissionID),
    FOREIGN KEY (UserGroupID) REFERENCES UserGroup(UserGroupID)
);

-- Contiene los Ides creadas
DROP TABLE IF EXISTS Ide CASCADE;
CREATE TABLE Ide
(
    IdeID SERIAL NOT NULL,
    Name VARCHAR(40) NOT NULL,
    Description VARCHAR(100) NULL,

    PRIMARY KEY (IdeID),
    UNIQUE (Name)
);

-- Contiene las Instituciones creadas
DROP TABLE IF EXISTS Institution CASCADE;
CREATE TABLE Institution
(
    InstitutionID SERIAL NOT NULL,
    IdeID INT NOT NULL,
    Name VARCHAR(70) NOT NULL,
    Description VARCHAR(100) NULL,

    PRIMARY KEY (InstitutionID),
    UNIQUE (Name),
    FOREIGN KEY (IdeID) REFERENCES Ide(IdeID)
);

-- Contiene los Nodos creados
DROP TABLE IF EXISTS Node CASCADE;
CREATE TABLE Node
(
    NodeID SERIAL NOT NULL,
    InstitutionID INT NOT NULL,
    Name VARCHAR(70) NOT NULL,
    Description VARCHAR(100) NULL,

    PRIMARY KEY (NodeID),
    UNIQUE (Name),
    FOREIGN KEY (InstitutionID) REFERENCES Institution(InstitutionID)
);

-- Contiene Capas que han sido cargadas por el sistema
DROP TABLE IF EXISTS Layer CASCADE;
CREATE TABLE Layer
(
    LayerID SERIAL NOT NULL,
    NodeID INT NOT NULL,
    Name VARCHAR(70) NOT NULL,
    Url VARCHAR(1024) NULL,
    Description VARCHAR(100) NULL,

    PRIMARY KEY (LayerID),
--    UNIQUE (Name),
    FOREIGN KEY (NodeID) REFERENCES Node(NodeID)
);

-- Contiene los Servicios Geograficos creados
DROP TABLE IF EXISTS GeographicServices CASCADE;
CREATE TABLE GeographicServices
(
    GeographicServicesID SERIAL NOT NULL,
    NodeID INT NOT NULL,
    Url VARCHAR(1024) NOT NULL,
    GeographicServicesType CHAR(3) NOT NULL, -- WMS, WFS, CSW
    Description VARCHAR(100) NULL,
    -- Metadato XML
    
    PRIMARY KEY (GeographicServicesID),
    UNIQUE (Url),
    FOREIGN KEY (NodeID) REFERENCES Node(NodeID),
    CONSTRAINT CK_GeographicServicesType_values CHECK (GeographicServicesType IN ('WMS','WFS','CSW'))
);

-- Usuarios que haran uso de la aplicacion
DROP TABLE IF EXISTS SystemUser CASCADE;
CREATE TABLE SystemUser
(
    UserID SERIAL NOT NULL,
    Email VARCHAR(40) NOT NULL,
    Password VARCHAR(40) NOT NULL,
    UserGroupID INT NOT NULL,
    FirstName VARCHAR(40) NULL,
    LastName VARCHAR(40) NULL,
    PhoneNumber BIGINT NULL,
    InstitutionID INT NOT NULL, -- Institucion a la cual pertenece el usuario

    PRIMARY KEY (UserID),
    UNIQUE (Email),
    FOREIGN KEY (UserGroupID) REFERENCES UserGroup(UserGroupID),
    FOREIGN KEY (InstitutionID) REFERENCES Institution(InstitutionID)
);

-- Contiene todos los objetos medibles ('Ide', 'Institución', 'Nodo', 'Capa', 'Servicio')
DROP TABLE IF EXISTS MeasurableObject CASCADE;
CREATE TABLE MeasurableObject
(
    MeasurableObjectID SERIAL NOT NULL,
    EntityID SERIAL NOT NULL,
    EntityType VARCHAR(11) NOT NULL, -- 'Ide', 'Institución', 'Nodo', 'Capa', 'Servicio'

    PRIMARY KEY (MeasurableObjectID),
    UNIQUE (EntityID, EntityType),
    CONSTRAINT CK_EntityType_values CHECK (EntityType IN ('Ide', 'Institución', 'Nodo', 'Capa', 'Servicio')) -- en castellano, debido a que dicho dato se mostrará al usuario
);

-- Contiene los objetos medibles que el usuario puede o no evaluar
DROP TABLE IF EXISTS UserMeasurableObject CASCADE;
CREATE TABLE UserMeasurableObject
(
    UserMeasurableObjectID SERIAL NOT NULL,
    UserID INT NOT NULL,
    MeasurableObjectID INT NOT NULL,
    CanMeasureFlag BOOLEAN NOT NULL, -- indica si el usuario puede evaluar el objeto en cuestion

    PRIMARY KEY (UserMeasurableObjectID),
    UNIQUE (UserID, MeasurableObjectID),
    FOREIGN KEY (UserID) REFERENCES SystemUser(UserID),
	FOREIGN KEY (MeasurableObjectID) REFERENCES MeasurableObject(MeasurableObjectID)
);

-- Contiene los distintos Perfiles que se vayan creando
DROP TABLE IF EXISTS Profile CASCADE;
CREATE TABLE Profile
(
    ProfileID SERIAL NOT NULL,
    Name VARCHAR(40) NOT NULL,
    Granurality VARCHAR(11) NOT NULL, -- 'Ide', 'Institución', 'Nodo', 'Capa', 'Servicio',
    IsWeightedFlag BOOLEAN NOT NULL, -- indica si el perfil es ponderado o no

    PRIMARY KEY (ProfileID),
    UNIQUE (Name),
    CONSTRAINT CK_vGranurality_values CHECK (Granurality IN ('Ide', 'Institución', 'Nodo', 'Capa', 'Servicio')) -- en castellano, debido a que dicho dato se mostrará al usuario
);

-- Contiene los distintos modelo de calidad existentes en el sistema
DROP TABLE IF EXISTS QualityModel CASCADE;
CREATE TABLE QualityModel
(
    QualityModelID SERIAL NOT NULL,
    Name VARCHAR(40) NOT NULL,

    PRIMARY KEY (QualityModelID),
    UNIQUE (Name)
);

-- Contiene las Dimensiones del modelo de calidad
DROP TABLE IF EXISTS Dimension CASCADE;
CREATE TABLE Dimension
(
    DimensionID SERIAL NOT NULL,
    QualityModelID INT NOT NULL,
    Name VARCHAR(40) NOT NULL,

    PRIMARY KEY (DimensionID),
    UNIQUE (Name),
    FOREIGN KEY (QualityModelID) REFERENCES QualityModel(QualityModelID)
);

-- Contiene los Factores del modelo de calidad
DROP TABLE IF EXISTS Factor CASCADE;
CREATE TABLE Factor
(
    FactorID SERIAL NOT NULL,
    DimensionID INT NOT NULL,
    Name VARCHAR(40) NOT NULL,

    PRIMARY KEY (FactorID),
    UNIQUE (Name),    
    FOREIGN KEY (DimensionID) REFERENCES Dimension(DimensionID)
);

-- Contiene las unidades utilizadas para medir cada una de las metricas de calidad
DROP TABLE IF EXISTS Unit CASCADE;
CREATE TABLE Unit
(
    UnitID SERIAL NOT NULL,
    Name VARCHAR(40) NOT NULL,
    Description VARCHAR(100) NULL,

    PRIMARY KEY (UnitID),
    UNIQUE (Name)
);

-- Contiene las Metricas del modelo de calidad
DROP TABLE IF EXISTS Metric CASCADE;
CREATE TABLE Metric
(
    MetricID SERIAL NOT NULL,
    FactorID INT NOT NULL,
    Name VARCHAR(100) NOT NULL,
    AgrgegationFlag BOOLEAN NOT NULL,
    UnitID INT NOT NULL,
    Granurality VARCHAR(11) NOT NULL, -- 'Ide', 'Institución', 'Nodo', 'Capa', 'Servicio', 'Método'
    Description VARCHAR(100) NULL,
	IsManual BOOLEAN NULL, -- 'true' si es de evaluacion manual
	IsUserMetric BOOLEAN NULL, --'true' si la metrica fue dada de alta por un usuario
	MetricFileName VARCHAR(100) NULL,

    PRIMARY KEY (MetricID),
    UNIQUE (Name),
	UNIQUE (MetricFileName),
    FOREIGN KEY (FactorID) REFERENCES Factor(FactorID),
    FOREIGN KEY (UnitID) REFERENCES Unit(UnitID),
    CONSTRAINT CK_Granularity_values CHECK (Granurality IN ('Ide', 'Institución', 'Nodo', 'Capa', 'Servicio', 'Método')) -- en castellano, debido a que dicho dato se mostrará al usuario
);

-- Contiene los rangos asignados a las Metricas del modelo de calidad, para cierto perfil
DROP TABLE IF EXISTS MetricRange CASCADE;
CREATE TABLE MetricRange
(
    MetricRangeID SERIAL NOT NULL,
    MetricID INT NOT NULL,
    ProfileID INT NOT NULL,
    BooleanFlag BOOLEAN NULL,
    BooleanAcceptanceValue BOOLEAN NULL,
    PercentageFlag BOOLEAN NULL,
    PercentageAcceptanceValue INT NULL,
    IntegerFlag BOOLEAN NULL,
    IntegerAcceptanceValue INT NULL,
    EnumerateFlag BOOLEAN NULL,
    EnumerateAcceptanceValue CHAR(1) NULL, -- 'B' = Basico, 'I' = Intermedio, 'C' = Completo
    
    PRIMARY KEY (MetricRangeID),
    UNIQUE (MetricID, ProfileID),
    CONSTRAINT CK_EnumerateAcceptanceValue_values CHECK (EnumerateAcceptanceValue IN ('B', 'I', 'C')),   
    CONSTRAINT CK_Flags_values CHECK
        (
            CASE WHEN BooleanFlag = TRUE AND BooleanAcceptanceValue IS NOT NULL 
                AND PercentageFlag = FALSE AND PercentageAcceptanceValue IS NULL
                AND IntegerFlag = FALSE AND IntegerAcceptanceValue IS NULL
                AND EnumerateFlag = FALSE AND EnumerateAcceptanceValue IS NULL
                    THEN 1 ELSE 0 END
            + CASE WHEN PercentageFlag = TRUE AND PercentageAcceptanceValue IS NOT NULL 
                AND BooleanFlag = FALSE AND BooleanAcceptanceValue IS NULL
                AND IntegerFlag = FALSE AND IntegerAcceptanceValue IS NULL
                AND EnumerateFlag = FALSE AND EnumerateAcceptanceValue IS NULL
                    THEN 1 ELSE 0 END
            + CASE WHEN IntegerFlag = TRUE AND IntegerAcceptanceValue IS NOT NULL 
                AND BooleanFlag = FALSE AND BooleanAcceptanceValue IS NULL
                AND PercentageFlag = FALSE AND PercentageAcceptanceValue IS NULL
                AND EnumerateFlag = FALSE AND EnumerateAcceptanceValue IS NULL   
                    THEN 1 ELSE 0 END
            + CASE WHEN EnumerateFlag = TRUE AND EnumerateAcceptanceValue IS NOT NULL 
                AND BooleanFlag = FALSE AND BooleanAcceptanceValue IS NULL
                AND PercentageFlag = FALSE AND PercentageAcceptanceValue IS NULL
                AND IntegerFlag = FALSE AND IntegerAcceptanceValue IS NULL 
		    THEN 1 ELSE 0 END
            = 1
        ),
    FOREIGN KEY (MetricID) REFERENCES Metric(MetricID),
    FOREIGN KEY (ProfileID) REFERENCES Profile(ProfileID)
);

-- Guarda las ponderaciones asignadas al Perfil y a los elementos de la jerarquia del modelo de calidad
DROP TABLE IF EXISTS Weighing CASCADE;
CREATE TABLE Weighing
(
    WeighingID SERIAL NOT NULL,
    ProfileID INT NOT NULL,
    ElementID INT NOT NULL, -- QualityModelID, DimensionID, FactorID, MetricID, MetricRangeID
    ElementType CHAR(1) NOT NULL, -- 'Q' = QualityModel, 'D' = Dimension, 'F' = Factor, 'M' = Metrica, 'R' = Rango
    NumeratorValue INT NOT NULL,
	DenominatorValue INT NULL,

    PRIMARY KEY (WeighingID),
    UNIQUE (ProfileID, ElementID, ElementType),    
    FOREIGN KEY (ProfileID) REFERENCES Profile(ProfileID),
    CONSTRAINT CK_ElementType_values CHECK (ElementType IN ('Q', 'D', 'F', 'M', 'R')),
	CONSTRAINT CK_Denominator_values CHECK (DenominatorValue != 0)
);

-- Contiene un resumen por perfil de cada evaluacion realizada
DROP TABLE IF EXISTS EvaluationSummary CASCADE;
CREATE TABLE EvaluationSummary
(
    EvaluationSummaryID SERIAL NOT NULL,
    UserID INT NOT NULL,
    ProfileID INT NOT NULL,
    MeasurableObjectID INT NOT NULL,
    SuccessFlag BOOLEAN NULL, -- indica si el resultado de las evaluaciones fueron exitosas
    SuccessPercentage INT, -- indica que porcentaje de las evaluaciones fueron exitosas	

    PRIMARY KEY (EvaluationSummaryID),
    FOREIGN KEY (UserID) REFERENCES SystemUser(UserID),
    FOREIGN KEY (ProfileID) REFERENCES Profile(ProfileID),
    FOREIGN KEY (MeasurableObjectID) REFERENCES MeasurableObject(MeasurableObjectID)
);

-- Contiene un resumen por perfil de cada evaluacion realizada
DROP TABLE IF EXISTS EvaluationPeriodic CASCADE;
CREATE TABLE EvaluationPeriodic
(
    EvaluationSummaryID INT NOT NULL,
    MeasurableObjectUrl VARCHAR(1024) NOT NULL,
    EvaluatedCount INT,
	Periodic DATE,
	SuccessCount INT,
    SuccessPercentage INT,
	MeasurableObjectDesc VARCHAR(1024) NOT NULL,
	UserID INT

    --FOREIGN KEY (EvaluationSummaryID),
    --FOREIGN KEY (MeasurableObjectUrl)
    --FOREIGN KEY (ProfileID) REFERENCES Profile(ProfileID),
    --FOREIGN KEY (MeasurableObjectID) REFERENCES MeasurableObject(MeasurableObjectID)
);

-- Contiene el resultado de cada evaluacion en particular
DROP TABLE IF EXISTS Evaluation CASCADE;
CREATE TABLE Evaluation
(
    EvaluationID SERIAL NOT NULL,
    EvaluationSummaryID INT NOT NULL,
    MetricID INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NULL,
    IsEvaluationCompletedFlag BOOLEAN NOT NULL,
    SuccessFlag BOOLEAN NULL, -- indica si el resultado de la evaluacion fue exitosa
	EvaluationCount INT,      -- indica la cantidaad de evaluaciones realizadas hasta el momento
	EvaluationApprovedValues INT,

    PRIMARY KEY (EvaluationID),
    FOREIGN KEY (EvaluationSummaryID) REFERENCES EvaluationSummary(EvaluationSummaryID),
    FOREIGN KEY (MetricID) REFERENCES Metric(MetricID)
);

-- Contiene el resultado parcial de las evaluaciones que aun no han finalizado
DROP TABLE IF EXISTS PartialEvaluation CASCADE;
CREATE TABLE PartialEvaluation
(
    PartialEvaluationID SERIAL NOT NULL,
    EvaluationID INT NOT NULL,
    ExecutionDate DATE NOT NULL,
    PartialSuccessFlag BOOLEAN NULL, -- indica si el resultado de la evaluacion parcial fue exitosa

    PRIMARY KEY (PartialEvaluationID),
    UNIQUE (EvaluationID, ExecutionDate),
    FOREIGN KEY (EvaluationID) REFERENCES Evaluation(EvaluationID)
);
/* ****************************************************************************************************** */
/*                                      FIN - 1 - SCHEMA TABLES                                           */
/* ****************************************************************************************************** */ 
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
/*                                    2 - DATOS DE CASO DE ESTUDIO                                        */
/* ****************************************************************************************************** */ 
INSERT INTO UserGroup (Name, Description) VALUES
('Administrador Tecnico','Usuario administrador que tiene completo acceso a todas las funcionalidades.'),
('Administrador General','Usuario con el fin de realizar gestion y cuidado de la herramienta.'),
('Administrador IDE','Usuario que tiene como cometido realizar evaluaciones sobre IDEs.'),
('Administrador Institucional','Usuario que tiene como cometido realizar evaluaciones sobre Instituciones.');

-- Permisos
INSERT INTO UserPermission (Name, Description) VALUES
('Alta de Usuario','Alta de Usuario'),
('Baja de Usuario','Baja de Usuario'),
('Modificacion de Usuario','Modificacion de Usuario'),
('Alta de Perfil','Alta de Perfil de evaluacion'),
('Baja de Perfil','Baja de Perfil de evaluacion'),
('Modificacion de Perfil','Modificacion de Perfil de evaluacion'),
('Alta de objeto medible','Alta de objetos medibles'),
('Baja de objeto medible','Baja de objetos medibles'),
('Modificacion de objeto medible','Modificacion de objetos medibles'),
('Alta de modelo','Alta de modelo de calidad'),
('Baja de modelo','Baja de modelo de calidad'),
('Modificacion de modelo','Modificacion de modelo de calidad'),
('Evaluacion de objeto medible','Evaluacion de objetos medibles');

INSERT INTO GroupPermission (UserPermissionID, UserGroupID)
SELECT p.UserPermissionID, 1 -- Tecnico
FROM UserPermission p
UNION
SELECT p.UserPermissionID, 2 -- General
FROM UserPermission p
WHERE p.UserPermissionID IN (13) --Evaluacion
UNION
SELECT p.UserPermissionID, 3 -- IDE
FROM UserPermission p
WHERE p.UserPermissionID IN (13) --Evaluacion
UNION
SELECT p.UserPermissionID, 4 -- Institucion
FROM UserPermission p
WHERE p.UserPermissionID IN (13); --Evaluacion

INSERT INTO QualityModel (Name) VALUES
('ModeloIDEuy');

INSERT INTO Dimension (QualityModelID, Name) VALUES
(1, 'Seguridad'),
(1, 'Confiabilidad'),
(1, 'Interoperabilidad'),
(1, 'Publicación de Datos'),
(1, 'Metadatos'),
(1, 'Usabilidad');
--(1, 'Rendimiento')

INSERT INTO Factor (DimensionID, Name) VALUES
(1, 'Protección'),
(2, 'Disponibilidad'),
(3, 'Soporte de estándares'),
(3, 'Sistema de referencias'),
(4, 'Formatos soportados'),
(5, 'Metadatos Servicio'),
(6, 'Facilidad de aprendizaje');
--(5, 'Publicación Catálogo'),
--(5, 'Metadatos Capa'),
--(4, 'Representación Gráfica'),
--(2, 'Robustez'),
--(1, 'Ingegridad'),
--(7, 'Tiempo de respuesta'),
--(7, 'Capacidad')

INSERT INTO Unit (Name, Description) VALUES 
('Boleano',''),
('Porcentaje',''),
('Milisegundos',''),
('Basico-Intermedio-Completo',''),
('Entero','');

-- No cambiar orden de las metricas, ya que estan mapeadas segun el id
INSERT INTO Metric (FactorID, Name, AgrgegationFlag, UnitID, Granurality, IsManual, IsUserMetric, MetricFileName) VALUES
(1, 'Información en excepciones', FALSE, 1, 'Servicio', FALSE, FALSE, NULL),
(3, 'Excepciones en formato OGC', FALSE, 1, 'Servicio', FALSE, FALSE, NULL),
(4, 'Capas del servicio con CRS adecuado (IDEuy)', FALSE, 2, 'Servicio', FALSE, FALSE, NULL),
(4, 'Capa con CRS Adecuado (IDEuy)', FALSE, 1, 'Capa', FALSE, FALSE, NULL),
(5, 'Formato PNG', FALSE, 1, 'Método', FALSE, FALSE, NULL),
(5, 'Formato KML', FALSE, 1, 'Método', FALSE, FALSE, NULL),
(5, 'Formato text/html metodo getFeatureInfo', FALSE, 1, 'Método', FALSE, FALSE, NULL),
(5, 'Formato Excepcion application/vnd.ogc.se_inimage', FALSE, 1, 'Método', FALSE, FALSE, NULL),
(5, 'Formato Excepcion application/vnd.ogc.se_blank', FALSE, 1, 'Método', FALSE, FALSE, NULL),
(5, 'Cantidad de formatos soportados', FALSE, 5, 'Servicio', FALSE, FALSE, NULL),
(5, 'Cantidad de formatos de excepciones soportadas', FALSE, 5, 'Servicio', FALSE, FALSE, NULL),
(6, 'Leyenda de la Capa', FALSE, 1, 'Servicio', FALSE, FALSE, NULL),
(6, 'Específica Rango Util', FALSE, 1, 'Capa', FALSE, FALSE, NULL),
(7, 'Errores descriptivos', FALSE, 1, 'Servicio', TRUE, FALSE, NULL),
(2, 'Disponibilidad diaria del servicio', FALSE, 2, 'Servicio', FALSE, FALSE, NULL);
--(4, 'Tolerancia a parametros nulos', FALSE, 1, 'Método', FALSE, NULL),
--(4, 'Tolerancia a parametros largos', FALSE, 1, 'Método', FALSE, NULL),
--(5, 'Promedio tiempo de respuesta diario', FALSE, 3, 'Método', FALSE, NULL),
--(7, 'Adopcion del estandar OGC', FALSE, 4, 'Servicio', FALSE, NULL),
--(1, 'Integridad de datos', FALSE, 1, 'Nodo', FALSE, NULL),
--(11, 'Contiene servicio CSW', FALSE, 1, 'Institución', FALSE, NULL),
--(12, 'Fecha del dato', FALSE, 2, 'Institución', FALSE, NULL),

INSERT INTO Ide (Name, Description) VALUES
('ide.uy','Infraestructura de Datos Espaciales del Uruguay');

INSERT INTO Institution (IdeID, Name, Description) VALUES
(1, 'Presidencia', 'Presidencia de la República'),
(1, 'Ministerio de Defensa Nacional', 'Ministerio de Defensa Nacional'),
(1, 'MIDES', 'Ministerio de Desarrollo Social'),
(1, 'Ministerio de Economía y Finanzas', 'Ministerio de Economía y Finanzas'),
(1, 'Ministerio de Ganadería, Agricultura y Pesca', 'Ministerio de Ganadería, Agricultura y Pesca'),
(1, 'MIEM', 'Ministerio de Industria, Energía y Minería'),
(1, 'MTOP', 'Ministerio de Transporte y Obras Públicas'),
(1, 'Ministerio de Vivienda, Ordenamiento Territorial y Medio Ambiente', 'Ministerio de Vivienda, Ordenamiento Territorial y Medio Ambiente'),
(1, 'Montevideo', 'Intendencia de Montevideo');

INSERT INTO Node (InstitutionID, Name, Description) VALUES
(1, 'INE', 'Instituto Nacional de Estadística'),
(1, 'SINAE', 'Sistema Nacional de Emergencia'),
(1, 'UNASEV', 'Unidad de Seguridad Vial'),
(2, 'Servicio Geográfico Militar', 'Servicio Geográfico Militar'),
(3, 'MIDES', 'Ministerio de Desarrollo Social'),
(4, 'DNC', 'Dirección Nacional de Catastro'),
(5, 'RENARE', 'Dirección Nacional de Recursos Renovables'),
(6, 'Dirección Nacional de Minería y Geología', 'Dirección Nacional de Minería y Geología'),
(7, 'Dirección Nacional de Topografía', 'Direción Nacional de Topografía'),
(8, 'DINAMA', 'Dirección Nacional de Medio Ambiente'),
(8, 'DINOT', 'Dirección Nacional de Ordenamiento Territorial'),
(9, 'Servicio de Geomática', 'Servicio de Geomática'); 


INSERT INTO Profile (Name, Granurality, IsWeightedFlag) VALUES
('Perfil Servicio Básico', 'Servicio', FALSE),
('Perfil Servicio Avanzado', 'Servicio', FALSE),
('Perfil Capa Basico', 'Capa', FALSE),
('Perfil Nodo Basico', 'Nodo', FALSE),
('Perfil Institucion Basico', 'Institución', FALSE),
('Perfil Ide Basico', 'Ide', FALSE);

INSERT INTO MetricRange (MetricID, ProfileID, BooleanFlag, BooleanAcceptanceValue, PercentageFlag, PercentageAcceptanceValue, IntegerFlag, IntegerAcceptanceValue, EnumerateFlag, EnumerateAcceptanceValue) VALUES
(1, 1, TRUE, TRUE, FALSE, NULL, FALSE, NULL, FALSE, NULL), -- perfil servicio basico
(2, 1, TRUE, TRUE, FALSE, NULL, FALSE, NULL, FALSE, NULL),
(1, 2, TRUE, TRUE, FALSE, NULL, FALSE, NULL, FALSE, NULL), -- perfil servicio avanzado
(2, 2, TRUE, TRUE, FALSE, NULL, FALSE, NULL, FALSE, NULL),
(3, 2, FALSE, NULL, TRUE, 20, FALSE, NULL, FALSE, NULL),
(10, 2, FALSE, NULL, FALSE, NULL, TRUE, 1, FALSE, NULL),
(11, 2, FALSE, NULL, FALSE, NULL, TRUE, 1, FALSE, NULL),
(15, 2, FALSE, NULL, TRUE, 50, FALSE, NULL, FALSE, NULL),
(4, 3, TRUE, TRUE, FALSE, NULL, FALSE, NULL, FALSE, NULL), -- perfil capa basico
(13, 3, TRUE, TRUE, FALSE, NULL, FALSE, NULL, FALSE, NULL),
(1, 4, TRUE, TRUE, FALSE, NULL, FALSE, NULL, FALSE, NULL), -- perfil nodo basico
(2, 4, TRUE, TRUE, FALSE, NULL, FALSE, NULL, FALSE, NULL),
(3, 4, FALSE, NULL, TRUE, 20, FALSE, NULL, FALSE, NULL),
(10, 4, FALSE, NULL, FALSE, NULL, TRUE, 1, FALSE, NULL),
(11, 4, FALSE, NULL, FALSE, NULL, TRUE, 1, FALSE, NULL),
(2, 5, TRUE, TRUE, FALSE, NULL, FALSE, NULL, FALSE, NULL), -- perfil institucion
(10, 5, FALSE, NULL, FALSE, NULL, TRUE, 1, FALSE, NULL),
(11, 5, FALSE, NULL, FALSE, NULL, TRUE, 1, FALSE, NULL),
(2, 6, TRUE, TRUE, FALSE, NULL, FALSE, NULL, FALSE, NULL), -- perfil ide
(10, 6, FALSE, NULL, FALSE, NULL, TRUE, 1, FALSE, NULL),
(11, 6, FALSE, NULL, FALSE, NULL, TRUE, 1, FALSE, NULL);

INSERT INTO Layer (NodeID, Name, Url, Description) VALUES
--UNASEV
(3, '0', 'http://gissrv.unasev.gub.uy/arcgis/services/UNASEV/srvUNASEVWFS/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', ''), 
--Servicio G. Militar
(4, 'ESTACIONAMIENTO_AQ140-PCN10', 'http://geoservicios.sgm.gub.uy/UYAR.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', ''),
(4, 'ISLA_ISLOTE_BA030-PCN10', 'http://geoservicios.sgm.gub.uy/UYAR.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', ''),
(4, 'LAGUNA_LAGO_BH080-PCN10', 'http://geoservicios.sgm.gub.uy/UYAR.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', ''),
(4, 'PLACA_GIRATORIA_AN075-PCN10', 'http://geoservicios.sgm.gub.uy/UYAR.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', ''), 
(4, 'PLAZA_AL170-PCN10', 'http://geoservicios.sgm.gub.uy/UYAR.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', ''), 
(4, 'PRADERA-CHILCAL_EB015-PCN10', 'http://geoservicios.sgm.gub.uy/UYAR.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', ''),
(4, 'PUENTE_A-AQ040-PCN10', 'http://geoservicios.sgm.gub.uy/UYAR.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', ''), 
(4, 'REPRESA_A-BI020-PCN10', 'http://geoservicios.sgm.gub.uy/UYAR.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', ''),
(4, 'PLANTA_PROCESAMIENTO-AC000-PCN10', 'http://geoservicios.sgm.gub.uy/UYAR.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', ''), 
(4, 'RIO_ARROYO_A-BH140_PCN10', 'http://geoservicios.sgm.gub.uy/UYAR.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', ''),
(4, 'SILO-AM020_PCN10', 'http://geoservicios.sgm.gub.uy/UYAR.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', ''), 
(4, 'VEGETACION_MIXTA_EE000-PCN10', 'http://geoservicios.sgm.gub.uy/UYAR.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', ''),
(4, 'CONSTRUCCION_AL015-PCN10', 'http://geoservicios.sgm.gub.uy/UYAR.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', ''), 
(4, 'CANTERO_AL117-PCN10', 'http://geoservicios.sgm.gub.uy/UYAR.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', ''),
(4, 'CANAL_L-BH020-PCN10', 'http://geoservicios.sgm.gub.uy/UYAR.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', ''),
(4, 'CERCO_ALAMBRADA_AL070-PCN10', 'http://geoservicios.sgm.gub.uy/UYAR.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', ''), 
(4, 'HUELLA_SENDA_AP010-PCN10', 'http://geoservicios.sgm.gub.uy/UYAR.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', ''),
(4, 'BARRANCA_DB010-PCN10', 'http://geoservicios.sgm.gub.uy/UYAR.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', ''), 
(4, 'VIAFERREA_AN010-PCN10', 'http://geoservicios.sgm.gub.uy/UYAR.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', ''),
(4, 'PASO_BH070-PCN10', 'http://geoservicios.sgm.gub.uy/UYAR.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', ''), 
(4, 'RIO_ARROYO_L-BH140-PCN10', 'http://geoservicios.sgm.gub.uy/UYAR.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', ''),
(4, 'TERRAPLEN-DB090-PCN10', 'http://geoservicios.sgm.gub.uy/UYAR.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', ''),
(4, 'ALCANTARILLA_L-AQ065-PCN10', 'http://geoservicios.sgm.gub.uy/UYAR.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', ''), 
(4, 'CAMINOS_AP030-PCN10', 'http://geoservicios.sgm.gub.uy/UYAR.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', ''),
(4, 'CURVA_NIVEL_CA010-PCN10', 'http://geoservicios.sgm.gub.uy/UYAR.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', ''),
--RENARE;
(7, '0', 'http://web.renare.gub.uy/arcgis/services/SUELOS/MOSAICO_FOTOPLANOS/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', ''),
(7, '0', 'http://web.renare.gub.uy/arcgis/services/TEMATICOS/IntConeat/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', ''),
(7, '0', 'http://web.renare.gub.uy/arcgis/services/SUELOS/SUELOS/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', 'Departamentos'),
(7, '1', 'http://web.renare.gub.uy/arcgis/services/SUELOS/SUELOS/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', 'Relieve'),
(7, '2', 'http://web.renare.gub.uy/arcgis/services/SUELOS/SUELOS/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities', 'Carta de Suelos 1 millon');

--ide.uy/Presidencia de la República/Unidad de Seguridad Vial
   --http://aplicaciones.unasev.gub.uy/mapas/Descarga/Descarga
INSERT INTO GeographicServices (NodeID, Url, GeographicServicesType, Description) VALUES
(3,'http://gissrv.unasev.gub.uy/arcgis/services/UNASEV/srvUNASEVWFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.3.0&REQUEST=GetCapabilities','WFS', 'Siniestros Fatales'),
(3,'http://gissrv.unasev.gub.uy/arcgis/services/UNASEV/srvUNASEVWFS/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Siniestros Fatales');

--ide.uy/Ministerio de Defensa Nacional/Servicio Geográfico Militar
   --http://www.sgm.gub.uy/geoportal/index.php/geoservicios/listado-de-servicios
INSERT INTO GeographicServices (NodeID, Url, GeographicServicesType, Description) VALUES
(4,'http://geoservicios.sgm.gub.uy/UYAR.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Artigas - Artigas'),
(4,'http://geoservicios.sgm.gub.uy/DPTO_UYAR.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Artigas - Otros'),
(4,'http://geoservicios.sgm.gub.uy/UYCA.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Canelones - Canelones'),
(4,'http://geoservicios.sgm.gub.uy/DPTO_UYCA.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Canelones - Otros'),
(4,'http://geoservicios.sgm.gub.uy/UYCL.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Cerro Largo - Melo'),
(4,'http://geoservicios.sgm.gub.uy/DPTO_UYCL.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Cerro Largo - Otros'),
(4,'http://geoservicios.sgm.gub.uy/UY_Landsat.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Cobertura Nacional - Mosaico de imagenes'),
(4,'http://geoservicios.sgm.gub.uy/SGMVectorial.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Cobertura Nacional'),
(4,'http://geoservicios.sgm.gub.uy/SGMRaster.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Cobertura Nacional - PCN50'),
(4,'http://geoservicios.sgm.gub.uy/wfsPCN1000.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WFS', 'Cobertura Nacional'),
(4,'http://geoservicios.sgm.gub.uy/UYCO.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Colonia - Colonia del Sacramento'),
(4,'http://geoservicios.sgm.gub.uy/PCN25_N27a.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Colonia - Boca del Rosario'),
(4,'http://geoservicios.sgm.gub.uy/DPTO_UYCO.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Colonia - Otros'),
(4,'http://geoservicios.sgm.gub.uy/UYDU.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Durazno - Durazno'),
(4,'http://geoservicios.sgm.gub.uy/DPTO_UYDU.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Durazno - Otros'),
(4,'http://geoservicios.sgm.gub.uy/UYFS.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Flores - Trinidad'),
(4,'http://geoservicios.sgm.gub.uy/UYFD.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Florida - Florida'),
(4,'http://geoservicios.sgm.gub.uy/DPTO_UYFD.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Florida - Otros'),
(4,'http://geoservicios.sgm.gub.uy/UYLA.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Lavalleja - Minas'),
(4,'http://geoservicios.sgm.gub.uy/DPTO_UYLA.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Lavalleja - Otros'),
(4,'http://geoservicios.sgm.gub.uy/UYMA.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Maldonado - Maldonado'),
(4,'http://geoservicios.sgm.gub.uy/DPYO_UYMA.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Maldonado - Otros'),
(4,'http://geoservicios.sgm.gub.uy/UYPA.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Paysandú - Paysandú'),
(4,'http://geoservicios.sgm.gub.uy/DPTO_UYPA.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Paysandú - Otros'),
(4,'http://geoservicios.sgm.gub.uy/UYRV.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Rivera - Rivera'),
(4,'http://geoservicios.sgm.gub.uy/DPTO_UYRV.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Rivera - Otros'),
(4,'http://geoservicios.sgm.gub.uy/UYRO.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Rocha - Rocha'),
(4,'http://geoservicios.sgm.gub.uy/DPTO_UYRO.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Rocha - Otros'),
(4,'http://geoservicios.sgm.gub.uy/UYRN.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Río Negro - Fray Bentos'),
(4,'http://geoservicios.sgn.gub.uy/DPTO_UYRN.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Río Negro - Otros'),
(4,'http://geoservicios.sgm.gub.uy/UYSA.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Salto - Salto'),
(4,'http://geoservicios.sgm.gub.uy/DPTO_UYSA.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Salto - Otros'),
(4,'http://geoservicios.sgm.gub.uy/UYSJ.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'San José - San José'),
(4,'http://geoservicios.sgm.gub.uy/DPTO_UYSJ.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'San José - Otros'),
(4,'http://geoservicios.sgm.gub.uy/UYSO.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Soriano - Mercedes'),
(4,'http://geoservicios.sgm.gub.uy/DPYO_UYSO.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Soriano - Dolores'),
(4,'http://geoservicios.sgm.gub.uy/DPTO_UYSO.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Soriano - Otros'),
(4,'http://geoservicios.sgm.gub.uy/UYTA.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Tacuarembó - Tacuarembó'),
(4,'http://geoservicios.sgm.gub.uy/DPTO_UYTA.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Tacuarembó - Otros'),
(4,'http://geoservicios.sgm.gub.uy/UYTT.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Treinta y Tres - Treinta y Tres'),
(4,'http://geoservicios.sgm.gub.uy/DPTO_UYTT.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Treinta y Tres - Otros');

--ide.uy/Ministerio de Economía y Finanzas/Dirección Nacional de Catastro
	--http://catastro.mef.gub.uy/12360/10/areas/geocatastro.html#wfs
INSERT INTO GeographicServices (NodeID, Url, GeographicServicesType, Description) VALUES
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/Artigas_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.3.0&REQUEST=GetCapabilities','WFS', 'Artigas'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/Lavalleja_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.3.0&REQUEST=GetCapabilities','WFS', 'Lavalleja'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/Canelones_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.3.0&REQUEST=GetCapabilities','WFS', 'Canelones'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/Colonia_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.3.0&REQUEST=GetCapabilities','WFS', 'Colonia'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/Flores_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.3.0&REQUEST=GetCapabilities','WFS', 'Flores'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/Montevideo_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.3.0&REQUEST=GetCapabilities','WFS', 'Montevideo'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/Maldonado_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.3.0&REQUEST=GetCapabilities','WFS', 'Maldonado'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/Rocha_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.3.0&REQUEST=GetCapabilities','WFS', 'Rocha'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/Soriano_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.3.0&REQUEST=GetCapabilities','WFS', 'Soriano'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/Florida_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.3.0&REQUEST=GetCapabilities','WFS', 'Florida'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/TreintayTres_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.3.0&REQUEST=GetCapabilities','WFS', 'Treinta y Tres'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/Durazno_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.3.0&REQUEST=GetCapabilities','WFS', 'Durazno'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/CerroLargo_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.3.0&REQUEST=GetCapabilities','WFS', 'CerroLargo'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/Tacuarembo_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.3.0&REQUEST=GetCapabilities','WFS', 'Tacuarembo'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/RioNegro_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.3.0&REQUEST=GetCapabilities','WFS', 'Rio Negro'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/Rivera_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.3.0&REQUEST=GetCapabilities','WFS', 'Rivera'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/Paysandu_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.3.0&REQUEST=GetCapabilities','WFS', 'Paysandu'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/Salto_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.3.0&REQUEST=GetCapabilities','WFS', 'Salto'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/SanJose_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.3.0&REQUEST=GetCapabilities','WFS', 'SanJose');

--ide.uy/Ministerio de Ganadería, Agricultura y Pesca/Dirección Nacional de Recursos Renovables
    --http://www.cebra.com.uy/renare/visualizadores-graficos-y-consulta-de-mapas
INSERT INTO GeographicServices (NodeID, Url, GeographicServicesType, Description) VALUES
(7,'http://web.renare.gub.uy/arcgis/services/SUELOS/MOSAICO_FOTOPLANOS/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'FOTOPLANOS'),
(7,'http://web.renare.gub.uy/arcgis/services/TEMATICOS/IntConeat/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Mapas interpretativos a partir de la Cartografia CONEAT'),
(7,'http://web.renare.gub.uy/arcgis/services/SUELOS/SUELOS/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Cartas de Suelos');

--ide.uy/Ministerio de Industria, Energía y Minería/Dirección Nacional de Minería y Geología
   --http://www.miem.gub.uy/web/mineria-y-geologia/sistema-de-informacion-geografica/-/asset_publisher/Kh0fSy8zj77G/content/sistema-de-informacion-geografica?redirect=http%3A//www.miem.gub.uy/web/mineria-y-geologia/sistema-de-informacion-geografica%3Fp_p_id%3D101_INSTANCE_Kh0fSy8zj77G%26p_p_lif
INSERT INTO GeographicServices (NodeID, Url, GeographicServicesType, Description) VALUES
(8,'http://visualizadorgeominero.dinamige.gub.uy:8080/arcgis/services/Dinamige_GeoS/CatastroMineroGeoS/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Catastro Minero'),
(8,'http://visualizadorgeominero.dinamige.gub.uy:8080/arcgis/services/Dinamige_GeoS/CatastroMineroGeoS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.3.0&REQUEST=GetCapabilities','WFS', 'Catastro Minero'),
(8,'http://visualizadorgeominero.dinamige.gub.uy:8080/arcgis/services/Dinamige_GeoS/HidrogeologiaGeoS/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Hidrogeología'),
(8,'http://visualizadorgeominero.dinamige.gub.uy:8080/arcgis/services/Dinamige_GeoS/MapaBaseUnidadesGeologicasGeoS/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Mapa Geológico'),
(8,'http://visualizadorgeominero.dinamige.gub.uy:8080/arcgis/services/Dinamige_GeoS/GeolUnidadesGeologicas500000WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.3.0&REQUEST=GetCapabilities','WFS', 'Mapa Geológico'),
(8,'http://visualizadorgeominero.dinamige.gub.uy:8080/arcgis/services/Dinamige_GeoS/LaboratorioGeoS/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Laboratorio'),
(8,'http://visualizadorgeominero.dinamige.gub.uy:8080/arcgis/services/Dinamige_GeoS/GeologiaGeoS/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Distritos Mineros'),
(8,'http://visualizadorgeominero.dinamige.gub.uy:8080/arcgis/services/Dinamige_GeoS/GeologiaGeoS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.3.0&REQUEST=GetCapabilities','WFS', 'Distritos Mineros');

--ide.uy/Ministerio de Transporte y Obras Públicas/Dirección Nacional de Topografía
   --http://geoportal.mtop.gub.uy/geoserv.html
INSERT INTO GeographicServices (NodeID, Url, GeographicServicesType, Description) VALUES
(9,'http://geoservicios.mtop.gub.uy/geoserver/inf_tte_ttelog_logistica/wms?service=WMS&version=1.3.0&request=GetCapabilities','WMS', 'INFRAESTRUCTURA, TRANSPORTE Y LOGÍSTICA - Información Logística'),
(9,'http://geoservicios.mtop.gub.uy/geoserver/inf_tte_ttelog_logistica/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'INFRAESTRUCTURA, TRANSPORTE Y LOGÍSTICA - Información Logística'),
(9,'http://geoservicios.mtop.gub.uy/geoserver/inf_tte_ttelog_terrestre/wms?service=WMS&version=1.3.0&request=GetCapabilities','WMS', 'INFRAESTRUCTURA, TRANSPORTE Y LOGÍSTICA - Transporte Terrestre'),
(9,'http://geoservicios.mtop.gub.uy/geoserver/inf_tte_ttelog_terrestre/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'INFRAESTRUCTURA, TRANSPORTE Y LOGÍSTICA - Transporte Terrestre'),
(9,'http://geoservicios.mtop.gub.uy/geoserver/inf_tte_ttelog_fluvial/wms?service=WMS&version=1.3.0&request=GetCapabilities','WMS', 'INFRAESTRUCTURA, TRANSPORTE Y LOGÍSTICA - Transporte Fluvial'),
(9,'http://geoservicios.mtop.gub.uy/geoserver/inf_tte_ttelog_fluvial/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'INFRAESTRUCTURA, TRANSPORTE Y LOGÍSTICA - Transporte Fluvial'),
(9,'http://geoservicios.mtop.gub.uy/geoserver/inf_tte_ttelog_ferroviario/wms?service=WMS&version=1.3.0&request=GetCapabilities','WMS', 'INFRAESTRUCTURA, TRANSPORTE Y LOGÍSTICA - Transporte Ferroviario'),
(9,'http://geoservicios.mtop.gub.uy/geoserver/inf_tte_ttelog_ferroviario/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'INFRAESTRUCTURA, TRANSPORTE Y LOGÍSTICA - Transporte Ferroviario'),
(9,'http://geoservicios.mtop.gub.uy/geoserver/inf_tte_ttelog_aereo/wms?service=WMS&version=1.3.0&request=GetCapabilities','WMS', 'INFRAESTRUCTURA, TRANSPORTE Y LOGÍSTICA - Transporte Aéreo'),
(9,'http://geoservicios.mtop.gub.uy/geoserver/inf_tte_ttelog_aereo/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'INFRAESTRUCTURA, TRANSPORTE Y LOGÍSTICA - Transporte Aéreo'),
(9,'http://geoservicios.mtop.gub.uy/geoserver/inf_tte_ttelog_otros/wms?service=WMS&version=1.3.0&request=GetCapabilities','WMS', 'INFRAESTRUCTURA, TRANSPORTE Y LOGÍSTICA - Otras Infraestructuras'),
(9,'http://geoservicios.mtop.gub.uy/geoserver/inf_tte_ttelog_otros/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'INFRAESTRUCTURA, TRANSPORTE Y LOGÍSTICA - Otras Infraestructuras'),
(9,'http://geoservicios.mtop.gub.uy/geoserver/relevamiento_transito/wms?service=WMS&version=1.3.0&request=GetCapabilities','WMS', 'INFRAESTRUCTURA, TRANSPORTE Y LOGÍSTICA - Relevamiento Estadístico de Tránsito'),
(9,'http://geoservicios.mtop.gub.uy/geoserver/relevamiento_transito/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'INFRAESTRUCTURA, TRANSPORTE Y LOGÍSTICA - Relevamiento Estadístico de Tránsito'),
(9,'http://geoservicios.mtop.gub.uy/geoserver/inf_soc_comunitaria/wms?service=WMS&version=1.3.0&request=GetCapabilities','WMS', 'INFRAESTRUCTURA SOCIAL - Infraestructura Comunitaria'),
(9,'http://geoservicios.mtop.gub.uy/geoserver/inf_soc_comunitaria/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'INFRAESTRUCTURA SOCIAL - Infraestructura Comunitaria'),
(9,'http://geoservicios.mtop.gub.uy/geoserver/acc_intern_cosiplan/wms?service=WMS&version=1.3.0&request=GetCapabilities','WMS', 'ACCIÓN INTERNACIONAL - Cartografía COSIPLAN'),
(9,'http://geoservicios.mtop.gub.uy/geoserver/acc_intern_cosiplan/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'ACCIÓN INTERNACIONAL - Cartografía COSIPLAN'),
(9,'http://geoservicios.mtop.gub.uy/geoserver/rec_hidrograficos/wms?service=WMS&version=1.3.0&request=GetCapabilities','WMS', 'RECURSOS HIDROGRÁFICOS'),
(9,'http://geoservicios.mtop.gub.uy/geoserver/rec_hidrograficos/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'RECURSOS HIDROGRÁFICOS'),
(9,'http://geoservicios.mtop.gub.uy/geoserver/planos_publicar/wms?service=WMS&version=1.3.0&request=GetCapabilities','WMS', 'CONSULTA DE PLANOS DE MENSURA - Planos de mensura'),
(9,'http://geoservicios.mtop.gub.uy/geoserver/planos_publicar/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'CONSULTA DE PLANOS DE MENSURA - Planos de mensura'),
(9,'http://geoservicios.mtop.gub.uy/geoserver/mb_hervidero/wms?service=WMS&version=1.3.0&request=GetCapabilities','WMS', 'VUELOS FOTOGRAMÉTRICOS - Parque Arroyo Hervidero'),
(9,'http://geoservicios.mtop.gub.uy/geoserver/mb_hervidero/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'VUELOS FOTOGRAMÉTRICOS - Parque Arroyo Hervidero'),
(9,'http://geoservicios.mtop.gub.uy/geoserver/mb_sayago/wms?service=WMS&version=1.3.0&request=GetCapabilities','WMS', 'VUELOS FOTOGRAMÉTRICOS - Regasificadora Puntas de Sayago'),
(9,'http://geoservicios.mtop.gub.uy/geoserver/mb_sayago/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'VUELOS FOTOGRAMÉTRICOS - Regasificadora Puntas de Sayago'),
(9,'http://geoservicios.mtop.gub.uy/geoserver/mb_pap/wms?service=WMS&version=1.3.0&request=GetCapabilities','WMS', 'VUELOS FOTOGRAMÉTRICOS - Puerto de Aguas Profundas'),
(9,'http://geoservicios.mtop.gub.uy/geoserver/mb_pap/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'VUELOS FOTOGRAMÉTRICOS - Puerto de Aguas Profundas'),
(9,'http://geoservicios.mtop.gub.uy/geoserver/mb_piria/wms?service=WMS&version=1.3.0&request=GetCapabilities','WMS', 'VUELOS FOTOGRAMÉTRICOS - Piriápolis'),
(9,'http://geoservicios.mtop.gub.uy/geoserver/mb_piria/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'VUELOS FOTOGRAMÉTRICOS - Piriápolis'),
(9,'http://geoservicios.mtop.gub.uy/geoserver/rutas_SD/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'SEGMENTACIÓN DINÁMICA - Rutas nacionales ');

--ide.uy/Ministerio de Vivienda, Ordenamiento Territorial y Medio Ambiente/Dirección Nacional de Medio Ambiente
--https://www.dinama.gub.uy/geoservicios/
INSERT INTO GeographicServices (NodeID, Url, GeographicServicesType, Description) VALUES
(10,'https://www.dinama.gub.uy/geoserver/u19600217/wms?service=WMS&version=1.3.0&REQUEST=GetCapabilities','WMS', 'Informacion sobre DINAMA');


--ide.uy/Ministerio de Vivienda, Ordenamiento Territorial y Medio Ambiente/Dirección Nacional de Ordenamiento Territorial
   --http://sit.mvotma.gub.uy/serviciosOGC.htm
INSERT INTO GeographicServices (NodeID, Url, GeographicServicesType, Description) VALUES
(11,'http://sit.mvotma.gub.uy/ArcGIS/services/SIT/instrumentosOT/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'NORMATIVA DE ORDENAMIENTO TERRITORIAL'),
(11,'http://sit.mvotma.gub.uy/arcgis/services/SIT/instrumentosOT/MapServer/WFSServer?SERVICE=WFS&VERSION=1.3.0&REQUEST=GetCapabilities','WFS', 'NORMATIVA DE ORDENAMIENTO TERRITORIAL'),
(11,'http://sit.mvotma.gub.uy/ArcGIS/services/SIT/instrumentos_elaboracion/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'INSTRUMENTOS DE O.T EN ELABORACIÓN'),
(11,'http://sit.mvotma.gub.uy/arcgis/services/SIT/instrumentos_elaboracion/MapServer/WFSServer?SERVICE=WFS&VERSION=1.3.0&REQUEST=GetCapabilities','WFS', 'INSTRUMENTOS DE O.T EN ELABORACIÓN'),
(11,'http://sit.mvotma.gub.uy/ArcGIS/services/SIT/chs/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'CONJUNTOS HABITACIONALES DE PROMOCIÓN PÚBLICA'),
(11,'http://sit.mvotma.gub.uy/ArcGIS/services/SIT/chs/MapServer/WFSServer?SERVICE=WFS&VERSION=1.3.0&REQUEST=GetCapabilities','WFS', 'CONJUNTOS HABITACIONALES DE PROMOCIÓN PÚBLICA'),
(11,'http://sit.mvotma.gub.uy/ArcGIS/services/SIT/asentamientos/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'ASENTAMIENTOS'),
(11,'http://sit.mvotma.gub.uy/ArcGIS/services/SIT/asentamientos/MapServer/WFSServer?SERVICE=WFS&VERSION=1.3.0&REQUEST=GetCapabilities','WFS', 'ASENTAMIENTOS'),
(11,'http://sit.mvotma.gub.uy/ArcGIS/services/OGC/OGC_cobertura/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'COBERTURA DEL SUELO'),
(11,'http://sit.mvotma.gub.uy/ArcGIS/services/OGC/OGC_cobertura/MapServer/WFSServer?SERVICE=WFS&VERSION=1.3.0&REQUEST=GetCapabilities','WFS', 'COBERTURA DEL SUELO');

--ide.uy/Intendencia de Montevideo/Servicio de Geomática
--http://sig.montevideo.gub.uy/content/geoservicios-web
INSERT INTO GeographicServices (NodeID, Url, GeographicServicesType, Description) VALUES
(12,'http://geoweb.montevideo.gub.uy/geonetwork/srv/es/csw','CSW', 'ACCESO A SERVICIOS CSW');


INSERT INTO SystemUser (Email, Password, UserGroupID, FirstName, LastName, PhoneNumber, InstitutionID) VALUES 
('ncalle@mail.com', 'ncalle', 1, 'Natalia', 'Calle', '098765432', 1),
('rsanchez@mail.com', 'rsanchez', 1, 'Ramiro', 'Sanchez', '098961259', 1);
/* ****************************************************************************************************** */
/*                                 FIN - 2 - DATOS DE CASO DE ESTUDIO                                     */
/* ****************************************************************************************************** */ 
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
/*                                       3 - DATOS DE PRUEBA                                              */
/* ****************************************************************************************************** */ 
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
/* ****************************************************************************************************** */
/*                                    FIN - 3 - DATOS DE PRUEBA                                           */
/* ****************************************************************************************************** */ 
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
/*                                      4 - STORED FUNCTIONS                                              */
/* ****************************************************************************************************** */ 
--DROP FUNCTION evaluation_get(integer);
CREATE OR REPLACE FUNCTION evaluation_get
(
   pUserID INT --no requerido
)
RETURNS TABLE 
(
   EvaluationID INT
   , UserID INT	  
   , ProfileID INT
   , ProfileName VARCHAR(40)
   , MeasurableObjectID INT
   , EntityID INT
   , EntityType VARCHAR(11)
   , MeasurableObjectName VARCHAR(1024)
   , QualityModelID INT
   , QualityModelName VARCHAR(40)
   , MetricID INT
   , MetricName VARCHAR(100)
   , StartDate DATE
   , EndDate DATE
   , IsEvaluationCompletedFlag BOOLEAN
   , SuccessFlag BOOLEAN
   , EvaluationCount INT
   , EvaluationApprovedValues INT
) AS $$
/************************************************************************************************************
** Name: evaluation_get
**
** Desc: Devuelve la lista de Evaluaciones disponibles hasta el momento
**       Si se le pasa el usuario, entonces se devuelven solo las evaluaciones correspondientes a el mismo.
**
** 11/02/2017 Created
**
*************************************************************************************************************/
DECLARE v_canUserMeasureAble BOOLEAN;

BEGIN

   -- validacion de usuario
   IF (pUserID IS NOT NULL)
      AND NOT EXISTS (SELECT 1 FROM SystemUser su WHERE su.UserID = pUserID)
   THEN
      RAISE EXCEPTION 'Error - El Usuario no existe.';
   END IF;
   
   IF (pUserID IS NOT NULL)
   THEN
      SELECT TRUE INTO v_canUserMeasureAble;
   ELSE
      SELECT FALSE INTO v_canUserMeasureAble;
   END IF;
	
   RETURN QUERY
   SELECT e.EvaluationID
      , es.UserID	  
      , es.ProfileID
      , p.Name AS ProfileName
      , mo.MeasurableObjectID
      , mo.EntityID
      , mo.EntityType
      , CASE 
         WHEN gs.GeographicServicesID IS NOT NULL THEN gs.Url
         WHEN l.LayerID IS NOT NULL THEN l.Url
         WHEN n.NodeID IS NOT NULL THEN n.Name
         WHEN i.InstitutionID IS NOT NULL THEN i.Name
         WHEN ide.IdeID IS NOT NULL THEN ide.Name
      END AS MeasurableObjectName
      , q.QualityModelID
      , q.Name AS QualityModelName
      , m.MetricID
      , m.Name AS MetricName
      , e.StartDate
      , e.EndDate
      , e.IsEvaluationCompletedFlag
      , e.SuccessFlag
	  , e.EvaluationCount
	  , e.EvaluationApprovedValues
   FROM EvaluationSummary es
   INNER JOIN Evaluation e ON e.EvaluationSummaryID = es.EvaluationSummaryID
   INNER JOIN Profile p ON p.ProfileID = es.ProfileID
   INNER JOIN Metric m ON m.MetricID = e.MetricID
   INNER JOIN Factor f ON f.FactorID = m.FactorID
   INNER JOIN Dimension d ON d.DimensionID = f.DimensionID
   INNER JOIN QualityModel q ON q.QualityModelID = d.QualityModelID
   INNER JOIN MeasurableObject mo ON mo.MeasurableObjectID = es.MeasurableObjectID
   LEFT JOIN UserMeasurableObject umo ON umo.MeasurableObjectID = mo.MeasurableObjectID
   LEFT JOIN GeographicServices gs ON gs.GeographicServicesID = mo.EntityID AND mo.EntityType = 'Servicio'
   LEFT JOIN Layer l ON l.LayerID = mo.EntityID AND mo.EntityType = 'Capa'
   LEFT JOIN Node n ON n.NodeID = mo.EntityID AND mo.EntityType = 'Nodo'
   LEFT JOIN Institution i ON i.InstitutionID = mo.EntityID AND mo.EntityType = 'Institución'
   LEFT JOIN Ide ide ON ide.IdeID = mo.EntityID AND mo.EntityType = 'Ide'
   WHERE umo.UserID = COALESCE(pUserID, umo.UserID)
      AND (CASE WHEN v_canUserMeasureAble = TRUE THEN umo.CanMeasureFlag = TRUE ELSE TRUE END)
   GROUP BY e.EvaluationID
      , es.UserID	  
      , es.ProfileID
      , p.Name
      , mo.MeasurableObjectID
      , mo.EntityID
      , mo.EntityType
      , gs.GeographicServicesID
      , l.LayerID
      , n.NodeID
      , i.InstitutionID
      , ide.IdeID
      , q.QualityModelID
      , q.Name
      , m.MetricID
      , m.Name
      , e.StartDate
      , e.EndDate
      , e.IsEvaluationCompletedFlag
      , e.SuccessFlag
   ORDER BY e.EvaluationID;
         
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */ 
/* ****************************************************************************************************** */ 
--DROP FUNCTION evaluation_insert (integer, integer, boolean);
CREATE OR REPLACE FUNCTION evaluation_insert
(
   pEvaluationSummaryID INT
   , pMetricID INT
   , pSuccessFlag BOOLEAN
   , pIsEvaluationCompletedFlag BOOLEAN
   , pEvaluationCount INT
   , pEvaluationApprovedValues INT
)
RETURNS VOID AS $$
/************************************************************************************************************
** Name: evaluation_insert
**
** Desc: Ingreso de evaluacion
**
** 11/12/2016 - Created
**
*************************************************************************************************************/
BEGIN
    
   -- parametros requeridos
   IF (pEvaluationSummaryID IS NULL OR pMetricID IS NULL)
   THEN
      RAISE EXCEPTION 'Error - Los parametros ID de EvaluacionSummary, ID de Metrica son requerido.';
   END IF;
          
   -- validacion de Metrica
   IF NOT EXISTS (SELECT 1 FROM Metric m WHERE m.MetricID = pMetricID)
   THEN
      RAISE EXCEPTION 'Error - El ID de Metrica no es correcto.';
   END IF;    
   
   -- validacion de EvaluationSummaryID
   IF NOT EXISTS (SELECT 1 FROM EvaluationSummary es WHERE es.EvaluationSummaryID = pEvaluationSummaryID)
   THEN
      RAISE EXCEPTION 'Error - El ID de EvaluationSummary no es correcto.';
   END IF; 

   -- Ingreso de Evaluacion
   INSERT INTO Evaluation
   (EvaluationSummaryID, MetricID, StartDate, EndDate, IsEvaluationCompletedFlag, SuccessFlag, EvaluationCount, EvaluationApprovedValues)
   VALUES
   (pEvaluationSummaryID, pMetricID, CURRENT_DATE, CURRENT_DATE, pIsEvaluationCompletedFlag, pSuccessFlag, pEvaluationCount, pEvaluationApprovedValues);

END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
--DROP FUNCTION evaluation_summary_get(integer);
CREATE OR REPLACE FUNCTION evaluation_summary_get
(
   pUserID INT --no requerido
)
RETURNS TABLE 
(
   EvaluationSummaryID INT
   , UserID INT	  
   , ProfileID INT
   , ProfileName VARCHAR(40)
   , MeasurableObjectID INT
   , EntityID INT
   , EntityType VARCHAR(11)
   , MeasurableObjectName VARCHAR(1024)
   , MeasurableObjectDescription VARCHAR(100)
   , SuccessFlag BOOLEAN
   , SuccessPercentage INT
) AS $$
/************************************************************************************************************
** Name: evaluation_summary_get
**
** Desc: Devuelve el resumen de las Evaluaciones
**       Si se le pasa el usuario, entonces se devuelven solo el resumen de las evaluaciones correspondientes a el mismo.
**
** 11/02/2017 Created
**
*************************************************************************************************************/
DECLARE v_canUserMeasureAble BOOLEAN;

BEGIN

   -- validacion de usuario
   IF (pUserID IS NOT NULL)
      AND NOT EXISTS (SELECT 1 FROM SystemUser su WHERE su.UserID = pUserID)
   THEN
      RAISE EXCEPTION 'Error - El Usuario no existe.';
   END IF;
   
   IF (pUserID IS NOT NULL)
   THEN
      SELECT TRUE INTO v_canUserMeasureAble;
   ELSE
      SELECT FALSE INTO v_canUserMeasureAble;
   END IF;
	
   RETURN QUERY
   SELECT es.EvaluationSummaryID
      , es.UserID	  
      , es.ProfileID
      , p.Name AS ProfileName
      , mo.MeasurableObjectID
      , mo.EntityID
      , mo.EntityType
      , CASE 
         WHEN gs.GeographicServicesID IS NOT NULL THEN gs.Url
         WHEN l.LayerID IS NOT NULL THEN l.Url
         WHEN n.NodeID IS NOT NULL THEN n.Name
         WHEN i.InstitutionID IS NOT NULL THEN i.Name
         WHEN ide.IdeID IS NOT NULL THEN ide.Name
      END AS MeasurableObjectName
      , CASE 
         WHEN gs.GeographicServicesID IS NOT NULL THEN gs.Description
         WHEN l.LayerID IS NOT NULL THEN l.Url
         WHEN n.NodeID IS NOT NULL THEN n.Name
         WHEN i.InstitutionID IS NOT NULL THEN i.Name
         WHEN ide.IdeID IS NOT NULL THEN ide.Name
      END AS MeasurableObjectDescription
      , es.SuccessFlag
      , es.SuccessPercentage
   FROM EvaluationSummary es
   INNER JOIN Profile p ON p.ProfileID = es.ProfileID
   INNER JOIN MeasurableObject mo ON mo.MeasurableObjectID = es.MeasurableObjectID
   LEFT JOIN UserMeasurableObject umo ON umo.MeasurableObjectID = mo.MeasurableObjectID
   LEFT JOIN GeographicServices gs ON gs.GeographicServicesID = mo.EntityID AND mo.EntityType = 'Servicio'
   LEFT JOIN Layer l ON l.LayerID = mo.EntityID AND mo.EntityType = 'Capa'
   LEFT JOIN Node n ON n.NodeID = mo.EntityID AND mo.EntityType = 'Nodo'
   LEFT JOIN Institution i ON i.InstitutionID = mo.EntityID AND mo.EntityType = 'Institución'
   LEFT JOIN Ide ide ON ide.IdeID = mo.EntityID AND mo.EntityType = 'Ide'
   WHERE umo.UserID = COALESCE(pUserID, umo.UserID)
      AND (CASE WHEN v_canUserMeasureAble = TRUE THEN umo.CanMeasureFlag = TRUE ELSE TRUE END)
   GROUP BY es.EvaluationSummaryID
      , es.UserID	  
      , es.ProfileID
      , p.Name
      , mo.MeasurableObjectID
      , mo.EntityID
      , mo.EntityType
      , gs.GeographicServicesID
      , l.LayerID
      , n.NodeID
      , i.InstitutionID
      , ide.IdeID
      , es.SuccessFlag
      , es.SuccessPercentage
   ORDER BY es.EvaluationSummaryID;
         
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
--DROP FUNCTION evaluation_summary_insert(integer,integer,integer,boolean,integer);
CREATE OR REPLACE FUNCTION evaluation_summary_insert
(
   pUserID INT
   , pProfileID INT
   , pMeasurableObjectID INT
   , pSuccessFlag BOOLEAN
   , pSuccessPercentage INT
)
RETURNS TABLE 
(
   EvaluationSummaryID INT
   , UserID INT	  
   , ProfileID INT
   , ProfileName VARCHAR(40)
   , MeasurableObjectID INT
   , EntityID INT
   , EntityType VARCHAR(11)
   , MeasurableObjectName VARCHAR(1024)
   , MeasurableObjectDescription VARCHAR(100)
   , SuccessFlag BOOLEAN
   , SuccessPercentage INT
) AS $$
/************************************************************************************************************
** Name: evaluation_summary_insert
**
** Desc: Ingreso de resumen de una evaluacion. Devuelde datos del resumen ingresado.
**
** 10/03/2017 - Created
**
*************************************************************************************************************/
DECLARE v_EvaluationSummaryID INT;

BEGIN
    
   -- parametros requeridos
   IF (pUserID IS NULL OR pProfileID IS NULL OR pMeasurableObjectID IS NULL)
   THEN
      RAISE EXCEPTION 'Error - Los parametros ID de Usuario, ID de Perfil, ID de Metrica e ID de Objeto Medible son requerido.';
   END IF;
    
   -- validacion de usuario
   IF NOT EXISTS (SELECT 1 FROM SystemUser u WHERE u.UserID = pUserID)
   THEN
      RAISE EXCEPTION 'Error - El ID de Usuario no es correcto.';
   END IF;
    
   -- validacion de perfil
   IF NOT EXISTS (SELECT 1 FROM Profile p WHERE p.ProfileID = pProfileID)
   THEN
      RAISE EXCEPTION 'Error - El ID de Perfil no es correcto.';
   END IF; 
   
   -- validacion de Objeto Medible
   IF NOT EXISTS (SELECT 1 FROM MeasurableObject mo WHERE mo.MeasurableObjectID = pMeasurableObjectID)
   THEN
      RAISE EXCEPTION 'Error - El ID de Objeto Medible no es correcto.';
   END IF; 

   INSERT INTO EvaluationSummary AS es
   (UserID, ProfileID, MeasurableObjectID, SuccessFlag, SuccessPercentage)
   VALUES
   (pUserID, pProfileID, pMeasurableObjectID, pSuccessFlag, pSuccessPercentage)
      RETURNING es.EvaluationSummaryID INTO v_EvaluationSummaryID;

   RETURN QUERY 
      SELECT es.EvaluationSummaryID
      , es.UserID	  
      , es.ProfileID
      , p.Name AS ProfileName
      , mo.MeasurableObjectID
      , mo.EntityID
      , mo.EntityType
      , CASE 
         WHEN gs.GeographicServicesID IS NOT NULL THEN gs.Url
         WHEN l.LayerID IS NOT NULL THEN l.Url
         WHEN n.NodeID IS NOT NULL THEN n.Name
         WHEN i.InstitutionID IS NOT NULL THEN i.Name
         WHEN ide.IdeID IS NOT NULL THEN ide.Name
      END AS MeasurableObjectName
      , CASE 
         WHEN gs.GeographicServicesID IS NOT NULL THEN gs.Description
      END AS MeasurableObjectDescription
      , es.SuccessFlag
      , es.SuccessPercentage
   FROM EvaluationSummary es
   INNER JOIN Profile p ON p.ProfileID = es.ProfileID
   INNER JOIN MeasurableObject mo ON mo.MeasurableObjectID = es.MeasurableObjectID
   LEFT JOIN UserMeasurableObject umo ON umo.MeasurableObjectID = mo.MeasurableObjectID
   LEFT JOIN GeographicServices gs ON gs.GeographicServicesID = mo.EntityID AND mo.EntityType = 'Servicio'
   LEFT JOIN Layer l ON l.LayerID = mo.EntityID AND mo.EntityType = 'Capa'
   LEFT JOIN Node n ON n.NodeID = mo.EntityID AND mo.EntityType = 'Nodo'
   LEFT JOIN Institution i ON i.InstitutionID = mo.EntityID AND mo.EntityType = 'Institución'
   LEFT JOIN Ide ide ON ide.IdeID = mo.EntityID AND mo.EntityType = 'Ide'
   WHERE es.EvaluationSummaryID = v_EvaluationSummaryID
   GROUP BY es.EvaluationSummaryID
      , es.UserID	  
      , es.ProfileID
      , p.Name
      , mo.MeasurableObjectID
      , mo.EntityID
      , mo.EntityType
      , gs.GeographicServicesID
      , l.LayerID
      , n.NodeID
      , i.InstitutionID
      , ide.IdeID
      , es.SuccessFlag
      , es.SuccessPercentage;

END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */

CREATE OR REPLACE FUNCTION evaluation_periodic_insert
(
   pEvaluationSummaryID INT
   , pMeasurableObjectUrl VARCHAR(1024)
   , pEvaluatedCount INT
   , pPeriodic DATE
   , pSuccessCount INT
   , pSuccessPercentage INT
   , pMeasurableObjectDesc VARCHAR(1024)
   , pUserID INT
)
RETURNS TABLE 
(
    EvaluationSummaryID INT
   , MeasurableObjectUrl VARCHAR(1024)
   , EvaluatedCount INT
   , Periodic DATE
   , SuccessCount INT
   , SuccessPercentage INT
   , MeasurableObjectDesc VARCHAR(1024)
   , UserID INT
) AS $$
/************************************************************************************************************
** Name: evaluation_periodic_insert
**
** Desc: Ingreso de evaluacion periodica
**
*************************************************************************************************************/
DECLARE v_EvaluationSummaryID INT;

BEGIN    

   INSERT INTO EvaluationPeriodic AS es
   (EvaluationSummaryID, MeasurableObjectUrl, EvaluatedCount, Periodic, SuccessCount, SuccessPercentage, MeasurableObjectDesc, UserID)
   VALUES
   (pEvaluationSummaryID, pMeasurableObjectUrl, pEvaluatedCount, pPeriodic, pSuccessCount, pSuccessPercentage, pMeasurableObjectDesc, pUserID)
      RETURNING es.EvaluationSummaryID INTO v_EvaluationSummaryID;

   RETURN QUERY 
      SELECT es.EvaluationSummaryID
      , es.MeasurableObjectUrl	  
      , es.EvaluatedCount
      , es.Periodic
      , es.SuccessCount
	  , es.SuccessPercentage
	  , es.MeasurableObjectDesc
	  , es.UserID
   FROM EvaluationPeriodic es
   GROUP BY es.EvaluationSummaryID, es.MeasurableObjectUrl, es.EvaluatedCount, es.Periodic, es.SuccessCount, es.SuccessPercentage, es.MeasurableObjectDesc, es.UserID;

END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
--DROP FUNCTION evaluation_periodic_get(integer);
CREATE OR REPLACE FUNCTION evaluation_periodic_get
(
   pUserID INT --no requerido
)
RETURNS TABLE 
(
   EvaluationSummaryID INT
   , MeasurableObjectUrl VARCHAR(1024)
   , EvaluatedCount INT
   , Periodic DATE
   , SuccessCount INT
   , SuccessPercentage INT
   , MeasurableObjectDesc VARCHAR(1024)
   , UserID INT
) AS $$
/************************************************************************************************************
** Name: evaluation_periodic_get
**
** Desc: Las evaluaciones periodicas de disponibilidad 
**
*************************************************************************************************************/
DECLARE v_canUserMeasureAble BOOLEAN;

BEGIN

   -- validacion de usuario
   IF (pUserID IS NOT NULL)
      AND NOT EXISTS (SELECT 1 FROM SystemUser su WHERE su.UserID = pUserID)
   THEN
      RAISE EXCEPTION 'Error - El Usuario no existe.';
   END IF;
   
   IF (pUserID IS NOT NULL)
   THEN
      SELECT TRUE INTO v_canUserMeasureAble;
   ELSE
      SELECT FALSE INTO v_canUserMeasureAble;
   END IF;
	
   RETURN QUERY
   SELECT es.EvaluationSummaryID
      , es.MeasurableObjectURL
      , es.EvaluatedCount
      , es.Periodic
      , es.SuccessCount
      , es.SuccessPercentage
	  , es.MeasurableObjectDesc
	  , es.UserID
   FROM EvaluationPeriodic es
   GROUP BY es.EvaluationSummaryID, es.MeasurableObjectUrl, es.EvaluatedCount, es.Periodic, es.SuccessCount, es.SuccessPercentage, es.MeasurableObjectDesc,  es.UserID;
         
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
CREATE OR REPLACE FUNCTION evaluation_periodic_delete
(
   pEvaluationSummaryID INT
)
RETURNS VOID AS $$

BEGIN
   
   DELETE FROM EvaluationPeriodic
   WHERE EvaluationSummaryID = pEvaluationSummaryID;
    
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
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
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
--DROP FUNCTION measurable_object_get(integer);
CREATE OR REPLACE FUNCTION measurable_object_get
(
   pUserID INT
)
RETURNS TABLE 
   (
      IdeID INT
      , IdeName VARCHAR(40)
      , IdeDescription VARCHAR(100)
      , InstitutionID INT
      , InstitutionName VARCHAR(70)
      , InstitutionDescription VARCHAR(100)
      , NodeID INT
      , NodeName VARCHAR(70)
      , NodeDescription VARCHAR(100)
      , LayerID INT
      , LayerName VARCHAR(70)
      , LayerURL VARCHAR(1024)
      , GeographicServicesID INT
      , GeographicServicesURL VARCHAR(1024)
      , GeographicServicesType CHAR(3)
      , GeographicServicesDescription VARCHAR(100)
 ) AS $$
/************************************************************************************************************
** Name: measurable_object_get
**
** Desc: Devuelve la lista de objetos medibles disponibles.
**       Si el ID de Usuario es pasado por parametro, entonces se listan solo los Objetos Medibles que el usuario en cuestion puede medir.
**
** 02/12/2016 - Created
**
*************************************************************************************************************/
BEGIN
   
   -- validacion de usuario
   IF (pUserID IS NOT NULL)
      AND NOT EXISTS (SELECT 1 FROM SystemUser su WHERE su.UserID = pUserID)
   THEN
      RAISE EXCEPTION 'Error - El Usuario no existe.';
   END IF;

   -- Lista de objetos medibles
   RETURN QUERY
   SELECT ide.IdeID
      , ide.Name AS IdeName
      , ide.Description AS IdeDescription
      , ins.InstitutionID
      , ins.Name AS InstitutionName
      , ins.Description AS InstitutionDescription
      , n.NodeID
      , n.Name AS NodeName
      , n.Description AS NodeDescription
      , l.LayerID
      , l.Name AS LayerName
      , l.URL AS LayerURL
      , NULL AS GeographicServicesID
      , NULL AS GeographicServicesURL
      , NULL AS GeographicServicesType
      , NULL AS GeographicServicesDescription
   FROM Ide ide
   INNER JOIN Institution ins ON ins.IdeID = ide.IdeID
   INNER JOIN Node n ON n.InstitutionID = ins.InstitutionID
   INNER JOIN Layer l ON l.NodeID = n.NodeID
   LEFT JOIN MeasurableObject mo ON 
      CASE
         WHEN mo.EntityType = 'Ide' THEN mo.EntityID = ide.IdeID
         WHEN mo.EntityType = 'Institución' THEN mo.EntityID = ins.InstitutionID
         WHEN mo.EntityType = 'Nodo' THEN mo.EntityID = n.NodeID
         WHEN mo.EntityType = 'Capa' THEN mo.EntityID = l.LayerID
      END
   LEFT JOIN UserMeasurableObject umo ON umo.MeasurableObjectID = mo.MeasurableObjectID
   LEFT JOIN SystemUser u ON u.UserID = umo.UserID
   WHERE (CASE WHEN pUserID IS NOT NULL THEN u.UserID = pUserID ELSE TRUE END)
      AND (CASE WHEN pUserID IS NOT NULL THEN umo.CanMeasureFlag = TRUE ELSE TRUE END)
   GROUP BY ide.IdeID
      , ide.Name
      , ide.Description
      , ins.InstitutionID
      , ins.Name
      , ins.Description
      , n.NodeID
      , n.Name
      , n.Description
      , l.LayerID
      , l.Name
      , l.URL

   UNION
         
   SELECT ide.IdeID
      , ide.Name AS IdeName
      , ide.Description AS IdeDescription
      , ins.InstitutionID
      , ins.Name AS InstitutionName
      , ins.Description AS InstitutionDescription
      , n.NodeID
      , n.Name AS NodeName
      , n.Description AS NodeDescription
      , NULL AS LayerID
      , NULL AS LayerName
      , NULL AS LayerURL
      , sg.GeographicServicesID
      , sg.URL AS GeographicServicesURL
      , sg.GeographicServicesType
      , sg.Description AS GeographicServicesDescription
   FROM Ide ide
   INNER JOIN Institution ins ON ins.IdeID = ide.IdeID
   INNER JOIN Node n ON n.InstitutionID = ins.InstitutionID
   INNER JOIN GeographicServices sg ON sg.NodeID = n.NodeID
   LEFT JOIN MeasurableObject mo ON 
      CASE
         WHEN mo.EntityType = 'Ide' THEN mo.EntityID = ide.IdeID
         WHEN mo.EntityType = 'Institución' THEN mo.EntityID = ins.InstitutionID
         WHEN mo.EntityType = 'Nodo' THEN mo.EntityID = n.NodeID
         WHEN mo.EntityType = 'Servicio' THEN mo.EntityID = sg.GeographicServicesID
      END
   LEFT JOIN UserMeasurableObject umo ON umo.MeasurableObjectID = mo.MeasurableObjectID
   LEFT JOIN SystemUser u ON u.UserID = umo.UserID
   WHERE (CASE WHEN pUserID IS NOT NULL THEN u.UserID = pUserID ELSE TRUE END)
      AND (CASE WHEN pUserID IS NOT NULL THEN umo.CanMeasureFlag = TRUE ELSE TRUE END)
   GROUP BY ide.IdeID
      , ide.Name
      , ide.Description
      , ins.InstitutionID
      , ins.Name
      , ins.Description
      , n.NodeID
      , n.Name
      , n.Description
      , sg.GeographicServicesID
      , sg.URL
      , sg.GeographicServicesType
      , sg.Description

   ORDER BY IdeID
      , InstitutionID
      , NodeID
      , LayerID
      , GeographicServicesID;
        
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
--DROP FUNCTION metric_get()
CREATE OR REPLACE FUNCTION metric_get()
RETURNS TABLE 
   (
      MetricID INT
      , MetricFactorID INT	  
      , MetricName VARCHAR(100)
      , MetricAgrgegationFlag BOOLEAN
      , MetricUnitID INT
      , MetricGranurality VARCHAR(11)
      , MetricDescription VARCHAR(100)
	  , MetricManual BOOLEAN
   ) AS $$
/************************************************************************************************************
** Name: metric_get
**
** Desc: Devuelve el conunto de Metricas disponibles
**
** 08/02/2017 Created
**
*************************************************************************************************************/
BEGIN

   RETURN QUERY
   SELECT m.MetricID
      , m.FactorID	  
      , m.Name
      , m.AgrgegationFlag
      , m.UnitID
      , m.Granurality
      , m.Description
	  , m.IsManual
   FROM Metric m
   ORDER BY m.MetricID;
         
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
--DROP FUNCTION profile_delete (integer);
CREATE OR REPLACE FUNCTION profile_delete
(
   pProfileID INT
)
RETURNS VOID AS $$
/************************************************************************************************************
** Name: profile_delete
**
** Desc: Elimina el Perfil pasado por parametro así como los registros en MetricRange asociados al Perfil
**
** 04/03/2017 - Created
**
*************************************************************************************************************/
BEGIN
   
   -- parametros requeridos
   IF (pProfileID IS NULL)
   THEN
      RAISE EXCEPTION 'Error - El parametro ID de Perfil es requerido.';
   END IF;
   
   -- validación de existencia de Perfil
   IF NOT EXISTS (SELECT 1 FROM Profile p WHERE p.ProfileID = pProfileID)
   THEN
      RAISE EXCEPTION 'Error - El Perfil de ID: % no existe.', pProfileID;
   END IF;

   -- Borrado de registros dependientes del Perfil
   DELETE FROM PartialEvaluation pe
   USING EvaluationSummary es
      , Evaluation e
   WHERE e.EvaluationSummaryID = es.EvaluationSummaryID
      AND e.EvaluationID = pe.EvaluationID
      AND es.ProfileID = pProfileID;

   DELETE FROM Evaluation e
   USING EvaluationSummary es
   WHERE es.EvaluationSummaryID = e.EvaluationSummaryID
      AND ProfileID = pProfileID;

   DELETE FROM EvaluationSummary
   WHERE ProfileID = pProfileID;
   
   DELETE FROM Weighing
   WHERE ProfileID = pProfileID;

   DELETE FROM MetricRange
   WHERE ProfileID = pProfileID;
       
   -- Borrado del Perfil de la tabla Profile
   DELETE FROM Profile
   WHERE ProfileID = pProfileID;
    
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
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
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
--DROP FUNCTION profile_insert (character varying, character varying, boolean, text);
CREATE OR REPLACE FUNCTION profile_insert
(
   pName VARCHAR(40)
   , pGranurality VARCHAR(11)
   , pIsWeightedFlag BOOLEAN
   , pMetricKeys TEXT -- Lista de enteros separada por coma, que representa los IDs de las metricas
)
RETURNS VOID AS $$
/************************************************************************************************************
** Name: profile_insert
**
** Desc: se agrega un Perfil a la lista de perfiles disponibles, al que se le asocian las metricas pasadas por parametros con los Rangos
**
** 10/12/2016 Created
**
*************************************************************************************************************/
DECLARE LastProfileID INT;

BEGIN
    
   -- parametros requeridos
   IF (pName IS NULL OR pGranurality IS NULL OR pIsWeightedFlag IS NULL)
   THEN
      RAISE EXCEPTION 'Error - Los parametros nombre de perfil, granularidad y ponderación son requeridos.';
   END IF;
    
   -- validacion
   IF (pMetricKeys IS NULL)
   THEN
      RAISE EXCEPTION 'Error - La lista de Metricas no puede ser vacia.';
   END IF;

   
   CREATE TEMP TABLE MetricKeys
   (
      MetricID INT
   );

   INSERT INTO MetricKeys
   (MetricID)
   SELECT CAST(regexp_split_to_table(pMetricKeys, E',') AS INT);
      
   -- Ingreso de Perfil
   INSERT INTO Profile
   (Name, Granurality, IsWeightedFlag)
   VALUES
   (pName, pGranurality, pIsWeightedFlag)
      RETURNING ProfileID INTO LastProfileID;
    
    -- Insert de Rangos asociados a las Metricas y Perfil
    
   -- Metricas boleanas
   INSERT INTO MetricRange
   (
      MetricID
      , ProfileID
      , BooleanFlag
      , BooleanAcceptanceValue
      , PercentageFlag
      , PercentageAcceptanceValue
      , IntegerFlag
      , IntegerAcceptanceValue
      , EnumerateFlag
      , EnumerateAcceptanceValue
   )
   SELECT 
      m.MetricID
      , LastProfileID
      , TRUE --Boleano
      , TRUE --Por defecto en TRUE
      , FALSE
      , NULL
      , FALSE
      , NULL
      , FALSE
      , NULL
   FROM Metric m
   WHERE m.MetricID IN (SELECT mb.MetricID FROM MetricKeys mb)
      AND m.UnitID = 1; --Boleano

   -- Metricas Porcentaje
   INSERT INTO MetricRange
   (
      MetricID
      , ProfileID
      , BooleanFlag
      , BooleanAcceptanceValue
      , PercentageFlag
      , PercentageAcceptanceValue
      , IntegerFlag
      , IntegerAcceptanceValue
      , EnumerateFlag
      , EnumerateAcceptanceValue
   )
   SELECT 
      m.MetricID
      , LastProfileID
      , FALSE
      , NULL
      , TRUE --Porcentaje
      , 50 --Por defecto en 50%
      , FALSE
      , NULL
      , FALSE
      , NULL
   FROM Metric m
   WHERE m.MetricID IN (SELECT mb.MetricID FROM MetricKeys mb)
      AND m.UnitID = 2; --Porcentaje

   -- Metricas Milisegundos
   INSERT INTO MetricRange
   (
      MetricID
      , ProfileID
      , BooleanFlag
      , BooleanAcceptanceValue
      , PercentageFlag
      , PercentageAcceptanceValue
      , IntegerFlag
      , IntegerAcceptanceValue
      , EnumerateFlag
      , EnumerateAcceptanceValue
   )
   SELECT 
      m.MetricID
      , LastProfileID
      , FALSE
      , NULL
      , FALSE
      , NULL
      , TRUE --Milisegundos
      , 10000 --Por defecto en 10 segundos
      , FALSE
      , NULL
   FROM Metric m
   WHERE m.MetricID IN (SELECT mb.MetricID FROM MetricKeys mb)
      AND m.UnitID = 3; --Milisegundos

   -- Metricas Basico-Intermedio-Completo
   INSERT INTO MetricRange
   (
      MetricID
      , ProfileID
      , BooleanFlag
      , BooleanAcceptanceValue
      , PercentageFlag
      , PercentageAcceptanceValue
      , IntegerFlag
      , IntegerAcceptanceValue
      , EnumerateFlag
      , EnumerateAcceptanceValue
   )
   SELECT 
      m.MetricID
      , LastProfileID
      , FALSE
      , NULL
      , FALSE
      , NULL
      , FALSE
      , NULL
      , TRUE --Basico-Intermedio-Completo
      , 'I' -- 'B' = Basico, 'I' = Intermedio, 'C' = Completo
   FROM Metric m
   WHERE m.MetricID IN (SELECT mb.MetricID FROM MetricKeys mb)
      AND m.UnitID = 4; --Basico-Intermedio-Completo

   -- Metricas Entero
   INSERT INTO MetricRange
   (
      MetricID
      , ProfileID
      , BooleanFlag
      , BooleanAcceptanceValue
      , PercentageFlag
      , PercentageAcceptanceValue
      , IntegerFlag
      , IntegerAcceptanceValue
      , EnumerateFlag
      , EnumerateAcceptanceValue
   )
   SELECT 
      m.MetricID
      , LastProfileID
      , FALSE
      , NULL
      , FALSE
      , NULL
      , TRUE --Entero
      , 1 --Por defecto en 1
      , FALSE
      , NULL
   FROM Metric m
   WHERE m.MetricID IN (SELECT mb.MetricID FROM MetricKeys mb)
      AND m.UnitID = 5; --Entero

   -- Carga de valores de peso en 0 por defecto al dar de alta un perfil ponderado  
   IF (pIsWeightedFlag = TRUE)
   THEN
      -- Carga de pesos para los rangos de metricas
      INSERT INTO Weighing
      (
         ProfileID
         , ElementID -- DimensionID, FactorID, MetricID, MetricRangeID
         , ElementType -- 'D' = Dimension, 'F' = Factor, 'M' = Metrica, 'R' = Rango
         , NumeratorValue
         , DenominatorValue
      )
      SELECT
         LastProfileID
         , mr.MetricRangeID
         , 'R'
         , 1
         , NULL
      FROM MetricKeys mk
      INNER JOIN MetricRange mr ON mr.MetricID = mk.MetricID
      WHERE mr.ProfileID = LastProfileID
      GROUP BY
         LastProfileID
         , mr.MetricRangeID;
     
      -- Carga de pesos para las metricas
      INSERT INTO Weighing
      (
         ProfileID
         , ElementID -- DimensionID, FactorID, MetricID, MetricRangeID
         , ElementType -- 'D' = Dimension, 'F' = Factor, 'M' = Metrica, 'R' = Rango
         , NumeratorValue
         , DenominatorValue
      )
      SELECT
         LastProfileID
         , m.MetricID
         , 'M'
         , 1
         , NULL
      FROM MetricKeys mk
      INNER JOIN MetricRange mr ON mr.MetricID = mk.MetricID
      INNER JOIN Metric m ON m.MetricID = mr.MetricID
      WHERE mr.ProfileID = LastProfileID
      GROUP BY
         LastProfileID
         , m.MetricID;

      -- Carga de pesos para los factores
      INSERT INTO Weighing
      (
         ProfileID
         , ElementID -- DimensionID, FactorID, MetricID, MetricRangeID
         , ElementType -- 'D' = Dimension, 'F' = Factor, 'M' = Metrica, 'R' = Rango
         , NumeratorValue
         , DenominatorValue
      )
      SELECT
         LastProfileID
         , f.FactorID
         , 'F'
         , 1
         , NULL
      FROM MetricKeys mk
      INNER JOIN MetricRange mr ON mr.MetricID = mk.MetricID
      INNER JOIN Metric m ON m.MetricID = mr.MetricID
      INNER JOIN Factor f ON f.FactorID = m.FactorID
      WHERE mr.ProfileID = LastProfileID
      GROUP BY
         LastProfileID
        , f.FactorID;
       
      -- Carga de pesos para las dimensiones
      INSERT INTO Weighing
      (
         ProfileID
         , ElementID -- DimensionID, FactorID, MetricID, MetricRangeID
         , ElementType -- 'D' = Dimension, 'F' = Factor, 'M' = Metrica, 'R' = Rango
         , NumeratorValue
         , DenominatorValue
      )
      SELECT
         LastProfileID
         , d.DimensionID
         , 'D'
         , 1
         , NULL
      FROM MetricKeys mk
      INNER JOIN MetricRange mr ON mr.MetricID = mk.MetricID
      INNER JOIN Metric m ON m.MetricID = mr.MetricID
      INNER JOIN Factor f ON f.FactorID = m.FactorID
      INNER JOIN Dimension d ON d.DimensionID = f.DimensionID
      WHERE mr.ProfileID = LastProfileID
      GROUP BY
         LastProfileID
         , d.DimensionID;       
		 
      -- Carga de pesos para las dimensiones
      INSERT INTO Weighing
      (
         ProfileID
         , ElementID -- QualityModelID, DimensionID, FactorID, MetricID, MetricRangeID
         , ElementType -- 'Q' = QualityModel, 'D' = Dimension, 'F' = Factor, 'M' = Metrica, 'R' = Rango
         , NumeratorValue
         , DenominatorValue
      )
      SELECT
         LastProfileID
         , q.QualityModelID
         , 'Q'
         , 1
         , NULL
      FROM MetricKeys mk
      INNER JOIN MetricRange mr ON mr.MetricID = mk.MetricID
      INNER JOIN Metric m ON m.MetricID = mr.MetricID
      INNER JOIN Factor f ON f.FactorID = m.FactorID
      INNER JOIN Dimension d ON d.DimensionID = f.DimensionID
	  INNER JOIN QualityModel q ON q.QualityModelID = d.QualityModelID
      WHERE mr.ProfileID = LastProfileID
      GROUP BY
         LastProfileID
         , q.QualityModelID;
   END IF;
   
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
--DROP FUNCTION profile_metric_get(integer, integer);
CREATE OR REPLACE FUNCTION profile_metric_get
(
   pProfileID INT
   , pUnitID INT
)
RETURNS TABLE 
   (
      QualityModelID INT
      , QualityModelName VARCHAR(40)
      , DimensionID INT
      , DimensionName VARCHAR(40)
      , FactorID INT
      , FactorName VARCHAR(40)
      , MetricID INT
      , MetricName VARCHAR(100)
      , MetricAgrgegationFlag BOOLEAN
      , MetricGranurality VARCHAR(11)
      , MetricDescription VARCHAR(100)
	  , MetricManual BOOLEAN
	  , IsUserMetric BOOLEAN
	  , MetricFileName VARCHAR(100)
      , UnitID INT
      , UnitName VARCHAR(40)
      , UnitDescription VARCHAR(100)
      , MetricRangeID INT
      , BooleanFlag BOOLEAN
      , BooleanAcceptanceValue BOOLEAN
      , PercentageFlag BOOLEAN
      , PercentageAcceptanceValue INT
      , IntegerFlag BOOLEAN
      , IntegerAcceptanceValue INT
      , EnumerateFlag BOOLEAN
      , EnumerateAcceptanceValue CHAR(1)
 ) AS $$
/************************************************************************************************************
** Name: profile_metric_get
**
** Desc: Devuelve las Metricas asociadas al Perfil y para la Unidad pasada por parmetro, así como todo el modelo de calidad en cuestión.
**       Si no se especifica Unidad, entonces se devuelve la lista entera de Metricas asociadas al Perfil.
**
** 02/28/2016 - Created
**
*************************************************************************************************************/
BEGIN

   -- parametros requeridos
   IF (pProfileID IS NULL)
   THEN
      RAISE EXCEPTION 'Error - El parametro ID de Perfil es requerido.';
   END IF;

   -- validación de Perfil
   IF NOT EXISTS
      (
         SELECT 1
         FROM Profile p
         WHERE p.ProfileID = pProfileID
      )
   THEN
      RAISE EXCEPTION 'Error - El ID de Perfil pasado por parametro no es correcto.';
   END IF;

   -- validación de Unidad
   IF (pUnitID IS NOT NULL) AND NOT EXISTS
      (
         SELECT 1
         FROM Unit u
         WHERE u.UnitID = pUnitID
      )
   THEN
      RAISE EXCEPTION 'Error - El ID de Unidad pasado por parametro no es correcto.';
   END IF;

   -- Lista de modelos de calidad
   RETURN QUERY
   SELECT qm.QualityModelID
      , qm.Name
      , d.DimensionID
      , d.Name
      , f.FactorID
      , f.Name
      , m.MetricID
      , m.Name
      , m.AgrgegationFlag
      , m.Granurality
      , m.Description
	  , m.IsManual
	  , m.IsUserMetric
	  , m.MetricFileName
      , u.UnitID
      , u.Name
      , u.Description
      , mr.MetricRangeID
      , mr.BooleanFlag
      , mr.BooleanAcceptanceValue
      , mr.PercentageFlag
      , mr.PercentageAcceptanceValue
      , mr.IntegerFlag
      , mr.IntegerAcceptanceValue
      , mr.EnumerateFlag
      , mr.EnumerateAcceptanceValue
   FROM QualityModel qm
   INNER JOIN Dimension d ON d.QualityModelID = qm.QualityModelID
   INNER JOIN Factor f ON f.DimensionID = d.DimensionID
   INNER JOIN Metric m ON m.FactorID = f.FactorID
   INNER JOIN Unit u ON u.UnitID = m.UnitID 
   INNER JOIN MetricRange mr ON mr.MetricID = m.MetricID
   INNER JOIN Profile p ON p.ProfileID = mr.ProfileID
   WHERE p.ProfileID = pProfileID
      AND u.UnitID = COALESCE(pUnitID,u.UnitID)
   GROUP BY qm.QualityModelID
      , qm.Name
      , d.DimensionID
      , d.Name
      , f.FactorID
      , f.Name
      , m.MetricID
      , m.Name
      , m.AgrgegationFlag
      , m.Granurality
      , m.Description
	  , m.IsManual
	  , m.IsUserMetric
	  , m.MetricFileName
      , u.UnitID
      , u.Name
      , u.Description
      , mr.MetricRangeID
      , mr.BooleanFlag
      , mr.BooleanAcceptanceValue
      , mr.PercentageFlag
      , mr.PercentageAcceptanceValue
      , mr.IntegerFlag
      , mr.IntegerAcceptanceValue
      , mr.EnumerateFlag
      , mr.EnumerateAcceptanceValue
   ORDER BY QualityModelID
      , d.DimensionID
      , f.FactorID
      , m.MetricID
      , u.UnitID
      , mr.MetricRangeID;
        
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
--DROP FUNCTION profile_metric_update(integer,integer,boolean,integer,integer,character);
CREATE OR REPLACE FUNCTION profile_metric_update
(
   pMetricRangeID INT
   , pBooleanAcceptanceValue BOOLEAN
   , pPercentageAcceptanceValue INT
   , pIntegerAcceptanceValue INT
   , pEnumerateAcceptanceValue CHAR(1)
)
RETURNS VOID AS $$
/************************************************************************************************************
** Name: profile_metric_update()
**
** Desc: Actualiza datos de MetricRange (metricas asociadas a un perfil)
**
** 07/03/2017 - Created
**
*************************************************************************************************************/
DECLARE v_UnitID INT;

BEGIN

   -- parametros requeridos
   IF (pMetricRangeID IS NULL)
   THEN
      RAISE EXCEPTION 'Error - El parametros ID de Rango de Metrica es requerido.';
   END IF;

   -- validación de existencia de Rango Metrica
   IF NOT EXISTS (SELECT 1 FROM MetricRange mr WHERE mr.MetricRangeID = pMetricRangeID)
   THEN
      RAISE EXCEPTION 'Error - El Rango de Metrica no es correcto';
   END IF;
   
   SELECT m.UnitID INTO v_UnitID
   FROM MetricRange mr
   INNER JOIN Metric m ON m.MetricID = mr.MetricID
   WHERE mr.MetricRangeID = pMetricRangeID;

   -- Actualizar datos de Perfil
   IF (v_UnitID = 1)  --Boleano
   THEN
      UPDATE MetricRange
      SET BooleanAcceptanceValue = pBooleanAcceptanceValue
      WHERE MetricRangeID = pMetricRangeID;
   ELSIF (v_UnitID = 2)  --Porcentaje
   THEN
      UPDATE MetricRange
      SET PercentageAcceptanceValue = pPercentageAcceptanceValue
      WHERE MetricRangeID = pMetricRangeID;
   ELSIF (v_UnitID = 3 OR v_UnitID = 5)  --Milisegundos o Entero
   THEN
      UPDATE MetricRange
      SET IntegerAcceptanceValue = pIntegerAcceptanceValue
      WHERE MetricRangeID = pMetricRangeID;
   ELSIF (v_UnitID = 4)  --Basico-Intermedio-Completo
   THEN
      UPDATE MetricRange
      SET EnumerateAcceptanceValue = pEnumerateAcceptanceValue
      WHERE MetricRangeID = pMetricRangeID;
   END IF;
   
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
--DROP FUNCTION profile_remove_metric (integer, integer);
CREATE OR REPLACE FUNCTION profile_remove_metric
(
   pProfileID INT
   , pMetricID INT
)
RETURNS VOID AS $$
/************************************************************************************************************
** Name: profile_remove_metric
**
** Desc: Remueve la metrica de la lista de metricas disponibles para el perfil de ID pProfileID
**
** 04/03/2017 Created
**
*************************************************************************************************************/

BEGIN

   -- parametros requeridos
   IF (pProfileID IS NULL OR pMetricID IS NULL)
   THEN
      RAISE EXCEPTION 'Error - Los parametros ID de Perfil e ID de Metrica son requeridos.';
   END IF;
    
   -- validación de existencia de Perfil
   IF NOT EXISTS (SELECT 1 FROM Profile p WHERE p.ProfileID = pProfileID)
   THEN
      RAISE EXCEPTION 'Error - El Perfil de ID: % no existe.', pProfileID;
   END IF;

   -- validación de existencia de Metrica
   IF NOT EXISTS (SELECT 1 FROM Metric m WHERE m.MetricID = pMetricID)
   THEN
      RAISE EXCEPTION 'Error - La Metrica de ID: % no existe.', pMetricID;
   END IF;

   -- validación de Metrica asociada al Perfil
   IF NOT EXISTS (SELECT 1 FROM MetricRange mr WHERE mr.MetricID = pMetricID AND mr.ProfileID = pProfileID)
   THEN
      RAISE EXCEPTION 'Error - La Metrica de ID: % no se encuentra asociada al Perfil de ID: %.', pMetricID, pProfileID;
   END IF;
   
   DELETE FROM MetricRange
   WHERE MetricID = pMetricID
      AND ProfileID = pProfileID;

END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
--DROP FUNCTION profile_update();
CREATE OR REPLACE FUNCTION profile_update
(
   pProfileID INT
   , pName VARCHAR(40)
   , pGranurality VARCHAR(11) -- 'Ide', 'Institución', 'Nodo', 'Capa', 'Servicio',
   , pIsWeightedFlag BOOLEAN
)
RETURNS VOID AS $$
/************************************************************************************************************
** Name: profile_update()
**
** Desc: Actualiza datos de Perfil
**
** 04/03/2017 - Created
**
*************************************************************************************************************/
DECLARE v_wasWeightedFlag BOOLEAN;

BEGIN
   
   -- parametros requeridos
   IF (pProfileID IS NULL)
   THEN
      RAISE EXCEPTION 'Error - El parametroe ID de Perfil es requerido.';
   END IF;

   -- validación de existencia de Perfil
   IF NOT EXISTS (SELECT 1 FROM Profile p WHERE p.ProfileID = pProfileID)
   THEN
      RAISE EXCEPTION 'Error - El Perfil de ID: % no existe.', pProfileID;
   END IF;
   
   SELECT IsWeightedFlag
   FROM Profile p
   WHERE p.ProfileID = pProfileID
   INTO v_wasWeightedFlag;
   
   -- Actualizar datos de Perfil
   UPDATE Profile
   SET Name = pName
      , Granurality = pGranurality
      , IsWeightedFlag = pIsWeightedFlag
   WHERE ProfileID = pProfileID;
   
   IF (pIsWeightedFlag != v_wasWeightedFlag)
   THEN
      -- de ponderado a no ponderado
      IF (pIsWeightedFlag = FALSE)
      THEN
         DELETE
         FROM Weighing
         WHERE ProfileID = pProfileID;     
      
	  -- de no ponderado a ponderado
      ELSE
         CREATE TEMP TABLE MetricKeys
         (
            MetricID INT
         );

         INSERT INTO MetricKeys
         (MetricID)
         SELECT m.MetricID
         FROM MetricRange mr
         INNER JOIN Metric m ON m.MetricID = mr.MetricID
         WHERE mr.ProfileID = pProfileID
         GROUP BY m.MetricID;
       
         -- Carga de pesos para los rangos de metricas
         INSERT INTO Weighing
         (
           ProfileID
           , ElementID -- DimensionID, FactorID, MetricID, MetricRangeID
           , ElementType -- 'D' = Dimension, 'F' = Factor, 'M' = Metrica, 'R' = Rango
           , NumeratorValue
           , DenominatorValue
         )
         SELECT
           pProfileID
           , mr.MetricRangeID
           , 'R'
           , 0
           , NULL
         FROM MetricKeys mk
         INNER JOIN MetricRange mr ON mr.MetricID = mk.MetricID
         WHERE mr.ProfileID = pProfileID
         GROUP BY
           pProfileID
           , mr.MetricRangeID;
         
         -- Carga de pesos para las metricas
         INSERT INTO Weighing
         (
           ProfileID
           , ElementID -- DimensionID, FactorID, MetricID, MetricRangeID
           , ElementType -- 'D' = Dimension, 'F' = Factor, 'M' = Metrica, 'R' = Rango
           , NumeratorValue
           , DenominatorValue
         )
         SELECT
           pProfileID
           , m.MetricID
           , 'M'
           , 0
           , NULL
         FROM MetricKeys mk
         INNER JOIN MetricRange mr ON mr.MetricID = mk.MetricID
         INNER JOIN Metric m ON m.MetricID = mr.MetricID
         WHERE mr.ProfileID = pProfileID
         GROUP BY
           pProfileID
           , m.MetricID;

         -- Carga de pesos para los factores
         INSERT INTO Weighing
         (
           ProfileID
           , ElementID -- DimensionID, FactorID, MetricID, MetricRangeID
           , ElementType -- 'D' = Dimension, 'F' = Factor, 'M' = Metrica, 'R' = Rango
           , NumeratorValue
           , DenominatorValue
         )
         SELECT
           pProfileID
           , f.FactorID
           , 'F'
           , 0
           , NULL
         FROM MetricKeys mk
         INNER JOIN MetricRange mr ON mr.MetricID = mk.MetricID
         INNER JOIN Metric m ON m.MetricID = mr.MetricID
         INNER JOIN Factor f ON f.FactorID = m.FactorID
         WHERE mr.ProfileID = pProfileID
         GROUP BY
           pProfileID
          , f.FactorID;
          
         -- Carga de pesos para las dimensiones
         INSERT INTO Weighing
         (
           ProfileID
           , ElementID -- DimensionID, FactorID, MetricID, MetricRangeID
           , ElementType -- 'D' = Dimension, 'F' = Factor, 'M' = Metrica, 'R' = Rango
           , NumeratorValue
           , DenominatorValue
         )
         SELECT
           pProfileID
           , d.DimensionID
           , 'D'
           , 0
           , NULL
         FROM MetricKeys mk
         INNER JOIN MetricRange mr ON mr.MetricID = mk.MetricID
         INNER JOIN Metric m ON m.MetricID = mr.MetricID
         INNER JOIN Factor f ON f.FactorID = m.FactorID
         INNER JOIN Dimension d ON d.DimensionID = f.DimensionID
         WHERE mr.ProfileID = pProfileID
         GROUP BY
           pProfileID
           , d.DimensionID;       
           
         -- Carga de pesos para las dimensiones
         INSERT INTO Weighing
         (
           ProfileID
           , ElementID -- QualityModelID, DimensionID, FactorID, MetricID, MetricRangeID
           , ElementType -- 'Q' = QualityModel, 'D' = Dimension, 'F' = Factor, 'M' = Metrica, 'R' = Rango
           , NumeratorValue
           , DenominatorValue
         )
         SELECT
           pProfileID
           , q.QualityModelID
           , 'Q'
           , 0
           , NULL
         FROM MetricKeys mk
         INNER JOIN MetricRange mr ON mr.MetricID = mk.MetricID
         INNER JOIN Metric m ON m.MetricID = mr.MetricID
         INNER JOIN Factor f ON f.FactorID = m.FactorID
         INNER JOIN Dimension d ON d.DimensionID = f.DimensionID
         INNER JOIN QualityModel q ON q.QualityModelID = d.QualityModelID
         WHERE mr.ProfileID = pProfileID
         GROUP BY
           pProfileID
           , q.QualityModelID;     
      END IF;
   END IF;
    
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
--DROP FUNCTION prototype_measurable_object_update();
CREATE OR REPLACE FUNCTION prototype_measurable_object_update
(
   pMeasurableObjectID INT
   , pUrl VARCHAR(1024)
   , pGeographicServicesType CHAR(3) -- WMS, WFS, CSW
   , pName VARCHAR(70)
   , pDescription VARCHAR(100)
)
RETURNS VOID AS $$
/************************************************************************************************************
** Name: prototype_measurable_object_update()
**
** Desc: Actualiza datos de Objetos Medibles
**
** 28/02/2017 - Created
**
*************************************************************************************************************/
DECLARE v_EntityID INT;
DECLARE v_EntityType VARCHAR(11);

BEGIN
   
   -- parametros requeridos
   IF (pMeasurableObjectID IS NULL)
   THEN
      RAISE EXCEPTION 'Error - El ID de Objeto Medible es requerido.';
   END IF;
   
   SELECT mo.EntityID, mo.EntityType FROM MeasurableObject mo WHERE mo.MeasurableObjectID = pMeasurableObjectID INTO v_EntityID, v_EntityType;
   
   -- validacion de nodo
   IF (v_EntityType = 'Servicio') AND NOT EXISTS (SELECT 1 FROM GeographicServices sg INNER JOIN Node n ON n.NodeID = sg.NodeID WHERE sg.GeographicServicesID = v_EntityID)
   THEN
      RAISE EXCEPTION 'Error - El Servicio Geografico no existe o el Nodo pasado por parametro es incorrecto.';
   END IF;
       
   -- Actualizar datos de objetods medibles
   IF (v_EntityType = 'Servicio')
   THEN
      UPDATE GeographicServices
      SET Url = pUrl
         , GeographicServicesType = pGeographicServicesType
         , Description = pDescription
      WHERE GeographicServicesID = v_EntityID;

   ELSIF (v_EntityType = 'Capa')
   THEN
      UPDATE Layer
      SET Url = pUrl
         , Name = pName
         , Description = pDescription
      WHERE LayerID = v_EntityID;

   ELSIF (v_EntityType = 'Nodo')
   THEN
      UPDATE Node
      SET Name = pName
         , Description = pDescription
      WHERE NodeID = v_EntityID;   
   
   ELSIF (v_EntityType = 'Institución')
   THEN
      UPDATE Institution
      SET Name = pName
         , Description = pDescription
      WHERE InstitutionID = v_EntityID;
      
   ELSIF (v_EntityType = 'Ide')
   THEN
      UPDATE Ide
      SET Name = pName
         , Description = pDescription
      WHERE IdeID = v_EntityID;   
   END IF;
   
    
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */

CREATE OR REPLACE FUNCTION evaluation_periodic_update
(
 pEvaluationSummaryID INT
   , pMeasurableObjectUrl VARCHAR(1024)
   , pEvaluatedCount INT
   , pPeriodic DATE
   , pSuccessCount INT
   , pSuccessPercentage INT
   , pMeasurableObjectDesc VARCHAR(1024)
   , pUserID INT
)
RETURNS VOID AS $$
/************************************************************************************************************
** Name: evaluation_periodic_update()
*************************************************************************************************************/

BEGIN

   UPDATE EvaluationPeriodic
   SET EvaluationSummaryID = pEvaluationSummaryID
      , MeasurableObjectUrl = pMeasurableObjectUrl
      , EvaluatedCount = pEvaluatedCount
      , Periodic = pPeriodic
      , SuccessCount = pSuccessCount
      , SuccessPercentage = pSuccessPercentage
	  , MeasurableObjectDesc = pMeasurableObjectDesc
	  , UserID = pUserID
   WHERE EvaluationSummaryID = pEvaluationSummaryID;
    
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
--DROP FUNCTION prototype_measurable_objects_delete(integer);
CREATE OR REPLACE FUNCTION prototype_measurable_objects_delete
(
   pMeasurableObjectID INT
)
RETURNS VOID AS $$
/************************************************************************************************************
** Name: prototype_measurable_objects_delete
**
** Desc: Borra un objeto medible
**
** 08/12/2016 Created
**
*************************************************************************************************************/
DECLARE v_EntityType VARCHAR(11);
DECLARE v_EntityID INT;

BEGIN

   -- parametros requeridos
   IF (pMeasurableObjectID IS NULL)
   THEN
      RAISE EXCEPTION 'Error - El parametro ID de Objeto Medible es requerido.';
   END IF;
    
   -- validacion de Objeto Medible
   IF NOT EXISTS 
      (
         SELECT 1 
         FROM UserMeasurableObject umo 
         WHERE MeasurableObjectID = pMeasurableObjectID
      )
   THEN
      RAISE EXCEPTION 'Error - El Objeto Medible que se intenta eliminar no existe.';
   END IF;
	
   SELECT mo.EntityType, mo.EntityID FROM MeasurableObject mo WHERE mo.MeasurableObjectID = pMeasurableObjectID INTO v_EntityType, v_EntityID;
	
   -- validacion Servicio Geografico
   IF (v_EntityType = 'Servicio')
      AND NOT EXISTS (SELECT 1 FROM GeographicServices sg WHERE sg.GeographicServicesID = v_EntityID)
   THEN
      RAISE EXCEPTION 'Error - El Servicio Geografico que se intenta eliminar no existe.';
   END IF;

   -- Borrado de registros dependientes del Objeto Medible
   DELETE FROM UserMeasurableObject
   WHERE MeasurableObjectID = pMeasurableObjectID;

   DELETE FROM PartialEvaluation pe
   USING EvaluationSummary es
      , Evaluation e
   WHERE e.EvaluationSummaryID = es.EvaluationSummaryID
      AND e.EvaluationID = pe.EvaluationID
      AND es.MeasurableObjectID = pMeasurableObjectID;

   DELETE FROM Evaluation e
   USING EvaluationSummary es
   WHERE es.EvaluationSummaryID = e.EvaluationSummaryID
      AND es.MeasurableObjectID = pMeasurableObjectID;

   DELETE FROM EvaluationSummary
   WHERE MeasurableObjectID = pMeasurableObjectID;   
   
   IF v_EntityType = 'Servicio'
   THEN
      DELETE FROM GeographicServices
      WHERE GeographicServicesID = v_EntityID;
   END IF;
         
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
CREATE OR REPLACE FUNCTION prototype_measurable_objects_get
(
   pUserID INT
)
RETURNS TABLE 
   (
      MeasurableObjectID INT
      , EntityID INT
      , EntityType VARCHAR(11)
      , MeasurableObjectName VARCHAR(70)
      , MeasurableObjectDescription VARCHAR(100)
      , MeasurableObjectURL VARCHAR(1024)
      , MeasurableObjectServicesType CHAR(3)
 ) AS $$
/************************************************************************************************************
** Name: prototype_measurable_objects_get
**
** Desc: Devuelve la lista de objetos medibles disponibles. Si se pasa el usuario, entonces se filtra por el mismo
** Se debe ampliar a otros objetos medibles.
**
** 02/12/2016 - Created
**
*************************************************************************************************************/
BEGIN

   -- Lista de objetos medibles sobre los cuales el usuario puede realizar evaluaciones
   RETURN QUERY
   SELECT mo.MeasurableObjectID
      , mo.EntityID
      , mo.EntityType
      , CASE
         --WHEN mo.EntityType = 'Ide' THEN ide.Name
         --WHEN mo.EntityType = 'Institución' THEN ins.Name
         --WHEN mo.EntityType = 'Nodo' THEN n.Name
         WHEN mo.EntityType = 'Capa' THEN l.Name
         WHEN mo.EntityType = 'Servicio' THEN NULL ::VARCHAR(70)
         END AS MeasurableObjectName
      , CASE
         --WHEN mo.EntityType = 'Ide' THEN ide.Description
         --WHEN mo.EntityType = 'Institución' THEN ins.Description
         --WHEN mo.EntityType = 'Nodo' THEN n.Description
         WHEN mo.EntityType = 'Capa' THEN l.Description
         WHEN mo.EntityType = 'Servicio' THEN sg.Description
         END AS MeasurableObjectDescription
      , CASE
         --WHEN mo.EntityType = 'Ide' THEN NULL
         --WHEN mo.EntityType = 'Institución' THEN NULL
         --WHEN mo.EntityType = 'Nodo' THEN NULL
         WHEN mo.EntityType = 'Capa' THEN l.Url
         WHEN mo.EntityType = 'Servicio' THEN sg.Url
         END AS MeasurableObjectURL
      , CASE
         --WHEN mo.EntityType = 'Ide' THEN NULL
         --WHEN mo.EntityType = 'Institución' THEN NULL
         --WHEN mo.EntityType = 'Nodo' THEN NULL
         WHEN mo.EntityType = 'Capa' THEN 'WMS'
         WHEN mo.EntityType = 'Servicio' THEN sg.GeographicServicesType
         END AS MeasurableObjectServicesType
   FROM MeasurableObject mo
   INNER JOIN UserMeasurableObject umo ON umo.MeasurableObjectID = mo.MeasurableObjectID
   LEFT JOIN GeographicServices sg ON mo.EntityID = sg.GeographicServicesID AND mo.EntityType = 'Servicio'
   LEFT JOIN Layer l ON mo.EntityID = l.LayerID AND mo.EntityType = 'Capa'
   LEFT JOIN SystemUser u ON u.UserID = umo.UserID
   WHERE (CASE WHEN pUserID IS NOT NULL THEN u.UserID = pUserID ELSE TRUE END)
      AND (CASE WHEN pUserID IS NOT NULL THEN umo.CanMeasureFlag = TRUE ELSE TRUE END)
      AND (mo.EntityType = 'Servicio' OR mo.EntityType = 'Capa')
   GROUP BY mo.MeasurableObjectID
      , mo.EntityID
      , mo.EntityType
      --, ide.Name
      --, ins.Name
      --, n.Name
      , l.Name
      , l.Description
      , l.Url
      --, ide.Description
      --, ins.Description
      --, n.Description
      , sg.Description
      , sg.Url
      , sg.GeographicServicesType
   ORDER BY mo.MeasurableObjectID;
        
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
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
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
--DROP FUNCTION prototype_profile_add_metric (integer, integer);
CREATE OR REPLACE FUNCTION prototype_profile_add_metric
(
   pProfileID INT
   , pMetricID INT
)
RETURNS VOID AS $$
/************************************************************************************************************
** Name: prototype_profile_add_metric
**
** Desc: se asocia una metrica dada con un perfil determinado
**
** 05/03/2017 Created
**
*************************************************************************************************************/
BEGIN
    
   -- parametros requeridos
   IF (pProfileID IS NULL OR pMetricID IS NULL)
   THEN
      RAISE EXCEPTION 'Error - Los parametros ID de Perfil e ID de Metrica son requeridos.';
   END IF;
    
   -- validación de existencia de Perfil
   IF NOT EXISTS (SELECT 1 FROM Profile p WHERE p.ProfileID = pProfileID)
   THEN
      RAISE EXCEPTION 'Error - El Perfil de ID: % no existe.', pProfileID;
   END IF;

   -- validación de existencia de Metrica
   IF NOT EXISTS (SELECT 1 FROM Metric m WHERE m.MetricID = pMetricID)
   THEN
      RAISE EXCEPTION 'Error - La Metrica de ID: % no existe.', pMetricID;
   END IF;

   -- validación de asociación de Metrica y Perfil
   IF EXISTS (SELECT 1 FROM MetricRange mr WHERE mr.MetricID = pMetricID AND mr.ProfileID = pProfileID)
   THEN
      RAISE EXCEPTION 'Error - La Metrica ya se encuentra asociada al Perfil.';
   END IF;
         
    -- Insert de Rangos asociados a las Metricas y Perfil
   -- Metricas boleanas
   IF EXISTS (SELECT 1 FROM Metric m WHERE m.MetricID = pMetricID AND m.UnitID = 1) --Booleano
   THEN
      INSERT INTO MetricRange
      (
         MetricID
         , ProfileID
         , BooleanFlag
         , BooleanAcceptanceValue
         , PercentageFlag
         , PercentageAcceptanceValue
         , IntegerFlag
         , IntegerAcceptanceValue
         , EnumerateFlag
         , EnumerateAcceptanceValue
      )
      SELECT 
         pMetricID
         , pProfileID
         , TRUE --Boleano
         , TRUE --Por defecto en TRUE
         , FALSE
         , NULL
         , FALSE
         , NULL
         , FALSE
         , NULL;
   END IF;

   -- Metricas Porcentaje
   IF EXISTS (SELECT 1 FROM Metric m WHERE m.MetricID = pMetricID AND m.UnitID = 2) --Porcentaje
   THEN
      INSERT INTO MetricRange
      (
         MetricID
         , ProfileID
         , BooleanFlag
         , BooleanAcceptanceValue
         , PercentageFlag
         , PercentageAcceptanceValue
         , IntegerFlag
         , IntegerAcceptanceValue
         , EnumerateFlag
         , EnumerateAcceptanceValue
      )
      SELECT 
         pMetricID
         , pProfileID
         , FALSE
         , NULL
         , TRUE --Porcentaje
         , 50 --Por defecto en 50%
         , FALSE
         , NULL
         , FALSE
         , NULL;
   END IF;

   -- Metricas Milisegundos
   IF EXISTS (SELECT 1 FROM Metric m WHERE m.MetricID = pMetricID AND m.UnitID = 3) --Milisegundos
   THEN
      INSERT INTO MetricRange
      (
         MetricID
         , ProfileID
         , BooleanFlag
         , BooleanAcceptanceValue
         , PercentageFlag
         , PercentageAcceptanceValue
         , IntegerFlag
         , IntegerAcceptanceValue
         , EnumerateFlag
         , EnumerateAcceptanceValue
      )
      SELECT 
         pMetricID
         , pProfileID
         , FALSE
         , NULL
         , FALSE
         , NULL
         , TRUE --Milisegundos
         , 10000 --Por defecto en 10 segundos
         , FALSE
         , NULL;
   END IF;

   -- Metricas Basico-Intermedio-Completo
   IF EXISTS (SELECT 1 FROM Metric m WHERE m.MetricID = pMetricID AND m.UnitID = 4) --Basico-Intermedio-Completo
   THEN
      INSERT INTO MetricRange
      (
         MetricID
         , ProfileID
         , BooleanFlag
         , BooleanAcceptanceValue
         , PercentageFlag
         , PercentageAcceptanceValue
         , IntegerFlag
         , IntegerAcceptanceValue
         , EnumerateFlag
         , EnumerateAcceptanceValue
      )
      SELECT 
         pMetricID
         , pProfileID
         , FALSE
         , NULL
         , FALSE
         , NULL
         , FALSE
         , NULL
         , TRUE --Basico-Intermedio-Completo
         , 'I'; -- 'B' = Basico, 'I' = Intermedio, 'C' = Completo
   END IF;

   -- Metricas Entero
   IF EXISTS (SELECT 1 FROM Metric m WHERE m.MetricID = pMetricID AND m.UnitID = 5) --Entero
   THEN
      INSERT INTO MetricRange
      (
         MetricID
         , ProfileID
         , BooleanFlag
         , BooleanAcceptanceValue
         , PercentageFlag
         , PercentageAcceptanceValue
         , IntegerFlag
         , IntegerAcceptanceValue
         , EnumerateFlag
         , EnumerateAcceptanceValue
      )
      SELECT 
         pMetricID
         , pProfileID
         , FALSE
         , NULL
         , FALSE
         , NULL
         , TRUE --Entero
         , 1 --Por defecto en 1
         , FALSE
         , NULL;
   END IF;

END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
--DROP FUNCTION prototype_profile_metric_to_add_get(integer);
CREATE OR REPLACE FUNCTION prototype_profile_metric_to_add_get
(
   pProfileID INT
)
RETURNS TABLE (
   MetricID INT
   , MetricFactorID INT	  
   , MetricName VARCHAR(100)
   , MetricAgrgegationFlag BOOLEAN
   , MetricUnitID INT
   , MetricGranurality VARCHAR(11)
   , MetricDescription VARCHAR(100)
   , MetricManual BOOLEAN
) AS $$
/************************************************************************************************************
** Name: prototype_profile_metric_to_add_get
**
** Desc: Lista las metricas que se pueden asociar al Perfil, que aun no han sido asociadas
**
** 05/03/2017 Created
**
*************************************************************************************************************/

BEGIN

   -- parametros requeridos
   IF (pProfileID IS NULL)
   THEN
      RAISE EXCEPTION 'Error - El parametro ID de Perfil es requerido.';
   END IF;
    
   -- validacion Usuario
   IF NOT EXISTS (SELECT 1 FROM Profile p WHERE p.ProfileID = pProfileID)
   THEN
      RAISE EXCEPTION 'Error - El Perfil seleccionado no es correcto.';
   END IF;
   
   -- Lista de metricas que pueden ser asociadas al Perfil
   RETURN QUERY
   SELECT m.MetricID
      , m.FactorID
      , m.Name
      , m.AgrgegationFlag
      , m.UnitID
      , m.Granurality
      , m.Description
	  , m.IsManual
   FROM Metric m
   LEFT JOIN MetricRange mr ON mr.MetricID = m.MetricID AND mr.ProfileID = pProfileID
   WHERE mr.MetricRangeID IS NULL
   GROUP BY m.MetricID
      , m.FactorID
      , m.Name
      , m.AgrgegationFlag
      , m.UnitID
      , m.Granurality
      , m.Description;

END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
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
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
--DROP FUNCTION prototype_user_measurable_object_to_add_get(integer);
CREATE OR REPLACE FUNCTION prototype_user_measurable_object_to_add_get
(
   pUserID INT
)
RETURNS TABLE (
   MeasurableObjectID INT
   , EntityID INT
   , EntityType VARCHAR(11)
   , MeasurableObjectName VARCHAR(70)
   , MeasurableObjectDescription VARCHAR(100)
   , MeasurableObjectURL VARCHAR(1024)
   , MeasurableObjectServicesType CHAR(3)
) AS $$
/************************************************************************************************************
** Name: prototype_user_measurable_object_to_add_get
**
** Desc: Lista los objetos medibles que el usuario puede agregar a su lista de objetos que actualmente puede medir
**
** 21/02/2016 Created
**
*************************************************************************************************************/

BEGIN

   -- parametros requeridos
   IF (pUserID IS NULL)
   THEN
      RAISE EXCEPTION 'Error - El parametro ID de usuario es requerido.';
   END IF;
    
   -- validacion Usuario
   IF NOT EXISTS (SELECT 1 FROM SystemUser u WHERE u.UserID = pUserID)
   THEN
      RAISE EXCEPTION 'Error - El Usuario seleccionado no es correcto.';
   END IF;
   
   -- Lista de objetos medibles sobre los cuales el usuario puede realizar evaluaciones
   RETURN QUERY
   SELECT mo.MeasurableObjectID
      , mo.EntityID
      , mo.EntityType
      , CASE
         --WHEN mo.EntityType = 'Ide' THEN ide.Name
         --WHEN mo.EntityType = 'Institución' THEN ins.Name
         --WHEN mo.EntityType = 'Nodo' THEN n.Name
         --WHEN mo.EntityType = 'Capa' THEN l.Name
         WHEN mo.EntityType = 'Servicio' THEN NULL ::VARCHAR(70)
         END AS MeasurableObjectName
      , CASE
         --WHEN mo.EntityType = 'Ide' THEN ide.Description
         --WHEN mo.EntityType = 'Institución' THEN ins.Description
         --WHEN mo.EntityType = 'Nodo' THEN n.Description
         --WHEN mo.EntityType = 'Capa' THEN NULL
         WHEN mo.EntityType = 'Servicio' THEN sg.Description
         END AS MeasurableObjectDescription
      , CASE
         --WHEN mo.EntityType = 'Ide' THEN NULL
         --WHEN mo.EntityType = 'Institución' THEN NULL
         --WHEN mo.EntityType = 'Nodo' THEN NULL
         --WHEN mo.EntityType = 'Capa' THEN l.Url
         WHEN mo.EntityType = 'Servicio' THEN sg.Url
         END AS MeasurableObjectURL
      , CASE
         --WHEN mo.EntityType = 'Ide' THEN NULL
         --WHEN mo.EntityType = 'Institución' THEN NULL
         --WHEN mo.EntityType = 'Nodo' THEN NULL
         --WHEN mo.EntityType = 'Capa' THEN NULL
         WHEN mo.EntityType = 'Servicio' THEN sg.GeographicServicesType
         END AS MeasurableObjectServicesType
   FROM GeographicServices sg
   INNER JOIN MeasurableObject mo ON mo.EntityID = sg.GeographicServicesID AND mo.EntityType = 'Servicio'
   INNER JOIN UserMeasurableObject umo ON umo.MeasurableObjectID = mo.MeasurableObjectID
   WHERE mo.EntityType = 'Servicio'
      AND umo.UserID = pUserID
      AND umo.CanMeasureFlag = FALSE -- indica si el usuario puede evaluar el objeto en cuestion
   GROUP BY mo.MeasurableObjectID
      , mo.EntityID
      , mo.EntityType
      --, ide.Name
      --, ins.Name
      --, n.Name
      --, l.Name
      --, ide.Description
      --, ins.Description
      --, n.Description
      --, l.Url
      , sg.Description
      , sg.Url
      , sg.GeographicServicesType;
         
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
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
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
--DROP FUNCTION quality_models_get();
CREATE OR REPLACE FUNCTION quality_models_get()
RETURNS TABLE 
   (
      ElementID INT --QualityModelID, DimensionID, FactorID, MetricID
      , ElementName VARCHAR(100)
      , ElementType CHAR(1) --'Q' = QualityModel, 'D' = Dimension, 'F' = Factor, 'M' = Metrica
      , FatherElementyID INT
      , AggregationFlag BOOLEAN
      , Granularity VARCHAR(11)
      , Unit VARCHAR(40)
      , IsUserMetric BOOLEAN
      , MetricFileName VARCHAR(100)
 ) AS $$
/************************************************************************************************************
** Name: quality_models_get
**
** Desc: Devuelve los modelos de calidad existentes
**
** 02/28/2016 - Created
**
*************************************************************************************************************/
BEGIN
   
   RETURN QUERY
   SELECT
      qm.QualityModelID AS ElementID
      , qm.Name AS ElementName
      , 'Q' :: CHAR(1) AS ElementType
      , NULL :: INT
      , NULL :: BOOLEAN
      , NULL :: VARCHAR(11)
      , NULL :: VARCHAR(40)
      , NULL :: BOOLEAN
      , NULL :: VARCHAR(100)
   FROM QualityModel qm

   UNION
   
   SELECT
      d.DimensionID AS ElementID
      , d.Name AS ElementName
      , 'D' :: CHAR(1) AS ElementType
      , d.QualityModelID AS FatherElementyID
      , NULL :: BOOLEAN
      , NULL :: VARCHAR(11)
      , NULL :: VARCHAR(40)
      , NULL :: BOOLEAN
      , NULL :: VARCHAR(100)	  
   FROM Dimension d

   UNION
   
   SELECT
      f.FactorID AS ElementID
      , f.Name AS ElementName
      , 'F' :: CHAR(1) AS ElementType
      , f.DimensionID AS FatherElementyID
      , NULL :: BOOLEAN
      , NULL :: VARCHAR(11)
      , NULL :: VARCHAR(40)
      , NULL :: BOOLEAN
      , NULL :: VARCHAR(100)	  
   FROM Factor f

   UNION
   
   SELECT
      m.MetricID AS ElementID
      , m.Name AS ElementName
      , 'M' :: CHAR(1) AS ElementType
      , m.FactorID AS FatherElementyID
      , m.AgrgegationFlag
      , m.Granurality
      , u.Name AS Unit
      , m.IsUserMetric
      , m.MetricFileName	  
   FROM Metric m
   INNER JOIN Unit u ON u.UnitID = m.UnitID;
        
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
--DROP FUNCTION user_delete (integer)
CREATE OR REPLACE FUNCTION user_delete
(
   pUserID INT
)
RETURNS VOID AS $$
/************************************************************************************************************
** Name: user_delete
**
** Desc: Quita el Usuario de UsuarioID de la tabla Usuario
**
** 04/12/2016 - Created
**
*************************************************************************************************************/
-- TODO: Asegurarse desde el codigo o BD que al solicitar un borrado, no se llamen a posibles instancias pendientes de evaluacion para el usuario eliminado
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

   -- Borrado de registros dependientes del usuario  
   DELETE FROM UserMeasurableObject
   WHERE UserID = pUserID;

   DELETE FROM PartialEvaluation pe
   USING EvaluationSummary es
      , Evaluation e
   WHERE e.EvaluationSummaryID = es.EvaluationSummaryID
      AND e.EvaluationID = pe.EvaluationID
      AND es.UserID = pUserID;

   DELETE FROM Evaluation e
   USING EvaluationSummary es
   WHERE es.EvaluationSummaryID = e.EvaluationSummaryID
      AND es.UserID = pUserID;

   DELETE FROM EvaluationSummary
   WHERE UserID = pUserID;   
    
   -- Borrado del usuario de la tabla Usuario
   DELETE FROM SystemUser
   WHERE UserID = pUserID;
    
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
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
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
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
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
CREATE OR REPLACE FUNCTION user_insert
(
   pEmail VARCHAR(40)
   , pPassword VARCHAR(40)
   , pUserGroupID INT
   , pFirstName VARCHAR(40)
   , pLastName VARCHAR(40)
   , pPhoneNumber BIGINT
   , pInstitutionID INT
)
RETURNS VOID AS $$

/************************************************************************************************************
** Name: user_insert
**
** Desc: Agrega un usuario a la tabla Usuarios
**
** 02/12/2016 Created
**
*************************************************************************************************************/
DECLARE v_UserID INT;
BEGIN
    
   -- parametros requeridos
   IF (pEmail IS NULL OR pPassword IS NULL OR pUserGroupID IS NULL)
   THEN
      RAISE EXCEPTION 'Error - Los parametro email, password y grupo del usuario son requerido.';
   END IF;
    
   IF EXISTS (SELECT 1 FROM SystemUser u WHERE u.Email = pEmail)
   THEN      
      RAISE EXCEPTION 'Error - El email ya fue registrado. Usario ya existente.';
   END IF;

   INSERT INTO SystemUser
   (Email, Password, UserGroupID, FirstName, LastName, PhoneNumber, InstitutionID)
   VALUES
   (pEmail, pPassword, pUserGroupID, pFirstName, pLastName, pPhoneNumber, pInstitutionID)
      RETURNING UserID INTO v_UserID;

   --Negar permisos de evaluación sobre todos los objetos medible existentes a los usuarios que no sean ncalle o rsanchez
   INSERT INTO UserMeasurableObject (UserID, MeasurableObjectID, CanMeasureFlag)
   SELECT v_UserID, mo.MeasurableObjectID, FALSE
   FROM MeasurableObject mo;
    
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
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
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
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
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
--DROP FUNCTION report_geographic_services_per_institution();
CREATE OR REPLACE FUNCTION report_geographic_services_per_institution ()
RETURNS TABLE (InstitutionID INT, InstitutionName VARCHAR(70), GeographicServicesCount BIGINT, GeographicServicesPercentage NUMERIC) AS $$
/************************************************************************************************************
** Name: report_geographic_services_per_institution
**
** Desc: Devuelve la cantidad de servicios geograficos presentes por institucion
**
** 2017/03/09 - Created
**
*************************************************************************************************************/
DECLARE v_TotalGeographicServices BIGINT;

BEGIN
  
   SELECT COUNT(*) FROM GeographicServices gs INTO v_TotalGeographicServices;

   RETURN QUERY
   SELECT i.InstitutionID
      , i.Name
      , COUNT(gs.GeographicServicesID) AS GeographicServicesCount
      , CASE WHEN v_TotalGeographicServices = 0 THEN 0 ELSE ((COUNT(gs.GeographicServicesID) * 100.00) / v_TotalGeographicServices) END AS GeographicServicesPercentage
   FROM Institution i
   INNER JOIN Node n ON n.InstitutionID = i.InstitutionID
   INNER JOIN GeographicServices gs ON gs.NodeID = n.NodeID
   GROUP BY i.InstitutionID
      , i.Name
   ORDER BY COUNT(gs.GeographicServicesID) DESC;
               
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
--DROP FUNCTION report_evaluation_success_vs_failed();
CREATE OR REPLACE FUNCTION report_evaluation_success_vs_failed ()
RETURNS TABLE (SuccessCount BIGINT, FailCount BIGINT, SuccessPercentage NUMERIC, FailPercentage NUMERIC, TotalEvaluationCount BIGINT) AS $$
/************************************************************************************************************
** Name: report_evaluation_success_vs_failed
**
** Desc: Devuelve la cantidad de exitos sobre la cantidad fracasos del total de evaluaciones.
**
** 2017/03/09 - Created
**
*************************************************************************************************************/
DECLARE v_SuccessCount BIGINT;
DECLARE v_FailCount BIGINT;
DECLARE v_SuccessPercentage NUMERIC;
DECLARE v_FailPercentage NUMERIC;
DECLARE v_TotalEvaluationCount BIGINT;

BEGIN
  
   SELECT COUNT(*)
   FROM Evaluation e
   WHERE e.SuccessFlag = TRUE
   INTO v_SuccessCount;

   SELECT COUNT(*)
   FROM Evaluation e
   WHERE e.SuccessFlag = FALSE
   INTO v_FailCount;

   SELECT COUNT(*)
   FROM Evaluation e
   INTO v_TotalEvaluationCount;

   SELECT CASE WHEN v_TotalEvaluationCount = 0 THEN 0 ELSE (v_SuccessCount * 100.00 ) / v_TotalEvaluationCount END
   INTO v_SuccessPercentage;

   SELECT CASE WHEN v_TotalEvaluationCount = 0 THEN 0 ELSE (v_FailCount * 100.00) / v_TotalEvaluationCount END
   INTO v_FailPercentage;

   RETURN QUERY
   SELECT
      v_SuccessCount
      , v_FailCount
      , v_SuccessPercentage
      , v_FailPercentage
      , v_TotalEvaluationCount;
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
--DROP FUNCTION report_evaluations_per_metric();
CREATE OR REPLACE FUNCTION report_evaluations_per_metric ()
RETURNS TABLE (MetricID INT, MetricName VARCHAR(100), EvaluationPerMetricCount BIGINT, EvaluationPerMetricPercentage NUMERIC) AS $$
/************************************************************************************************************
** Name: report_evaluations_per_metric
**
** Desc: Devuelve la cantidad de evaluaciones realizadas por metrica
**
** 2017/03/09 - Created
**
*************************************************************************************************************/
DECLARE v_TotalEvaluationCount BIGINT;
BEGIN

   SELECT COUNT(*)
   FROM Evaluation e
   INTO v_TotalEvaluationCount;
  
   RETURN QUERY
   SELECT e.MetricID
      , m.Name
      , COUNT(e.MetricID) AS EvaluationPerMetricCount
      , CASE WHEN v_TotalEvaluationCount = 0 THEN 0 ELSE ((COUNT(e.MetricID) * 100.00) / v_TotalEvaluationCount) END AS EvaluationPerMetricPercentage
   FROM Evaluation e
   INNER JOIN Metric m ON m.MetricID = e.MetricID
   GROUP BY e.MetricID
      , m.Name
   ORDER BY COUNT(e.MetricID) DESC;
               
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
--DROP FUNCTION report_success_evaluation_per_profile();
CREATE OR REPLACE FUNCTION report_success_evaluation_per_profile ()
RETURNS TABLE (ProfileID INT, ProfileName VARCHAR(70), ProfileCount BIGINT, ProfilePercentage NUMERIC, ProfileSuccessPercentage BIGINT) AS $$
/************************************************************************************************************
** Name: report_success_evaluation_per_profile
**
** Desc: Devuelve la cantidad y el porcentaje de exitos por perfil
**
** 2017/03/11 - Created
**
*************************************************************************************************************/
DECLARE v_TotalEvaluationSummary BIGINT;

BEGIN
  
   SELECT COUNT(*) FROM EvaluationSummary es INTO v_TotalEvaluationSummary;

   RETURN QUERY
   SELECT p.ProfileID
      , p.Name AS ProfileName
      , COUNT(es.EvaluationSummaryID) AS ProfileCount
      , CASE WHEN v_TotalEvaluationSummary = 0 THEN 0 ELSE ((COUNT(es.EvaluationSummaryID) * 100.00) / v_TotalEvaluationSummary) END AS ProfilePercentage
      , CASE WHEN COUNT(es.EvaluationSummaryID) = 0 THEN 0 ELSE ((SELECT SUM(ies.SuccessPercentage) FROM EvaluationSummary ies WHERE ies.ProfileID = p.ProfileID) / COUNT(es.EvaluationSummaryID)) END AS ProfileSuccessPercentage
   FROM EvaluationSummary es
   INNER JOIN Profile p ON es.ProfileID = p.ProfileID
   GROUP BY p.ProfileID
      , p.Name
   ORDER BY COUNT (es.EvaluationSummaryID) DESC;
               
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
--DROP FUNCTION report_success_evaluation_per_institution();
CREATE OR REPLACE FUNCTION report_success_evaluation_per_institution ()
RETURNS TABLE (InstitutionID INT, InstitutionName VARCHAR(70), InstitutionCount BIGINT, InstitutionPercentage NUMERIC, InstitutionSuccessPercentage BIGINT) AS $$
/************************************************************************************************************
** Name: report_success_evaluation_per_institution
**
** Desc: Devuelve la cantidad y el porcentaje de exitos por institucion
**
** 2017/03/11 - Created
**
*************************************************************************************************************/
DECLARE v_TotalEvaluationSummary BIGINT;
DECLARE v_InstitutionsCount INT;

BEGIN
  
   SELECT COUNT(*) FROM EvaluationSummary es INTO v_TotalEvaluationSummary;

   CREATE TEMP TABLE InstitutionsAux
   (
      InstitutionID INT
      , InstitutionName VARCHAR(70)
      , SummaryInstitutionSuccessPercentage BIGINT
   );

   INSERT INTO InstitutionsAux
   (InstitutionID, InstitutionName, SummaryInstitutionSuccessPercentage)
   SELECT i.InstitutionID
      , i.Name AS InstitutionName
      , CASE WHEN COUNT(es.EvaluationSummaryID) = 0 THEN 0 ELSE ((SELECT SUM(ies.SuccessPercentage) FROM EvaluationSummary ies WHERE ies.MeasurableObjectID = mo.MeasurableObjectID) / COUNT(i.InstitutionID)) END AS SummaryInstitutionSuccessPercentage
   FROM EvaluationSummary es
   INNER JOIN MeasurableObject mo ON mo.MeasurableObjectID = es.MeasurableObjectID
   INNER JOIN GeographicServices gs ON gs.GeographicServicesID = mo.EntityID AND mo.EntityType = 'Servicio'
   INNER JOIN Node n ON n.NodeID = gs.NodeID
   INNER JOIN Institution i ON i.InstitutionID = n.InstitutionID
   GROUP BY i.InstitutionID
      , i.Name
      , mo.MeasurableObjectID;

   SELECT COUNT(DISTINCT ia.InstitutionID) FROM InstitutionsAux ia INTO v_InstitutionsCount;

   RETURN QUERY
   SELECT ia.InstitutionID
      , ia.InstitutionName
      , COUNT(ia.InstitutionID) AS InstitutionCount
      , COUNT(ia.InstitutionID) / (v_InstitutionsCount) :: NUMERIC AS InstitutionPercentage
      , CASE WHEN COUNT(ia.SummaryInstitutionSuccessPercentage) = 0 THEN 0 ELSE (SELECT SUM(ia.SummaryInstitutionSuccessPercentage) / (COUNT(ia.InstitutionID))) END :: BIGINT AS InstitutionSuccessPercentage
   FROM InstitutionsAux ia
   GROUP BY ia.InstitutionID
      , ia.InstitutionName
   ORDER BY ia.InstitutionName DESC;

   DROP TABLE InstitutionsAux;
               
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
--DROP FUNCTION report_success_evaluation_per_node();
CREATE OR REPLACE FUNCTION report_success_evaluation_per_node ()
RETURNS TABLE (NodeID INT, NodeName VARCHAR(70), NodeCount BIGINT, NodePercentage NUMERIC, NodeSuccessPercentage BIGINT) AS $$
/************************************************************************************************************
** Name: report_success_evaluation_per_node
**
** Desc: Devuelve la cantidad y el porcentaje de exitos por institucion
**
** 2017/03/11 - Created
**
*************************************************************************************************************/
DECLARE v_TotalEvaluationSummary BIGINT;
DECLARE v_NodesCount INT;

BEGIN
  
   SELECT COUNT(*) FROM EvaluationSummary es INTO v_TotalEvaluationSummary;

   CREATE TEMP TABLE NodesAux
   (
      NodeID INT
      , NodeName VARCHAR(70)
      , SummaryNodeSuccessPercentage BIGINT
   );

   INSERT INTO NodesAux
   (NodeID, NodeName, SummaryNodeSuccessPercentage)
   SELECT n.NodeID
      , n.Name AS NodeName
      , CASE WHEN COUNT(es.EvaluationSummaryID) = 0 THEN 0 ELSE ((SELECT SUM(ies.SuccessPercentage) FROM EvaluationSummary ies WHERE ies.MeasurableObjectID = mo.MeasurableObjectID) / COUNT(n.NodeID)) END AS SummaryNodeSuccessPercentage
   FROM EvaluationSummary es
   INNER JOIN MeasurableObject mo ON mo.MeasurableObjectID = es.MeasurableObjectID
   INNER JOIN GeographicServices gs ON gs.GeographicServicesID = mo.EntityID AND mo.EntityType = 'Servicio'
   INNER JOIN Node n ON n.NodeID = gs.NodeID
   GROUP BY n.NodeID
      , n.Name
      , mo.MeasurableObjectID;

   SELECT COUNT(DISTINCT na.NodeID) FROM NodesAux na INTO v_NodesCount;

   RETURN QUERY
   SELECT na.NodeID
      , na.NodeName
      , COUNT(na.NodeID) AS NodeCount
      , COUNT(na.NodeID) / (v_NodesCount) :: NUMERIC AS NodePercentage
      , CASE WHEN COUNT(na.SummaryNodeSuccessPercentage) = 0 THEN 0 ELSE (SELECT SUM(na.SummaryNodeSuccessPercentage) / (COUNT(na.NodeID))) END :: BIGINT AS NodeSuccessPercentage
   FROM NodesAux na
   GROUP BY na.NodeID
      , na.NodeName
   ORDER BY na.NodeName DESC;

   DROP TABLE NodesAux;
               
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */ 
--DROP FUNCTION report_top_best_worst_measurable_object_get(integer, boolean, boolean);
CREATE OR REPLACE FUNCTION report_top_best_worst_measurable_object_get
(
    pTop INT
    , pMeasurableObjectSuccessPercentageDesc BOOLEAN
    , pMeasurableObjectSuccessPercentageAsc BOOLEAN
)
RETURNS TABLE 
   (
      MeasurableObjectID INT
      , EntityID INT
      , EntityType VARCHAR(11)
      , MeasurableObjectDescription VARCHAR(100)
      , MeasurableObjectURL VARCHAR(1024)
      , MeasurableObjectServicesType CHAR(3)
      , MeasurableObjectSuccessPercentage NUMERIC
 ) AS $$
/************************************************************************************************************
** Name: report_top_best_worst_measurable_object_get
**
** Desc: Devuelve una cierta cantidad (pTop) de servicios ordenados por algúno de los criterios pasados por parametro.
**
** 03/13/2017 - Created
**
*************************************************************************************************************/
DECLARE v_TotalEvaluationCount BIGINT;

BEGIN

   SELECT COUNT(*)
   FROM Evaluation e
   INTO v_TotalEvaluationCount;

   IF (pMeasurableObjectSuccessPercentageAsc = TRUE)
   THEN
      RETURN QUERY
      SELECT es.MeasurableObjectID
         , mo.EntityID
         , mo.EntityType 
         , gs.Description AS MeasurableObjectDescription
         , gs.Url AS MeasurableObjectURL
         , gs.GeographicServicesType AS MeasurableObjectServicesType
         , CASE WHEN v_TotalEvaluationCount = 0 THEN 0 
              ELSE ((COUNT(e.EvaluationID) * 100.00) / 
                (
                   SELECT COUNT(ei.EvaluationID) 
                   FROM Evaluation ei 
                   INNER JOIN EvaluationSummary esi ON esi.EvaluationSummaryID = ei.EvaluationSummaryID
                   WHERE esi.MeasurableObjectID = es.MeasurableObjectID
                )
           ) END AS MeasurableObjectSuccessPercentage
      FROM Evaluation e
      INNER JOIN EvaluationSummary es ON es.EvaluationSummaryID = e.EvaluationSummaryID
      INNER JOIN MeasurableObject mo ON mo.MeasurableObjectID = es.MeasurableObjectID
      INNER JOIN GeographicServices gs ON gs.GeographicServicesID = mo.EntityID
      WHERE mo.EntityType = 'Servicio'
          AND e.SuccessFlag = TRUE
      GROUP BY es.MeasurableObjectID
         , mo.EntityID
         , mo.EntityType
         , gs.Description
         , gs.Url
         , gs.GeographicServicesType
         , e.SuccessFlag
      ORDER BY MeasurableObjectSuccessPercentage ASC
      LIMIT pTop;
   
   ELSE
      RETURN QUERY
      SELECT es.MeasurableObjectID
         , mo.EntityID
         , mo.EntityType 
         , gs.Description AS MeasurableObjectDescription
         , gs.Url AS MeasurableObjectURL
         , gs.GeographicServicesType AS MeasurableObjectServicesType
         , CASE WHEN v_TotalEvaluationCount = 0 THEN 0 
              ELSE ((COUNT(e.EvaluationID) * 100.00) / 
                (
                   SELECT COUNT(ei.EvaluationID) 
                   FROM Evaluation ei 
                   INNER JOIN EvaluationSummary esi ON esi.EvaluationSummaryID = ei.EvaluationSummaryID
                   WHERE esi.MeasurableObjectID = es.MeasurableObjectID
                )
           ) END AS MeasurableObjectSuccessPercentage
      FROM Evaluation e
      INNER JOIN EvaluationSummary es ON es.EvaluationSummaryID = e.EvaluationSummaryID
      INNER JOIN MeasurableObject mo ON mo.MeasurableObjectID = es.MeasurableObjectID
      INNER JOIN GeographicServices gs ON gs.GeographicServicesID = mo.EntityID
      WHERE mo.EntityType = 'Servicio'
          AND e.SuccessFlag = TRUE
      GROUP BY es.MeasurableObjectID
         , mo.EntityID
         , mo.EntityType
         , gs.Description
         , gs.Url
         , gs.GeographicServicesType
         , e.SuccessFlag
      ORDER BY MeasurableObjectSuccessPercentage DESC
      LIMIT pTop;
   END IF;

END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */ 
/* ****************************************************************************************************** */
--DROP FUNCTION ide_tree_structure_get(integer);
CREATE OR REPLACE FUNCTION ide_tree_structure_get
(
   pUserID INT
)
RETURNS TABLE 
   (
      IdeMeasurableObjectID INT
      , IdeID INT
      , IdeName VARCHAR(40)
      , IdeDescription VARCHAR(100)
      , InstitutionMeasurableObjectID INT
      , InstitutionID INT
      , InstitutionName VARCHAR(70)
      , InstitutionDescription VARCHAR(100)
      , NodeMeasurableObjectID INT
      , NodeID INT
      , NodeName VARCHAR(70)
      , NodeDescription VARCHAR(100)
 ) AS $$
/************************************************************************************************************
** Name: ide_tree_structure_get
**
** Desc: Devuelve la estructura conformada por las Ides disponibles en el sistema. Hasta los Nodos
**
** 19/03/2017 - Created
**
*************************************************************************************************************/
BEGIN
   
   -- validacion de usuario
   IF (pUserID IS NOT NULL)
      AND NOT EXISTS (SELECT 1 FROM SystemUser su WHERE su.UserID = pUserID)
   THEN
      RAISE EXCEPTION 'Error - El Usuario no existe.';
   END IF;

   -- Lista de objetos medibles
   RETURN QUERY
   SELECT 
      (SELECT moo.MeasurableObjectID FROM MeasurableObject moo WHERE moo.EntityType = 'Ide' AND moo.EntityID = ide.IdeID) AS IdeMeasurableObjectID
      , ide.IdeID
      , ide.Name AS IdeName
      , ide.Description AS IdeDescription
      , (SELECT moo.MeasurableObjectID FROM MeasurableObject moo WHERE moo.EntityType = 'Institución' AND moo.EntityID = ins.InstitutionID) AS InstitutionMeasurableObjectID
      , ins.InstitutionID
      , ins.Name AS InstitutionName
      , ins.Description AS InstitutionDescription
      , (SELECT moo.MeasurableObjectID FROM MeasurableObject moo WHERE moo.EntityType = 'Nodo' AND moo.EntityID = n.NodeID) AS NodeMeasurableObjectID      
      , n.NodeID
      , n.Name AS NodeName
      , n.Description AS NodeDescription
   FROM Ide ide
   LEFT JOIN Institution ins ON ins.IdeID = ide.IdeID
   LEFT JOIN Node n ON n.InstitutionID = ins.InstitutionID
   LEFT JOIN MeasurableObject mo ON 
      CASE
         WHEN mo.EntityType = 'Ide' THEN mo.EntityID = ide.IdeID
         WHEN mo.EntityType = 'Institución' THEN mo.EntityID = ins.InstitutionID
         WHEN mo.EntityType = 'Nodo' THEN mo.EntityID = n.NodeID
      END
   LEFT JOIN UserMeasurableObject umo ON umo.MeasurableObjectID = mo.MeasurableObjectID
   LEFT JOIN SystemUser u ON u.UserID = umo.UserID
   WHERE (CASE WHEN pUserID IS NOT NULL THEN u.UserID = pUserID ELSE TRUE END)
      AND (CASE WHEN pUserID IS NOT NULL THEN umo.CanMeasureFlag = TRUE ELSE TRUE END)
   GROUP BY mo.MeasurableObjectID
      , ide.IdeID
      , ide.Name
      , ide.Description
      , ins.InstitutionID
      , ins.Name
      , ins.Description
      , n.NodeID
      , n.Name
      , n.Description
   ORDER BY IdeID
      , InstitutionID
      , NodeID;
        
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */ 
--DROP FUNCTION services_and_layers_get(integer, character varying, character varying);
CREATE OR REPLACE FUNCTION services_and_layers_get
(
   pUserID INT
   , pEntityName VARCHAR(70)
   , pEntityType VARCHAR(11)
)
RETURNS TABLE 
   (
      MeasurableObjectID INT
      , EntityID INT
      , EntityType VARCHAR(11)
      , MeasurableObjectName VARCHAR(70)
      , MeasurableObjectDescription VARCHAR(100)
      , MeasurableObjectURL VARCHAR(1024)
      , MeasurableObjectServicesType CHAR(3)
 ) AS $$
/************************************************************************************************************
** Name: services_and_layers_get
**
** Desc: Devuelve la lista de servicios que pertenecen al Nodo pasado por parametro, y al Usuario si el mismo es especificado.
**
** 19/03/2017 - Created
**
*************************************************************************************************************/
BEGIN

   -- Lista de objetos medibles sobre los cuales el usuario puede realizar evaluaciones
   RETURN QUERY
   SELECT mo.MeasurableObjectID
      , sg.GeographicServicesID AS EntityID
      , 'Servicio' ::VARCHAR(11) AS EntityType
      , NULL ::VARCHAR(70) AS MeasurableObjectName
      , sg.Description AS MeasurableObjectDescription
      , sg.Url AS MeasurableObjectURL
      , sg.GeographicServicesType AS MeasurableObjectServicesType
   FROM Ide ide
   INNER JOIN Institution i ON i.IdeID = ide.IdeID
   INNER JOIN Node n ON n.InstitutionID = i.InstitutionID
   INNER JOIN GeographicServices sg ON sg.NodeID = n.NodeID
   INNER JOIN MeasurableObject mo ON mo.EntityID = sg.GeographicServicesID AND mo.EntityType = 'Servicio'
   LEFT JOIN UserMeasurableObject umo ON umo.MeasurableObjectID = mo.MeasurableObjectID
   LEFT JOIN SystemUser u ON u.UserID = umo.UserID
   WHERE (CASE WHEN pUserID IS NOT NULL THEN u.UserID = pUserID ELSE TRUE END)
      AND (CASE WHEN pUserID IS NOT NULL THEN umo.CanMeasureFlag = TRUE ELSE TRUE END)
      AND (CASE WHEN pEntityName IS NOT NULL AND pEntityType = 'Nodo' THEN n.Name = pEntityName ELSE TRUE END)
      AND (CASE WHEN pEntityName IS NOT NULL AND pEntityType = 'Institución' THEN i.Name = pEntityName ELSE TRUE END)
      AND (CASE WHEN pEntityName IS NOT NULL AND pEntityType = 'Ide' THEN ide.Name = pEntityName ELSE TRUE END)
   GROUP BY mo.MeasurableObjectID
      , sg.GeographicServicesID
      , mo.EntityType
      , sg.Description
      , sg.Url
      , sg.GeographicServicesType
   
   UNION

   SELECT mo.MeasurableObjectID
      , l.LayerID AS EntityID
      , 'Capa' ::VARCHAR(11) AS EntityType
      , l.Name AS MeasurableObjectName
      , l.Description AS MeasurableObjectDescription
      , l.Url AS MeasurableObjectURL
      , 'WMS' ::CHAR(3) AS MeasurableObjectServicesType
   FROM Ide ide
   INNER JOIN Institution i ON i.IdeID = ide.IdeID
   INNER JOIN Node n ON n.InstitutionID = i.InstitutionID
   INNER JOIN Layer l ON l.NodeID = n.NodeID
   INNER JOIN MeasurableObject mo ON mo.EntityID = l.LayerID AND mo.EntityType = 'Capa'
   LEFT JOIN UserMeasurableObject umo ON umo.MeasurableObjectID = mo.MeasurableObjectID
   LEFT JOIN SystemUser u ON u.UserID = umo.UserID
   WHERE (CASE WHEN pUserID IS NOT NULL THEN u.UserID = pUserID ELSE TRUE END)
      AND (CASE WHEN pUserID IS NOT NULL THEN umo.CanMeasureFlag = TRUE ELSE TRUE END)
      AND (CASE WHEN pEntityName IS NOT NULL AND pEntityType = 'Nodo' THEN n.Name = pEntityName ELSE TRUE END)
      AND (CASE WHEN pEntityName IS NOT NULL AND pEntityType = 'Institución' THEN i.Name = pEntityName ELSE TRUE END)
      AND (CASE WHEN pEntityName IS NOT NULL AND pEntityType = 'Ide' THEN ide.Name = pEntityName ELSE TRUE END)
   GROUP BY mo.MeasurableObjectID
      , l.LayerID
      , mo.EntityType
      , l.Name
      , l.Description
      , l.Url
   ORDER BY MeasurableObjectID;
        
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */ 
--DROP FUNCTION quality_weight_tree_sctucture(integer);
CREATE OR REPLACE FUNCTION quality_weight_tree_sctucture
(
   pProfileID INT
)
RETURNS TABLE
(
   WeighingID INT
   , ProfileID INT
   , ElementID INT -- QualityModelID, DimensionID, FactorID, MetricID, MetricRangeID
   , ElementName VARCHAR(40)
   , ElementType CHAR(1) -- 'Q' = QualityModel, 'D' = Dimension, 'F' = Factor, 'M' = etrica, 'R' = Rango
   , NumeratorValue INT
   , DenominatorValue INT
   , FatherElementyID INT
) AS $$
/************************************************************************************************************
** Name: quality_weight_tree_sctucture
**
** Desc: Devuelve la estructura del modelo de calidad, asociado a las metricas correspondientes al perfil pasado por parametro
**
** 23/04/2017 - Created
**
*************************************************************************************************************/
BEGIN
   
   -- validacion de perfil
   IF (pProfileID IS NOT NULL)
      AND NOT EXISTS (SELECT 1 FROM Profile p WHERE p.ProfileID = pProfileID)
   THEN
      RAISE EXCEPTION 'Error - El Perfil seleccionado no existe.';
   END IF;
   
   RETURN QUERY
   SELECT
      w.WeighingID
	  , w.ProfileID
	  , w.ElementID
	  , qm.Name AS ElementName
	  , w.ElementType
	  , w.NumeratorValue
	  , w.DenominatorValue
	  , NULL :: INT
   FROM Weighing w
   INNER JOIN QualityModel qm ON qm.QualityModelID = w.ElementID
   WHERE w.ProfileID = pProfileID
      AND w.ElementType = 'Q'

   UNION
   
   SELECT
      w.WeighingID
	  , w.ProfileID
	  , w.ElementID
	  , d.Name AS ElementName
	  , w.ElementType
	  , w.NumeratorValue
	  , w.DenominatorValue
	  , d.QualityModelID
   FROM Weighing w
   INNER JOIN Dimension d ON d.DimensionID = w.ElementID
   WHERE w.ProfileID = pProfileID
      AND w.ElementType = 'D'

   UNION
   
   SELECT
      w.WeighingID
	  , w.ProfileID
	  , w.ElementID
	  , f.Name AS ElementName
	  , w.ElementType
	  , w.NumeratorValue
	  , w.DenominatorValue
	  , f.DimensionID
   FROM Weighing w
   INNER JOIN Factor f ON f.FactorID = w.ElementID
   WHERE w.ProfileID = pProfileID
      AND w.ElementType = 'F'

   UNION
   
   SELECT
      w.WeighingID
	  , w.ProfileID
	  , w.ElementID
	  , m.Name AS ElementName
	  , w.ElementType
	  , w.NumeratorValue
	  , w.DenominatorValue
	  , m.FactorID
   FROM Weighing w
   INNER JOIN Metric m ON m.MetricID = w.ElementID
   WHERE w.ProfileID = pProfileID
      AND w.ElementType = 'M'

   UNION
   
   SELECT
      w.WeighingID
	  , w.ProfileID
	  , w.ElementID
	  , NULL :: VARCHAR(40)
	  , w.ElementType
	  , w.NumeratorValue
	  , w.DenominatorValue
	  , mr.MetricID
   FROM Weighing w
   INNER JOIN MetricRange mr ON mr.MetricRangeID = w.ElementID
   WHERE w.ProfileID = pProfileID
      AND w.ElementType = 'R';
	  
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */ 
--DROP FUNCTION quality_weight_update();
CREATE OR REPLACE FUNCTION quality_weight_update
(
   pNominator INT
   , pDenominator INT
   , pWeighingID INT
)
RETURNS VOID AS $$
/************************************************************************************************************
** Name: quality_weight_update()
**
** Desc: Actualiza datos de Objetos Medibles
**
** 26/04/2017 - Created
**
*************************************************************************************************************/
BEGIN
   
   -- parametros requeridos
   IF (pWeighingID IS NULL)
   THEN
      RAISE EXCEPTION 'Error - El ID de ponderación no puede ser nulo.';
   END IF;
   
   -- validacion de ponderación
   IF (NOT EXISTS (SELECT 1 FROM Weighing w WHERE w.WeighingID = pWeighingID))
   THEN
      RAISE EXCEPTION 'Error - El ID de ponderción pasado por parametro es incorrecto.';
   END IF;
       
   UPDATE Weighing
   SET NumeratorValue = pNominator
      , DenominatorValue = pDenominator
   WHERE WeighingID = pWeighingID; 
    
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */ 
--DROP FUNCTION quality_model_update();
CREATE OR REPLACE FUNCTION quality_model_update
(
   pElementID INT --QualityModelID, DimensionID, FactorID, MetricID
   , pElementType CHAR(1) --'Q' = QualityModel, 'D' = Dimension, 'F' = Factor, 'M' = Metrica
   , pName VARCHAR(100)
)
RETURNS VOID AS $$
/************************************************************************************************************
** Name: quality_model_update()
**
** Desc: Actualiza datos del modelo de calidad
**
** 17/05/2017 - Created
**
*************************************************************************************************************/
BEGIN
   
   -- parametros requeridos
   IF (pElementID IS NULL)
   THEN
      RAISE EXCEPTION 'Error - El ID del elemento no puede ser nulo.';
   END IF;
       
   IF (pElementType = 'Q')
   THEN
      UPDATE QualityModel
      SET Name = pName
      WHERE QualityModelID = pElementID;
   ELSIF (pElementType = 'D')
   THEN
      UPDATE Dimension
      SET Name = pName
      WHERE DimensionID = pElementID;
   ELSIF (pElementType = 'F')
   THEN
      UPDATE Factor
      SET Name = pName
      WHERE FactorID = pElementID;
   ELSIF (pElementType = 'M')
   THEN
      UPDATE Metric
      SET Name = pName
      WHERE MetricID = pElementID;		
   END IF;
    
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */ 
--DROP FUNCTION quality_model_insert(character,integer,character varying, boolean, character varying, character varying, integer, boolean, character varaying, boolean, character varying);
CREATE OR REPLACE FUNCTION quality_model_insert
(
   pElementType CHAR(1) -- 'Q' = QualityModel, 'D' = Dimension, 'F' = Factor, 'M' = Metrica
   , pFatherElementyID INT
   , pElementName VARCHAR(100)
   , pAggregationFlag BOOLEAN
   , pGranularity VARCHAR(11)
   , pUnit VARCHAR(40)
   , pMetricUnitID INT
   , pMetricIsManual BOOLEAN
   , pMetricDescription VARCHAR(100)
   , pIsUserMetric BOOLEAN
   , pMetricFileName VARCHAR(100)
)
RETURNS VOID AS $$
/************************************************************************************************************
** Name: quality_model_insert
**
** Desc: Agrega un entidad a los modelos de calidad
**
** 20/05/2017 Created
**
*************************************************************************************************************/
BEGIN

   IF (pElementType IS NULL)
   THEN
      RAISE EXCEPTION 'Error - El tipo de Entidad es requerido.';
   END IF;
   
   -- validacion padre
   IF pElementType = 'M' AND NOT EXISTS (SELECT 1 FROM Factor f WHERE f.FactorID = pFatherElementyID)
   THEN
      RAISE EXCEPTION 'Error - El factor seleccionado no existe.';
   END IF;
   -- validacion padre
   IF pElementType = 'F' AND NOT EXISTS (SELECT 1 FROM Dimension d WHERE d.DimensionID = pFatherElementyID)
   THEN
      RAISE EXCEPTION 'Error - La dimension seleccionada no existe.';
   END IF;
   -- validacion padre
   IF pElementType = 'D' AND NOT EXISTS (SELECT 1 FROM QualityModel qm WHERE qm.QualityModelID = pFatherElementyID)
   THEN
      RAISE EXCEPTION 'Error - El modelo de calidad seleccionado no existe.';
   END IF; 

   IF pElementType = 'Q'
   THEN
      INSERT INTO QualityModel
      (Name)
      VALUES
      (pElementName);
   END IF;

   IF pElementType = 'D'
   THEN
      INSERT INTO Dimension
      (Name, QualityModelID)
      VALUES
      (pElementName, pFatherElementyID);
   END IF;

   IF pElementType = 'F'
   THEN
      INSERT INTO Factor
      (Name, DimensionID)
      VALUES
      (pElementName, pFatherElementyID);
   END IF;

   IF pElementType = 'M'
   THEN
      INSERT INTO Metric
      (Name, FactorID, AgrgegationFlag, Granurality, UnitID, IsManual, Description, IsUserMetric, MetricFileName)
      VALUES
      (pElementName, pFatherElementyID, pAggregationFlag, pGranularity, pMetricUnitID, pMetricIsManual, pMetricDescription, pIsUserMetric, pMetricFileName);
   END IF;
         
END;
$$ LANGUAGE plpgsql;
/* ****************************************************************************************************** */ 
/*                                   FIN - 4 - STORED FUNCTIONS                                           */
/* ****************************************************************************************************** */ 
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */