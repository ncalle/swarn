package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.ejb.LocalBean;
import javax.ejb.Stateless;

import entity.QualityWeightTreeStructure;

/**
 * Session Bean implementation class UserBean
 */
@Stateless
@LocalBean
public class QualityWeightTreeStructureBean implements QualityWeightTreeStructureBeanRemote {

    private static final String SQL_QUALITY_WEIGHT_TREE_STRUCTURE_LIST =
    		"SELECT WeighingID, ProfileID, ElementID, ElementName, ElementType, NumeratorValue, DenominatorValue, FatherElementyID FROM quality_weight_tree_sctucture(?)";
	private static final String SQL_UPDATE =
        	"SELECT * FROM quality_weight_update (?, ?, ?)";
    private DAOFactory daoFactory;

    QualityWeightTreeStructureBean(DAOFactory daoFactory) {
        this.daoFactory = daoFactory;
    }
    
    public QualityWeightTreeStructureBean() {
		// Obtener DAOFactory
    	daoFactory = DAOFactory.getInstance("geoservicequality.jdbc");
    }    
    
    @Override
    public List<QualityWeightTreeStructure> list(Integer profileID) throws DAOException {
        List<QualityWeightTreeStructure> qualityWeightTreeStructures = new ArrayList<>();

        Connection connection = null;
		PreparedStatement statement = null;
		ResultSet resultSet = null;
        
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_QUALITY_WEIGHT_TREE_STRUCTURE_LIST);

            if (profileID != null){
            	statement.setInt(1, profileID);
            }
            else {
            	statement.setObject(1, null);	
            }
            
            
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
            	qualityWeightTreeStructures.add(map(resultSet));
            }
            
            connection.close();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }

        return qualityWeightTreeStructures;
    }
    
    @Override
    public void update(Integer nominator, Integer denominator, Integer weighingID) throws DAOException {

    	Connection connection = null;
		PreparedStatement statement = null;
		
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_UPDATE);
            
            statement.setInt(1, nominator);
            if (denominator == null){
            	statement.setObject(2, null);
            }
            else{
            	statement.setInt(2, denominator);
            }
            statement.setInt(3, weighingID);        
        
            statement.executeQuery();
            
            connection.close();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }
    }
        
    private static QualityWeightTreeStructure map(ResultSet resultSet) throws SQLException {
    	QualityWeightTreeStructure qualityWeightTreeStructure = new QualityWeightTreeStructure();
    	
    	qualityWeightTreeStructure.setWeighingID(resultSet.getInt("WeighingID"));
    	qualityWeightTreeStructure.setProfileID(resultSet.getInt("ProfileID"));
    	qualityWeightTreeStructure.setElementID(resultSet.getInt("ElementID"));
    	qualityWeightTreeStructure.setElementName(resultSet.getString("ElementName"));
    	qualityWeightTreeStructure.setElementType(resultSet.getString("ElementType"));
    	qualityWeightTreeStructure.setNumeratorValue(resultSet.getInt("NumeratorValue"));
    	qualityWeightTreeStructure.setDenominatorValue(resultSet.getInt("DenominatorValue"));
    	qualityWeightTreeStructure.setFatherElementyID(resultSet.getInt("FatherElementyID"));
    	
        return qualityWeightTreeStructure;
    }

}
