package service;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.annotation.PostConstruct;
import javax.ejb.EJB;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
import javax.faces.context.FacesContext;

import org.primefaces.event.NodeSelectEvent;
import org.primefaces.event.RowEditEvent;
import org.primefaces.event.SelectEvent;
import org.primefaces.model.DefaultTreeNode;
import org.primefaces.model.TreeNode;

import entity.IdeTreeStructure;
import entity.MeasurableObject;
import dao.DAOException;
import dao.IdeTreeStructureBean;
import dao.IdeTreeStructureBeanRemote;
import dao.MeasurableObjectBean;
import dao.MeasurableObjectBeanRemote;


@ManagedBean(name="measurableObjectBeanList")
@ViewScoped
public class MeasurableObjectBeanList {
	
	private List<IdeTreeStructure> listIdeStructure;
	private List<MeasurableObject> listObjects;
	private MeasurableObject selectedMeasurableObject;
    
	private TreeNode root;
	private TreeNode selectedNode;
	private MeasurableObject selectedTreeNode;
	
	private List <MeasurableObject> listIdeMO;
	private List <MeasurableObject> listInstitutionMO;
	private List <MeasurableObject> listNodeMO;

	@EJB
    private MeasurableObjectBeanRemote moDao = new MeasurableObjectBean();
	private IdeTreeStructureBeanRemote ideTreeDao = new IdeTreeStructureBean();
	
	@PostConstruct
	private void init()	{
		try {
			Integer userID = null;
			listIdeStructure = ideTreeDao.list(userID);

            createTree();
            
    	} catch(DAOException e) {
    		e.printStackTrace();
    	} 
	}
	
	public List<MeasurableObject> getListObjects() {
		return listObjects;
	}
	
	public void setListObjects(List<MeasurableObject> listObjects) {
		this.listObjects = listObjects;
	}

	public MeasurableObject getSelectedMeasurableObject() {
		return selectedMeasurableObject;
	}

	public void setSelectedMeasurableObject(MeasurableObject selectedMeasurableObject) {
		this.selectedMeasurableObject = selectedMeasurableObject;
	}
	
    public TreeNode getSelectedNode() {
        return selectedNode;
    }
 
    public void setSelectedNode(TreeNode selectedNode) {
        this.selectedNode = selectedNode;
    }
	
    public TreeNode getRoot() {
        return root;
    }
    
	public MeasurableObject getSelectedTreeNode() {
		return selectedTreeNode;
	}

	public void setSelectedTreeNode(MeasurableObject selectedTreeNode) {
		this.selectedTreeNode = selectedTreeNode;
	}
	
	public List<MeasurableObject> getListIdeMO() {
		return listIdeMO;
	}

	public void setListIdeMO(List<MeasurableObject> listIdeMO) {
		this.listIdeMO = listIdeMO;
	}
	
	public List<IdeTreeStructure> getListIdeStructure() {
		return listIdeStructure;
	}

	public void setListIdeStructure(List<IdeTreeStructure> listIdeStructure) {
		this.listIdeStructure = listIdeStructure;
	}

	public List <MeasurableObject> getListInstitutionMO() {
		return listInstitutionMO;
	}

	public void setListInstitutionMO(List <MeasurableObject> listInstitutionMO) {
		this.listInstitutionMO = listInstitutionMO;
	}

	public List <MeasurableObject> getListNodeMO() {
		return listNodeMO;
	}

	public void setListNodeMO(List <MeasurableObject> listNodeMO) {
		this.listNodeMO = listNodeMO;
	}
	
    public void onRowSelect(SelectEvent event) {
    	//agregar codigo de ser necesario
    }
    
	public void onTreeRowEdit(RowEditEvent event) {    	
		MeasurableObject mo = ((MeasurableObject) event.getObject());
		
		moDao.update(mo);
		FacesMessage msg = new FacesMessage("Objeto Medible editado correctamente.");
        FacesContext.getCurrentInstance().addMessage(null, msg);
        init();
    }	
       	
	public void onRowEdit(RowEditEvent event) {    	
		MeasurableObject mo = ((MeasurableObject) event.getObject());
		
		moDao.update(mo);
		FacesMessage msg = new FacesMessage("Objeto Medible editado correctamente.");
        FacesContext.getCurrentInstance().addMessage(null, msg);
    }	
	
	public void deleteMeasurableObject() {
		moDao.delete(selectedMeasurableObject);    	
    	listObjects.remove(selectedMeasurableObject);
        selectedMeasurableObject = null;
        
		FacesMessage msg = new FacesMessage("El Objecto Medible fue eliminado correctamente.");       
        FacesContext.getCurrentInstance().addMessage(null, msg);
    }
	

	public void createTree(){
        root = new DefaultTreeNode("Ides", null);
        List <Integer> listIde = new ArrayList<>();
        List <Integer> listInstitution = new ArrayList<>();
        List <Integer> listNode = new ArrayList<>();
        
        listIdeMO = new ArrayList<>();
        listInstitutionMO = new ArrayList<>();
        listNodeMO = new ArrayList<>();
        
        if (listIdeStructure != null){
        	System.out.println("TREE: " + listIdeStructure);
        				
			for (IdeTreeStructure ide : listIdeStructure) {
				if ((!listIde.contains(ide.getIdeID()))){
					listIde.add(ide.getIdeID());
					
					MeasurableObject ideMO = new MeasurableObject();
					ideMO.setEntityType("Ide");
					ideMO.setEntityID(ide.getIdeID());
					ideMO.setMeasurableObjectID(ide.getIdeMeasurableObjectID());
					ideMO.setMeasurableObjectName(ide.getIdeName());
					ideMO.setMeasurableObjectDescription(ide.getIdeDescription());
					listIdeMO.add(ideMO);
					
					TreeNode tIde = new DefaultTreeNode(ide.getIdeName(), root);
					
					for (IdeTreeStructure institution : listIdeStructure) {
						if ((!listInstitution.contains(institution.getInstitutionID()))
								&& ide.getIdeID() == institution.getIdeID()) {
							listInstitution.add(institution.getInstitutionID());
							
							MeasurableObject institutionMO = new MeasurableObject();
							institutionMO.setEntityType("Institución");
							institutionMO.setEntityID(institution.getInstitutionID());
							institutionMO.setMeasurableObjectID(institution.getInstitutionMeasurableObjectID());
							institutionMO.setMeasurableObjectName(institution.getInstitutionName());
							institutionMO.setMeasurableObjectDescription(institution.getInstitutionDescription());
							listInstitutionMO.add(institutionMO);
							
							TreeNode tInstitution = new DefaultTreeNode(institution.getInstitutionName(), tIde);
							
							for (IdeTreeStructure node : listIdeStructure) {
								if ((!listNode.contains(node.getNodeID()))
										&& institution.getInstitutionID() == node.getInstitutionID()) {
									listNode.add(node.getNodeID());
									
									MeasurableObject nodeMO = new MeasurableObject();
									nodeMO.setEntityType("Nodo");
									nodeMO.setEntityID(node.getNodeID());
									nodeMO.setMeasurableObjectID(node.getNodeMeasurableObjectID());
									nodeMO.setMeasurableObjectName(node.getNodeName());
									nodeMO.setMeasurableObjectDescription(node.getNodeDescription());
									listNodeMO.add(nodeMO);
									
									TreeNode tNode = new DefaultTreeNode(node.getNodeName(), tInstitution);
								}
							}
						}
					}						
				}
			}
        }
	}
        
    public void onNodeSelect(NodeSelectEvent event) {    	   	
    	if (selectedNode != null && selectedNode.getRowKey() != null) {
        	String rowKey = selectedNode.getRowKey();
        	Integer numberOfUnderscore = rowKey.length() - rowKey.replace("_", "").length();
        	MeasurableObject element;
        	
    		switch (numberOfUnderscore) {
			case 0:
				listObjects = moDao.servicesAndLayerGet(null, selectedNode.getData().toString(), "Ide");

				Iterator<MeasurableObject> ideItr = listIdeMO.iterator();
				while(ideItr.hasNext()) {
					element = ideItr.next();
					if (element.getMeasurableObjectName().equals(selectedNode.getData())){
						selectedTreeNode = element;						
					}
				}
				break;
			case 1:
				listObjects = moDao.servicesAndLayerGet(null, selectedNode.getData().toString(), "Institución");
				
				Iterator<MeasurableObject> instItr = listInstitutionMO.iterator();

				while(instItr.hasNext()) {
					element = instItr.next();
					if (element.getMeasurableObjectName().equals(selectedNode.getData())){
						selectedTreeNode = element;						
					}
				}
				break;
			case 2:			
				listObjects = moDao.servicesAndLayerGet(null, selectedNode.getData().toString(), "Nodo");
				
				Iterator<MeasurableObject> nodeItr = listNodeMO.iterator();

				while(nodeItr.hasNext()) {
					element = nodeItr.next();
					if (element.getMeasurableObjectName().equals(selectedNode.getData())){
						selectedTreeNode = element;						
					}
				}
				break;
			default:
				break;
			}
    	}    	    	
    }
}
