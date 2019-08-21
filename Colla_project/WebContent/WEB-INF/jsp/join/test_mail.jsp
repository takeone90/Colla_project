<%@ page contentType="text/html; charset=UTF-8" %>
 
<%@ page import="mail.*"  %>
<%
String emailAddress = (String)request.getAttribute("emailAddress");
MailSend ms = new MailSend();
ms.MailSend(emailAddress);
 
out.println("메일 발송 성공");
%>
