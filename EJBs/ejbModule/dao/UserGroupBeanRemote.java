package dao;

import java.util.List;
import javax.ejb.Remote;

import entity.UserGroup;

@Remote
public interface UserGroupBeanRemote {

    public List<UserGroup> list() throws DAOException;
    
    public UserGroup find(Integer usuarioid) throws DAOException;

}