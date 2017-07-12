package dao;

import java.util.List;
import javax.ejb.Remote;

import entity.EvaluationSummary;

@Remote
public interface EvaluationSummaryBeanRemote {

    public List<EvaluationSummary> list() throws DAOException;
    
    public EvaluationSummary create(EvaluationSummary evaluationSummary) throws IllegalArgumentException, DAOException;

}
