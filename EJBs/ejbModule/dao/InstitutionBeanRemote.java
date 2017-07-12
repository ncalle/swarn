package dao;

import java.util.List;
import javax.ejb.Remote;

import entity.Institution;

@Remote
public interface InstitutionBeanRemote {

    public List<Institution> list() throws DAOException;
    
    public Institution find(Integer institutionID) throws DAOException;

}