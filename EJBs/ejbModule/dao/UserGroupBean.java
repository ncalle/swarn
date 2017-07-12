package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.ejb.LocalBean;
import javax.ejb.Stateless;

import entity.UserGroup;

/**
 * Session Bean implementation class UserBean
 */
@Stateless
@LocalBean
public class UserGroupBean implements UserGroupBeanRemote {

    private static final String SQL_USERGROUP_LIST_ORDER_BY_NAME =
    		"SELECT UserGroupID, Name FROM user_group_get (?)";
    private static final String SQL_FIND_USERGROUP_BY_ID =
            "SELECT UserGroupID, Name FROM user_group_get (?)";
    
    private DAOFactory daoFactory;

    UserGroupBean(DAOFactory daoFactory) {
        this.daoFactory = daoFactory;
    }
    
    public UserGroupBean() {
		// Obtener DAOFactory
    	daoFactory = DAOFactory.getInstance("geoservicequality.jdbc");
    }    
    
    @Override
    public List<UserGroup> list() throws DAOException {
        List<UserGroup> userGroups = new ArrayList<>();

        Connection connection = null;
		PreparedStatement statement = null;
		ResultSet resultSet = null;
        
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_USERGROUP_LIST_ORDER_BY_NAME);

            statement.setObject(1, null); //userGroupID
            
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
            	userGroups.add(map(resultSet));
            }
            
            connection.close();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }

        return userGroups;
    }
    
    @Override
    public UserGroup find(Integer userGroupID) throws DAOException {
        UserGroup userGroup = null;
        
        Connection connection = null;
		PreparedStatement statement = null;
		ResultSet resultSet = null;
		
		try {
			connection = daoFactory.getConnection();
			statement = connection.prepareStatement(SQL_FIND_USERGROUP_BY_ID);

			statement.setInt(1, userGroupID); 

			resultSet = statement.executeQuery();
			
			if (resultSet.next()) {
                userGroup = map(resultSet);
            }
			
            connection.close();
            
		} catch (SQLException e) {
			throw new DAOException(e);
		}
		
    	return userGroup;
    }

        
    private static UserGroup map(ResultSet resultSet) throws SQLException {
        UserGroup userGroup = new UserGroup();
        userGroup.setUserGroupID(resultSet.getInt("UserGroupID"));
        userGroup.setName(resultSet.getString("Name"));

        return userGroup;
    }

}
