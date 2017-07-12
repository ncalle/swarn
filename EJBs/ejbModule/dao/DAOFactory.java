package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import javax.sql.DataSource;

/**
 * Representa DAO factory para bases de datos.
 * Utilizar getInstance para obtener una instancia de la base de datos, que depende del archivo properties de configuracion.
 */
public abstract class DAOFactory {

    private static final String URL = "jdbc:postgresql://localhost:5432/geoservicequality";
    private static final String DRIVER = "org.postgresql.Driver";
    private static final String USERNAME = "postgres";
    private static final String PASSWORD = "root";

    public static DAOFactory getInstance(String name) throws DAOConfigurationException {
        if (name == null) {
            throw new DAOConfigurationException("Database name is null.");
        }

        
        DAOFactory instance;

        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            throw new DAOConfigurationException(
                "Error en el driver de conexion a la base de datos.", e);
        }
        instance = new DriverManagerDAOFactory(URL, USERNAME, PASSWORD);

        return instance;
    }

    abstract Connection getConnection() throws SQLException;

    public UserBeanRemote getUserBeanRemote() {
        return new UserBean(this);
    }
    
    public MeasurableObjectBeanRemote geMeasurableObjectBeanRemote() {
        return new MeasurableObjectBean(this);
    }

}


class DriverManagerDAOFactory extends DAOFactory {
    private String url;
    private String username;
    private String password;

    DriverManagerDAOFactory(String url, String username, String password) {
        this.url = url;
        this.username = username;
        this.password = password;
    }

    @Override
    Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, username, password);
    }
}


class DataSourceDAOFactory extends DAOFactory {
    private DataSource dataSource;

    DataSourceDAOFactory(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Override
    Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }
}

class DataSourceWithLoginDAOFactory extends DAOFactory {
    private DataSource dataSource;
    private String username;
    private String password;

    DataSourceWithLoginDAOFactory(DataSource dataSource, String username, String password) {
        this.dataSource = dataSource;
        this.username = username;
        this.password = password;
    }

    @Override
    Connection getConnection() throws SQLException {
        return dataSource.getConnection(username, password);
    }
}
