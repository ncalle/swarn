package service;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.PostConstruct;
import javax.ejb.EJB;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
import javax.faces.context.FacesContext;

import EvaluationCore.App;
import entity.IdeTreeStructure;
import entity.MeasurableObject;
import dao.DAOException;
import dao.IdeTreeStructureBean;
import dao.IdeTreeStructureBeanRemote;
import dao.MeasurableObjectBean;
import dao.MeasurableObjectBeanRemote;


@ManagedBean(name="measurableObjectBeanAdd")
@ViewScoped
public class MeasurableObjectBeanAdd {
	
	private List<IdeTreeStructure> listIdeStructure;
    private List <IdeTreeStructure> listIdes;
    private List <IdeTreeStructure> listInstitutions;
    private List <IdeTreeStructure> listNodes;
	
	private String entityType;
    
    private String ideName;
    private String ideDescription;
    
    private IdeTreeStructure institutionIde;
    private String institutionName;
    private String institutionDescription;
    
    private IdeTreeStructure nodeInstitution;
    private String nodeName;
    private String nodeDescription;
    
    private IdeTreeStructure layerNode;
    private String layerName;
    private String layerDescription;
    private String layerURL;
    
    private IdeTreeStructure serviceNode;
    private String serviceDescription;
    private String serviceURL;
    private String serviceType;
    
    private final String GET_CAPABILITIES = "REQUEST=GetCapabilities";
    private final String GET_SERVICE = "SERVICE=";
    private final String GET_VERSION = "VERSION=";
    private final String GET_VERSION_WMS = "VERSION=1.3.0";
    private final String GET_VERSION_WFS = "VERSION=1.1.0";
    private final String GET_VERSION_CSW = "VERSION=3.0";
    
	@EJB
    private MeasurableObjectBeanRemote moDao = new MeasurableObjectBean();
	private IdeTreeStructureBeanRemote ideTreeDao = new IdeTreeStructureBean();
	
	
	@PostConstruct
	private void init()
	{
		try {
			listIdeStructure = ideTreeDao.list(null); //userID
			createMeasurableObjectLists();
    	} catch(DAOException e) {
    		e.printStackTrace();
    	} 
	}
	
	public List<IdeTreeStructure> getListIdeStructure() {
		return listIdeStructure;
	}

	public void setListIdeStructure(List<IdeTreeStructure> listIdeStructure) {
		this.listIdeStructure = listIdeStructure;
	}
       
	public List<IdeTreeStructure> getListIdes() {
		return listIdes;
	}

	public void setListIdes(List<IdeTreeStructure> listIdes) {
		this.listIdes = listIdes;
	}

	public List<IdeTreeStructure> getListInstitutions() {
		return listInstitutions;
	}

	public void setListInstitutions(List<IdeTreeStructure> listInstitutions) {
		this.listInstitutions = listInstitutions;
	}

	public List<IdeTreeStructure> getListNodes() {
		return listNodes;
	}

	public void setListNodes(List<IdeTreeStructure> listNodes) {
		this.listNodes = listNodes;
	}

	public String getEntityType() {
		return entityType;
	}

	public void setEntityType(String entityType) {
		this.entityType = entityType;
	}
	
	public String getIdeName() {
		return ideName;
	}

	public void setIdeName(String ideName) {
		this.ideName = ideName;
	}
	
	public String getIdeDescription() {
		return ideDescription;
	}

	public void setIdeDescription(String ideDescription) {
		this.ideDescription = ideDescription;
	}
	
	public IdeTreeStructure getInstitutionIde() {
		return institutionIde;
	}

	public void setInstitutionIde(IdeTreeStructure institutionIde) {
		this.institutionIde = institutionIde;
	}

	public String getInstitutionName() {
		return institutionName;
	}

	public void setInstitutionName(String institutionName) {
		this.institutionName = institutionName;
	}

	public String getInstitutionDescription() {
		return institutionDescription;
	}

	public void setInstitutionDescription(String institutionDescription) {
		this.institutionDescription = institutionDescription;
	}

	public IdeTreeStructure getNodeInstitution() {
		return nodeInstitution;
	}

	public void setNodeInstitution(IdeTreeStructure nodeInstitution) {
		this.nodeInstitution = nodeInstitution;
	}

	public String getNodeName() {
		return nodeName;
	}

	public void setNodeName(String nodeName) {
		this.nodeName = nodeName;
	}

	public String getNodeDescription() {
		return nodeDescription;
	}

	public void setNodeDescription(String nodeDescription) {
		this.nodeDescription = nodeDescription;
	}
	
	public IdeTreeStructure getLayerNode() {
		return layerNode;
	}

	public void setLayerNode(IdeTreeStructure layerNode) {
		this.layerNode = layerNode;
	}

	public String getLayerName() {
		return layerName;
	}

	public void setLayerName(String layerName) {
		this.layerName = layerName;
	}

	public String getLayerDescription() {
		return layerDescription;
	}

	public void setLayerDescription(String layerDescription) {
		this.layerDescription = layerDescription;
	}

	public String getLayerURL() {
		return layerURL;
	}

	public void setLayerURL(String layerURL) {
		this.layerURL = layerURL;
	}
	
	public IdeTreeStructure getServiceNode() {
		return serviceNode;
	}

	public void setServiceNode(IdeTreeStructure serviceNode) {
		this.serviceNode = serviceNode;
	}
	
    public String getServiceDescription() {
		return serviceDescription;
	}
    
    public void setServiceDescription(String serviceDescription) {
		this.serviceDescription = serviceDescription;
	}
    
    public String getServiceURL() {
		return serviceURL;
	}
    
    public void setServiceURL(String serviceURL) {
		this.serviceURL = serviceURL;
	}
    
    public String getServiceType() {
		return serviceType;
	}
    
    public void setServiceType(String serviceType) {
		this.serviceType = serviceType;
	}
    
    public void createMeasurableObjectLists(){
        listIdes = new ArrayList<>();
        List <Integer> listIdesIDs = new ArrayList<>();
        listInstitutions = new ArrayList<>();
        List <Integer> listInstitutionsIDs = new ArrayList<>();
        listNodes = new ArrayList<>();
        List <Integer> listNodesIDs = new ArrayList<>();
        
        if (listIdeStructure != null){
        	System.out.println("TREE: " + listIdeStructure);
        				
			for (IdeTreeStructure measurableObjects : listIdeStructure) {
				if ((!listIdesIDs.contains(measurableObjects.getIdeID()))){
					listIdes.add(measurableObjects);
					listIdesIDs.add(measurableObjects.getIdeID());
				}
				
				if ((!listInstitutionsIDs.contains(measurableObjects.getInstitutionID()))){
					listInstitutions.add(measurableObjects);
					listInstitutionsIDs.add(measurableObjects.getInstitutionID());
				}
							
				if ((!listNodesIDs.contains(measurableObjects.getNodeID()))){
					listNodes.add(measurableObjects);
					listNodesIDs.add(measurableObjects.getNodeID());
				}

			}
        }
    }
    
    public void save() {

    	if(entityType == "Servicio") {
    		if (serviceURL.length()==0){
        		FacesContext context = FacesContext.getCurrentInstance();
        		context.addMessage(null, new FacesMessage("Debe ingresar una url"));
        		return;
        	}
    		parametersRequestUrl();	
    	}
    	
    	/*if(entityType == "Capa") {
    		if (layerURL.length()==0){
        		FacesContext context = FacesContext.getCurrentInstance();
        		context.addMessage(null, new FacesMessage("Debe ingresar una url"));
        		return;
        	}
    		//parametersRequestUrl();	
    	} */   	
    	
    	MeasurableObject object = new MeasurableObject();
    	
    	switch(entityType){
	    	case "Ide":
	    		object.setEntityType(entityType);
	    		object.setFatherEntityID(null);
	    		object.setFatherEntityType(null);
	    		object.setMeasurableObjectName(ideName);
	    		object.setMeasurableObjectDescription(ideDescription);
	        	object.setMeasurableObjectURL(null);
	        	object.setMeasurableObjectServicesType(null);
	        	break;
	    	case "Institución":
	    		object.setEntityType(entityType);
	    		object.setFatherEntityID(institutionIde.getIdeID());
	    		object.setFatherEntityType("Ide");
	    		object.setMeasurableObjectName(institutionName);
	    		object.setMeasurableObjectDescription(institutionDescription);
	        	object.setMeasurableObjectURL(null);
	        	object.setMeasurableObjectServicesType(null);
	        	break;
	    	case "Nodo":
	    		object.setEntityType(entityType);
	    		object.setFatherEntityID(nodeInstitution.getInstitutionID());
	    		object.setFatherEntityType("Institución");
	    		object.setMeasurableObjectName(nodeName);
	    		object.setMeasurableObjectDescription(nodeDescription);
	        	object.setMeasurableObjectURL(null);
	        	object.setMeasurableObjectServicesType(null);
	        	break;	
	    	/*case "Capa":
	    		object.setEntityType(entityType);
	    		object.setFatherEntityID(layerNode.getNodeID());
	    		object.setFatherEntityType("Nodo");
	    		object.setMeasurableObjectName(layerName);
	    		object.setMeasurableObjectDescription(layerDescription);
	        	object.setMeasurableObjectURL(layerURL);
	        	object.setMeasurableObjectServicesType(null);
	        	break;*/
	    	case "Servicio":
	    		object.setEntityType(entityType);
	    		object.setFatherEntityID(serviceNode.getNodeID());
	    		object.setFatherEntityType("Nodo");
	    		object.setMeasurableObjectName(null);
	    		object.setMeasurableObjectDescription(serviceDescription);
	        	object.setMeasurableObjectURL(serviceURL);
	        	object.setMeasurableObjectServicesType(serviceType);
	        	
	        	//Se agregan las capas del servicio
	        	List<String> layersNames =  App.getLayers(serviceURL, serviceType);
	        	for (String name : layersNames) {
	        		saveLayers(name);
				}
	        	break;
			default:
				break;	
    	}
    	    	    	
    	System.out.println("save.. " + object);
    	
    	try{
            moDao.create(object, entityType);
            
            FacesContext context = FacesContext.getCurrentInstance();
        	context.addMessage(null, new FacesMessage("El objeto medible fue guardado correctamente."));
        		
    	} catch(DAOException e) {
    		
    		FacesContext context = FacesContext.getCurrentInstance();
    		context.addMessage(null, new FacesMessage("Error al guardar el objeto medible."));
    		
    		e.printStackTrace();
    	} 

	}
    
    
    public void saveLayers(String layerName) {

    	MeasurableObject object = new MeasurableObject();
    	
		object.setEntityType("Capa");
		object.setFatherEntityID(serviceNode.getNodeID());
		object.setFatherEntityType("Nodo");
		object.setMeasurableObjectName(layerName);
		object.setMeasurableObjectDescription("");
    	object.setMeasurableObjectURL(serviceURL);
    	object.setMeasurableObjectServicesType(serviceType);
    	    	    	
    	System.out.println("saveLayers.. " + object);
    	
    	try{
            moDao.create(object, "Capa");
            
    	} catch(DAOException e) {
    		e.printStackTrace();
    	} 

	}
    
    public void parametersRequestUrl() {
   	
    	//Se agrega el pedido de servicio
    	if(serviceURL.indexOf(GET_SERVICE)==-1){
    		if(serviceURL.indexOf("?")==-1){
    			serviceURL = serviceURL + "?";
    		} else if(!serviceURL.substring(serviceURL.length()-1, serviceURL.length()).equals("?")){
    			serviceURL = serviceURL + "&";
    		}
    		serviceURL = serviceURL + GET_SERVICE + serviceType;
    	}
    	
    	//Se agrega el pedido de version
    	if(serviceURL.indexOf(GET_VERSION)==-1){
    		
    		if(!serviceURL.substring(serviceURL.length()-1, serviceURL.length()).equals("&")){
    			serviceURL = serviceURL + "&";
    		}
    		
    		if(serviceType.equals("WMS")){
    			serviceURL = serviceURL + GET_VERSION_WMS;
    		} else if(serviceType.equals("WFS")){
    			serviceURL = serviceURL + GET_VERSION_WFS;
    		} else {
    			serviceURL = serviceURL + GET_VERSION_CSW;
    		}
    	} 
    	
    	//Se agrega el pedido de capabilities
    	if(serviceURL.indexOf(GET_CAPABILITIES)==-1){
    		if(!serviceURL.substring(serviceURL.length()-1, serviceURL.length()).equals("&")){
    			serviceURL = serviceURL + "&";
    		}
    		serviceURL = serviceURL + GET_CAPABILITIES;
    	} 
    	
    }
}
