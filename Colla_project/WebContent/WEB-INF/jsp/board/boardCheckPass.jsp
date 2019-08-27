<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 확인</title>
<link rel="stylesheet" type="text/css" href="../css/reset.css"/>
<link rel="stylesheet" type="text/css" href="../css/base.css"/>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp" %>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp" %>
	<c:if test="${ msg ne null }" >
		<script>
			alert("비밀번호가 일치하지 않습니다.");
 		</script> 
	</c:if>
	<div id="wsBody">
		<h3>게시글 비밀번호 확인</h3>
		<form id="passForm" action="checkPass" method="post">
			<input type="password" name="pw" placeholder="비밀번호를 입력해주세요">
			<input type="hidden" name="bNum" value="${updateMap.bNum }">
			<input type="hidden" name="mode" value="${updateMap.mode }">
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
			<button>확인</button>
			<a href="#" onclick="window.location.replace('list')">취소</a>
			<script>
			</script>
		</form>
	</div>
</body>
</html>