package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.ejb.LocalBean;
import javax.ejb.Stateless;

import entity.Institution;

/**
 * Session Bean implementation class Institution
 */
@Stateless
@LocalBean
public class InstitutionBean implements InstitutionBeanRemote {

    private static final String SQL_INSTITUTION_LIST =
    		"SELECT InstitutionID, Name FROM institution_get (?)";
    private static final String SQL_FIND_INSTITUTION_BY_ID =
            "SELECT InstitutionID, Name FROM Institution_get (?)";
    
    private DAOFactory daoFactory;

    InstitutionBean(DAOFactory daoFactory) {
        this.daoFactory = daoFactory;
    }
    
    public InstitutionBean() {
		// Obtener DAOFactory
    	daoFactory = DAOFactory.getInstance("geoservicequality.jdbc");
    }    
    
    @Override
    public List<Institution> list() throws DAOException {
        List<Institution> institutions = new ArrayList<>();

        Connection connection = null;
		PreparedStatement statement = null;
		ResultSet resultSet = null;
        
        try {
            connection = daoFactory.getConnection();
            statement = connection.prepareStatement(SQL_INSTITUTION_LIST);

            statement.setObject(1, null); //InstitutionID
            
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
            	institutions.add(map(resultSet));
            }
            
            connection.close();
            
        } catch (SQLException e) {
            throw new DAOException(e);
        }

        return institutions;
    }
    
    @Override
    public Institution find(Integer institutionID) throws DAOException {
    	Institution institution = null;
        
        Connection connection = null;
		PreparedStatement statement = null;
		ResultSet resultSet = null;
		
		try {
			connection = daoFactory.getConnection();
			statement = connection.prepareStatement(SQL_FIND_INSTITUTION_BY_ID);

			statement.setInt(1, institutionID); 

			resultSet = statement.executeQuery();
			
			if (resultSet.next()) {
				institution = map(resultSet);
            }
			
            connection.close();
            
		} catch (SQLException e) {
			throw new DAOException(e);
		}
		
    	return institution;
    }

        
    private static Institution map(ResultSet resultSet) throws SQLException {
    	Institution institution = new Institution();
    	institution.setInstitutionID(resultSet.getInt("InstitutionID"));
    	institution.setName(resultSet.getString("Name"));

        return institution;
    }

}
