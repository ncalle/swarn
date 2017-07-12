package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.ejb.LocalBean;
import javax.ejb.Stateless;

import entity.Metric;
import entity.Profile;

@Stateless
@LocalBean
public class ProfileBean implements ProfileBeanRemote {

    private static final String SQL_LIST_ORDER_BY_ID =
    		"SELECT ProfileID, ProfileName, ProfileGranurality, ProfileIsWeightedFlag FROM profile_get ()";
	private static final String SQL_INSERT =
            "SELECT * FROM profile_insert (?, ?, ?, ?)";
	private static final String SQL_DELETE =
        	"SELECT * FROM profile_delete (?)";
	private static final String SQL_UPDATE =
        	"SELECT * FROM profile_update (?, ?, ?, ?)";

    private DAOFactory daoFactory;
	
    public ProfileBean() {
    	daoFactory = DAOFactory.getInstance("geoservicequality.jdbc");
    }

    ProfileBean(DAOFactory daoFactory) {
        this.daoFactory = daoFactory;
    }

	@Override
	public List<Profile> list() throws DAOException {

		 List<Profile> list = new ArrayList<>();

	        Connection connection = null;
			PreparedStatement statement = null;
			ResultSet resultSet = null;
	        
	        try {
	            connection = daoFactory.getConnection();
	            statement = connection.prepareStatement(SQL_LIST_ORDER_BY_ID);
	            
	            resultSet = statement.executeQuery();

	            while (resultSet.next()) {
	            	list.add(map(resultSet));
	            }
	            
	            connection.close();
	            
	        } catch (SQLException e) {
	            throw new DAOException(e);
	        }

	        return list;
	}
	

	@Override
	public void create(Profile profile, List<Metric> metrics) throws IllegalArgumentException, DAOException {
		Connection connection = null;
		PreparedStatement statement = null;
        
		System.out.println("DAO Metricas recibidas: " + metrics);
		
        try {
        	String metricIDs = "";
        	Integer iterCount = 0;
        	
    		Iterator<Metric> iterator = metrics.iterator();
    		while (iterator.hasNext()) {
    			
    			if (iterCount == 0) {
    				metricIDs = Integer.toString(iterator.next().getMetricID());
    			}
    			else{
    				metricIDs = metricIDs + "," + Integer.toString(iterator.next().getMetricID());	
    			};
    			
    			iterCount = iterCount + 1;
    		}
        	
    		System.out.println("DAO Profile metricIDs: " + metricIDs);
    		
        	connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_INSERT);

            statement.setString(1, profile.getName());
			statement.setString(2, profile.getGranurality());
			statement.setBoolean(3, profile.getIsWeightedFlag());
			statement.setString(4, metricIDs);
			
            statement.executeQuery();
            
            connection.close();

        } catch (SQLException e) {
            throw new DAOException(e);
        }        
		
	}

	@Override
	public void delete(Profile profile) throws DAOException {
    	Connection connection = null;
		PreparedStatement statement = null;
        
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_DELETE);

            statement.setInt(1, profile.getProfileId());
        
            statement.executeQuery();

            profile.setProfileId(null);
            
            connection.close();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }		
	}
	
	@Override
	public void update(Profile profile) throws DAOException{
    	Connection connection = null;
		PreparedStatement statement = null;
        
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_UPDATE);

            statement.setInt(1, profile.getProfileId());
            statement.setString(2, profile.getName());
            statement.setString(3, profile.getGranurality());
            statement.setBoolean(4, profile.getIsWeightedFlag());
        
            statement.executeQuery();
            
            connection.close();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }
	}
	
	private static Profile map(ResultSet resultSet) throws SQLException {
	    Profile profile = new Profile();
	   	profile.setProfileId(resultSet.getInt("ProfileID"));
	   	profile.setName(resultSet.getString("ProfileName"));
	   	profile.setGranurality(resultSet.getString("ProfileGranurality"));
	   	profile.setIsWeightedFlag(resultSet.getBoolean("ProfileIsWeightedFlag"));
	
	   	return profile; 
	}
	
}
