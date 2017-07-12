package service;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Method;
import java.lang.reflect.Parameter;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLClassLoader;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;

import javax.annotation.PostConstruct;
import javax.ejb.EJB;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
import javax.faces.context.FacesContext;

import org.primefaces.event.FileUploadEvent;
import org.primefaces.model.UploadedFile;

import dao.DAOException;
import dao.QualityModelTreeStructureBean;
import dao.QualityModelTreeStructureBeanRemote;
import entity.QualityModelTreeStructure;

@ManagedBean(name="qualityModelBeanAdd")
@ViewScoped
public class QualityModelBeanAdd {
	
	private List<QualityModelTreeStructure> listQualityModels;
    private List <QualityModelTreeStructure> listModel;
    private List <QualityModelTreeStructure> listDimension;
    private List <QualityModelTreeStructure> listFactor;
    private List <QualityModelTreeStructure> listMetric;
	
	private String entityType;
    private String modelName;
    private QualityModelTreeStructure dimensionModel;
    private String dimensionName;
    private QualityModelTreeStructure factorDimension;
    private String factorName;
    private QualityModelTreeStructure metricFactor;

    private Boolean metricIsAggregation;
    private Integer metricUnitID;
    private String metricGranularity;
    private String metricName;
    private String metricDescription;
    private String metricFileName;
    
	@EJB
	private QualityModelTreeStructureBeanRemote qmDao = new QualityModelTreeStructureBean();

	@PostConstruct
	private void init()
	{
		try {
			listQualityModels = qmDao.list();
			createQualityModelLists();
    	} catch(DAOException e) {
    		e.printStackTrace();
    	} 
	}
	
	public List<QualityModelTreeStructure> getListQualityModels() {
		return listQualityModels;
	}
	
	public void setListQualityModels(List<QualityModelTreeStructure> listQualityModels) {
		this.listQualityModels = listQualityModels;
	}

	public String getEntityType() {
		return entityType;
	}

	public void setEntityType(String entityType) {
		this.entityType = entityType;
	}
    
    public List<QualityModelTreeStructure> getListModel() {
		return listModel;
	}

	public void setListModel(List<QualityModelTreeStructure> listModel) {
		this.listModel = listModel;
	}

	public List<QualityModelTreeStructure> getListDimension() {
		return listDimension;
	}

	public void setListDimension(List<QualityModelTreeStructure> listDimension) {
		this.listDimension = listDimension;
	}

	public List<QualityModelTreeStructure> getListFactor() {
		return listFactor;
	}

	public void setListFactor(List<QualityModelTreeStructure> listFactor) {
		this.listFactor = listFactor;
	}

	public List<QualityModelTreeStructure> getListMetric() {
		return listMetric;
	}

	public void setListMetric(List<QualityModelTreeStructure> listMetric) {
		this.listMetric = listMetric;
	}

	public String getModelName() {
		return modelName;
	}

	public void setModelName(String modelName) {
		this.modelName = modelName;
	}

	public QualityModelTreeStructure getDimensionModel() {
		return dimensionModel;
	}

	public void setDimensionModel(QualityModelTreeStructure dimensionModel) {
		this.dimensionModel = dimensionModel;
	}

	public String getDimensionName() {
		return dimensionName;
	}

	public void setDimensionName(String dimensionName) {
		this.dimensionName = dimensionName;
	}

	public QualityModelTreeStructure getFactorDimension() {
		return factorDimension;
	}

	public void setFactorDimension(QualityModelTreeStructure factorDimension) {
		this.factorDimension = factorDimension;
	}

	public String getFactorName() {
		return factorName;
	}

	public void setFactorName(String factorName) {
		this.factorName = factorName;
	}

	public QualityModelTreeStructure getMetricFactor() {
		return metricFactor;
	}

	public void setMetricFactor(QualityModelTreeStructure metricFactor) {
		this.metricFactor = metricFactor;
	}

	public String getMetricName() {
		return metricName;
	}

	public void setMetricName(String metricName) {
		this.metricName = metricName;
	}	
	
	public Boolean getMetricIsAggregation() {
		return metricIsAggregation;
	}

	public void setMetricIsAggregation(Boolean metricIsAggregation) {
		this.metricIsAggregation = metricIsAggregation;
	}

	public Integer getMetricUnitID() {
		return metricUnitID;
	}

	public void setMetricUnitID(Integer metricUnitID) {
		this.metricUnitID = metricUnitID;
	}

	public String getMetricGranularity() {
		return metricGranularity;
	}

	public void setMetricGranularity(String metricGranularity) {
		this.metricGranularity = metricGranularity;
	}

	public String getMetricDescription() {
		return metricDescription;
	}

	public void setMetricDescription(String metricDescription) {
		this.metricDescription = metricDescription;
	}
	
	public String getMetricFileName() {
		return metricFileName;
	}

	public void setMetricFileName(String metricFileName) {
		this.metricFileName = metricFileName;
	}	

	public void createQualityModelLists(){
	    listModel = new ArrayList<>();
        List <Integer> listModelIDs = new ArrayList<>();
        listDimension = new ArrayList<>();
        List <Integer> listDimensionIDs = new ArrayList<>();
        listFactor = new ArrayList<>();
        List <Integer> listFactorIDs = new ArrayList<>();
        listMetric = new ArrayList<>();
        List <Integer> listMetricIDs = new ArrayList<>();
        
        if (listQualityModels != null){
			for (QualityModelTreeStructure qualityModelsElement : listQualityModels) {
				if ((!listModelIDs.contains(qualityModelsElement.getElementID()) && qualityModelsElement.getElementType().equals("Q"))){
					listModel.add(qualityModelsElement);
					listModelIDs.add(qualityModelsElement.getElementID());
				}
				
				if ((!listDimensionIDs.contains(qualityModelsElement.getElementID()) && qualityModelsElement.getElementType().equals("D"))){
					listDimension.add(qualityModelsElement);
					listDimensionIDs.add(qualityModelsElement.getElementID());
				}
							
				if ((!listFactorIDs.contains(qualityModelsElement.getElementID()) && qualityModelsElement.getElementType().equals("F"))){
					listFactor.add(qualityModelsElement);
					listFactorIDs.add(qualityModelsElement.getElementID());
				}
				
				if ((!listMetricIDs.contains(qualityModelsElement.getElementID()) && qualityModelsElement.getElementType().equals("M"))){
					listMetric.add(qualityModelsElement);
					listMetricIDs.add(qualityModelsElement.getElementID());
				}
			}
        }
    }
    
    public void save() {
    	
    	QualityModelTreeStructure element = new QualityModelTreeStructure();
    	
    	Boolean metricIsManual = false; //by default
    	Boolean IsUserMetric = false;

    	switch(entityType){
	    	case "Model":
	    		element.setElementName(modelName);
	    		element.setElementType("Q");
	    		element.setFatherElementyID(null);
	    		element.setAggregationFlag(null);
	    		element.setGranularity(null);
	    		element.setUnit(null);
	        	break;
	    	case "Dimension":
	    		element.setElementName(dimensionName);
	    		element.setElementType("D");
	    		element.setFatherElementyID(dimensionModel.getElementID());
	    		element.setAggregationFlag(null);
	    		element.setGranularity(null);
	    		element.setUnit(null);
	        	break;
	    	case "Factor":
	    		element.setElementName(factorName);
	    		element.setElementType("F");
	    		element.setFatherElementyID(factorDimension.getElementID());
	    		element.setAggregationFlag(null);
	    		element.setGranularity(null);
	    		element.setUnit(null);
	        	break;	
	    	case "Metric":
	    		element.setElementName(metricName);
	    		element.setElementType("M");
	    		element.setFatherElementyID(metricFactor.getElementID());
	    		element.setAggregationFlag(metricIsAggregation);
	    		element.setGranularity(metricGranularity);
	    		element.setUnit(null);
	    		IsUserMetric = true;
	        	break;
			default:
				break;	
    	}
    	
    	try{
    		if (entityType.equals("Metric") && metricFileName == null){
        		FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_ERROR, "Error!", "Debe asociar un método a la métrica");
    	        FacesContext.getCurrentInstance().addMessage(null, message);
    		}
    		else{
        		qmDao.create(element, metricUnitID, metricIsManual, metricDescription, IsUserMetric, metricFileName);
                
        		listQualityModels = qmDao.list();
        		createQualityModelLists();
        		
                FacesContext context = FacesContext.getCurrentInstance();
            	context.addMessage(null, new FacesMessage("La entidad del modelo de calidad fue guardada correctamente."));
    		}        		
    	} catch(DAOException e) {
    		
    		FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_ERROR, "Error!", "Error al guardar la entidad");
	        FacesContext.getCurrentInstance().addMessage(null, message);
    		
    		e.printStackTrace();
    	}

	}
    
    public void handleFileUpload(FileUploadEvent event) throws NoSuchMethodException, SecurityException, ClassNotFoundException {
        try {	
	        InputStream in = (event.getFile()).getInputstream();
	        metricFileName = event.getFile().getFileName();
	        
	        Boolean fileNameInUse = false;
	        String metricName = "";
			for (QualityModelTreeStructure element : listMetric) {
				if (element.getMetricFileName() != null && element.getMetricFileName().equals(metricFileName)){
					fileNameInUse = true;
					metricName = element.getElementName();
				}
			}
			
			if (fileNameInUse == true){
		        FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_ERROR, "Error!", metricFileName + " ya se encuentra asociado a la métrica " + metricName);
		        FacesContext.getCurrentInstance().addMessage(null, message);
		        metricFileName = null;
		        fileNameInUse = false;
			}
			else{
				//se copia el archivo a una carpeta local
		        File file = new File("C:/GeoServiceQualityJARs/" + metricFileName);
		        OutputStream out = new FileOutputStream(file);
		        int read = 0;
		        byte[] bytes = new byte[1024];
		
		        while ((read = in.read(bytes)) != -1) {
		            out.write(bytes, 0, read);
		        }
		        in.close();
		        out.flush();
		        out.close();
		        System.out.println("Archivo subido!");

		        //Busqueda de clase y firma necesaria para los jars
            	Boolean isValidJarFile = false;
            	
		        JarFile jarFile = new JarFile(file);
		        Enumeration allEntries = jarFile.entries();
		        
		        while (allEntries.hasMoreElements()) {
	                JarEntry entry = (JarEntry) allEntries.nextElement();
	                String className = entry.getName();
	                
	                if (className.toLowerCase().endsWith(".class")){                	
	                	className = className.replaceAll("/", ".").substring(0, className.lastIndexOf("."));
	                	
	                	System.out.println("Clase encontrada: " + className);
	                	
	                	if (className.equals("UserMetricPackage.UserMetricClass")){
		    		        //Loading de clase para buscar la firma de los metodos que contiene
		                	URL url = file.toURI().toURL();
		    		        URL[] urls = new URL[]{url};

		    		        ClassLoader cl = new URLClassLoader(urls);
		    		        Class<?> cls = cl.loadClass(className);
		                	
		                    Method[] methods = cls.getDeclaredMethods();
		                    for (Method m : methods) {
		                    	System.out.println("Metodo encontrado: " + m.getName());
		                    	
		                        if (m.getName().equals("userMetricMethod") && m.getParameterCount() == 2 && m.getReturnType().toString().equals("boolean")){
		                        	
		                        	Parameter[] p = m.getParameters();
		                        	if (p[0].getType().toString().equals("class java.lang.String") && p[1].getType().toString().equals("class java.lang.String")){
		                        		isValidJarFile = true;
		                        		System.out.println("OK: userMetricMethod contiene dos parametros de tipo string y retorna un booleano");
		                                break;
		                            }
		                        }
		                    }		                		
	                	}
	                }
		        }
		        
		        if (isValidJarFile == true){
			        FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_INFO, "Info", "Método subido correctamente.");
			        FacesContext.getCurrentInstance().addMessage(null, message);
		        }
		        else{
			        FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_ERROR, "Error!", metricFileName + " no está formado de manera correcta");
			        FacesContext.getCurrentInstance().addMessage(null, message);
			        metricFileName = null;
		        }
			}
	    } catch (IOException e) {
	        System.out.println(e.getMessage());
	    }
    }
}
