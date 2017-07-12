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

/**
 * Session Bean implementation class MeasurableObjectBean
 */
@Stateless
@LocalBean
public class MeasurableObjectBean implements MeasurableObjectBeanRemote {

    private static final String SQL_LIST_ORDER_BY_ID =
    		"SELECT MeasurableObjectID, EntityID, EntityType, MeasurableObjectName, MeasurableObjectDescription, MeasurableObjectURL, MeasurableObjectServicesType FROM prototype_measurable_objects_get (?)";
	private static final String SQL_INSERT =
            "SELECT * FROM measurable_objects_insert (?, ?, ?, ?, ?, ?)";
    private static final String SQL_DELETE =
        	"SELECT * FROM prototype_measurable_objects_delete(?)";
    private static final String SQL_USER_MEASURABLE_OBJECT_TO_ADD_GET =
    		"SELECT MeasurableObjectID, EntityID, EntityType, MeasurableObjectName, MeasurableObjectDescription, MeasurableObjectURL, MeasurableObjectServicesType FROM prototype_user_measurable_object_to_add_get (?)";
	private static final String SQL_UPDATE =
        	"SELECT * FROM prototype_measurable_object_update (?, ?, ?, ?, ?)";
    private static final String SQL_SERVICES_AND_LAYER_GET =
    		"SELECT MeasurableObjectID, EntityID, EntityType, MeasurableObjectName, MeasurableObjectDescription, MeasurableObjectURL, MeasurableObjectServicesType FROM services_and_layers_get (?, ?, ?)";	

    private DAOFactory daoFactory;
	
    public MeasurableObjectBean() {
    	daoFactory = DAOFactory.getInstance("geoservicequality.jdbc");
    }

    MeasurableObjectBean(DAOFactory daoFactory) {
        this.daoFactory = daoFactory;
    }
    
    @Override
    public List<MeasurableObject> list() throws DAOException {
        List<MeasurableObject> measurableobject = new ArrayList<>();

        Connection connection = null;
		PreparedStatement statement = null;
		ResultSet resultSet = null;
        
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_LIST_ORDER_BY_ID);
            
			statement.setObject(1, null); //userID
			
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
            	measurableobject.add(map(resultSet));
            }
            
            connection.close();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }

        return measurableobject;
    }
    
    @Override
    public List<MeasurableObject> list(Integer userID) throws DAOException {
        List<MeasurableObject> measurableobject = new ArrayList<>();

        Connection connection = null;
		PreparedStatement statement = null;
		ResultSet resultSet = null;
        
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_LIST_ORDER_BY_ID);
            
			statement.setObject(1, userID);
			
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
            	measurableobject.add(map(resultSet));
            }
            
            connection.close();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }

        return measurableobject;
    }    

    @Override
    public void create(MeasurableObject measurableobject, String entityType) throws IllegalArgumentException, DAOException {
        Connection connection = null;
		PreparedStatement statement = null;
        
		System.out.println(measurableobject);
		
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_INSERT);
            
            statement.setString(1, entityType);
            
            if (measurableobject.getFatherEntityID() == null){
            	statement.setObject(2, null);
            }
            else{
            	statement.setInt(2, measurableobject.getFatherEntityID());	
            }
            
            if (measurableobject.getMeasurableObjectName() == null){
            	statement.setObject(3, null);
            }
            else{
            	statement.setString(3, measurableobject.getMeasurableObjectName());	
            }
            
            if (measurableobject.getMeasurableObjectDescription() == null){
            	statement.setObject(4, null);
            }
            else{
            	statement.setString(4, measurableobject.getMeasurableObjectDescription());	
            }
            
            if (measurableobject.getMeasurableObjectURL() == null){
            	statement.setObject(5, null);
            }
            else{
            	statement.setString(5, measurableobject.getMeasurableObjectURL());
            }
            
            if (measurableobject.getMeasurableObjectServicesType() == null){
            	statement.setObject(6, null);
            }
            else{
            	statement.setString(6, measurableobject.getMeasurableObjectServicesType());	
            }
            
            statement.executeQuery();
            
            connection.close();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }        
    }

    @Override
    public void delete(MeasurableObject measurableobject) throws DAOException {

    	Connection connection = null;
		PreparedStatement statement = null;
		
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_DELETE);

            statement.setInt(1, measurableobject.getMeasurableObjectID());
                   
            statement.executeQuery();
            
            measurableobject.setMeasurableObjectID(null);
            
            connection.close();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }
    }
    
    @Override
    public List<MeasurableObject> userMeasurableObjectsToAddGet(Integer userID) throws DAOException {
        System.out.println("userID en MOBEAN" + userID);
    	List<MeasurableObject> measurableobject = new ArrayList<>();

        Connection connection = null;
		PreparedStatement statement = null;
		ResultSet resultSet = null;
        
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_USER_MEASURABLE_OBJECT_TO_ADD_GET);
            
			statement.setInt(1, userID);
			
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
            	measurableobject.add(map(resultSet));
            }
            
            connection.close();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }

        return measurableobject;
    }
    
    @Override
    public void update(MeasurableObject measurableObject) throws DAOException{

    	Connection connection = null;
		PreparedStatement statement = null;
        
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_UPDATE);

            statement.setInt(1, measurableObject.getMeasurableObjectID());
            statement.setString(2, measurableObject.getMeasurableObjectURL());
            statement.setString(3, measurableObject.getMeasurableObjectServicesType());
            statement.setString(4, measurableObject.getMeasurableObjectName());
            statement.setString(5, measurableObject.getMeasurableObjectDescription());
        
            statement.executeQuery();
            
            connection.close();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }
    }
    
    @Override
    public List<MeasurableObject> servicesAndLayerGet(Integer userID, String EntityName, String EntityType) throws DAOException {
        List<MeasurableObject> measurableobject = new ArrayList<>();

        Connection connection = null;
		PreparedStatement statement = null;
		ResultSet resultSet = null;
        
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_SERVICES_AND_LAYER_GET);
            
			statement.setObject(1, null); //userID
			statement.setString(2, EntityName);
			statement.setString(3, EntityType);
			
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
            	measurableobject.add(map(resultSet));
            }
            
            connection.close();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }

        return measurableobject;
    }


    private static MeasurableObject map(ResultSet resultSet) throws SQLException {
    	MeasurableObject measurableobject = new MeasurableObject();
    	measurableobject.setMeasurableObjectID(resultSet.getInt("MeasurableObjectID"));
    	measurableobject.setEntityID(resultSet.getInt("EntityID"));
    	measurableobject.setEntityType(resultSet.getString("EntityType"));
    	measurableobject.setMeasurableObjectName(resultSet.getString("MeasurableObjectName"));
    	measurableobject.setMeasurableObjectDescription(resultSet.getString("MeasurableObjectDescription"));
    	measurableobject.setMeasurableObjectURL(resultSet.getString("MeasurableObjectURL"));
    	measurableobject.setMeasurableObjectServicesType(resultSet.getString("MeasurableObjectServicesType"));

        return measurableobject; 
    }
    
}