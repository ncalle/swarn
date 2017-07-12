package dao;

import java.util.List;
import javax.ejb.Remote;

import entity.Report;


@Remote
public interface ReportBeanRemote {

    public List<Report> geographicServicesPerInstitution() throws DAOException;
    
    public List<Report> evaluationSuccessVsFailed() throws DAOException;
    
    public List<Report> evaluationsPerMetric() throws DAOException;
    
    public List<Report> successEvaluationPerProfile() throws DAOException;
    
    public List<Report> successEvaluationPerInstitution() throws DAOException;
    
    public List<Report> successEvaluationPerNode() throws DAOException;
    
    public List<Report> topBestWorstMeasurableObjectGet(Integer Top, Boolean SuccessFlagAsc, Boolean SuccessFlagDesc) throws DAOException;
}