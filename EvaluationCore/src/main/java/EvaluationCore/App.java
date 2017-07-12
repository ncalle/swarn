package EvaluationCore;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.KeyStore.Entry.Attribute;
import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;
import javax.xml.transform.stream.StreamSource;

import net.opengis.wms.v_1_3_0.AuthorityURL;
import net.opengis.wms.v_1_3_0.Capability;
import net.opengis.wms.v_1_3_0.DCPType;
import net.opengis.wms.v_1_3_0.Dimension;
import net.opengis.wms.v_1_3_0.Layer;
import net.opengis.wms.v_1_3_0.OperationType;
import net.opengis.wms.v_1_3_0.Style;
import net.opengis.wms.v_1_3_0.WMSCapabilities;

import net.opengis.wms.v_1_1_1.Request;
import net.opengis.wms.v_1_1_1.WMTMSCapabilities;
import net.opengis.filter.v_1_1_0.FilterCapabilities;
import net.opengis.wfs.v_1_1_0.WFSCapabilitiesType;



public final class App {

	//static String URL = "http://geoservicios.mtop.gub.uy/geoserver/inf_tte_ttelog_logistica/wms?service=WMS&version=1.3.0&request=GetCapabilities";
	static String URL = "http://gissrv.unasev.gub.uy/arcgis/services/UNASEV/srvUNASEVWFS/MapServer/WMSServer?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities";
	//static String URL = "http://geoservicios.sgm.gub.uy/UYAR.cgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities";
	
	static int TIMEOUT_SERVICE = 18000;
	
	
    public static void main( String[] args ) {
        System.out.println( "Evaluation Core Test --------------------" );
        
        String serviceType = "WMS";
        
        ejecuteMetric(1, URL, serviceType, 0, "");
        
//        ejecuteMetric(2, URL, serviceType, 0, "");
//        
//        ejecuteMetric(3, URL, serviceType, 0, "");
//        
//        ejecuteMetric(4, URL, serviceType, 0, "");
//        
//        ejecuteMetric(5, URL, serviceType, 0, "");
//        
//        ejecuteMetric(6, URL, serviceType, 0, "");
//        
//        ejecuteMetric(7, URL, serviceType, 0, "");
//        
//        ejecuteMetric(8, URL, serviceType, 0, "");
//        
//        ejecuteMetric(9, URL, serviceType, 0, "");
//        
//        ejecuteMetric(10, URL, serviceType, 1, "");
//        
//        ejecuteMetric(11, URL, serviceType, 1, "");
//        
//        ejecuteMetric(12, URL, serviceType, 0, "");
//        
//        ejecuteMetric(13, URL, serviceType, 0, "Puerto_Aguas_Prof_Pyramid");
        
    }
    
    
    public static boolean ejecuteMetric(Integer metricId, String url, String serviceType, int integerAcceptanceValue, String layerName){
    	 boolean res = false;
    	 
    	 switch (metricId) {
			case 1:
				res = metricInformationException(url, serviceType);
				System.out.println( "metricInformation --------------------" + res);
				break;
			case 2:
				res = metricOGCFormatException(url, serviceType);
				System.out.println( "metricOGCFormat --------------------" + res);
				break;
			case 3:
				res = metricCRSInLayers(url, serviceType) >= integerAcceptanceValue;
				System.out.println( "metricCRSInLayers --------------------" + res);
				break;
			case 4:
				res = metricCRSInLayer(url, serviceType, layerName);
				System.out.println( "metricCRSInLayer --------------------" + res);
				break;
			case 5:
				res = metricGetMapFormat(url, serviceType, "image/png");
				System.out.println( "metricGetMapFormat --------------------" + res);
				break;
			case 6:
				res = metricGetMapFormat(url, serviceType, "application/vnd.google-earth.kml+xml");
				System.out.println( "metricGetMapFormat --------------------" + res);
				break;
			case 7:
				res = metricGetFeatureInfoFormat(url, serviceType, "text/html");
				System.out.println( "metricGetFeatureInfoFormat --------------------" + res);
				break;
			case 8:
				res = metricFormatException(url, serviceType, "INIMAGE");
				System.out.println( "metricFormat --------------------" + res);
				break;
			case 9:
				res = metricFormatException(url, serviceType, "BLANK");
				System.out.println( "metricFormat --------------------" + res);
				break;
			case 10:
				res = metricCountMapFormat(url, serviceType) >= integerAcceptanceValue;
				System.out.println( "metricCountMapFormat --------------------" + res);
				break;
			case 11:
				res = metricCountFormatException(url, serviceType) >= integerAcceptanceValue;
				System.out.println( "metricCountFormat --------------------" + res);
				break;
			case 12:
				res = metricGetLegendGraphic(url, serviceType);
				System.out.println( "metricGetLegendGraphic --------------------" + res);
				break;
			case 13:
				res = metricScaleHint(url, serviceType, layerName);
				System.out.println( "metricScaleHint --------------------" + res);
				break;
			case 15:
				res = metricServiceAvailable(url, TIMEOUT_SERVICE);
				System.out.println( "metricServiceAvailable --------------------" + res);
				break;
			
			default:
				break;
			}
    	 
    	 return res;
    }
    
    public static boolean metricServiceAvailable(String url, int timeout) {
        url = url.replaceFirst("^https", "http"); 

        try {
         	URL u = new URL(url);
            HttpURLConnection connection = (HttpURLConnection) u.openConnection();
            connection.setConnectTimeout(timeout);
            connection.setReadTimeout(timeout);
            connection.setRequestMethod("GET"); //HEAD no soportado en algun caso
            connection.setRequestProperty("Accept", "application/xml");
            connection.setRequestProperty("Content-Type", "application/xml; charset=\"utf-8\"");
            int responseCode = connection.getResponseCode();
            return (200 <= responseCode && responseCode <= 399);
        } catch (IOException exception) {
            return false;
        }
    }
    
    @SuppressWarnings("restriction")
   	public static Unmarshaller getUnmarshallerWFS_1_1_0(){
   		try{
   			// Para un esquema determinado
   			JAXBContext context = JAXBContext.newInstance("net.opengis.wfs.v_1_1_0");
   			
   			// Use the created JAXB context to construct an unmarshaller
   			return context.createUnmarshaller();
   			
   		} catch (Exception e) {
  			e.printStackTrace();
  			return null;
  		}
   		
   	}
    
    @SuppressWarnings("restriction")
   	public static Unmarshaller getUnmarshaller(){
   		try{
   			// Para un esquema determinado
   			JAXBContext context = JAXBContext.newInstance("net.opengis.wms.v_1_3_0");
   			
   			// Use the created JAXB context to construct an unmarshaller
   			return context.createUnmarshaller();
   			
   		} catch (JAXBException e) {
  			e.printStackTrace();
  			return null;
   		} catch (Exception e) {
  			e.printStackTrace();
  			return null;
  		}
   		
   	}
    
    @SuppressWarnings("restriction")
   	public static Unmarshaller getUnmarshaller_1_1_1(){
   		try{
   			// Para un esquema determinado
   			JAXBContext context = JAXBContext.newInstance("net.opengis.wms.v_1_1_1");
   			
   			// Use the created JAXB context to construct an unmarshaller
   			return context.createUnmarshaller();
   			
   		} catch (JAXBException e) {
  			e.printStackTrace();
  			return null;
  		}
   		
   	}
    
    @SuppressWarnings("restriction")
   	public static Unmarshaller getUnmarshaller_1_1_0(){
   		try{
   			// Para un esquema determinado
   			JAXBContext context = JAXBContext.newInstance("net.opengis.wms.v_1_1_0");
   			
   			// Use the created JAXB context to construct an unmarshaller
   			return context.createUnmarshaller();
   			
   		} catch (Exception e) {
  			e.printStackTrace();
  			return null;
  		}
   		
   	}
    
    
    /* --------------------------------------------------------------------------
     * Indica si las excepciones del servicio se encuentran en algún formato que evite exponer datos 
     * que sean de utilidad para un atacante. Algunos de estos datos pueden ser: servidor, sistema 
     * operativo, base de datos, etc. 
     * Ejemplos de estos formatos: application/vnd.ogc.se_inimage, application/vnd.ogc.se_blank
     * --------------------------------------------------------------------------*/
    
    @SuppressWarnings("restriction")
   	public static boolean metricInformationException(String url, String serviceType){
    	boolean res = false;
       	try {
       		
       		if(serviceType.equals("WMS")) {
       			
       			Unmarshaller unmarshaller = getUnmarshaller();
       			
       			JAXBElement<WMSCapabilities> wmsCapabilitiesElement = unmarshaller
       			        .unmarshal(new StreamSource(url), WMSCapabilities.class);
       			
       			WMSCapabilities wmsCapabilities = wmsCapabilitiesElement.getValue();
       			Capability c = wmsCapabilities.getCapability();
       			
       			if(c!=null && c.isSetException()){
       				List<String> list = c.getException().getFormat();
       				for (int i = 0; i < list.size(); i++) {
       					
						if(list.get(i).equals("INIMAGE") || list.get(i).equals("BLANK")){
							return true;
						}
					}
       			} 
       		} 
       		
       		/*else if(serviceType.equals("WFS")){
       			Unmarshaller unmarshaller = getUnmarshallerWFS_1_1_0();
       			
       			JAXBElement<WFSCapabilitiesType> capabilitiesElement = unmarshaller
       			        .unmarshal(new StreamSource(url+"&exceptions=text/xml"), WFSCapabilitiesType.class);
       			
       			WFSCapabilitiesType wfsCapabilities = capabilitiesElement.getValue();
       			if(wfsCapabilities.getOperationsMetadata().get){
       			}
       			
       			return false;
       		}*/
   			
   		} catch (Exception ex) {
   			ex.printStackTrace();
   		}
       	return res;
    }
    
    
    /* --------------------------------------------------------------------------
     * Indica si el método soporta el formato de excepción format
     * --------------------------------------------------------------------------*/
    
    @SuppressWarnings("restriction")
   	public static boolean metricFormatException(String url, String serviceType, String format){
    	boolean res = false;
       	try {
       		
       		
       		Unmarshaller unmarshaller = getUnmarshaller();
   			 
       		if(serviceType.equals("WMS")) {
       			// Unmarshal the given URL, retrieve WMSCapabilities element
       			JAXBElement<WMSCapabilities> wmsCapabilitiesElement = unmarshaller
       			        .unmarshal(new StreamSource(url), WMSCapabilities.class);
       			
       			// Retrieve WMSCapabilities instance
       			WMSCapabilities wmsCapabilities = wmsCapabilitiesElement.getValue();
       			Capability c = wmsCapabilities.getCapability();
       			
       			if(c.isSetException()){
       				List<String> list = c.getException().getFormat();
       				for (int i = 0; i < list.size(); i++) {
						if(list.get(i).equals(format)){
							return true;
						}
					}
       			}
       		}
   			
   		} catch (Exception e) {
  			e.printStackTrace();
  		}
       	return res;
    }
    
    /* --------------------------------------------------------------------------
     * Indica si las excepciones que son retornadas por el servicio se encuentran en 
     * algún formato propuesto por los estándares OGC.
     * --------------------------------------------------------------------------*/
    
    @SuppressWarnings("restriction")
   	public static boolean metricOGCFormatException(String url, String serviceType){
    	boolean res = false;
       	try {
       		
       		Unmarshaller unmarshaller = getUnmarshaller();
   			 
       		if(serviceType.equals("WMS")) {
       			// Unmarshal the given URL, retrieve WMSCapabilities element
       			JAXBElement<WMSCapabilities> wmsCapabilitiesElement = unmarshaller
       			        .unmarshal(new StreamSource(url), WMSCapabilities.class);
       			
       			// Retrieve WMSCapabilities instance
       			WMSCapabilities wmsCapabilities = wmsCapabilitiesElement.getValue();
       			Capability c = wmsCapabilities.getCapability();
       			
       			if(c.isSetException()){
       				List<String> list = c.getException().getFormat();
       				for (int i = 0; i < list.size(); i++) {
						if(list.get(i).equals("INIMAGE") || list.get(i).equals("BLANK") 
								|| list.get(i).equals("XML") || list.get(i).equals("PARTIALMAP")
								|| list.get(i).equals("JSON") || list.get(i).equals("JSONP")){
							return true;
						}
					}
       			}
       		}
   			
   		} catch (Exception e) {
  			e.printStackTrace();
  		}
       	return res;
    }
    
    /* --------------------------------------------------------------------------
     * Indica la cantidad de diferentes formatos que soporta el servicio para 
     * retornar una excepción.
     * --------------------------------------------------------------------------*/
    
    @SuppressWarnings("restriction")
   	public static Integer metricCountFormatException(String url, String serviceType){
    	int res = 0;
       	try {
       		
       		Unmarshaller unmarshaller = getUnmarshaller();
   			 
       		if(serviceType.equals("WMS")) {
       			// Unmarshal the given URL, retrieve WMSCapabilities element
       			JAXBElement<WMSCapabilities> wmsCapabilitiesElement = unmarshaller
       			        .unmarshal(new StreamSource(url), WMSCapabilities.class);
       			
       			// Retrieve WMSCapabilities instance
       			WMSCapabilities wmsCapabilities = wmsCapabilitiesElement.getValue();
       			Capability c = wmsCapabilities.getCapability();
       			
       			if(c.isSetException()){
       				List<String> list = c.getException().getFormat();
       				res = list.size();
       			}
       		}
   			
   		} catch (Exception e) {
  			e.printStackTrace();
  		}
       	return res;
    }
    
    
    /* --------------------------------------------------------------------------
     * Indica si el método getMap() soporta el formato Format.
     * --------------------------------------------------------------------------*/
    
    @SuppressWarnings("restriction")
   	public static boolean metricGetMapFormat(String url, String serviceType, String format){
    	boolean res = false;
       	try {
       		
       		Unmarshaller unmarshaller = getUnmarshaller();
   			 
       		if(serviceType.equals("WMS")) {
       			// Unmarshal the given URL, retrieve WMSCapabilities element
       			JAXBElement<WMSCapabilities> wmsCapabilitiesElement = unmarshaller
       			        .unmarshal(new StreamSource(url), WMSCapabilities.class);
       			
       			// Retrieve WMSCapabilities instance
       			WMSCapabilities wmsCapabilities = wmsCapabilitiesElement.getValue();
       			Capability c = wmsCapabilities.getCapability();
       			
       			if(c.getRequest()!=null && c.getRequest().getGetMap()!=null) {
       				for (String l : c.getRequest().getGetMap().getFormat()) {
    			    	if(format.equals(l)){
    			    		return true;
    			    	}
    				}
       			}
				
       		}
   			
   		} catch (Exception e) {
  			e.printStackTrace();
  		}
       	return res;
    }
    
    
    
    /* --------------------------------------------------------------------------
     * Indica si el método GetFeatureInfo() soporta el formato Format.
     * --------------------------------------------------------------------------*/
    
    @SuppressWarnings("restriction")
   	public static boolean metricGetFeatureInfoFormat(String url, String serviceType, String format){
    	boolean res = false;
       	try {
       		
       		Unmarshaller unmarshaller = getUnmarshaller();
   			 
       		if(serviceType.equals("WMS")) {
       			// Unmarshal the given URL, retrieve WMSCapabilities element
       			JAXBElement<WMSCapabilities> wmsCapabilitiesElement = unmarshaller
       			        .unmarshal(new StreamSource(url), WMSCapabilities.class);
       			
       			// Retrieve WMSCapabilities instance
       			WMSCapabilities wmsCapabilities = wmsCapabilitiesElement.getValue();
       			Capability c = wmsCapabilities.getCapability();
       			
       			if(c.getRequest()!=null && c.getRequest().getGetFeatureInfo()!=null) {
       				for (String l : c.getRequest().getGetFeatureInfo().getFormat()) {
    			    	if(format.equals(l)){
    			    		return true;
    			    	}
    				}
       			}
				
       		}
   			
   		} catch (Exception e) {
  			e.printStackTrace();
  		}
       	return res;
    }
    
    /* -------------------------------------------------------------------------------------------
     * Indica el grado del total de capas publicadas por el servicio que están en el CRS adecuado.
     * ------------------------------------------------------------------------------------------*/
    @SuppressWarnings("restriction")
   	public static int metricCRSInLayers(String url, String serviceType){
    	int res = 0, count = 0;
       	try {
       		Unmarshaller unmarshaller = getUnmarshaller();
  			 
       		if(serviceType.equals("WMS")) {
       			JAXBElement<WMSCapabilities> wmsCapabilitiesElement = unmarshaller
       			        .unmarshal(new StreamSource(url), WMSCapabilities.class);
       			
       			WMSCapabilities wmsCapabilities = wmsCapabilitiesElement.getValue();
       			
       			if(wmsCapabilities.getCapability()!=null && wmsCapabilities.getCapability().getLayer()!=null 
       					&& wmsCapabilities.getCapability().getLayer().getLayer().size()>0){
       			
	       			for (Layer layer : wmsCapabilities.getCapability().getLayer().getLayer()) {
	       				if(metricCRSInLayer(layer)){
	       					count++;
	       				}
	    			}
	       			
	       			res = (100 * count) / wmsCapabilities.getCapability().getLayer().getLayer().size();
	       		}
       		}
       		
   		} catch (Exception e) {
   			e.printStackTrace();
   		}
       	return res;
    }
    
    
    /* --------------------------------------------------------------------------
     * Indica si la capa cumple con el CRS adecuado.
     * --------------------------------------------------------------------------*/
    
   	public static boolean metricCRSInLayer(Layer layer){
    	boolean res = false;
       	try {
       		
       		return layer.isSetCRS();
       		
   		} catch (Exception e) {
   			e.printStackTrace();
   		}
       	return res;
    }
    
   	
    /* --------------------------------------------------------------------------
     * Representa la cantidad total de formatos que puede soportar el servicio 
     * geográfico, en la totalidad de sus métodos.
     * --------------------------------------------------------------------------*/
   	
   	@SuppressWarnings("restriction")
   	public static int metricCountMapFormat(String url, String serviceType){
    	int res = 0;
       	try {
       		
       		Unmarshaller unmarshaller = getUnmarshaller();
   			 
       		if(serviceType.equals("WMS")) {
       			// Unmarshal the given URL, retrieve WMSCapabilities element
       			JAXBElement<WMSCapabilities> wmsCapabilitiesElement = unmarshaller
       			        .unmarshal(new StreamSource(url), WMSCapabilities.class);
       			
       			// Retrieve WMSCapabilities instance
       			WMSCapabilities wmsCapabilities = wmsCapabilitiesElement.getValue();
       			Capability c = wmsCapabilities.getCapability();
       			
       			if(c.getRequest()!=null && c.getRequest().getGetMap()!=null) {
       				return c.getRequest().getGetMap().getFormat().size();
       			}
				
       		}
   			
   		} catch (Exception e) {
  			e.printStackTrace();
  		}
       	return res;
    }
   	
   	
   	/* --------------------------------------------------------------------------
     * Indica si el servicio implementa el método GetLegendGraphic.
     * --------------------------------------------------------------------------*/
    
    @SuppressWarnings("restriction")
   	public static boolean metricGetLegendGraphic(String url, String serviceType){
    	boolean res = false;
       	try {
       		
       		/*Para versiones menores a 1.3.0
       		 * Unmarshaller unmarshaller = getUnmarshaller_1_1_1();
  			 
       		if(serviceType.equals("WMS")) {
       			JAXBElement<net.opengis.wms.v_1_1_1.WMTMSCapabilities> wmsCapabilitiesElement = unmarshaller
       			        .unmarshal(new StreamSource(url), net.opengis.wms.v_1_1_1.WMTMSCapabilities.class);
       			
       			net.opengis.wms.v_1_1_1.WMTMSCapabilities wmsCapabilities = wmsCapabilitiesElement.getValue();
       			
       			net.opengis.wms.v_1_1_1.Capability c = wmsCapabilities.getCapability();
       			
	       		if(c.getRequest()!=null && c.getRequest().getGetLegendGraphic()!=null) {
	       			return true;
	       		}
				
       		}*/
       		
       		
 			 
       		if(serviceType.equals("WMS")) {
       			Unmarshaller unmarshaller = getUnmarshaller();
       			JAXBElement<WMSCapabilities> wmsCapabilitiesElement = unmarshaller
       			        .unmarshal(new StreamSource(url), WMSCapabilities.class);
       			
       			WMSCapabilities wmsCapabilities = wmsCapabilitiesElement.getValue();
       			
       			if(wmsCapabilities.getCapability()==null || wmsCapabilities.getCapability().getLayer()==null 
       					|| wmsCapabilities.getCapability().getLayer().getLayer().size()==0){
       				return false;
       			}
       			
       			for (Layer layer : wmsCapabilities.getCapability().getLayer().getLayer()) {
       				for (Style style : layer.getStyle()) {
       					if(style.isSetLegendURL()){
       						return true;
       					}
       				}
    			}
       		} 
       		
       		
   		} catch (Exception e) {
   			e.printStackTrace();
   		}
       	return res;
    }
    
    
    
    /* --------------------------------------------------------------------------
     * Indica si la capa tiene definido el parámetro <ScaleHint>. 
     * Dicho dato es el que sugiere cuál es la escala mínima y máxima en que es 
     * apropiado mostrar la capa.
     * --------------------------------------------------------------------------*/
    
    @SuppressWarnings("restriction")
   	public static boolean metricScaleHint(String url, String serviceType, String layerName){
    	boolean res = false;
       	try {
       		
       		/*
       		if(serviceType.equals("WMS")) {
       			Unmarshaller unmarshaller = getUnmarshaller_1_1_0();
       			JAXBElement<net.opengis.wms.v_1_1_0.WMTMSCapabilities> wmsCapabilitiesElement = unmarshaller
       			        .unmarshal(new StreamSource(url), net.opengis.wms.v_1_1_0.WMTMSCapabilities.class);
       			
       			net.opengis.wms.v_1_1_0.WMTMSCapabilities wmsCapabilities = wmsCapabilitiesElement.getValue();
       			
    			for (net.opengis.wms.v_1_1_0.Layer layer : wmsCapabilities.getCapability().getLayer().getLayer()) {
    				net.opengis.wms.v_1_1_0.ScaleHint scale = layer.getScaleHint();
    				
    				if(scale!=null) {
    					return true;
    				}
    			}
				
       		}*/
       		
       		if(serviceType.equals("WMS")) {
       			Unmarshaller unmarshaller = getUnmarshaller();
       			JAXBElement<WMSCapabilities> wmsCapabilitiesElement = unmarshaller
       			        .unmarshal(new StreamSource(url), WMSCapabilities.class);
       			
       			WMSCapabilities wmsCapabilities = wmsCapabilitiesElement.getValue();
       			
       			if(wmsCapabilities.getCapability()==null || wmsCapabilities.getCapability().getLayer()==null 
       					|| wmsCapabilities.getCapability().getLayer().getLayer().size()==0){
       				return false;
       			}
       			
       			for (Layer layer : wmsCapabilities.getCapability().getLayer().getLayer()) {
       				if(layer.getName().equals(layerName)){
       					if(layer.isSetMaxScaleDenominator() && layer.isSetMinScaleDenominator()) {
          					return true;
       					} else {
           					return false;
           				}
       				} 
    			}
       		} 
   			
   		} catch (Exception e) {
   			e.printStackTrace();
   		}
       	return res;
    }
    
    /* --------------------------------------------------------------------------
     * Indica si la capa cumple con el CRS adecuado.
     * --------------------------------------------------------------------------*/
    @SuppressWarnings("restriction")
   	public static boolean metricCRSInLayer(String url, String serviceType, String layerName){
    	boolean res = false;
       	try {
       		
       		if(serviceType.equals("WMS")) {
       			Unmarshaller unmarshaller = getUnmarshaller();
       			JAXBElement<WMSCapabilities> wmsCapabilitiesElement = unmarshaller
       			        .unmarshal(new StreamSource(url), WMSCapabilities.class);
       			
       			WMSCapabilities wmsCapabilities = wmsCapabilitiesElement.getValue();
       			
       			if(wmsCapabilities.getCapability()==null || wmsCapabilities.getCapability().getLayer()==null 
       					|| wmsCapabilities.getCapability().getLayer().getLayer().size()==0){
       				return false;
       			}
       			
       			for (Layer layer : wmsCapabilities.getCapability().getLayer().getLayer()) {
       				if(layer.getName().equals(layerName)){
       					return metricCRSInLayer(layer);
       				} 
    			}
       		} 
   			
   		} catch (Exception e) {
   			e.printStackTrace();
   		}
       	return res;
    }
    
    
    /* --------------------------------------------------------------------------
     * Devuelve las capas del servicio
     * --------------------------------------------------------------------------*/
    @SuppressWarnings("restriction")
   	public static List<String> getLayers(String url, String serviceType){
    	List<String> list = new ArrayList<String>();
       	try {
       		
       		if(serviceType.equals("WMS")) {
       			Unmarshaller unmarshaller = getUnmarshaller();
       			JAXBElement<WMSCapabilities> wmsCapabilitiesElement = unmarshaller
       			        .unmarshal(new StreamSource(url), WMSCapabilities.class);
       			
       			WMSCapabilities wmsCapabilities = wmsCapabilitiesElement.getValue();
       			
       			if(wmsCapabilities.getCapability()==null || wmsCapabilities.getCapability().getLayer()==null 
       					|| wmsCapabilities.getCapability().getLayer().getLayer().size()==0){
       				return list;
       			}
       			
       			for (Layer layer : wmsCapabilities.getCapability().getLayer().getLayer()) {
       				list.add(layer.getName());
    			}
       		} 
   			
   		} catch (Exception e) {
   			e.printStackTrace();
   			return list;
   		}
       	return list;
    }
}
