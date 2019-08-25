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
<title>마이페이지 메인</title>
<script src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous"></script>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp"%>
	<h1>마이페이지메인</h1>
	<img src="">
	<p>이메일 : ${member.email}</p>
	<p>이름 : ${member.name}</p>
	<p>전화번호 : ${member.phone}</p>
	<!-- 삭제예정 start -->
	<button onclick="location.href='${contextPath}/myPageCheckPassForm'">회원정보관리</button>
	<button onclick="location.href='${contextPath}/myPageAlarmForm'">알림설정</button>
	<button onclick="location.href='${contextPath}/myPageLicenseForm'">라이센스</button>
	<!-- 삭제예정 end -->
</body>
</html>