<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
	String contextPath = request.getContextPath();
	request.setAttribute("contextPath", contextPath);
%>
<title>라이선스관리</title>
<link rel="stylesheet" type="text/css" href="css/reset.css"/>
<link rel="stylesheet" type="text/css" href="css/base.css"/>
<link rel="stylesheet" type="text/css" href="css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="css/navMyPage.css"/>
<script src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous"></script>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%>
	<%@ include file="/WEB-INF/jsp/inc/navMyPage.jsp"%>
	<div id="wsBody">
	<h1>라이선스</h1>
	회원님의 라이선스는 ${useLicense.endDate } 종료 예정입니다<br>
	<button onclick="#">라이선스 연장</button>
	<button onclick="#">라이선스 변경</button>
	
	<h4>결제 내역</h4>
	<table border="1">
		<tr>
			<td>라이선스 종류</td>
			<td>결제일</td>
			<td>만료일</td>
		</tr>
		<c:forEach items="${licenseList }" var="license">
			<tr>
				<td>${license.type }</td>
				<td>${license.startDate }</td>
				<td>${license.endDate }</td>
			</tr>		
		</c:forEach>
	</table>
</div>

</body>
</html>