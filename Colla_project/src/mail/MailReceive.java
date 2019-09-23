package mail;

import java.io.UnsupportedEncodingException;
import java.util.Date;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class MailReceive {
    public void MailReceive(String name, String email, String title, String content) {
        Properties prop = System.getProperties();
        prop.put("mail.smtp.starttls.enable", "true");
        prop.put("mail.smtp.host", "smtp.gmail.com");
        prop.put("mail.smtp.auth", "true");
        prop.put("mail.smtp.port", "587");
        Authenticator auth = new MailAuth();
        Session session = Session.getDefaultInstance(prop, auth);
        MimeMessage msg = new MimeMessage(session);
        try {
            msg.setSentDate(new Date());
            msg.setFrom(new InternetAddress("collacolla19@gmail.com", "colla"));
            InternetAddress to = new InternetAddress("collacolla19@gmail.com");         
            msg.setRecipient(Message.RecipientType.TO, to);            
            msg.setSubject("FAQ 테스트", "UTF-8"); //제목
            msg.setContent(name+"님이 문의하신 내용입니다. "
            		+"제목 : "+title
            		+"\r내용 : "+content
            		+"\r답장 : "+email, "text/html;charset=UTF-8"); //내용
            Transport.send(msg);
        } catch(AddressException ae) {            
            System.out.println("AddressException : " + ae.getMessage());           
        } catch(MessagingException me) {            
            System.out.println("MessagingException : " + me.getMessage());
        } catch(UnsupportedEncodingException e) {
            System.out.println("UnsupportedEncodingException : " + e.getMessage());			
        }        
    }
}
