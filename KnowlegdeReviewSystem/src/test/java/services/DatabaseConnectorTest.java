package services;

import org.junit.jupiter.api.Test;

import java.sql.Connection;

import static org.junit.jupiter.api.Assertions.assertNotNull;

class DatabaseConnectorTest {

    @Test
    void testConnection() {
        Connection connection = null;
        connection = DatabaseConnector.getConnection();
        assertNotNull(connection);
    }
}