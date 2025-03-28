package services.dataaccess;

import models.dao.TermDomainDAO;

public class TermDomainService {
    private TermDomainDAO termDomainDAO;

    public TermDomainService() {
        this.termDomainDAO = new TermDomainDAO();
    }

    public int addTermDomain(int termId, int configId) throws Exception {
        try {
            return termDomainDAO.addTermDomain(termId, configId);
        } catch (Exception e) {
            throw new Exception("Failed to add term domain: " + e.getMessage());
        }
    }

    public int deleteByTermId(int termId) throws Exception {
        try {
            return termDomainDAO.deleteByTermId(termId);
        } catch (Exception e) {
            throw new Exception("Failed to delete term domain: " + e.getMessage());
        }
    }
}