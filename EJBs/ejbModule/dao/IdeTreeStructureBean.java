package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.ejb.LocalBean;
import javax.ejb.Stateless;

import entity.IdeTreeStructure;

/**
 * Session Bean implementation class UserBean
 */
@Stateless
@LocalBean
public class IdeTreeStructureBean implements IdeTreeStructureBeanRemote {

    private static final String SQL_IDE_TREE_STRUCTURE_LIST_ORDER_BY_ID =
    		"SELECT IdeMeasurableObjectID, IdeID, IdeName, IdeDescription, InstitutionMeasurableObjectID, InstitutionID, InstitutionName, InstitutionDescription, NodeMeasurableObjectID, NodeID, NodeName, NodeDescription FROM ide_tree_structure_get(?)";
    
    private DAOFactory daoFactory;

    IdeTreeStructureBean(DAOFactory daoFactory) {
        this.daoFactory = daoFactory;
    }
    
    public IdeTreeStructureBean() {
		// Obtener DAOFactory
    	daoFactory = DAOFactory.getInstance("geoservicequality.jdbc");
    }    
    
    @Override
    public List<IdeTreeStructure> list(Integer userID) throws DAOException {
        List<IdeTreeStructure> ideTreeStructures = new ArrayList<>();

        Connection connection = null;
		PreparedStatement statement = null;
		ResultSet resultSet = null;
        
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_IDE_TREE_STRUCTURE_LIST_ORDER_BY_ID);

            if (userID != null){
            	statement.setInt(1, userID);
            }
            else {
            	statement.setObject(1, null);	
            }
            
            
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
            	ideTreeStructures.add(map(resultSet));
            }
            
            connection.close();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }

        return ideTreeStructures;
    }
        
    private static IdeTreeStructure map(ResultSet resultSet) throws SQLException {
    	IdeTreeStructure ideTreeStructure = new IdeTreeStructure();
    	
    	ideTreeStructure.setIdeMeasurableObjectID(resultSet.getInt("IdeMeasurableObjectID"));
    	ideTreeStructure.setIdeID(resultSet.getInt("IdeID"));
    	ideTreeStructure.setIdeName(resultSet.getString("IdeName"));
    	ideTreeStructure.setIdeDescription(resultSet.getString("IdeDescription"));
    	ideTreeStructure.setInstitutionMeasurableObjectID(resultSet.getInt("InstitutionMeasurableObjectID"));
    	ideTreeStructure.setInstitutionID(resultSet.getInt("InstitutionID"));
    	ideTreeStructure.setInstitutionName(resultSet.getString("InstitutionName"));    	
    	ideTreeStructure.setInstitutionDescription(resultSet.getString("InstitutionDescription"));
    	ideTreeStructure.setNodeMeasurableObjectID(resultSet.getInt("NodeMeasurableObjectID"));
    	ideTreeStructure.setNodeID(resultSet.getInt("NodeID"));
    	ideTreeStructure.setNodeName(resultSet.getString("NodeName"));
    	ideTreeStructure.setNodeDescription(resultSet.getString("NodeDescription"));
    	
        return ideTreeStructure;
    }

}
