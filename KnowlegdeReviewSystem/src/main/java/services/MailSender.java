package services;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.List;
import java.util.Properties;

public class MailSender {

    private static final String smtpHost = "smtp.gmail.com"; // SMTP server (e.g., Gmail)
    private static final int smtpPort = 587; // SMTP port
    private static final String username = "katdev1002@gmail.com"; // Your email
    private static final String password = System.getenv("MAIL_SENDER_PASSWORD"); // Your email password or app password

    public static void sendEmail(String toEmail, String subject, String messageText) {
        // SMTP server properties
        Properties properties = new Properties();
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.host", smtpHost);
        properties.put("mail.smtp.port", String.valueOf(smtpPort));

        //System.out.println(System.getenv("mailSenderPassword"));

        // Create a session with an authenticator
        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        try {
            // Create a MimeMessage object
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            // Set the actual message
            message.setContent(messageText, "text/html; charset=utf-8");

            // Send the email
            Transport.send(message);
            System.out.println("Email sent successfully to " + toEmail);
        } catch (MessagingException e) {
            System.err.println("Failed to send email: " + e.getMessage());
        }
    }

    public static void sendEmailBcc(List<String> toEmails, String subject, String body) {
        // SMTP server properties
        Properties properties = new Properties();
        properties.put("mail.smtp.host", "smtp.gmail.com"); // Replace with your SMTP host
        properties.put("mail.smtp.port", "587"); // Replace with your SMTP port
        properties.put("mail.smtp.auth", "true"); // Enable authentication
        properties.put("mail.smtp.starttls.enable", "true"); // Enable STARTTLS

        // Get the Session object
        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        try {
            // Create a MimeMessage object
            Message message = new MimeMessage(session);

            // Set From: header field
            message.setFrom(new InternetAddress(username));

            // Set Bcc: header field
            for (String toEmail : toEmails) {
                message.addRecipient(Message.RecipientType.BCC, new InternetAddress(toEmail));
            }

            // Set Subject: header field
            message.setSubject(subject);

            // Set the actual message
            message.setContent(body, "text/html; charset=utf-8");

            // Send the message
            Transport.send(message);

            System.out.println("Email sent successfully!");

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

}
