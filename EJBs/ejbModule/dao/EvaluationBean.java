package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.ejb.LocalBean;
import javax.ejb.Stateless;

import entity.Evaluation;

@Stateless
@LocalBean
public class EvaluationBean implements EvaluationBeanRemote {

    private static final String SQL_LIST_ORDER_BY_ID =
    		"SELECT EvaluationID, UserID, ProfileID, ProfileName, MeasurableObjectID, EntityID, EntityType, MeasurableObjectName, QualityModelID, QualityModelName, MetricID, MetricName, StartDate, EndDate, IsEvaluationCompletedFlag, SuccessFlag, EvaluationCount, EvaluationApprovedValues FROM evaluation_get (?)";
    private static final String SQL_INSERT =
            "SELECT * FROM evaluation_insert (?, ?, ?, ?, ?, ?)";


    private DAOFactory daoFactory;
	
    public EvaluationBean() {
    	daoFactory = DAOFactory.getInstance("geoservicequality.jdbc");
    }

    EvaluationBean(DAOFactory daoFactory) {
        this.daoFactory = daoFactory;
    }

	@Override
	public List<Evaluation> list() throws DAOException {

		List<Evaluation> list = new ArrayList<>();

        Connection connection = null;
		PreparedStatement statement = null;
		ResultSet resultSet = null;
        
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_LIST_ORDER_BY_ID);
            
            statement.setObject(1, null); //userID
            
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
	public void create(Evaluation evaluation) throws IllegalArgumentException, DAOException {
		Connection connection = null;
		PreparedStatement statement = null;
        
        try {
        	
        	connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_INSERT);

            statement.setInt(1, evaluation.getEvaluationSummaryID());
			statement.setInt(2, evaluation.getMetricID());
			statement.setBoolean(3, evaluation.getSuccess()); 
			statement.setBoolean(4, evaluation.getIsEvaluationCompleted()); 
			statement.setInt(5, evaluation.getEvaluationCount());
			statement.setInt(6, evaluation.getEvaluationApprovedValue());
			
            statement.executeQuery();
            
            connection.close();
		
        } catch (SQLException e) {
        	throw new DAOException(e);
        }        
	}
	
	
	private static Evaluation map(ResultSet resultSet) throws SQLException {
		Evaluation object = new Evaluation();
		object.setEvaluationID(resultSet.getInt("EvaluationID"));
		object.setUserID(resultSet.getInt("UserID"));
		object.setProfileID(resultSet.getInt("ProfileID"));
		object.setProfileName(resultSet.getString("ProfileName"));		
		object.setMeasurableObjectID(resultSet.getInt("MeasurableObjectID"));
	    object.setEntityID(resultSet.getInt("EntityID"));
	    object.setEntityType(resultSet.getString("EntityType"));
	    object.setMeasurableObjectName(resultSet.getString("MeasurableObjectName"));
	    object.setQualityModelID(resultSet.getInt("QualityModelID"));
	    object.setQualityModelName(resultSet.getString("QualityModelName"));
	    object.setMetricID(resultSet.getInt("MetricID"));
	    object.setMetricName(resultSet.getString("MetricName"));
	    object.setStartDate(resultSet.getDate("StartDate"));
	    object.setEndDate(resultSet.getDate("EndDate"));    
		object.setIsEvaluationCompleted(resultSet.getBoolean("IsEvaluationCompletedFlag"));
		object.setSuccess(resultSet.getBoolean("SuccessFlag"));
		object.setEvaluationCount(resultSet.getInt("EvaluationCount"));
		object.setEvaluationApprovedValue(resultSet.getInt("EvaluationApprovedValues"));

       return object;
   }

}
