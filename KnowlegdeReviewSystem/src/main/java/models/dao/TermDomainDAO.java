package models.dao;

import models.Term;
import services.DatabaseConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class TermDomainDAO extends DatabaseConnector {
    Connection connection = getConnection();
    public int addTermDomain(int termId, int configId) throws Exception {
        String sql = "INSERT INTO term_domain (term_id, domain_id) VALUES (?, ?)";
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, termId);
            preparedStatement.setInt(2, configId);
            return preparedStatement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }

    public int deleteByTermId(int termId) throws Exception {
        String sql = "DELETE FROM term_domain WHERE term_id = ?";
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, termId);
            return preparedStatement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public static void main(String[] args) throws Exception {
        TermDomainDAO dao = new TermDomainDAO();
        System.out.println(dao.deleteByTermId(61));
        System.out.println(dao.addTermDomain(61, 1));
    }
}
