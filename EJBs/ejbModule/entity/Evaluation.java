package entity;

import java.io.Serializable;
import java.sql.Date;


public class Evaluation implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer EvaluationID;
    private Integer EvaluationSummaryID;
    private Integer UserID;
    private Integer ProfileID;
    private String ProfileName;
    private Integer MeasurableObjectID;
    private Integer EntityID;
    private String EntityType;
    private String MeasurableObjectName;
    private Integer QualityModelID;
    private String QualityModelName;
    private Integer MetricID;
    private String MetricName;
    private Date StartDate;
    private Date EndDate; 
    private Boolean IsEvaluationCompleted;
    private Boolean Success;
    private Integer EvaluationCount;
    private Integer EvaluationApprovedValue;
    private Double QualityIndex;

    
    public Integer getEvaluationApprovedValue() {
		return EvaluationApprovedValue;
	}
    
    public void setEvaluationApprovedValue(Integer evaluationApprovedValue) {
		EvaluationApprovedValue = evaluationApprovedValue;
	}
    
    public Integer getEvaluationCount() {
		return EvaluationCount;
	}
    
    public void setEvaluationCount(Integer evaluationCount) {
		EvaluationCount = evaluationCount;
	}

	public Integer getEvaluationID() {
		return EvaluationID;
	}


	public void setEvaluationID(Integer evaluationID) {
		EvaluationID = evaluationID;
	}

	
	public Integer getEvaluationSummaryID() {
		return EvaluationSummaryID;
	}


	public void setEvaluationSummaryID(Integer evaluationSummaryID) {
		EvaluationSummaryID = evaluationSummaryID;
	}
	

	public Integer getUserID() {
		return UserID;
	}


	public void setUserID(Integer userID) {
		UserID = userID;
	}


	public Integer getProfileID() {
		return ProfileID;
	}


	public void setProfileID(Integer profileID) {
		ProfileID = profileID;
	}
	
	public String getProfileName() {
		return ProfileName;
	}


	public void setProfileName(String profileName) {
		ProfileName = profileName;
	}
	
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


	public String getMeasurableObjectName() {
		return MeasurableObjectName;
	}


	public void setMeasurableObjectName(String measurableObjectName) {
		MeasurableObjectName = measurableObjectName;
	}


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
	

	public Date getStartDate() {
		return StartDate;
	}


	public void setStartDate(Date startDate) {
		StartDate = startDate;
	}


	public Date getEndDate() {
		return EndDate;
	}


	public void setEndDate(Date endDate) {
		EndDate = endDate;
	}


	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	
	public void setIsEvaluationCompleted(Boolean isEvaluationCompleted) {
		IsEvaluationCompleted = isEvaluationCompleted;
	}
	
	public Boolean getIsEvaluationCompleted() {
		return IsEvaluationCompleted;
	}
	
	public void setSuccess(Boolean success) {
		Success = success;
	}
	
	public Boolean getSuccess() {
		return Success;
	}
	
	public Double getQualityIndex() {
		return QualityIndex;
	}
	
	public void setQualityIndex(Double qualityIndex) {
		QualityIndex = qualityIndex;
	}

	@Override
    public boolean equals(Object other) {
        return (other instanceof Evaluation) && (getEvaluationID() != null)
             ? (
            		 getEvaluationID().equals(((Evaluation) other).getEvaluationID())
            	)
             : (other == this);
    }


    @Override
    public int hashCode() {
        return (getEvaluationID() != null) 
             ? (this.getClass().hashCode() + getEvaluationID().hashCode()) 
             : super.hashCode();
    }
    

    @Override
    public String toString() {
        return String.format("Evaluation[EvaluationID=%d, EvaluationSummaryID=%d, UserID=%d, ProfileID=%d, ProfileName=%s, MeasurableObjectID=%d, EntityID=%d, EntityType=%s, MeasurableObjectName=%s, "
        		+ "QualityModelID=%d, QualityModelName=%s, MetricID=%d, MetricName=%s, StartDate=%s, EndDate=%s, IsEvaluationCompleted=%s, Success=%s]",
        		getEvaluationID(), getEvaluationSummaryID(), getUserID(), getProfileID(), getProfileName(), getMeasurableObjectID(), getEntityID(), getEntityType(), getMeasurableObjectName(), 
        		getQualityModelID(), getQualityModelName(), getMetricID(), getMetricName(), getStartDate(), getEndDate(), getIsEvaluationCompleted(), getSuccess());
    }
}
