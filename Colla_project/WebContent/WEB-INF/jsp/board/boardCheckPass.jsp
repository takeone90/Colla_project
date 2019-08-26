<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 확인</title>
<link rel="stylesheet" type="text/css" href="../css/reset.css"/>
<link rel="stylesheet" type="text/css" href="../css/base.css"/>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp" %>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp" %>
	
	<div id="wsBody">
		<h3>게시글 비밀번호 확인</h3>
		<form action="" method="post">
			<input type="password" name="pw" placeholder="비밀번호를 입력해주세요">
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
			<button>확인</button>
			<a href="#" onclick="window.location.replace('list')">취소</a>
		</form>
	</div>
</body>
</html>