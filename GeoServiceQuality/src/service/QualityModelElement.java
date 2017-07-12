package service;

import java.io.Serializable;

public class QualityModelElement implements Serializable, Comparable<QualityModelElement> {
	 
	private Integer elementID;
	private String name;  
	private Boolean aggregationFlag;     
	private String granularity;
	private String unit;
	private String type;
	     
    public QualityModelElement(Integer elementID, String name, Boolean aggregationFlag, String granularity, String unit, String type) {
        this.elementID = elementID;
    	this.name = name;
    	this.aggregationFlag = aggregationFlag;
        this.granularity = granularity;
        this.unit = unit;
        this.type = type;
    }    
 
    public Integer getElementID() {
		return elementID;
	}

	public void setElementID(Integer elementID) {
		this.elementID = elementID;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Boolean getAggregationFlag() {
		return aggregationFlag;
	}

	public void setAggregationFlag(Boolean aggregationFlag) {
		this.aggregationFlag = aggregationFlag;
	}

	public String getGranularity() {
		return granularity;
	}

	public void setGranularity(String granularity) {
		this.granularity = granularity;
	}

	public String getUnit() {
		return unit;
	}

	public void setUnit(String unit) {
		this.unit = unit;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	//Eclipse Generated hashCode and equals
    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((elementID == null) ? 0 : elementID.hashCode());
        result = prime * result + ((name == null) ? 0 : name.hashCode());
        result = prime * result + ((aggregationFlag == null) ? 0 : aggregationFlag.hashCode());
        result = prime * result + ((granularity == null) ? 0 : granularity.hashCode());
        result = prime * result + ((unit == null) ? 0 : unit.hashCode());
        result = prime * result + ((type == null) ? 0 : type.hashCode());
        return result;
    }
 
    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        QualityModelElement other = (QualityModelElement) obj;
        if (elementID == null) {
            if (other.elementID != null)
                return false;
        } else if (!elementID.equals(other.elementID))
            return false;
        if (name == null) {
            if (other.name != null)
                return false;
        } else if (!name.equals(other.name))
            return false;
        if (aggregationFlag == null) {
            if (other.aggregationFlag != null)
                return false;
        } else if (!aggregationFlag.equals(other.aggregationFlag))
            return false;
        if (granularity == null) {
            if (other.granularity != null)
                return false;
        } else if (!granularity.equals(other.granularity))
            return false;
        if (unit == null) {
            if (other.unit != null)
                return false;
        } else if (!unit.equals(other.unit))
            return false;
        if (type == null) {
            if (other.type != null)
                return false;
        } else if (!type.equals(other.type))
            return false;
        return true;
    }
 
    @Override
    public String toString() {
        return name;
    }
 
    public int compareTo(QualityModelElement document) {
        return this.getName().compareTo(document.getName());
    }
}
