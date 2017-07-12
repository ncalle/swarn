package entity;

import java.io.Serializable;

/**
 * Modelo de Grupos de Usuario.
 * Puede ser usada a travez de todas las capas, capa de datos, controlador o vista
 */
public class UserGroup implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer UserGroupID;
    private String Name;

	
    public Integer getUserGroupID() {
		return UserGroupID;
	}

	public void setUserGroupID(Integer userGroupID) {
		UserGroupID = userGroupID;
	}
    
    public String getName() {
		return Name;
	}


	public void setName(String name) {
		Name = name;
	}

	@Override
    public boolean equals(Object other) {
        return (other instanceof UserGroup) && (UserGroupID != null)
             ? UserGroupID.equals(((UserGroup) other).UserGroupID)
             : (other == this);
    }

    @Override
    public int hashCode() {
        return (UserGroupID != null) 
             ? (this.getClass().hashCode() + UserGroupID.hashCode()) 
             : super.hashCode();
    }
    
    @Override
    public String toString() {
        return String.format("UserGroup[%d, %s]", UserGroupID, Name);
    }

}
