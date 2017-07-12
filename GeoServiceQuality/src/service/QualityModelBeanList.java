package service;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.PostConstruct;
import javax.ejb.EJB;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
import javax.faces.context.FacesContext;

import org.primefaces.event.RowEditEvent;
import org.primefaces.model.DefaultTreeNode;
import org.primefaces.model.TreeNode;

import entity.QualityModelTreeStructure;
import dao.DAOException;
import dao.QualityModelTreeStructureBean;
import dao.QualityModelTreeStructureBeanRemote;


@ManagedBean(name="qualityModelBeanList")
@ViewScoped
public class QualityModelBeanList {
	
	private List<QualityModelTreeStructure> listQualityModels;
	
    private TreeNode qualityModelTree;
	
	@EJB
	private QualityModelTreeStructureBeanRemote qmDao = new QualityModelTreeStructureBean();
		
	@PostConstruct
	private void init()	{
		try {
			qualityModelTree = createQualityModelTree();
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

	public TreeNode getQualityModelTree() {
		return qualityModelTree;
	}

	public void setQualityModelTree(TreeNode qualityModelTree) {
		this.qualityModelTree = qualityModelTree;
	}
	
    public void onQualityModelTreeRowEdit(Integer elementID, String elementType, String name) {   	
    	qmDao.update(elementID, elementType, name);
    	
        FacesMessage msg = new FacesMessage("Ponderación editada correctamente");
        FacesContext.getCurrentInstance().addMessage(null, msg);
    }
     
    public void onQualityModelTreeRowCancel(RowEditEvent event) {
        FacesMessage msg = new FacesMessage("Edición cancelada", ((TreeNode) event.getObject()).toString());
        FacesContext.getCurrentInstance().addMessage(null, msg);
    }
	
	
	public TreeNode createQualityModelTree() {
	        List <Integer> listQModels = new ArrayList<>();
	        List <Integer> listDimensions = new ArrayList<>();
	        List <Integer> listFactors = new ArrayList<>();
	        List <Integer> listMetrics = new ArrayList<>();
	        
	        listQualityModels = qmDao.list();
	        
	    	TreeNode root = new DefaultTreeNode(new QualityModelElement(0, "Modelos", false, null, null, null), null);
	        
	        if (listQualityModels != null){        	
				for (QualityModelTreeStructure qm : listQualityModels) {
					if (qm.getElementType().equals("Q") && !listQModels.contains(qm.getElementID())){
						
						listQModels.add(qm.getElementID());
						TreeNode qualityModel;
						
						qualityModel = new DefaultTreeNode(new QualityModelElement(qm.getElementID(), qm.getElementName(), qm.getAggregationFlag(), qm.getGranularity(), qm.getUnit(), "Q"), root);
						
						for (QualityModelTreeStructure d : listQualityModels) {
							if (d.getElementType().equals("D") && !listDimensions.contains(d.getElementID()) && qm.getElementID() == d.getFatherElementyID()){
								
								listDimensions.add(d.getElementID());
								TreeNode dimension;

								dimension = new DefaultTreeNode(new QualityModelElement(d.getElementID(), d.getElementName(), d.getAggregationFlag(), d.getGranularity(), d.getUnit(), "D"), qualityModel);
								
									
								for (QualityModelTreeStructure f : listQualityModels) {
									if (f.getElementType().equals("F") && !listFactors.contains(f.getElementID()) && d.getElementID() == f.getFatherElementyID()){
										
										listFactors.add(f.getElementID());
										TreeNode factor;
										
										factor = new DefaultTreeNode(new QualityModelElement(f.getElementID(), f.getElementName(), f.getAggregationFlag(), f.getGranularity(), f.getUnit(), "F"), dimension);									
										
										for (QualityModelTreeStructure m : listQualityModels) {
											if (m.getElementType().equals("M") && !listMetrics.contains(m.getElementID()) && f.getElementID() == m.getFatherElementyID()){
												
												listMetrics.add(m.getElementID());
												TreeNode metric;
												
												metric = new DefaultTreeNode(new QualityModelElement(m.getElementID(), m.getElementName(), m.getAggregationFlag(), m.getGranularity(), m.getUnit(), "M"), factor);
											}
										}
									}
								}
							}
						}						
					}
				}
	        }

	        return root;
	    }
}
