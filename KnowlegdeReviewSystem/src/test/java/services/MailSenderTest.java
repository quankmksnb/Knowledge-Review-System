package services;

import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;

class MailSenderTest {
    @Test
    void sendMail() {
        services.MailSender.sendEmail("nguyenphuc10022004@gmail.com", "TestSendEmail", "Email Sended Successfully");
    }

    @Test
    void sendMailBcc() {
        List<String> emails = new ArrayList<>();
        emails.add("nguyenphuc10022004@gmail.com");
        emails.add("taolagido123@gmail.com");
        services.MailSender.sendEmailBcc(emails, "TestSendEmailBcc", "Email Sended Successfully");
    }
}