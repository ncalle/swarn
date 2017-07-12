package dao;

import javax.ejb.ApplicationException;

/**
 * Representa una excepcion en la configuración DAO, que no puede ser resuelta en tiempo de ejecucion,
 * como un archivo faltante en el classpath o una propiedad faltante.
 */
@ApplicationException(rollback = true)
public class DAOConfigurationException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    public DAOConfigurationException(String message) {
        super(message);
    }

    public DAOConfigurationException(Throwable cause) {
        super(cause);
    }

    public DAOConfigurationException(String message, Throwable cause) {
        super(message, cause);
    }

}