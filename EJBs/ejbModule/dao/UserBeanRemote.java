package dao;

import java.util.List;
import javax.ejb.Remote;

import entity.MeasurableObject;
import entity.User;

@Remote
public interface UserBeanRemote {

	public User find(String email, String password) throws DAOException;
	
    public User find(Integer usuarioid) throws DAOException;

    public List<User> list() throws DAOException;

    public void create(User user) throws IllegalArgumentException, DAOException;

    public void update(User user) throws DAOException;
    
    public void delete(User user) throws DAOException;
    
    public void removeUserMeasurableObject(User user, MeasurableObject measurableObject) throws DAOException;
    
    public void userAddMeasurableObject(Integer userID, MeasurableObject measurableobject) throws DAOException;
}