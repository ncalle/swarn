package dao;

import java.util.List;
import javax.ejb.Remote;

import entity.Metric;
import entity.Profile;

@Remote
public interface ProfileBeanRemote {

    public List<Profile> list() throws DAOException;

    public void create(Profile profile, List<Metric> metrics) throws IllegalArgumentException, DAOException;

    public void delete(Profile profile) throws DAOException;
    
    public void update(Profile profile) throws DAOException;
    
}
