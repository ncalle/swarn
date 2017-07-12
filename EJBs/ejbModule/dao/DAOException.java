package dao;

import javax.ejb.ApplicationException;

/**
 * Representa una excepcion generia DAO. 
 * Envuelve cualquier excepcion de codigo subyacente, como SQLExceptions.
 */
@ApplicationException(rollback = true)
public class DAOException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    public DAOException(String message) {
        super(message);
    }

    public DAOException(Throwable cause) {
        super(cause);
    }

    public DAOException(String message, Throwable cause) {
        super(message, cause);
    }

}
