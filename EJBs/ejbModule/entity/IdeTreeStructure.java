package entity;

import java.io.Serializable;

/**
 * Modelo que representa el Modelo de Calidad.
 * Puede ser usada a travez de todas las capas, capa de datos, controlador o vista
 */
public class IdeTreeStructure implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer IdeMeasurableObjectID;
    private Integer IdeID;
    private String IdeName;
    private String IdeDescription;
    private Integer InstitutionMeasurableObjectID;
    private Integer InstitutionID;
    private String InstitutionName;
    private String InstitutionDescription;
    private Integer NodeMeasurableObjectID;
    private Integer NodeID;
    private String NodeName;
    private String NodeDescription;
   
	public Integer getIdeMeasurableObjectID() {
		return IdeMeasurableObjectID;
	}

	public void setIdeMeasurableObjectID(Integer ideMeasurableObjectID) {
		IdeMeasurableObjectID = ideMeasurableObjectID;
	}
    
    public Integer getIdeID() {
		return IdeID;
	}

	public void setIdeID(Integer ideID) {
		IdeID = ideID;
	}

	public String getIdeName() {
		return IdeName;
	}

	public void setIdeName(String ideName) {
		IdeName = ideName;
	}

	public String getIdeDescription() {
		return IdeDescription;
	}

	public void setIdeDescription(String ideDescription) {
		IdeDescription = ideDescription;
	}
	
	public Integer getInstitutionMeasurableObjectID() {
		return InstitutionMeasurableObjectID;
	}

	public void setInstitutionMeasurableObjectID(Integer institutionMeasurableObjectID) {
		InstitutionMeasurableObjectID = institutionMeasurableObjectID;
	}

	public Integer getInstitutionID() {
		return InstitutionID;
	}

	public void setInstitutionID(Integer institutionID) {
		InstitutionID = institutionID;
	}

	public String getInstitutionName() {
		return InstitutionName;
	}

	public void setInstitutionName(String institutionName) {
		InstitutionName = institutionName;
	}

	public String getInstitutionDescription() {
		return InstitutionDescription;
	}

	public void setInstitutionDescription(String institutionDescription) {
		InstitutionDescription = institutionDescription;
	}
	
	public Integer getNodeMeasurableObjectID() {
		return NodeMeasurableObjectID;
	}

	public void setNodeMeasurableObjectID(Integer nodeMeasurableObjectID) {
		NodeMeasurableObjectID = nodeMeasurableObjectID;
	}

	public Integer getNodeID() {
		return NodeID;
	}

	public void setNodeID(Integer nodeID) {
		NodeID = nodeID;
	}

	public String getNodeName() {
		return NodeName;
	}

	public void setNodeName(String nodeName) {
		NodeName = nodeName;
	}

	public String getNodeDescription() {
		return NodeDescription;
	}

	public void setNodeDescription(String nodeDescription) {
		NodeDescription = nodeDescription;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	@Override
    public boolean equals(Object other) {
        return (other instanceof IdeTreeStructure) && (IdeMeasurableObjectID != null) && (InstitutionMeasurableObjectID != null) && (NodeMeasurableObjectID != null)
             ? (
            		 IdeMeasurableObjectID.equals(((IdeTreeStructure) other).IdeMeasurableObjectID)
            		 && InstitutionMeasurableObjectID.equals(((IdeTreeStructure) other).InstitutionMeasurableObjectID)
            		 && NodeMeasurableObjectID.equals(((IdeTreeStructure) other).NodeMeasurableObjectID)
            	)
             : (other == this);
    }

    @Override
    public int hashCode() {
        return (IdeMeasurableObjectID != null) && (InstitutionMeasurableObjectID != null) && (NodeMeasurableObjectID != null)
             ? (
            		 this.getClass().hashCode() 
            		 + IdeMeasurableObjectID.hashCode()
            		 + InstitutionMeasurableObjectID.hashCode()
            		 + NodeMeasurableObjectID.hashCode()
            	) 
             : super.hashCode();
    }
    
    @Override
    public String toString() {
        return String.format("QualityModel[%d, %d, %s, %s, %d, %d, %s, %s, %d, %d, %s, %s]",
        		IdeMeasurableObjectID, IdeID, IdeName, IdeDescription, InstitutionMeasurableObjectID, InstitutionID, InstitutionName, InstitutionDescription, NodeMeasurableObjectID, NodeID, NodeName, NodeDescription);
    }
}
