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
(1, 'Rendimiento'),
(1, 'Interoperabilidad'),
(1, 'Publicacion de Datos'),
(1, 'Metadatos'),
(1, 'Usabilidad');

INSERT INTO Factor (DimensionID, Name) VALUES
(1, 'Ingegridad'),
(1, 'Proteccion'),
(2, 'Disponibilidad'),
(2, 'Robustez'),
(3, 'Tiempo de respuesta'),
(3, 'Capacidad'),
(4, 'Soporte de estandares'),
(4, 'Sistema de referencias'),
(5, 'Representacion Grafica'),
(5, 'Formatos soportados'),
(6, 'Publicacion Catalogo'),
(6, 'Metadatos Capa'),
(6, 'Metadatos Servicio'),
(7, 'Facilidad de aprendizaje');

INSERT INTO Unit (Name, Description) VALUES 
('Boleano',''),
('Porcentaje',''),
('Milisegundos',''),
('Basico-Intermedio-Completo',''),
('Entero','');

INSERT INTO Metric (FactorID, Name, AgrgegationFlag, UnitID, Granurality) VALUES
(2, 'Informacion en excepciones', FALSE, 1, 'Servicio'),
(7, 'Excepciones en formato OGC', FALSE, 1, 'Servicio'),
(8, 'Capas del servicio con CRS adecuado (IDEuy)', FALSE, 2, 'Servicio'),
(10, 'Formato PNG', FALSE, 1, 'Método'),
(10, 'Formato KML', FALSE, 1, 'Método'),
(10, 'Formato text/html metodo getFeatureInfo', FALSE, 1, 'Método'),
(10, 'Formato Excepcion application/vnd.ogc.se_inimage', FALSE, 1, 'Método'),
(10, 'Formato Excepcion application/vnd.ogc.se_blank', FALSE, 1, 'Método'),
(10, 'Cantidad de formatos soportados', FALSE, 5, 'Servicio'),
(10, 'Cantidad de formatos de excepciones soportadas', FALSE, 5, 'Servicio'),
(13, 'Leyenda de la Capa', FALSE, 2, 'Servicio'),
(13, 'Especifica Rango Util', FALSE, 1, 'Capa');
--(14, 'Errores descriptivos', FALSE, 1, 'Servicio');
--(3, 'Disponibilidad diaria del servicio', FALSE, 2, 'Servicio'),
--(4, 'Tolerancia a parametros nulos', FALSE, 1, 'Método'),
--(4, 'Tolerancia a parametros largos', FALSE, 1, 'Método'),
--(5, 'Promedio tiempo de respuesta diario', FALSE, 3, 'Método'),
--(7, 'Adopcion del estandar OGC', FALSE, 4, 'Servicio'),
--(1, 'Integridad de datos', FALSE, 1, 'Nodo'),
--(11, 'Contiene servicio CSW', FALSE, 1, 'Institución'),
--(12, 'Fecha del dato', FALSE, 2, 'Institución'),

INSERT INTO Ide (Name, Description) VALUES
('ide.uy','Infraestructura de Datos Espaciales del Uruguay');

INSERT INTO Institution (IdeID, Name, Description) VALUES
(1, 'Presidencia', 'Presidencia de la República'),
(1, 'Ministerio de Defensa Nacional', 'Ministerio de Defensa Nacional'),
(1, 'MIDES', 'Ministerio de Desarrollo Social'),
(1, 'Ministerio de Economía y Finanzas', 'Ministerio de Economía y Finanzas'),
(1, 'MEC', 'Ministerio de Educación y Cultura'),
(1, 'Ministerio de Ganadería, Agricultura y Pesca', 'Ministerio de Ganadería, Agricultura y Pesca'),
(1, 'MIEM', 'Ministerio de Industria, Energía y Minería'),
(1, 'MTOP', 'Ministerio de Transporte y Obras Públicas'),
(1, 'Ministerio de Turismo', 'Ministerio de Turismo'),
(1, 'Ministerio de Vivienda, Ordenamiento Territorial y Medio Ambiente', 'Ministerio de Vivienda, Ordenamiento Territorial y Medio Ambiente'),
(1, 'ANEP', 'Administración Nacional de Educación Pública'),
(1, 'Correo Uruguayo', 'Administración Nacional de Correos'),
(1, 'INIA', 'Instituto Nacional de Investigación Agropecuaria'),
(1, 'Maldonado', 'Intendencia de Maldonado'),
(1, 'Montevideo', 'Intendencia de Montevideo'),
(1, 'Rivera', 'Intendencia de Rivera');

INSERT INTO Node (InstitutionID, Name, Description) VALUES
(1, 'INE', 'Instituto Nacional de Estadística'),
(1, 'SINAE', 'Sistema Nacional de Emergencia'),
(1, 'UNASEV', 'Unidad de Seguridad Vial'),
(2, 'Servicio Geográfico Militar', 'Servicio Geográfico Militar'),
(3, 'MIDES', 'Ministerio de Desarrollo Social'),
(4, 'DNC', 'Dirección Nacional de Catastro'),
(5, 'MEC', 'Ministerio de Educación y Cultura'),
(6, 'RENARE', 'Dirección Nacional de Recursos Renovables'),
(7, 'Dirección Nacional de Minería y Geología', 'Dirección Nacional de Minería y Geología'),
(8, 'Dirección Nacional de Topografía', 'Direción Nacional de Topografía'),
(9, 'Ministerio de Turismo', 'Ministerio de Turismo'),
(10, 'DINAMA', 'Dirección Nacional de Medio Ambiente'),
(10, 'DINOT', 'Dirección Nacional de Ordenamiento Territorial'),
(11, 'ANEP', 'Administración Nacional de Educación Pública'),
(12, 'Unidad de Geomáica', 'Unidad de Geomáica'),
(13, 'GRAS', 'GRAS'),
(14, 'Unidad del Sistema de Información Geográfica', 'Unidad del Sistema de Información Geográfica'),
(15, 'Servicio de Geomática', 'Servicio de Geomática'),
(16, 'Rivera', 'Intendencia de Rivera');


INSERT INTO Profile (Name, Granurality, IsWeightedFlag) VALUES
('Perfil Basico', 'Servicio', FALSE),
('Perfil Avanzado', 'Servicio', FALSE);

INSERT INTO MetricRange (MetricID, ProfileID, BooleanFlag, BooleanAcceptanceValue, PercentageFlag, PercentageAcceptanceValue, IntegerFlag, IntegerAcceptanceValue, EnumerateFlag, EnumerateAcceptanceValue) VALUES
(1, 1, TRUE, TRUE, FALSE, NULL, FALSE, NULL, FALSE, NULL),
(2, 1, TRUE, TRUE, FALSE, NULL, FALSE, NULL, FALSE, NULL),
(4, 2, TRUE, TRUE, FALSE, NULL, FALSE, NULL, FALSE, NULL),
(5, 2, TRUE, TRUE, FALSE, NULL, FALSE, NULL, FALSE, NULL);

--INSERT INTO Layer (NodeID, Name, Url) VALUES
--(1, 'Capa de calles', 'http://CapaCalles1.1.1.1'),
--(2, 'Capa edificios', 'http://CapaEdificios1.1.1.2');

--ide.uy/Presidencia de la República/Unidad de Seguridad Vial
   --http://aplicaciones.unasev.gub.uy/mapas/Descarga/Descarga
INSERT INTO GeographicServices (NodeID, Url, GeographicServicesType, Description) VALUES
(3,'http://gissrv.unasev.gub.uy/arcgis/services/UNASEV/srvUNASEVWFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetCapabilities','WFS', 'Siniestros Fatales'),
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
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/Artigas_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetCapabilities','WFS', 'Artigas'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/Lavalleja_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetCapabilities','WFS', 'Lavalleja'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/Canelones_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetCapabilities','WFS', 'Canelones'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/Colonia_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetCapabilities','WFS', 'Colonia'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/Flores_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetCapabilities','WFS', 'Flores'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/Montevideo_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetCapabilities','WFS', 'Montevideo'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/Maldonado_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetCapabilities','WFS', 'Maldonado'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/Rocha_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetCapabilities','WFS', 'Rocha'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/Soriano_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetCapabilities','WFS', 'Soriano'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/Florida_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetCapabilities','WFS', 'Florida'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/TreintayTres_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetCapabilities','WFS', 'Treinta y Tres'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/Durazno_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetCapabilities','WFS', 'Durazno'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/CerroLargo_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetCapabilities','WFS', 'CerroLargo'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/Tacuarembo_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetCapabilities','WFS', 'Tacuarembo'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/RioNegro_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetCapabilities','WFS', 'Rio Negro'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/Rivera_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetCapabilities','WFS', 'Rivera'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/Paysandu_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetCapabilities','WFS', 'Paysandu'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/Salto_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetCapabilities','WFS', 'Salto'),
(6,'http://gis.catastro.gub.uy/arcgis/services/WFS/SanJose_WFS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetCapabilities','WFS', 'SanJose');

--ide.uy/Ministerio de Ganadería, Agricultura y Pesca/Dirección Nacional de Recursos Renovables
    --http://www.cebra.com.uy/renare/visualizadores-graficos-y-consulta-de-mapas
INSERT INTO GeographicServices (NodeID, Url, GeographicServicesType, Description) VALUES
(8,'http://web.renare.gub.uy/arcgis/services/SUELOS/MOSAICO_FOTOPLANOS/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'FOTOPLANOS'),
(8,'http://web.renare.gub.uy/arcgis/services/TEMATICOS/IntConeat/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Mapas interpretativos a partir de la Cartografia CONEAT'),
(8,'http://web.renare.gub.uy/arcgis/services/SUELOS/SUELOS/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Cartas de Suelos');

--ide.uy/Ministerio de Industria, Energía y Minería/Dirección Nacional de Minería y Geología
   --http://www.miem.gub.uy/web/mineria-y-geologia/sistema-de-informacion-geografica/-/asset_publisher/Kh0fSy8zj77G/content/sistema-de-informacion-geografica?redirect=http%3A//www.miem.gub.uy/web/mineria-y-geologia/sistema-de-informacion-geografica%3Fp_p_id%3D101_INSTANCE_Kh0fSy8zj77G%26p_p_lif
INSERT INTO GeographicServices (NodeID, Url, GeographicServicesType, Description) VALUES
(9,'http://visualizadorgeominero.dinamige.gub.uy:8080/arcgis/services/Dinamige_GeoS/CatastroMineroGeoS/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Catastro Minero'),
(9,'http://visualizadorgeominero.dinamige.gub.uy:8080/arcgis/services/Dinamige_GeoS/CatastroMineroGeoS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.3.0&REQUEST=GetCapabilities','WFS', 'Catastro Minero'),
--(9,'http://visualizadorgeominero.dinamige.gub.uy/shapefiles/CanteraObraPublica_Dinamige.zip','', 'Catastro Minero'),
--(9,'http://visualizadorgeominero.dinamige.gub.uy/shapefiles/ReservaMinera_Dinamige.zip','', 'Catastro Minero'),
--(9,'http://visualizadorgeominero.dinamige.gub.uy/shapefiles/Servidumbres_Dinamige.zip','', 'Catastro Minero'),
--(9,'http://visualizadorgeominero.dinamige.gub.uy/shapefiles/ZonasExclusion_Dinamige.zip','', 'Catastro Minero'),
--(9,'http://visualizadorgeominero.dinamige.gub.uy/shapefiles/PedimentosOtorgados_Dinamige.zip','', 'Catastro Minero'),
--(9,'http://visualizadorgeominero.dinamige.gub.uy/shapefiles/PedimentosTramite_Dinamige.zip','', 'Catastro Minero'),
(9,'http://visualizadorgeominero.dinamige.gub.uy:8080/arcgis/services/Dinamige_GeoS/HidrogeologiaGeoS/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Hidrogeología'),
--(9,'http://visualizadorgeominero.dinamige.gub.uy/shapefiles/Pozos_Dinamige.zip','', 'Hidrogeología'),
(9,'http://visualizadorgeominero.dinamige.gub.uy:8080/arcgis/services/Dinamige_GeoS/MapaBaseUnidadesGeologicasGeoS/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Mapa Geológico'),
(9,'http://visualizadorgeominero.dinamige.gub.uy:8080/arcgis/services/Dinamige_GeoS/GeolUnidadesGeologicas500000WFS/MapServer/WFSServer','WFS', 'Mapa Geológico'),
(9,'http://visualizadorgeominero.dinamige.gub.uy:8080/arcgis/services/Dinamige_GeoS/LaboratorioGeoS/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Laboratorio'),
(9,'http://visualizadorgeominero.dinamige.gub.uy:8080/arcgis/services/Dinamige_GeoS/GeologiaGeoS/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'Distritos Mineros'),
(9,'http://visualizadorgeominero.dinamige.gub.uy:8080/arcgis/services/Dinamige_GeoS/GeologiaGeoS/MapServer/WFSServer?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetCapabilities','WFS', 'Distritos Mineros');
--(9,'http://visualizadorgeominero.dinamige.gub.uy/shapefiles/GeoMinera_Dinamige.zip','', 'Canteras');

--ide.uy/Ministerio de Transporte y Obras Públicas/Dirección Nacional de Topografía
   --http://geoportal.mtop.gub.uy/geoserv.html
INSERT INTO GeographicServices (NodeID, Url, GeographicServicesType, Description) VALUES
(10,'http://geoservicios.mtop.gub.uy/geoserver/inf_tte_ttelog_logistica/wms?service=WMS&version=1.3.0&request=GetCapabilities','WMS', 'INFRAESTRUCTURA, TRANSPORTE Y LOGÍSTICA - Información Logística'),
(10,'http://geoservicios.mtop.gub.uy/geoserver/inf_tte_ttelog_logistica/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'INFRAESTRUCTURA, TRANSPORTE Y LOGÍSTICA - Información Logística'),
(10,'http://geoservicios.mtop.gub.uy/geoserver/inf_tte_ttelog_terrestre/wms?service=WMS&version=1.3.0&request=GetCapabilities','WMS', 'INFRAESTRUCTURA, TRANSPORTE Y LOGÍSTICA - Transporte Terrestre'),
(10,'http://geoservicios.mtop.gub.uy/geoserver/inf_tte_ttelog_terrestre/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'INFRAESTRUCTURA, TRANSPORTE Y LOGÍSTICA - Transporte Terrestre'),
(10,'http://geoservicios.mtop.gub.uy/geoserver/inf_tte_ttelog_fluvial/wms?service=WMS&version=1.3.0&request=GetCapabilities','WMS', 'INFRAESTRUCTURA, TRANSPORTE Y LOGÍSTICA - Transporte Fluvial'),
(10,'http://geoservicios.mtop.gub.uy/geoserver/inf_tte_ttelog_fluvial/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'INFRAESTRUCTURA, TRANSPORTE Y LOGÍSTICA - Transporte Fluvial'),
(10,'http://geoservicios.mtop.gub.uy/geoserver/inf_tte_ttelog_ferroviario/wms?service=WMS&version=1.3.0&request=GetCapabilities','WMS', 'INFRAESTRUCTURA, TRANSPORTE Y LOGÍSTICA - Transporte Ferroviario'),
(10,'http://geoservicios.mtop.gub.uy/geoserver/inf_tte_ttelog_ferroviario/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'INFRAESTRUCTURA, TRANSPORTE Y LOGÍSTICA - Transporte Ferroviario'),
(10,'http://geoservicios.mtop.gub.uy/geoserver/inf_tte_ttelog_aereo/wms?service=WMS&version=1.3.0&request=GetCapabilities','WMS', 'INFRAESTRUCTURA, TRANSPORTE Y LOGÍSTICA - Transporte Aéreo'),
(10,'http://geoservicios.mtop.gub.uy/geoserver/inf_tte_ttelog_aereo/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'INFRAESTRUCTURA, TRANSPORTE Y LOGÍSTICA - Transporte Aéreo'),
(10,'http://geoservicios.mtop.gub.uy/geoserver/inf_tte_ttelog_otros/wms?service=WMS&version=1.3.0&request=GetCapabilities','WMS', 'INFRAESTRUCTURA, TRANSPORTE Y LOGÍSTICA - Otras Infraestructuras'),
(10,'http://geoservicios.mtop.gub.uy/geoserver/inf_tte_ttelog_otros/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'INFRAESTRUCTURA, TRANSPORTE Y LOGÍSTICA - Otras Infraestructuras'),
(10,'http://geoservicios.mtop.gub.uy/geoserver/relevamiento_transito/wms?service=WMS&version=1.3.0&request=GetCapabilities','WMS', 'INFRAESTRUCTURA, TRANSPORTE Y LOGÍSTICA - Relevamiento Estadístico de Tránsito'),
(10,'http://geoservicios.mtop.gub.uy/geoserver/relevamiento_transito/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'INFRAESTRUCTURA, TRANSPORTE Y LOGÍSTICA - Relevamiento Estadístico de Tránsito'),
(10,'http://geoservicios.mtop.gub.uy/geoserver/inf_soc_comunitaria/wms?service=WMS&version=1.3.0&request=GetCapabilities','WMS', 'INFRAESTRUCTURA SOCIAL - Infraestructura Comunitaria'),
(10,'http://geoservicios.mtop.gub.uy/geoserver/inf_soc_comunitaria/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'INFRAESTRUCTURA SOCIAL - Infraestructura Comunitaria'),
(10,'http://geoservicios.mtop.gub.uy/geoserver/acc_intern_cosiplan/wms?service=WMS&version=1.3.0&request=GetCapabilities','WMS', 'ACCIÓN INTERNACIONAL - Cartografía COSIPLAN'),
(10,'http://geoservicios.mtop.gub.uy/geoserver/acc_intern_cosiplan/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'ACCIÓN INTERNACIONAL - Cartografía COSIPLAN'),
(10,'http://geoservicios.mtop.gub.uy/geoserver/rec_hidrograficos/wms?service=WMS&version=1.3.0&request=GetCapabilities','WMS', 'RECURSOS HIDROGRÁFICOS'),
(10,'http://geoservicios.mtop.gub.uy/geoserver/rec_hidrograficos/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'RECURSOS HIDROGRÁFICOS'),
(10,'http://geoservicios.mtop.gub.uy/geoserver/planos_publicar/wms?service=WMS&version=1.3.0&request=GetCapabilities','WMS', 'CONSULTA DE PLANOS DE MENSURA - Planos de mensura'),
(10,'http://geoservicios.mtop.gub.uy/geoserver/planos_publicar/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'CONSULTA DE PLANOS DE MENSURA - Planos de mensura'),
(10,'http://geoservicios.mtop.gub.uy/geoserver/mb_hervidero/wms?service=WMS&version=1.3.0&request=GetCapabilities','WMS', 'VUELOS FOTOGRAMÉTRICOS - Parque Arroyo Hervidero'),
(10,'http://geoservicios.mtop.gub.uy/geoserver/mb_hervidero/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'VUELOS FOTOGRAMÉTRICOS - Parque Arroyo Hervidero'),
(10,'http://geoservicios.mtop.gub.uy/geoserver/mb_sayago/wms?service=WMS&version=1.3.0&request=GetCapabilities','WMS', 'VUELOS FOTOGRAMÉTRICOS - Regasificadora Puntas de Sayago'),
(10,'http://geoservicios.mtop.gub.uy/geoserver/mb_sayago/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'VUELOS FOTOGRAMÉTRICOS - Regasificadora Puntas de Sayago'),
(10,'http://geoservicios.mtop.gub.uy/geoserver/mb_pap/wms?service=WMS&version=1.3.0&request=GetCapabilities','WMS', 'VUELOS FOTOGRAMÉTRICOS - Puerto de Aguas Profundas'),
(10,'http://geoservicios.mtop.gub.uy/geoserver/mb_pap/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'VUELOS FOTOGRAMÉTRICOS - Puerto de Aguas Profundas'),
(10,'http://geoservicios.mtop.gub.uy/geoserver/mb_piria/wms?service=WMS&version=1.3.0&request=GetCapabilities','WMS', 'VUELOS FOTOGRAMÉTRICOS - Piriápolis'),
(10,'http://geoservicios.mtop.gub.uy/geoserver/mb_piria/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'VUELOS FOTOGRAMÉTRICOS - Piriápolis'),
(10,'http://geoservicios.mtop.gub.uy/geoserver/rutas_SD/ows?service=WFS&version=1.3.0&request=GetCapabilities','WFS', 'SEGMENTACIÓN DINÁMICA - Rutas nacionales ');

--ide.uy/Ministerio de Vivienda, Ordenamiento Territorial y Medio Ambiente/Dirección Nacional de Medio Ambiente
   --https://www.dinama.gub.uy/geoservicios/
INSERT INTO GeographicServices (NodeID, Url, GeographicServicesType, Description) VALUES
(12,'https://www.dinama.gub.uy/geoserver/u19600217/wms?service=WMS&version=1.3.0&REQUEST=GetCapabilities','WMS', 'Informacion sobre DINAMA');


--ide.uy/Ministerio de Vivienda, Ordenamiento Territorial y Medio Ambiente/Dirección Nacional de Ordenamiento Territorial
   --http://sit.mvotma.gub.uy/serviciosOGC.htm
INSERT INTO GeographicServices (NodeID, Url, GeographicServicesType, Description) VALUES
(13,'http://sit.mvotma.gub.uy/ArcGIS/services/SIT/instrumentosOT/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'NORMATIVA DE ORDENAMIENTO TERRITORIAL'),
(13,'http://sit.mvotma.gub.uy/arcgis/services/SIT/instrumentosOT/MapServer/WFSServer?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetCapabilities','WFS', 'NORMATIVA DE ORDENAMIENTO TERRITORIAL'),
(13,'http://sit.mvotma.gub.uy/ArcGIS/services/SIT/instrumentos_elaboracion/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'INSTRUMENTOS DE O.T EN ELABORACIÓN'),
(13,'http://sit.mvotma.gub.uy/arcgis/services/SIT/instrumentos_elaboracion/MapServer/WFSServer?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetCapabilities','WFS', 'INSTRUMENTOS DE O.T EN ELABORACIÓN'),
(13,'http://sit.mvotma.gub.uy/ArcGIS/services/SIT/chs/MapServer/WMSServer?','WMS', 'CONJUNTOS HABITACIONALES DE PROMOCIÓN PÚBLICA'),
(13,'http://sit.mvotma.gub.uy/ArcGIS/services/SIT/chs/MapServer/WFSServer?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetCapabilities','WFS', 'CONJUNTOS HABITACIONALES DE PROMOCIÓN PÚBLICA'),
(13,'http://sit.mvotma.gub.uy/ArcGIS/services/SIT/asentamientos/MapServer/WMSServer?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetCapabilities','WMS', 'ASENTAMIENTOS'),
(13,'http://sit.mvotma.gub.uy/ArcGIS/services/SIT/asentamientos/MapServer/WFSServer?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetCapabilities','WFS', 'ASENTAMIENTOS'),
(13,'http://sit.mvotma.gub.uy/ArcGIS/services/OGC/OGC_cobertura/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities','WMS', 'COBERTURA DEL SUELO'),
(13,'http://sit.mvotma.gub.uy/ArcGIS/services/OGC/OGC_cobertura/MapServer/WFSServer?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetCapabilities','WFS', 'COBERTURA DEL SUELO');

--ide.uy/Intendencia de Montevideo/Servicio de Geomática
   --http://sig.montevideo.gub.uy/content/geoservicios-web
   --TODO: Ver como cargar los WS de la IM
INSERT INTO GeographicServices (NodeID, Url, GeographicServicesType, Description) VALUES
(18,'http://geoweb.montevideo.gub.uy/geonetwork/srv/es/csw','CSW', 'ACCESO A SERVICIOS CSW');
--(18,'http://geoweb.montevideo.gub.uy/geonetwork/srv/es/main.home','', 'PORTAL BÚSQUEDA DE METADATOS'),
--(18,'http://geoweb.montevideo.gub.uy/geoserver/ide/ows','', 'ACCESO A SERVICIOS WMS _ WFS');

INSERT INTO SystemUser (Email, Password, UserGroupID, FirstName, LastName, PhoneNumber, InstitutionID) VALUES 
('ncalle@mail.com', 'ncalle', 1, 'Natalia', 'Calle', '098765432', 1),
('rsanchez@mail.com', 'rsanchez', 1, 'Ramiro', 'Sanchez', '098961259', 1);