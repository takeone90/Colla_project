package mail;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class MailAuth extends Authenticator{
    PasswordAuthentication pa;
    public MailAuth() {
        String mail_id = "collacolla19@gmail.com";
        String mail_pw = "메일 비밀번호"; 
        pa = new PasswordAuthentication(mail_id, mail_pw);
    }
    public PasswordAuthentication getPasswordAuthentication() {
        return pa;
    }
}
