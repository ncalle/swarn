package entity;

import java.io.Serializable;

/**
 * Modelo de Grupos de Usuario.
 * Puede ser usada a travez de todas las capas, capa de datos, controlador o vista
 */
public class Institution implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer InstitutionID;
    private String Name;

	
    public Integer getInstitutionID() {
		return InstitutionID;
	}

	public void setInstitutionID(Integer institutionID) {
		InstitutionID = institutionID;
	}
    
    public String getName() {
		return Name;
	}


	public void setName(String name) {
		Name = name;
	}

	@Override
    public boolean equals(Object other) {
        return (other instanceof Institution) && (InstitutionID != null)
             ? InstitutionID.equals(((Institution) other).InstitutionID)
             : (other == this);
    }

    @Override
    public int hashCode() {
        return (InstitutionID != null) 
             ? (this.getClass().hashCode() + InstitutionID.hashCode()) 
             : super.hashCode();
    }
    
    @Override
    public String toString() {
        return String.format("Institution[%d, %s]", InstitutionID, Name);
    }

}
