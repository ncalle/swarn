package service;

import java.io.Serializable;

public class WeightValue implements Serializable, Comparable<WeightValue> {
	 
	private String value;  
	private String description;     
	private String reciprocal;
	     
    public WeightValue(String value, String description, String reciprocal) {
        this.value = value;
        this.description = description;
        this.reciprocal = reciprocal;
    }
    
    public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getReciprocal() {
		return reciprocal;
	}

	public void setReciprocal(String reciprocal) {
		this.reciprocal = reciprocal;
	}

	//Eclipse Generated hashCode and equals
    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((value == null) ? 0 : value.hashCode());
        result = prime * result + ((description == null) ? 0 : description.hashCode());
        result = prime * result + ((reciprocal == null) ? 0 : reciprocal.hashCode());
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
        WeightValue other = (WeightValue) obj;
        if (value == null) {
            if (other.value != null)
                return false;
        } else if (!value.equals(other.value))
            return false;
        if (description == null) {
            if (other.description != null)
                return false;
        } else if (!description.equals(other.description))
            return false;
        if (reciprocal == null) {
            if (other.reciprocal != null)
                return false;
        } else if (!reciprocal.equals(other.reciprocal))
            return false;
        return true;
    }
 
    @Override
    public String toString() {
        return value;
    }
 
    public int compareTo(WeightValue document) {
        return this.getValue().compareTo(document.getValue());
    }
}
