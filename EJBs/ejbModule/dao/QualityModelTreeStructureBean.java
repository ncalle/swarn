package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.ejb.LocalBean;
import javax.ejb.Stateless;

import entity.QualityModelTreeStructure;

/**
 * Session Bean implementation class UserBean
 */
@Stateless
@LocalBean
public class QualityModelTreeStructureBean implements QualityModelTreeStructureBeanRemote {

    private static final String SQL_QUALITY_MODEL_LIST =
    		"SELECT ElementID, ElementName, ElementType, FatherElementyID, AggregationFlag, Granularity, Unit, IsUserMetric, MetricFileName FROM quality_models_get()";
	private static final String SQL_UPDATE =
        	"SELECT * FROM quality_model_update (?, ?, ?)";
	private static final String SQL_INSERT =
            "SELECT * FROM quality_model_insert (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	
    private DAOFactory daoFactory;

    QualityModelTreeStructureBean(DAOFactory daoFactory) {
        this.daoFactory = daoFactory;
    }
    
    public QualityModelTreeStructureBean() {
		// Obtener DAOFactory
    	daoFactory = DAOFactory.getInstance("geoservicequality.jdbc");
    }    
    
    @Override
    public List<QualityModelTreeStructure> list() throws DAOException {
        List<QualityModelTreeStructure> qualityModels = new ArrayList<>();

        Connection connection = null;
		PreparedStatement statement = null;
		ResultSet resultSet = null;
        
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_QUALITY_MODEL_LIST);
            
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
            	qualityModels.add(map(resultSet));
            }
            
            connection.close();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }

        return qualityModels;
    }
    
    public void update(Integer elementID, String elementType, String name) throws DAOException {
    	Connection connection = null;
		PreparedStatement statement = null;
		
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_UPDATE);
            
            statement.setInt(1, elementID);
            statement.setString(2, elementType);
            statement.setString(3, name);        
        
            statement.executeQuery();
            
            connection.close();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }
    }
    
    public void create(QualityModelTreeStructure element, Integer metricUnitID, Boolean metricIsManual, String metricDescription, Boolean isUserMetric, String metricFileName) throws IllegalArgumentException, DAOException{
        Connection connection = null;
		PreparedStatement statement = null;
		
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_INSERT);
            
            statement.setString(1, element.getElementType());
            
            if (element.getFatherElementyID() == null){
            	statement.setObject(2, null);
            }
            else{
            	statement.setInt(2, element.getFatherElementyID());	
            }
            
            if (element.getElementName() == null){
            	statement.setObject(3, null);
            }
            else{
            	statement.setString(3, element.getElementName());	
            }
            
            if (element.getAggregationFlag() == null){
            	statement.setObject(4, null);
            }
            else{
            	statement.setBoolean(4, element.getAggregationFlag());	
            }
            
            if (element.getGranularity() == null){
            	statement.setObject(5, null);
            }
            else{
            	statement.setString(5, element.getGranularity());
            }
            
            if (element.getUnit() == null){
            	statement.setObject(6, null);
            }
            else{
            	statement.setString(6, element.getUnit());
            }
            
            if (element.getElementType().equals("M")){
            	statement.setInt(7, metricUnitID);
            	statement.setBoolean(8, metricIsManual);
            	statement.setString(9, metricDescription);
            	statement.setBoolean(10, isUserMetric);
            	statement.setString(11, metricFileName);
            }
            else{
            	statement.setObject(7, null);
            	statement.setObject(8, null);
            	statement.setObject(9, null);
            	statement.setObject(10, null);
            	statement.setObject(11, null);
            }
            
            statement.executeQuery();
            
            connection.close();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }        
    }
        
    private static QualityModelTreeStructure map(ResultSet resultSet) throws SQLException {
    	QualityModelTreeStructure qualityModel = new QualityModelTreeStructure();
    	
    	qualityModel.setElementID(resultSet.getInt("ElementID"));
    	qualityModel.setElementName(resultSet.getString("ElementName"));
    	qualityModel.setElementType(resultSet.getString("ElementType"));
    	qualityModel.setFatherElementyID(resultSet.getInt("FatherElementyID"));    	
    	qualityModel.setAggregationFlag(resultSet.getBoolean("AggregationFlag"));
    	qualityModel.setGranularity(resultSet.getString("Granularity"));    	
    	qualityModel.setUnit(resultSet.getString("Unit"));
    	qualityModel.setIsUserMetric(resultSet.getBoolean("IsUserMetric"));
    	qualityModel.setMetricFileName(resultSet.getString("MetricFileName"));
    	
        return qualityModel;
    }

}
