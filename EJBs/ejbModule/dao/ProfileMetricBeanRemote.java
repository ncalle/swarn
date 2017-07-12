package dao;

import java.util.List;
import javax.ejb.Remote;

import entity.Metric;
import entity.Profile;
import entity.ProfileMetric;

@Remote
public interface ProfileMetricBeanRemote {

    public List<ProfileMetric> profileMetricList(Profile profile, Integer unitID) throws DAOException;
    
    public void removeProfileMetric(Profile profile, ProfileMetric profileMetric) throws DAOException;
    
    public void profileAddMetric(Integer profileID, Metric metric) throws DAOException;
    
    public void update(ProfileMetric profileMetric) throws DAOException;
    
}