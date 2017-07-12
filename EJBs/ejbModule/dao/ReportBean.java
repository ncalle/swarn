package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.ejb.LocalBean;
import javax.ejb.Stateless;

import entity.Report;

/**
 * Session Bean implementation class UserBean
 */
@Stateless
@LocalBean
public class ReportBean implements ReportBeanRemote {

    private static final String GEOGRAPHIC_SERVICES_PER_INSTITUTION = 
    		"SELECT InstitutionID, InstitutionName, GeographicServicesCount, GeographicServicesPercentage FROM report_geographic_services_per_institution ()";
    private static final String EVALUATION_SUCCESS_VS_FAILED =
            "SELECT SuccessCount, FailCount, SuccessPercentage, FailPercentage, TotalEvaluationCount FROM report_evaluation_success_vs_failed ()";
    private static final String EVALUATIONS_PER_METRIC =
            "SELECT MetricID, MetricName, EvaluationPerMetricCount, EvaluationPerMetricPercentage FROM report_evaluations_per_metric ()";
    private static final String SUCCESS_EVALUATIONS_PER_PROFILE =
            "SELECT ProfileID, ProfileName, ProfileCount, ProfilePercentage, ProfileSuccessPercentage FROM report_success_evaluation_per_profile ()";
    private static final String SUCCESS_EVALUATIONS_PER_INSTITUTION =
            "SELECT InstitutionID, InstitutionName, InstitutionCount, InstitutionPercentage, InstitutionSuccessPercentage FROM report_success_evaluation_per_institution ()";
    private static final String SUCCESS_EVALUATIONS_PER_NODE =
            "SELECT NodeID, NodeName, NodeCount, NodePercentage, NodeSuccessPercentage FROM report_success_evaluation_per_node ()";   
    private static final String TOP_BEST_WORST_MEASURABLE_OBJECT_GET =
            "SELECT MeasurableObjectID, EntityID, EntityType, MeasurableObjectDescription, MeasurableObjectURL, MeasurableObjectServicesType, MeasurableObjectSuccessPercentage FROM report_top_best_worst_measurable_object_get (?, ?, ?)";
    

    private DAOFactory daoFactory;

    ReportBean(DAOFactory daoFactory) {
        this.daoFactory = daoFactory;
    }
    
    public ReportBean() {
		// Obtener DAOFactory
    	daoFactory = DAOFactory.getInstance("geoservicequality.jdbc");
    }    
    
    
    @Override
    public List<Report> geographicServicesPerInstitution() throws DAOException {
        List<Report> report = new ArrayList<>();

        Connection connection = null;
		PreparedStatement statement = null;
		ResultSet resultSet = null;
        
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(GEOGRAPHIC_SERVICES_PER_INSTITUTION);
            
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
            	report.add(map(resultSet));
            }
            
            connection.close();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }

        return report;
    }
    
    @Override
    public List<Report> evaluationSuccessVsFailed() throws DAOException {
        List<Report> report = new ArrayList<>();

        Connection connection = null;
		PreparedStatement statement = null;
		ResultSet resultSet = null;
        
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(EVALUATION_SUCCESS_VS_FAILED);
            
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
            	report.add(map(resultSet));
            }
            
            connection.close();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }

        return report;
    }
    
    @Override
    public List<Report> evaluationsPerMetric() throws DAOException {
        List<Report> report = new ArrayList<>();

        Connection connection = null;
		PreparedStatement statement = null;
		ResultSet resultSet = null;
        
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(EVALUATIONS_PER_METRIC);
            
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
            	report.add(map(resultSet));
            }
            
            connection.close();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }

        return report;
    }
    
    @Override
    public List<Report> successEvaluationPerProfile() throws DAOException {
        List<Report> report = new ArrayList<>();

        Connection connection = null;
		PreparedStatement statement = null;
		ResultSet resultSet = null;
        
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SUCCESS_EVALUATIONS_PER_PROFILE);
            
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
            	report.add(map(resultSet));
            }
            
            connection.close();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }

        return report;
    }
    
    @Override
    public List<Report> successEvaluationPerInstitution() throws DAOException {
        List<Report> report = new ArrayList<>();

        Connection connection = null;
		PreparedStatement statement = null;
		ResultSet resultSet = null;
        
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SUCCESS_EVALUATIONS_PER_INSTITUTION);
            
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
            	report.add(map(resultSet));
            }

            connection.close();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }

        return report;
    }
    
    @Override
    public List<Report> successEvaluationPerNode() throws DAOException {
        List<Report> report = new ArrayList<>();

        Connection connection = null;
		PreparedStatement statement = null;
		ResultSet resultSet = null;
        
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SUCCESS_EVALUATIONS_PER_NODE);
            
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
            	report.add(map(resultSet));
            }
            
            connection.close();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }

        return report;
    }
    
    @Override
    public List<Report> topBestWorstMeasurableObjectGet(Integer Top, Boolean SuccessFlagAsc, Boolean SuccessFlagDesc) throws DAOException {
        List<Report> report = new ArrayList<>();

        Connection connection = null;
		PreparedStatement statement = null;
		ResultSet resultSet = null;
        
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(TOP_BEST_WORST_MEASURABLE_OBJECT_GET);
            
            statement.setInt(1, Top);
            statement.setBoolean(2, SuccessFlagAsc);
            statement.setBoolean(3, SuccessFlagDesc);
            
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
            	report.add(map(resultSet));
            }
            
            connection.close();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }

        return report;
    }    
    
        
    private static Report map(ResultSet resultSet) throws SQLException {
        Report report = new Report();
        
        ResultSetMetaData rsMetaData = resultSet.getMetaData();
        report.setInstitutionID(null);
    	report.setInstitutionName(null);
    	report.setGeographicServicesCount(null);    	
    	report.setGeographicServicesPercentage(null);    	
    	report.setSuccessCount(null);
    	report.setFailCount(null);
    	report.setSuccessPercentage(null);
    	report.setFailPercentage(null);
    	report.setTotalEvaluationCount(null);
    	report.setProfileSuccessPercentage(null);
    	report.setProfilePercentage(null);
    	report.setProfileCount(null);
    	report.setProfileName(null);
    	report.setMetricID(null);
    	report.setProfileID(null);
    	report.setEvaluationPerMetricPercentage(null);
    	report.setEvaluationPerMetricCount(null);
    	report.setMetricName(null);
    	report.setInstitutionCount(null);
        report.setInstitutionPercentage(null);
        report.setInstitutionSuccessPercentage(null);
        report.setNodeID(null);
        report.setNodeName(null);
        report.setNodeCount(null);
        report.setNodePercentage(null);
        report.setNodeSuccessPercentage(null);
        report.setMeasurableObjectID(null);
        report.setEntityID(null);
        report.setEntityType(null);
        report.setMeasurableObjectDescription(null);
        report.setMeasurableObjectURL(null);
        report.setMeasurableObjectServicesType(null);
        report.setMeasurableObjectSuccessPercentage(null);
    	
        int numberOfColumns = rsMetaData.getColumnCount();
        for (int i = 1; i < numberOfColumns + 1; i++) {
            String columnName = rsMetaData.getColumnName(i);

            if ("InstitutionID".toLowerCase().equals(columnName)) {
            	report.setInstitutionID(resultSet.getInt("InstitutionID"));
            }
            
            if ("InstitutionName".toLowerCase().equals(columnName)) {
            	report.setInstitutionName(resultSet.getString("InstitutionName"));
            }
            
            if ("GeographicServicesCount".toLowerCase().equals(columnName)) {
            	report.setGeographicServicesCount(resultSet.getInt("GeographicServicesCount"));
            }
            
            if ("GeographicServicesPercentage".toLowerCase().equals(columnName)) {
            	report.setGeographicServicesPercentage(resultSet.getInt("GeographicServicesPercentage"));
            }   
            
            if ("SuccessCount".toLowerCase().equals(columnName)) {
            	report.setSuccessCount(resultSet.getInt("SuccessCount"));
            }

            if ("FailCount".toLowerCase().equals(columnName)) {
            	report.setFailCount(resultSet.getInt("FailCount"));
            }  

            if ("SuccessPercentage".toLowerCase().equals(columnName)) {
            	report.setSuccessPercentage(resultSet.getInt("SuccessPercentage"));
            }  

            if ("FailPercentage".toLowerCase().equals(columnName)) {
            	report.setFailPercentage(resultSet.getInt("FailPercentage"));
            }
            
            if ("TotalEvaluationCount".toLowerCase().equals(columnName)) {
            	report.setTotalEvaluationCount(resultSet.getInt("TotalEvaluationCount"));
            }
            
            if ("MetricID".toLowerCase().equals(columnName)) {
            	report.setMetricID(resultSet.getInt("MetricID"));
            }
            
            if ("MetricName".toLowerCase().equals(columnName)) {
            	report.setMetricName(resultSet.getString("MetricName"));
            }
            
            if ("EvaluationPerMetricCount".toLowerCase().equals(columnName)) {
            	report.setEvaluationPerMetricCount(resultSet.getInt("EvaluationPerMetricCount"));
            }
            
            if ("EvaluationPerMetricPercentage".toLowerCase().equals(columnName)) {
            	report.setEvaluationPerMetricPercentage(resultSet.getInt("EvaluationPerMetricPercentage"));
            }
            
            if ("ProfileID".toLowerCase().equals(columnName)) {
            	report.setProfileID(resultSet.getInt("ProfileID"));
            }
            
            if ("ProfileName".toLowerCase().equals(columnName)) {
            	report.setProfileName(resultSet.getString("ProfileName"));
            }

            if ("ProfileCount".toLowerCase().equals(columnName)) {
            	report.setProfileCount(resultSet.getInt("ProfileCount"));
            }
            
            if ("ProfilePercentage".toLowerCase().equals(columnName)) {
            	report.setProfilePercentage(resultSet.getInt("ProfilePercentage"));
            }

            if ("ProfileSuccessPercentage".toLowerCase().equals(columnName)) {
            	report.setProfileSuccessPercentage(resultSet.getInt("ProfileSuccessPercentage"));
            }
            
            if ("InstitutionCount".toLowerCase().equals(columnName)) {
            	report.setInstitutionCount(resultSet.getInt("InstitutionCount"));
            }
            
            if ("InstitutionPercentage".toLowerCase().equals(columnName)) {
            	report.setInstitutionPercentage(resultSet.getInt("InstitutionPercentage"));
            }

            if ("InstitutionSuccessPercentage".toLowerCase().equals(columnName)) {
            	report.setInstitutionSuccessPercentage(resultSet.getInt("InstitutionSuccessPercentage"));
            }

            if ("NodeID".toLowerCase().equals(columnName)) {
            	report.setNodeID(resultSet.getInt("NodeID"));
            }
            
            if ("NodeName".toLowerCase().equals(columnName)) {
            	report.setNodeName(resultSet.getString("NodeName"));
            }
            
            if ("NodeCount".toLowerCase().equals(columnName)) {
            	report.setNodeCount(resultSet.getInt("NodeCount"));
            }
            
            if ("NodePercentage".toLowerCase().equals(columnName)) {
            	report.setNodePercentage(resultSet.getInt("NodePercentage"));
            }
            
            if ("NodeSuccessPercentage".toLowerCase().equals(columnName)) {
            	report.setNodeSuccessPercentage(resultSet.getInt("NodeSuccessPercentage"));
            }
            
            
            if ("MeasurableObjectID".toLowerCase().equals(columnName)) {
            	report.setMeasurableObjectID(resultSet.getInt("MeasurableObjectID"));
            }

            if ("EntityID".toLowerCase().equals(columnName)) {
            	report.setEntityID(resultSet.getInt("EntityID"));
            }

            if ("EntityType".toLowerCase().equals(columnName)) {
            	report.setEntityType(resultSet.getString("EntityType"));
            }

            if ("MeasurableObjectDescription".toLowerCase().equals(columnName)) {
            	report.setMeasurableObjectDescription(resultSet.getString("MeasurableObjectDescription"));
            }

            if ("MeasurableObjectURL".toLowerCase().equals(columnName)) {
            	report.setMeasurableObjectURL(resultSet.getString("MeasurableObjectURL"));
            }

            if ("MeasurableObjectServicesType".toLowerCase().equals(columnName)) {
            	report.setMeasurableObjectServicesType(resultSet.getString("MeasurableObjectServicesType"));
            }
            
            if ("MeasurableObjectSuccessPercentage".toLowerCase().equals(columnName)) {
            	report.setMeasurableObjectSuccessPercentage(resultSet.getInt("MeasurableObjectSuccessPercentage"));
            }            
        }
        
        return report;
    }

}
