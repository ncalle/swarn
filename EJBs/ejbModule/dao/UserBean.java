package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.ejb.LocalBean;
import javax.ejb.Stateless;

import entity.MeasurableObject;
import entity.User;

/**
 * Session Bean implementation class UserBean
 */
@Stateless
@LocalBean
public class UserBean implements UserBeanRemote {

    private static final String SQL_FIND_BY_EMAIL_AND_PASSWORD =
        	"SELECT UserID, InstitutionID, InstitutionName, Email, UserGroupID, UserGroupName, FirstName, LastName, PhoneNumber FROM user_get (?, ?, ?)";
    private static final String SQL_FIND_BY_ID =
            "SELECT UserID, InstitutionID, InstitutionName, Email, UserGroupID, UserGroupName, FirstName, LastName, PhoneNumber FROM user_get (?, ?, ?)";
    private static final String SQL_LIST_ORDER_BY_ID =
    		"SELECT UserID, InstitutionID, InstitutionName, Email, UserGroupID, UserGroupName, FirstName, LastName, PhoneNumber FROM user_get (?, ?, ?)";
	private static final String SQL_INSERT =
            "SELECT * FROM user_insert (?, ?, ?, ?, ?, ?, ?)";
	private static final String SQL_UPDATE =
        	"SELECT * FROM user_update (?, ?, ?, ?, ?, ?, ?)";
	private static final String SQL_DELETE =
        	"SELECT * FROM user_delete (?)";
	private static final String SQL_USER_REMOVE_MEASURABLE_OBJECT =
        	"SELECT * FROM prototype_user_remove_measurable_object (?, ?)";
    private static final String SQL_USER_ADD_MEASURABLE_OBJECT =
        	"SELECT * FROM prototype_user_add_measurable_object(?, ?)";	
    //private static final String SQL_CHANGE_PASSWORD =
            //"UPDATE SystemUser SET Password = MD5(?) WHERE UserID = ?";
    
    private DAOFactory daoFactory;

    UserBean(DAOFactory daoFactory) {
        this.daoFactory = daoFactory;
    }
    
    public UserBean() {
		// Obtener DAOFactory
    	daoFactory = DAOFactory.getInstance("geoservicequality.jdbc");
    }

    //@Override
    public User find(String email, String password) throws DAOException {           	
    	User user = null;
    	
        Connection connection = null;
		PreparedStatement statement = null;
		ResultSet resultSet = null;
		
		try {			
			connection = daoFactory.getConnection();					
			statement = connection.prepareStatement(SQL_FIND_BY_EMAIL_AND_PASSWORD);
			
			statement.setObject(1, null); //userID
			statement.setString(2, email);
			statement.setString(3, password);
			
			resultSet = statement.executeQuery();
			
			if (resultSet.next()) {
                user = map(resultSet);
            }
			
            connection.close();
            
		} catch (SQLException e) {
			throw new DAOException(e);
		}
		
    	return user;        
    }
    
 
    @Override
    public User find(Integer userID) throws DAOException {
        User user = null;
        
        Connection connection = null;
		PreparedStatement statement = null;
		ResultSet resultSet = null;
		
		try {
			connection = daoFactory.getConnection();
			statement = connection.prepareStatement(SQL_FIND_BY_ID);

			statement.setInt(1, userID); 
			statement.setObject(2, null); //email
			statement.setObject(3, null); //password

			resultSet = statement.executeQuery();
			
			if (resultSet.next()) {
                user = map(resultSet);
            }
			
            connection.close();
            
		} catch (SQLException e) {
			throw new DAOException(e);
		}
		
    	return user;
    }
    
    
    @Override
    public List<User> list() throws DAOException {
        List<User> users = new ArrayList<>();

        Connection connection = null;
		PreparedStatement statement = null;
		ResultSet resultSet = null;
        
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_LIST_ORDER_BY_ID);
            
			statement.setObject(1, null); //userID
			statement.setObject(2, null); //email
			statement.setObject(3, null); //password
			
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                users.add(map(resultSet));
            }
            
            connection.close();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }

        return users;
    }

    
    @Override
    public void create(User user) throws IllegalArgumentException, DAOException {
        if (user.getUserId() != null) {
            throw new IllegalArgumentException("El usuario ya existe. Error.");
        }

        Connection connection = null;
		PreparedStatement statement = null;
        
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_INSERT);

            statement.setString(1, user.getEmail());
			statement.setString(2, user.getPassword());
			statement.setInt(3, user.getUserGroupID());
			statement.setString(4, user.getFirstName());
			statement.setString(5, user.getLastName());
			statement.setInt(6, user.getPhoneNumber());
			statement.setInt(7, user.getInstitutionID());

            statement.executeQuery();
            
            connection.close();

        } catch (SQLException e) {
            throw new DAOException(e);
        }        
    }

    @Override
    public void update(User user) throws DAOException {

    	Connection connection = null;
		PreparedStatement statement = null;
        
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_UPDATE);

            statement.setInt(1, user.getUserId());
            statement.setString(2, user.getEmail());
            statement.setInt(3, user.getUserGroupID());
            statement.setString(4, user.getFirstName());
            statement.setString(5, user.getLastName());
            statement.setInt(6, user.getPhoneNumber());
            statement.setInt(7, user.getInstitutionID());            
        
            statement.executeQuery();
            
            connection.close();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }
    }
    
    @Override
    public void delete(User user) throws DAOException {

    	Connection connection = null;
		PreparedStatement statement = null;
        
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_DELETE);

            statement.setInt(1, user.getUserId());
        
            statement.executeQuery();

            user.setUserId(null);
            
            connection.close();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }
    }
    
    @Override
    public void removeUserMeasurableObject(User user, MeasurableObject measurableObject) throws DAOException {
		Connection connection = null;
		PreparedStatement statement = null;
	    
		    try {
		        connection = daoFactory.getConnection();
		        statement = connection.prepareStatement(SQL_USER_REMOVE_MEASURABLE_OBJECT);
		
		        statement.setInt(1, user.getUserId());
		        statement.setInt(2, measurableObject.getMeasurableObjectID());
		    
		        statement.executeQuery();
		        
	            connection.close();
	            
		    } catch (SQLException e) {
		        throw new DAOException(e);
		    }
	}
    
    @Override
    public void userAddMeasurableObject(Integer userID, MeasurableObject measurableObject) throws DAOException {

    	Connection connection = null;
		PreparedStatement statement = null;
        
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_USER_ADD_MEASURABLE_OBJECT);

            statement.setInt(1, userID);
            statement.setInt(2, measurableObject.getMeasurableObjectID());
                   
            statement.executeQuery();
            
            connection.close();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }
    }
    
    private static User map(ResultSet resultSet) throws SQLException {
        User user = new User();
        user.setUserId(resultSet.getInt("UserID"));
        user.setInstitutionID(resultSet.getInt("InstitutionID"));
        user.setInstitutionName(resultSet.getString("InstitutionName"));
        user.setEmail(resultSet.getString("Email"));
        user.setUserGroupID(resultSet.getInt("UserGroupID"));
        user.setUserGroupName(resultSet.getString("UserGroupName"));
        user.setFirstName(resultSet.getString("FirstName"));
        user.setLastName(resultSet.getString("LastName"));
        user.setPhoneNumber(resultSet.getInt("PhoneNumber"));

        return user;
    }    

}
