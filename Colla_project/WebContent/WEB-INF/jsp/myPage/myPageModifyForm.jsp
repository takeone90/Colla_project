<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
	String contextPath = request.getContextPath();
	request.setAttribute("contextPath", contextPath);
%>
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous"></script>
</head>
<body>
	<h1>마이페이지 수정</h1>
	<form action="modifyMember" method="post">
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
		이메일 : <input type="text" name="email" value="${member.email}">
		이름 : <input type="text" name="name" value="${member.name}">
		비밀번호 : <input type="tel" name="pw" value="${member.pw}">
		전화번호 : <input type="tel" name="phone" value="${member.phone}">
		<input type="submit" value="수정">
	</form>

</body>
</html>