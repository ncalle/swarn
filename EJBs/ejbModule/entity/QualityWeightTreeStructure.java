package entity;

import java.io.Serializable;

/**
 * Modelo que representa el Modelo de Calidad y los pesos asociados a un perfil.
 * Puede ser usada a travez de todas las capas, capa de datos, controlador o vista
 */
public class QualityWeightTreeStructure implements Serializable {

    private static final long serialVersionUID = 1L;
    
    private Integer WeighingID;
    private Integer ProfileID;
    private Integer ElementID; //QualityModelID, DimensionID, FactorID, MetricID, MetricRangeID
    private String ElementName;
    private String ElementType; //'Q' = QualityModel, 'D' = Dimension, 'F' = Factor, 'M' = Metrica, 'R' = Rango
    private Integer NumeratorValue;
    private Integer DenominatorValue;
    private Integer FatherElementyID;
    
	public Integer getWeighingID() {
		return WeighingID;
	}

	public void setWeighingID(Integer weighingID) {
		WeighingID = weighingID;
	}

	public Integer getProfileID() {
		return ProfileID;
	}

	public void setProfileID(Integer profileID) {
		ProfileID = profileID;
	}

	public Integer getElementID() {
		return ElementID;
	}

	public void setElementID(Integer elementID) {
		ElementID = elementID;
	}
	
	public String getElementName() {
		return ElementName;
	}

	public void setElementName(String elementName) {
		ElementName = elementName;
	}

	public String getElementType() {
		return ElementType;
	}

	public void setElementType(String elementType) {
		ElementType = elementType;
	}

	public Integer getNumeratorValue() {
		return NumeratorValue;
	}

	public void setNumeratorValue(Integer numeratorValue) {
		NumeratorValue = numeratorValue;
	}

	public Integer getDenominatorValue() {
		return DenominatorValue;
	}

	public void setDenominatorValue(Integer denominatorValue) {
		DenominatorValue = denominatorValue;
	}

	public Integer getFatherElementyID() {
		return FatherElementyID;
	}

	public void setFatherElementyID(Integer fatherElementyID) {
		FatherElementyID = fatherElementyID;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}    
	
	@Override
    public boolean equals(Object other) {
        return (other instanceof QualityWeightTreeStructure) && (WeighingID != null)
             ? (
            		 WeighingID.equals(((QualityWeightTreeStructure) other).WeighingID)
            	)
             : (other == this);
    }

    @Override
    public int hashCode() {
        return (WeighingID != null)
             ? (
            		 this.getClass().hashCode() 
            		 + WeighingID.hashCode()
            	) 
             : super.hashCode();
    }
    
    @Override
    public String toString() {
        return String.format("QualityModel[%d, %d, %d, %s, %s, %d, %d, %d]",
        		WeighingID, ProfileID, ElementID, ElementName, ElementType, NumeratorValue, DenominatorValue, FatherElementyID);
    }
}
