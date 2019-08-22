<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>joinStep1</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script type="text/javascript">
/* function send_mail(){
	var emailAddress = $("input[name=emailAddress]").val();
    window.open("testMail?emailAddress="+emailAddress, "", "width=370, height=360, resizable=no, scrollbars=no, status=no");
    
} */
</script>
</head>
<body>
<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
	<form action="testMail" method="post">
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
		EMAIL			
		<input type="email" name="emailAddress" placeholder="example@c0lla.com">
		<input type="submit" value="인증메일 발송">
	</form>
	<!-- <input type="button" onclick="location.href='joinStep2'" value="다음 단계"><br> -->
	또는		
	<button onclick="">구글 계정 연동</button>	
	<button onclick="">네이버 계정 연동</button>
	
</body>
</html>