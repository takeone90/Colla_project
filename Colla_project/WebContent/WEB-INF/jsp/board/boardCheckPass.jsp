<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath() %>"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 확인</title>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/reset.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/base.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
</head>
<body>
	<c:if test="${ not empty param.msg }"  >
		<script>
			$(function(){
				alert("비밀번호가 일치하지 않습니다.");
				history.replaceState('','','checkPass?bNum=${updateMap.bNum}&mode=modify');
			})
 		</script> 
	</c:if>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp" %>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp" %>
	<div id="wsBody">
		<h3>게시글 비밀번호 확인</h3>
		<form id="passForm" action="checkPass" method="post">
			<input type="password" name="pw" placeholder="비밀번호를 입력해주세요">
			<input type="hidden" name="bNum" value="${updateMap.bNum }">
			<input type="hidden" name="mode" value="${updateMap.mode }">
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
			<button>확인</button>
			<a href="${contextPath }/board/view?num=${updateMap.bNum}">취소</a>
			<script>
			</script>
		</form>
	</div>
</body>
</html>