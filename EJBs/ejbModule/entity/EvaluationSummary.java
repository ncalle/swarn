package entity;

import java.io.Serializable;


public class EvaluationSummary implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer EvaluationSummaryID;
    private Integer UserID;
    private Integer ProfileID;
    private String ProfileName;
    private Integer MeasurableObjectID;
    private Integer EntityID;
    private String EntityType;
    private String MeasurableObjectName;
    private String MeasurableObjectDescription;
    private Boolean Success;
    private Integer SuccessPercentage;


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
	
	public String getMeasurableObjectDescription() {
		return MeasurableObjectDescription;
	}


	public void setMeasurableObjectDescription(String measurableObjectDescription) {
		MeasurableObjectDescription = measurableObjectDescription;
	}

	
	public static long getSerialversionuid() {
		return serialVersionUID;
	}

		
	public void setSuccess(Boolean success) {
		Success = success;
	}
	
	public Boolean getSuccess() {
		return Success;
	}	


	public Integer getSuccessPercentage() {
		return SuccessPercentage;
	}


	public void setSuccessPercentage(Integer successPercentage) {
		SuccessPercentage = successPercentage;
	}
	

	@Override
    public boolean equals(Object other) {
        return (other instanceof EvaluationSummary) && (getEvaluationSummaryID() != null)
             ? (
            		 getEvaluationSummaryID().equals(((EvaluationSummary) other).getEvaluationSummaryID())
            	)
             : (other == this);
    }


    @Override
    public int hashCode() {
        return (getEvaluationSummaryID() != null) 
             ? (this.getClass().hashCode() + getEvaluationSummaryID().hashCode()) 
             : super.hashCode();
    }
    

    @Override
    public String toString() {
        return String.format("EvaluationSummaryID[EvaluationSummaryID=%d, UserID=%d, ProfileID=%d, ProfileName=%s, MeasurableObjectID=%d, EntityID=%d, EntityType=%s, MeasurableObjectName=%s, MeasurableObjectDescription=%s, Success=%s, SuccessPercentage=%d]",
        		getEvaluationSummaryID(), getUserID(), getProfileID(), getProfileName(), getMeasurableObjectID(), getEntityID(), getEntityType(), getMeasurableObjectName(), getMeasurableObjectDescription(), getSuccess(), getSuccessPercentage());
    }
}
