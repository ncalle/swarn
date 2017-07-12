package entity;

import java.io.Serializable;

/**
 * Modelo que representa el Modelo de Calidad.
 * Puede ser usada a travez de todas las capas, capa de datos, controlador o vista
 */
public class QualityModelTreeStructure implements Serializable {

    private static final long serialVersionUID = 1L;
    
    private Integer ElementID; //QualityModelID, DimensionID, FactorID, MetricID
    private String ElementName;
    private String ElementType; //'Q' = QualityModel, 'D' = Dimension, 'F' = Factor, 'M' = Metrica
    private Integer FatherElementyID;
    private Boolean AggregationFlag;     
	private String Granularity;
	private String Unit;
	private Boolean IsUserMetric;
	private String MetricFileName;

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

	public Integer getFatherElementyID() {
		return FatherElementyID;
	}

	public void setFatherElementyID(Integer fatherElementyID) {
		FatherElementyID = fatherElementyID;
	}
	
	public Boolean getAggregationFlag() {
		return AggregationFlag;
	}

	public void setAggregationFlag(Boolean aggregationFlag) {
		AggregationFlag = aggregationFlag;
	}

	public String getGranularity() {
		return Granularity;
	}

	public void setGranularity(String granularity) {
		Granularity = granularity;
	}

	public String getUnit() {
		return Unit;
	}

	public void setUnit(String unit) {
		Unit = unit;
	}

	public Boolean getIsUserMetric() {
		return IsUserMetric;
	}

	public void setIsUserMetric(Boolean isUserMetric) {
		IsUserMetric = isUserMetric;
	}

	public String getMetricFileName() {
		return MetricFileName;
	}

	public void setMetricFileName(String metricFileName) {
		MetricFileName = metricFileName;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}    
	
	@Override
    public boolean equals(Object other) {
        return (other instanceof QualityModelTreeStructure) && (ElementID != null) && (ElementType != null)
             ? (
            		 ElementID.equals(((QualityModelTreeStructure) other).ElementID)
            		 && ElementType.equals(((QualityModelTreeStructure) other).ElementType)
            	)
             : (other == this);
    }

    @Override
    public int hashCode() {
        return (ElementID != null) && (ElementType != null)
             ? (
            		 this.getClass().hashCode() 
            		 + ElementID.hashCode()
            		 + ElementType.hashCode()
            	) 
             : super.hashCode();
    }
    
    @Override
    public String toString() {
        return String.format("QualityModel[%d, %s, %s, %d, %s, %s, %s, %s, %s]",
        		ElementID, ElementName, ElementType, FatherElementyID, AggregationFlag, Granularity, Unit, IsUserMetric, MetricFileName);
    }
}
