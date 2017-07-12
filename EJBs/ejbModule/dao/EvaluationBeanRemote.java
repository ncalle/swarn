package dao;

import java.util.List;
import javax.ejb.Remote;

import entity.Evaluation;

@Remote
public interface EvaluationBeanRemote {

    public List<Evaluation> list() throws DAOException;
    
    public void create(Evaluation evaluation) throws IllegalArgumentException, DAOException;

}
