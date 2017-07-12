package dao;

import java.util.List;
import javax.ejb.Remote;

import entity.IdeTreeStructure;

@Remote
public interface IdeTreeStructureBeanRemote {

    public List<IdeTreeStructure> list(Integer userID) throws DAOException;

}