package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.ejb.LocalBean;
import javax.ejb.Stateless;

import entity.Metric;
import entity.Profile;
import entity.ProfileMetric;

/**
 * Session Bean implementation class UserBean
 */
@Stateless
@LocalBean
public class ProfileMetricBean implements ProfileMetricBeanRemote {

    private static final String SQL_PROFILE_METRIC_LIST =
    		"SELECT QualityModelID, QualityModelName, DimensionID, DimensionName, FactorID, FactorName, MetricID, MetricName, MetricAgrgegationFlag, MetricGranurality, MetricDescription, MetricManual, IsUserMetric, MetricFileName, UnitID, UnitName, UnitDescription, MetricRangeID, BooleanFlag, BooleanAcceptanceValue, PercentageFlag, PercentageAcceptanceValue, IntegerFlag, IntegerAcceptanceValue, EnumerateFlag, EnumerateAcceptanceValue FROM profile_metric_get (?, ?)";
	private static final String SQL_PROFILE_REMOVE_METRIC =
        	"SELECT * FROM profile_remove_metric (?, ?)";
    private static final String SQL_PROFILE_ADD_METRIC =
        	"SELECT * FROM prototype_profile_add_metric(?, ?)";
	private static final String SQL_UPDATE =
        	"SELECT * FROM profile_metric_update (?, ?, ?, ?, ?)";
    
    private DAOFactory daoFactory;

    ProfileMetricBean(DAOFactory daoFactory) {
        this.daoFactory = daoFactory;
    }
    
    public ProfileMetricBean() {
		// Obtener DAOFactory
    	daoFactory = DAOFactory.getInstance("geoservicequality.jdbc");
    }    
        
    
    @Override
    public List<ProfileMetric> profileMetricList(Profile profile, Integer unitID) throws DAOException{
        List<ProfileMetric> metricList = new ArrayList<>();

        Connection connection = null;
		PreparedStatement statement = null;
		ResultSet resultSet = null;
        
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_PROFILE_METRIC_LIST);
            
            statement.setInt(1, profile.getProfileId());
            if (unitID == null){
            	statement.setObject(2, null);	
            }
            else{
            	statement.setInt(2, unitID);	
            }
                        
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
            	metricList.add(map(resultSet));
            }
        } catch (SQLException e) {
            throw new DAOException(e);
        }

        return metricList;    
    	
    }
    
    @Override
    public void removeProfileMetric(Profile profile, ProfileMetric profileMetric) throws DAOException{
    	Connection connection = null;
    	PreparedStatement statement = null;
        
    	    try {
    	        connection = daoFactory.getConnection();
    	        statement = connection.prepareStatement(SQL_PROFILE_REMOVE_METRIC);
    	
    	        statement.setInt(1, profile.getProfileId());
    	        statement.setInt(2, profileMetric.getMetricID());
    	    
    	        statement.executeQuery();
    	        
    	    } catch (SQLException e) {
    	        throw new DAOException(e);
    	    }
    }
    
    @Override
    public void profileAddMetric(Integer profileID, Metric metric) throws DAOException{
    	Connection connection = null;
		PreparedStatement statement = null;
        
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_PROFILE_ADD_METRIC);

            statement.setInt(1, profileID);
            statement.setInt(2, metric.getMetricID());
                   
            statement.executeQuery();
                        
        } catch (SQLException e) {
            throw new DAOException(e);
        }    	
    }
    
    @Override
    public void update(ProfileMetric profileMetric) throws DAOException{
    	Connection connection = null;
		PreparedStatement statement = null;
        
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_UPDATE);

            statement.setInt(1, profileMetric.getMetricRangeID());
            statement.setBoolean(2, profileMetric.getBooleanAcceptanceValue());
            statement.setInt(3, profileMetric.getPercentageAcceptanceValue());
            statement.setInt(4, profileMetric.getIntegerAcceptanceValue());
            statement.setString(5, profileMetric.getEnumerateAcceptanceValue());
            
            statement.executeQuery();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }
    }
        
    private static ProfileMetric map(ResultSet resultSet) throws SQLException {
    	ProfileMetric profileMetric = new ProfileMetric();
    	profileMetric.setQualityModelID(resultSet.getInt("QualityModelID"));
    	profileMetric.setQualityModelName(resultSet.getString("QualityModelName"));
    	profileMetric.setDimensionID(resultSet.getInt("DimensionID"));
    	profileMetric.setDimensionName(resultSet.getString("DimensionName"));    	
    	profileMetric.setFactorID(resultSet.getInt("FactorID"));
    	profileMetric.setFactorName(resultSet.getString("FactorName"));    	
    	profileMetric.setMetricID(resultSet.getInt("MetricID"));
    	profileMetric.setMetricName(resultSet.getString("MetricName"));
    	profileMetric.setMetricAgrgegationFlag(resultSet.getBoolean("MetricAgrgegationFlag"));
    	profileMetric.setMetricGranurality(resultSet.getString("MetricGranurality"));
    	profileMetric.setMetricDescription(resultSet.getString("MetricDescription"));
    	profileMetric.setMetricManual(resultSet.getBoolean("MetricManual"));
    	profileMetric.setIsUserMetric(resultSet.getBoolean("IsUserMetric"));
    	profileMetric.setMetricFileName(resultSet.getString("MetricFileName"));
    	profileMetric.setUnitID(resultSet.getInt("UnitID"));
    	profileMetric.setUnitName(resultSet.getString("UnitName"));
    	profileMetric.setUnitDescription(resultSet.getString("UnitDescription"));
    	
    	profileMetric.setMetricRangeID(resultSet.getInt("MetricRangeID"));
    	profileMetric.setBooleanFlag(resultSet.getBoolean("BooleanFlag"));
    	profileMetric.setBooleanAcceptanceValue(resultSet.getBoolean("BooleanAcceptanceValue"));
    	profileMetric.setPercentageFlag(resultSet.getBoolean("PercentageFlag"));
    	profileMetric.setPercentageAcceptanceValue(resultSet.getInt("PercentageAcceptanceValue"));
    	profileMetric.setIntegerFlag(resultSet.getBoolean("IntegerFlag"));
    	profileMetric.setIntegerAcceptanceValue(resultSet.getInt("IntegerAcceptanceValue"));
    	profileMetric.setEnumerateFlag(resultSet.getBoolean("EnumerateFlag"));
    	profileMetric.setEnumerateAcceptanceValue(resultSet.getString("EnumerateAcceptanceValue"));
    	
        return profileMetric;
    }

}
