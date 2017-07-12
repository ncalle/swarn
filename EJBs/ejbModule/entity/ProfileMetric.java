package entity;

import java.io.Serializable;

/**
 * Modelo que representa el Modelo de Calidad.
 * Puede ser usada a travez de todas las capas, capa de datos, controlador o vista
 */
public class ProfileMetric implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer QualityModelID;
    private String QualityModelName;
    private Integer DimensionID;
    private String DimensionName;
    private Integer FactorID;
    private String FactorName;
    private Integer MetricID;
    private String MetricName;
    private Boolean MetricAgrgegationFlag;
    private String MetricGranurality;
    private String MetricDescription;
    private Boolean MetricManual;
    private Boolean IsUserMetric;
    private String MetricFileName;
	private Integer UnitID;
    private String UnitName;
    private String UnitDescription;

	private Integer MetricRangeID;
	private Boolean BooleanFlag;
	private Boolean BooleanAcceptanceValue;
	private Boolean PercentageFlag;
	private Integer PercentageAcceptanceValue;
	private Boolean IntegerFlag;
	private Integer IntegerAcceptanceValue;
	private Boolean EnumerateFlag;
	private String EnumerateAcceptanceValue;
    
	
	public Integer getQualityModelID() {
		return QualityModelID;
	}

	public void setQualityModelID(Integer qualityModelID) {
		QualityModelID = qualityModelID;
	}

	public String getQualityModelName() {
		return QualityModelName;
	}

	public void setQualityModelName(String qualityModelName) {
		QualityModelName = qualityModelName;
	}

	public Integer getDimensionID() {
		return DimensionID;
	}

	public void setDimensionID(Integer dimensionID) {
		DimensionID = dimensionID;
	}

	public String getDimensionName() {
		return DimensionName;
	}

	public void setDimensionName(String dimensionName) {
		DimensionName = dimensionName;
	}

	public Integer getFactorID() {
		return FactorID;
	}

	public void setFactorID(Integer factorID) {
		FactorID = factorID;
	}

	public String getFactorName() {
		return FactorName;
	}

	public void setFactorName(String factorName) {
		FactorName = factorName;
	}

	public Integer getMetricID() {
		return MetricID;
	}

	public void setMetricID(Integer metricID) {
		MetricID = metricID;
	}

	public String getMetricName() {
		return MetricName;
	}

	public void setMetricName(String metricName) {
		MetricName = metricName;
	}

	public Boolean getMetricAgrgegationFlag() {
		return MetricAgrgegationFlag;
	}

	public void setMetricAgrgegationFlag(Boolean metricAgrgegationFlag) {
		MetricAgrgegationFlag = metricAgrgegationFlag;
	}

	public String getMetricGranurality() {
		return MetricGranurality;
	}

	public void setMetricGranurality(String metricGranurality) {
		MetricGranurality = metricGranurality;
	}

	public String getMetricDescription() {
		return MetricDescription;
	}

	public void setMetricDescription(String metricDescription) {
		MetricDescription = metricDescription;
	}

	public Integer getUnitID() {
		return UnitID;
	}

	public void setUnitID(Integer unitID) {
		UnitID = unitID;
	}

	public String getUnitName() {
		return UnitName;
	}

	public void setUnitName(String unitName) {
		UnitName = unitName;
	}

	public String getUnitDescription() {
		return UnitDescription;
	}

	public void setUnitDescription(String unitDescription) {
		UnitDescription = unitDescription;
	}
	
	public Integer getMetricRangeID() {
		return MetricRangeID;
	}

	public void setMetricRangeID(Integer metricRangeID) {
		MetricRangeID = metricRangeID;
	}

	public Boolean getBooleanFlag() {
		return BooleanFlag;
	}

	public void setBooleanFlag(Boolean booleanFlag) {
		BooleanFlag = booleanFlag;
	}

	public Boolean getBooleanAcceptanceValue() {
		return BooleanAcceptanceValue;
	}

	public void setBooleanAcceptanceValue(Boolean booleanAcceptanceValue) {
		BooleanAcceptanceValue = booleanAcceptanceValue;
	}

	public Boolean getPercentageFlag() {
		return PercentageFlag;
	}

	public void setPercentageFlag(Boolean percentageFlag) {
		PercentageFlag = percentageFlag;
	}

	public Integer getPercentageAcceptanceValue() {
		return PercentageAcceptanceValue;
	}

	public void setPercentageAcceptanceValue(Integer percentageAcceptanceValue) {
		PercentageAcceptanceValue = percentageAcceptanceValue;
	}

	public Boolean getIntegerFlag() {
		return IntegerFlag;
	}

	public void setIntegerFlag(Boolean integerFlag) {
		IntegerFlag = integerFlag;
	}

	public Integer getIntegerAcceptanceValue() {
		return IntegerAcceptanceValue;
	}

	public void setIntegerAcceptanceValue(Integer integerAcceptanceValue) {
		IntegerAcceptanceValue = integerAcceptanceValue;
	}

	public Boolean getEnumerateFlag() {
		return EnumerateFlag;
	}

	public void setEnumerateFlag(Boolean enumerateFlag) {
		EnumerateFlag = enumerateFlag;
	}

	public String getEnumerateAcceptanceValue() {
		return EnumerateAcceptanceValue;
	}

	public void setEnumerateAcceptanceValue(String enumerateAcceptanceValue) {
		EnumerateAcceptanceValue = enumerateAcceptanceValue;
	}
	
	public Boolean getMetricManual() {
		return MetricManual;
	}
	
	public void setMetricManual(Boolean metricManual) {
		MetricManual = metricManual;
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
	
	@Override
    public boolean equals(Object other) {
        return (other instanceof ProfileMetric) && (QualityModelID != null) && (DimensionID != null) && (FactorID != null) && (MetricID != null) && (MetricRangeID != null)
             ? (
            		 QualityModelID.equals(((ProfileMetric) other).QualityModelID)
            		 && DimensionID.equals(((ProfileMetric) other).DimensionID)
            		 && FactorID.equals(((ProfileMetric) other).FactorID)
            		 && MetricID.equals(((ProfileMetric) other).MetricID)
            		 && MetricRangeID.equals(((ProfileMetric) other).MetricRangeID)
            	)
             : (other == this);
    }

    @Override
    public int hashCode() {
        return (MetricRangeID != null) 
             ? (
            		 this.getClass().hashCode() 
            		 + QualityModelID.hashCode()
            		 + DimensionID.hashCode()
            		 + FactorID.hashCode()
            		 + MetricID.hashCode()
            		 + MetricRangeID.hashCode()
            	) 
             : super.hashCode();
    }
    
    @Override
    public String toString() {
        return String.format("ProfileMetric[%d, %s, %d, %s, %d, %s, %d, %s, %s, %s, %s, %d, %s, %s, %s, %s, %s, %s, %s, %s, %d, %s, %d, %s, %s, %s]",
        		QualityModelID, QualityModelName, DimensionID, DimensionName, FactorID, FactorName, MetricID, MetricName, MetricAgrgegationFlag, MetricGranurality, MetricDescription, IsUserMetric, MetricFileName, UnitID, UnitName, UnitDescription, 
        		MetricRangeID, BooleanFlag, BooleanAcceptanceValue, PercentageFlag, PercentageAcceptanceValue, IntegerFlag, IntegerAcceptanceValue, EnumerateFlag, EnumerateAcceptanceValue, MetricManual);
    }
}
