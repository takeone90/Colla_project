<%@page import="javax.naming.Context"%>
<%@page import="controller.LoginManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript">
	<%
		String contextPath = request.getContextPath();
		request.setAttribute("contextPath", contextPath);
		LoginManager loginManager = new LoginManager();
		String userEmail = (String)session.getAttribute("userEmail");
	%>
	var alert = confirm("이미 로그인 되어있습니다. 기존 접속한 아이디를 로그아웃 하겠습니다");
	location.href="${contextPath}/workspace";
</script>
</head>
<body>

</body>
</html>