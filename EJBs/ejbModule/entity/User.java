package entity;

import java.io.Serializable;

/**
 * Modelo de Usuario.
 * Puede ser usada a travez de todas las capas, capa de datos, controlador o vista
 */
public class User implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer UserId;
    private Integer InstitutionID;
    private String InstitutionName;
    private String Email;
    private String Password;
    private Integer UserGroupID;
    private String UserGroupName;
    private String FirstName;
    private String LastName;
    private Integer PhoneNumber;


	public Integer getUserId() {
		return UserId;
	}

	public void setUserId(Integer userId) {
		UserId = userId;
	}
	
	public Integer getInstitutionID() {
		return InstitutionID;
	}

	public void setInstitutionID(Integer institutionID) {
		InstitutionID = institutionID;
	}

	public String getInstitutionName() {
		return InstitutionName;
	}

	public void setInstitutionName(String institutionName) {
		InstitutionName = institutionName;
	}

	public String getEmail() {
		return Email;
	}

	public void setEmail(String email) {
		Email = email;
	}

	public String getPassword() {
		return Password;
	}

	public void setPassword(String password) {
		Password = password;
	}

	public Integer getUserGroupID() {
		return UserGroupID;
	}

	public void setUserGroupID(Integer userGroupID) {
		UserGroupID = userGroupID;
	}

	public String getUserGroupName() {
		return UserGroupName;
	}

	public void setUserGroupName(String userGroupName) {
		UserGroupName = userGroupName;
	}

	public String getFirstName() {
		return FirstName;
	}

	public void setFirstName(String firstName) {
		FirstName = firstName;
	}

	public String getLastName() {
		return LastName;
	}

	public void setLastName(String lastName) {
		LastName = lastName;
	}

	public Integer getPhoneNumber() {
		return PhoneNumber;
	}

	public void setPhoneNumber(Integer phoneNumber) {
		PhoneNumber = phoneNumber;
	}    


	@Override
    public boolean equals(Object other) {
        return (other instanceof User) && (UserId != null)
             ? UserId.equals(((User) other).UserId)
             : (other == this);
    }


    @Override
    public int hashCode() {
        return (UserId != null) 
             ? (this.getClass().hashCode() + UserId.hashCode()) 
             : super.hashCode();
    }
    
    /**
     * Devuelve los datos de usuario en formato string
     * Usado como log para debugear
     */
    @Override
    public String toString() {
        return String.format("User[UserId=%d, InstitutionID=%d, InstitutionName=%s, Email=%s, UserGroupID=%d, UserGroupName=%s, FirstName=%s, LastName=%s, PhoneNumber=%s]",
        		UserId, InstitutionID, InstitutionName, Email, UserGroupID, UserGroupName, FirstName, LastName, PhoneNumber);
    }

}
