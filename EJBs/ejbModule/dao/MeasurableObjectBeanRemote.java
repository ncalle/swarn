package dao;

import java.util.List;
import javax.ejb.Remote;

import entity.MeasurableObject;

@Remote
public interface MeasurableObjectBeanRemote {

    public List<MeasurableObject> list() throws DAOException;
    
    public List<MeasurableObject> list(Integer userID) throws DAOException;

    public void create(MeasurableObject measurableobject, String entityType) throws IllegalArgumentException, DAOException;

    public void delete(MeasurableObject measurableobject) throws DAOException;
    
    public List<MeasurableObject> userMeasurableObjectsToAddGet(Integer userID) throws DAOException;
    
    public void update(MeasurableObject measurableObject) throws DAOException;
    
    public List<MeasurableObject> servicesAndLayerGet(Integer userID, String EntityName, String EntityType) throws DAOException;
    
}
