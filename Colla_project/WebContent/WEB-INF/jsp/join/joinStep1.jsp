<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>joinStep1</title>
</head>
<body>
<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
	<form action="" method="post">
		 
		회원가입	
		EMAIL			
		<input type="email" name="m_email" placeholder="example@c0lla.com">
		<input type="submit" value="인증 메일 발송">
		<input type="button" onclick="location.href='joinStep2'" value="다음 단계">
		또는		
		<button onclick="">구글 계정 연동</button>	
		<button onclick="">네이버 계정 연동</button>
	</form>
</body>
</html>