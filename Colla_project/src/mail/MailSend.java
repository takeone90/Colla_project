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
 
public class MailSend {
    public void MailSend(String emailAddress, String code, String type) {
        Properties prop = System.getProperties();
        prop.put("mail.smtp.starttls.enable", "true");
        prop.put("mail.smtp.host", "smtp.gmail.com");
        prop.put("mail.smtp.auth", "true");
        prop.put("mail.smtp.port", "587");
        Authenticator auth = new MailAuth();
        Session session = Session.getDefaultInstance(prop, auth);
        MimeMessage msg = new MimeMessage(session);
        String mailTitle = null;
        if(type.equals("verifyCode")) {
        	mailTitle = "[COLLA] 회원가입 인증코드 메일입니다.";
        } else if(type.equals("resetCode")) {
        	mailTitle = "[COLLA] 비밀번호 재설정 인증코드 메일입니다.";
        } else {
        	mailTitle = "[COLLA] 워크스페이스 초대 메일입니다.";
        }
        try {
            msg.setSentDate(new Date());
            msg.setFrom(new InternetAddress("collacolla19@gmail.com", "colla"));
            InternetAddress to = new InternetAddress(emailAddress);         
            msg.setRecipient(Message.RecipientType.TO, to);            
            msg.setSubject(mailTitle, "UTF-8");
            msg.setContent(code,"text/html;charset=UTF-8");
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