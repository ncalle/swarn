package dao;

import java.util.List;
import javax.ejb.Remote;

import entity.QualityWeightTreeStructure;

@Remote
public interface QualityWeightTreeStructureBeanRemote {

    public List<QualityWeightTreeStructure> list(Integer profileID) throws DAOException;
    
    public void update(Integer nominator, Integer denominator, Integer weighingID) throws DAOException;

}