<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
	<form action="login" method="post">	
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
		<input type="text" name="m_email" placeholder="아이디를 입력해주세요">
		<input type="password" name="m_pw" placeholder="비밀번호를 입력해주세요">
		<input type="submit" value="로그인">
	</form>
	<button onclick="">구글 계정 연동</button>
	<button onclick="">네이버 계정 연동</button>
	
	<h3>
		<c:if test='${param.login eq "false"}'>
			로그인 후 이용하세요.
		</c:if>
		<c:if test='${param.login eq "fail"}'>
			로그인에 실패하였습니다.
		</c:if>
	</h3>
		
</body>
</html>