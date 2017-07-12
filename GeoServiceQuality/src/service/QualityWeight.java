package service;

import java.io.Serializable;

public class QualityWeight implements Serializable, Comparable<QualityWeight> {
	 
	private Integer weighingID;
	private String name;  
	private String weight;     
	private String type;
	     
    public QualityWeight(Integer weighingID, String name, String weight, String type) {
        this.weighingID = weighingID;
    	this.name = name;
        this.weight = weight;
        this.type = type;
    }
 
	public Integer getWeighingID() {
		return weighingID;
	}

	public void setWeighingID(Integer weighingID) {
		this.weighingID = weighingID;
	}
	
    public String getName() {
        return name;
    }
 
    public void setName(String name) {
        this.name = name;
    }
 
    public String getWeight() {
        return weight;
    }
 
    public void setWeight(String weight) {
        this.weight = weight;
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
        result = prime * result + ((weighingID == null) ? 0 : weighingID.hashCode());
        result = prime * result + ((name == null) ? 0 : name.hashCode());
        result = prime * result + ((weight == null) ? 0 : weight.hashCode());
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
        QualityWeight other = (QualityWeight) obj;
        if (weighingID == null) {
            if (other.weighingID != null)
                return false;
        } else if (!weighingID.equals(other.weighingID))
            return false;
        if (name == null) {
            if (other.name != null)
                return false;
        } else if (!name.equals(other.name))
            return false;
        if (weight == null) {
            if (other.weight != null)
                return false;
        } else if (!weight.equals(other.weight))
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
 
    public int compareTo(QualityWeight document) {
        return this.getName().compareTo(document.getName());
    }
}
