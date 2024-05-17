package com.example.Logystics.service;

import org.springframework.stereotype.Service;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

@Service
public class MailService {
    private Properties properties;
    private static String propFileName = "src/main/resources/mail.properties";
    public MailService() {
        properties = new Properties();

        try {
            FileInputStream inputStream = null;
            inputStream = new FileInputStream(propFileName);
            properties.load(inputStream);

        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
    public boolean send(String subject, String text, String receiverEmail) {
        return send(subject, text, receiverEmail, null);
    }

    public boolean send(String subject, String text, String receiverEmail, String attachFilePath) {
        try{
            Session session = Session.getDefaultInstance(properties, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(properties.getProperty("username"), properties.getProperty("password"));
                }
            });

            MimeMessage mimeMessage = new MimeMessage(session);
            mimeMessage.setFrom(new InternetAddress("no-reply@gmail.com"));

            mimeMessage.setRecipient(Message.RecipientType.TO, new InternetAddress(receiverEmail));
            mimeMessage.setSubject(subject);
            mimeMessage.setText(text);

            if (attachFilePath != null) {
                MimeBodyPart attachmentPart = new MimeBodyPart();
                attachmentPart.attachFile(new File(attachFilePath));
                Multipart multipart = new MimeMultipart();
                multipart.addBodyPart(attachmentPart);
                mimeMessage.setContent(multipart);
            }

            Transport.send(mimeMessage);

            return true;
        }catch (Exception e){
            return false;
        }
    }
}
