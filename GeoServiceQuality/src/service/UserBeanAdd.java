package service;

import java.util.List;

import javax.annotation.PostConstruct;
import javax.ejb.EJB;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.RequestScoped;
import javax.faces.context.FacesContext;

import org.primefaces.context.RequestContext;

import entity.Institution;
import entity.User;
import entity.UserGroup;
import dao.UserBeanRemote;
import dao.UserGroupBean;
import dao.UserGroupBeanRemote;
import dao.UserBean;
import dao.DAOException;
import dao.InstitutionBean;
import dao.InstitutionBeanRemote;


@ManagedBean(name="userBeanAdd")
@RequestScoped
public class UserBeanAdd {
	
    private String email;
    private String password;
    private Integer userGroupID;
    private String firstName;
    private String lastName;
    private Integer phoneNumber;
    private Integer institutionID;
    
	private List<UserGroup> listUserGroups;
	private UserGroup userGroup;
	private List<Institution> listInstitutions;
	private Institution institution;
    
	@EJB
    private UserBeanRemote uDao = new UserBean();
	private UserGroupBeanRemote ugDao = new UserGroupBean();
	private InstitutionBeanRemote insDao = new InstitutionBean();
	
	@PostConstruct
	private void init()	{
        listUserGroups = ugDao.list();
        System.out.println("user group list size: "+ listUserGroups.size());
        
        listInstitutions = insDao.list();
        System.out.println("Institution list size: "+ listInstitutions.size());
	}	
  
	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public Integer getUserGroupID() {
		return userGroupID;
	}

	public void setUserGroupID(Integer userGroupID) {
		this.userGroupID = userGroupID;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public Integer getPhoneNumber() {
		return phoneNumber;
	}

	public void setPhoneNumber(Integer phoneNumber) {
		this.phoneNumber = phoneNumber;
	}

	public Integer getInstitutionID() {
		return institutionID;
	}

	public void setInstitutionID(Integer institutionID) {
		this.institutionID = institutionID;
	}
	
	public List<UserGroup> getListUserGroups() {
		return listUserGroups;
	}

	public void setListUserGroups(List<UserGroup> listUserGroups) {
		this.listUserGroups = listUserGroups;
	}

	public UserGroup getUserGroup() {
		return userGroup;
	}

	public void setUserGroup(UserGroup userGroup) {
		this.userGroup = userGroup;
	}

	public List<Institution> getListInstitutions() {
		return listInstitutions;
	}

	public void setListInstitutions(List<Institution> listInstitutions) {
		this.listInstitutions = listInstitutions;
	}

	public Institution getInstitution() {
		return institution;
	}

	public void setInstitution(Institution institution) {
		this.institution = institution;
	}	
		
	public void save() {
    	
		User user = new User();
		FacesMessage msg;
		
		if (userGroup != null){
			user.setUserGroupID(userGroup.getUserGroupID());
			user.setUserGroupName(userGroup.getName());			
		}

		if (institution != null){
			user.setInstitutionID(institution.getInstitutionID());
			user.setInstitutionName(institution.getName());			
		}
		
        user.setEmail(email);
        user.setPassword(password);
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setPhoneNumber(phoneNumber);
        
    	System.out.println("save.. " + user);
    	
    	try{
    		uDao.create(user);
    		msg = new FacesMessage("El usuario fue guardado correctamente.");
            FacesContext.getCurrentInstance().addMessage(null, msg);
    	} catch(DAOException e) {   		
    		msg = new FacesMessage("Error al guardar el usuario.");
            FacesContext.getCurrentInstance().addMessage(null, msg);
    	}
	}
	
}
