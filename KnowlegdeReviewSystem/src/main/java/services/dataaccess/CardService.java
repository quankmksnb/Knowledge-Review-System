package services.dataaccess;

import models.dao.CardDAO;

public class CardService {
    private CardDAO cardDAO;

    public CardService() {
        this.cardDAO = new CardDAO();
    }

    public boolean add(int userId, int termId) {
        return cardDAO.add(userId, termId);
    }

    public boolean delete(int userId, int termId) {
        return cardDAO.delete(userId, termId);
    }
}
