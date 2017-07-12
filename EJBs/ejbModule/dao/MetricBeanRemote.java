package dao;

import java.util.List;
import javax.ejb.Remote;

import entity.Metric;

@Remote
public interface MetricBeanRemote {

    public List<Metric> list() throws DAOException;
    
    public List<Metric> profileMetricsToAddGet(Integer profileID) throws DAOException;

}
