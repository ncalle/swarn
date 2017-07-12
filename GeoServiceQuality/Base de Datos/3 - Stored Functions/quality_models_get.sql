--DROP FUNCTION quality_models_get()
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
   FROM Metric m
   INNER JOIN Unit u ON u.UnitID = m.UnitID;
        
END;
$$ LANGUAGE plpgsql;