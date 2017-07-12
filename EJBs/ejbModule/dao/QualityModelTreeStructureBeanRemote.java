package dao;

import java.util.List;
import javax.ejb.Remote;

import entity.QualityModelTreeStructure;

@Remote
public interface QualityModelTreeStructureBeanRemote {

    public List<QualityModelTreeStructure> list() throws DAOException;
    
    public void update(Integer elementID, String elementType, String name) throws DAOException;
    
    public void create(QualityModelTreeStructure element, Integer metricUnitID, Boolean metricIsManual, String metricDescription, Boolean isUserMetric, String metricFileName) throws IllegalArgumentException, DAOException;

}