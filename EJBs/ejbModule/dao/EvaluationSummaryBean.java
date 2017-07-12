package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.ejb.LocalBean;
import javax.ejb.Stateless;

import entity.EvaluationSummary;

@Stateless
@LocalBean
public class EvaluationSummaryBean implements EvaluationSummaryBeanRemote {

    private static final String SQL_LIST_ORDER_BY_ID =
    		"SELECT EvaluationSummaryID, UserID, ProfileID, ProfileName, MeasurableObjectID, EntityID, EntityType, MeasurableObjectName, MeasurableObjectDescription, SuccessFlag, SuccessPercentage FROM evaluation_summary_get (?)";
    private static final String SQL_INSERT =
            "SELECT EvaluationSummaryID, UserID, ProfileID, ProfileName, MeasurableObjectID, EntityID, EntityType, MeasurableObjectName, MeasurableObjectDescription, SuccessFlag, SuccessPercentage FROM evaluation_summary_insert (?, ?, ?, ?, ?)";


    private DAOFactory daoFactory;
	
    public EvaluationSummaryBean() {
    	daoFactory = DAOFactory.getInstance("geoservicequality.jdbc");
    }

    EvaluationSummaryBean(DAOFactory daoFactory) {
        this.daoFactory = daoFactory;
    }

	@Override
	public List<EvaluationSummary> list() throws DAOException {

		List<EvaluationSummary> list = new ArrayList<>();

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
	public EvaluationSummary create(EvaluationSummary evaluationSummary) throws IllegalArgumentException, DAOException {
		Connection connection = null;
		PreparedStatement statement = null;
		ResultSet resultSet = null;
		
		EvaluationSummary evS = null;
        
        try {
        	
        	connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_INSERT);

            statement.setInt(1, evaluationSummary.getUserID());
			statement.setInt(2, evaluationSummary.getProfileID());
			statement.setInt(3, evaluationSummary.getMeasurableObjectID());
			statement.setBoolean(4, evaluationSummary.getSuccess());
			statement.setInt(5, evaluationSummary.getSuccessPercentage());
			
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
            	evS = map(resultSet);
            }
            
            connection.close();
		
        } catch (SQLException e) {
        	throw new DAOException(e);
        }
        
        return evS;
	}
	
	
	private static EvaluationSummary map(ResultSet resultSet) throws SQLException {
		EvaluationSummary object = new EvaluationSummary();
		object.setEvaluationSummaryID(resultSet.getInt("EvaluationSummaryID"));
		object.setUserID(resultSet.getInt("UserID"));
		object.setProfileID(resultSet.getInt("ProfileID"));
		object.setProfileName(resultSet.getString("ProfileName"));		
		object.setMeasurableObjectID(resultSet.getInt("MeasurableObjectID"));
	    object.setEntityID(resultSet.getInt("EntityID"));
	    object.setEntityType(resultSet.getString("EntityType"));
	    object.setMeasurableObjectName(resultSet.getString("MeasurableObjectName"));
	    object.setMeasurableObjectDescription(resultSet.getString("MeasurableObjectDescription"));
		object.setSuccess(resultSet.getBoolean("SuccessFlag"));
		object.setSuccessPercentage(resultSet.getInt("SuccessPercentage"));

       return object;
   }

}
