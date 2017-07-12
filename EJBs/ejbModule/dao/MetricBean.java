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

@Stateless
@LocalBean
public class MetricBean implements MetricBeanRemote {

    private static final String SQL_LIST_ORDER_BY_ID =
    		"SELECT MetricID, MetricFactorID, MetricName, MetricAgrgegationFlag, MetricUnitID, MetricGranurality, MetricDescription, MetricManual FROM metric_get ()";
    private static final String SQL_PROFILE_METRIC_TO_ADD_GET =
    		"SELECT MetricID, MetricFactorID, MetricName, MetricAgrgegationFlag, MetricUnitID, MetricGranurality, MetricDescription, MetricManual FROM prototype_profile_metric_to_add_get (?)";

    private DAOFactory daoFactory;
	
    MetricBean(DAOFactory daoFactory) {
        this.daoFactory = daoFactory;
    }
    
    public MetricBean() {
    	daoFactory = DAOFactory.getInstance("geoservicequality.jdbc");
    }
   

	@Override
	public List<Metric> list() throws DAOException {

		List<Metric> metrics = new ArrayList<>();

        Connection connection = null;
		PreparedStatement statement = null;
		ResultSet resultSet = null;
        
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_LIST_ORDER_BY_ID);
            
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
            	metrics.add(map(resultSet));
            }
            
            connection.close();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }

        return metrics;
	}
	
	
	@Override
    public List<Metric> profileMetricsToAddGet(Integer profileID) throws DAOException{
        System.out.println("profileID en PMBEAN" + profileID);
    	List<Metric> metric = new ArrayList<>();

        Connection connection = null;
		PreparedStatement statement = null;
		ResultSet resultSet = null;
        
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_PROFILE_METRIC_TO_ADD_GET);
            
			statement.setObject(1, profileID);
			
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
            	metric.add(map(resultSet));
            }
            
            connection.close();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }

        return metric;    	
    }
	
	 private static Metric map(ResultSet resultSet) throws SQLException {
		Metric metric = new Metric();
		metric.setMetricID(resultSet.getInt("MetricID"));
		metric.setName(resultSet.getString("MetricName"));
		metric.setGranurality(resultSet.getString("MetricGranurality"));
		metric.setFactorID(resultSet.getInt("MetricFactorID"));
		metric.setUnitID(resultSet.getInt("MetricUnitID"));
		metric.setAgrgegationFlag(resultSet.getBoolean("MetricAgrgegationFlag"));
		metric.setDescription(resultSet.getString("MetricDescription"));
		metric.setManual(resultSet.getBoolean("MetricManual"));
		
        return metric; 
    }

}
