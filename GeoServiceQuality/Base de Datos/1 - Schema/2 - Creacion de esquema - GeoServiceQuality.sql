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

    PRIMARY KEY (MetricID),
    UNIQUE (Name),
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
    FOREIGN KEY (MetricID) REFERENCES Metric(MetricID),
    CONSTRAINT CK_IsEvaluationCompletedFlag CHECK
        (
	    CASE WHEN IsEvaluationCompletedFlag = TRUE AND SuccessFlag IS NOT NULL THEN 1 ELSE 0 END
	    + CASE WHEN IsEvaluationCompletedFlag = FALSE AND SuccessFlag IS NULL THEN 1 ELSE 0 END
            = 1
        )
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