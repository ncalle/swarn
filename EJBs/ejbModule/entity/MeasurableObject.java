package entity;

import java.io.Serializable;

/**
 * Modelo de Objetos medibles. 
 * Puede ser usada a travez de todas las capas, capa de datos, controlador o vista
 */
public class MeasurableObject implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer MeasurableObjectID;
    private Integer EntityID;
    private String EntityType;
    private Integer FatherEntityID;
    private String FatherEntityType;
    private String MeasurableObjectName;
    private String MeasurableObjectDescription;
    private String MeasurableObjectURL;
    private String MeasurableObjectServicesType;

	
    public Integer getMeasurableObjectID() {
		return MeasurableObjectID;
	}


	public void setMeasurableObjectID(Integer measurableObjectID) {
		MeasurableObjectID = measurableObjectID;
	}

	public Integer getEntityID() {
		return EntityID;
	}


	public void setEntityID(Integer entityID) {
		EntityID = entityID;
	}


	public String getEntityType() {
		return EntityType;
	}


	public void setEntityType(String entityType) {
		EntityType = entityType;
	}
	
	public Integer getFatherEntityID() {
		return FatherEntityID;
	}


	public void setFatherEntityID(Integer fatherEntityID) {
		FatherEntityID = fatherEntityID;
	}


	public String getFatherEntityType() {
		return FatherEntityType;
	}


	public void setFatherEntityType(String fatherEntityType) {
		FatherEntityType = fatherEntityType;
	}


	public String getMeasurableObjectName() {
		return MeasurableObjectName;
	}


	public void setMeasurableObjectName(String measurableObjectName) {
		MeasurableObjectName = measurableObjectName;
	}


	public String getMeasurableObjectDescription() {
		return MeasurableObjectDescription;
	}


	public void setMeasurableObjectDescription(String measurableObjectDescription) {
		MeasurableObjectDescription = measurableObjectDescription;
	}


	public String getMeasurableObjectURL() {
		return MeasurableObjectURL;
	}


	public void setMeasurableObjectURL(String measurableObjectURL) {
		MeasurableObjectURL = measurableObjectURL;
	}


	public String getMeasurableObjectServicesType() {
		return MeasurableObjectServicesType;
	}


	public void setMeasurableObjectServicesType(String measurableObjectServicesType) {
		MeasurableObjectServicesType = measurableObjectServicesType;
	}


	@Override
    public boolean equals(Object other) {
        return (other instanceof MeasurableObject) && (getMeasurableObjectID() != null)
             ? (
            		 getMeasurableObjectID().equals(((MeasurableObject) other).getMeasurableObjectID())
            	)
             : (other == this);
    }


    @Override
    public int hashCode() {
        return (getMeasurableObjectID() != null) 
             ? (this.getClass().hashCode() + getMeasurableObjectID().hashCode()) 
             : super.hashCode();
    }
    
    /**
     * Devuelve los datos de objetos medibles en formato string
     * Usado como log para debugear
     */
    @Override
    public String toString() {
        return String.format("MeasurableObject[MeasurableObjectID=%d, EntityID=%d, EntitytType=%s, FatherEntityID=%d, FatherEntitytType=%s, MeasurableObjectName=%s, MeasurableObjectDescription=%s, MeasurableObjectURL=%s, MeasurableObjectServicesType=%s]",
        		getMeasurableObjectID(), getEntityID(), getEntityType(), getFatherEntityID(), getFatherEntityType(), getMeasurableObjectName(), getMeasurableObjectDescription(), getMeasurableObjectURL(), getMeasurableObjectServicesType());
    }
}
