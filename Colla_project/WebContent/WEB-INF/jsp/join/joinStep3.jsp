<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>joinStep3</title>
</head>
<body>
<%
String emailAddress = (String)session.getAttribute("emailAddress");
%>
<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
	<form action="joinMember" method="post">
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
		회원가입
		EMAIL
		<input type="email" name="email" readonly="readonly" value="${emailAddress}">
		PASSWORD
		<input type="password" name="pw">
		NAME
		<input type="text" name="name">
		<input type="checkbox">
		약관에 동의합니다.
		<input type="submit" value="시작하기">
	</form>
</body>
</html>