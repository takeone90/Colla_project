<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<% 
String contextPath = request.getContextPath();
request.setAttribute("contextPath", contextPath);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" type="text/css" href="css/reset.css"/>
<link rel="stylesheet" type="text/css" href="css/base.css"/>
<link rel="stylesheet" type="text/css" href="css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="css/navWs.css"/>
<script src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous"></script>
<title>calSearchList</title>
</head>
<body>
<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%>
<%@ include file="/WEB-INF/jsp/inc/navWs.jsp"%>
<div id="wsBody">
<div id="wsBodyContainer">
	<form action="calSearchList">
		<select name="searchType">
			<option value="1">제목</option>
			<option value="2">내용</option>
			<option value="3">제목+내용</option>
			<option value="4">작성자</option>
		</select>
		<input type="text" name="searchKeyword" placeholder="검색어를 입력해주세요.">
		<input type="submit" value="검색">
	</form>
	<label><input type="checkbox" name="calType" id="calType" value="project">프로젝트</label>
	<label><input type="checkbox" name="calType" id="calType" value="vacation">휴가</label>
	<label><input type="checkbox" name="calType" id="calType" value="event">행사</label>
	<button onclick="location.href='${contextPath}/calMonth'">월간</button>
	<button onclick="location.href='${contextPath}/calMonth'">연간</button>
	<table>
		<tr>
			<th>제목</th>
			<th>내용</th>
			<th>작성자</th>
		</tr>
		<c:forEach items="${searchedCalendarList}" var="schedule">
			<tr>
				<td>${schedule.title}</td>
				<td>${schedule.content}</td>
				<td>${schedule.mName}</td>
			</tr>
		</c:forEach>
	</table>
</div>
</div>	
</body>
</html>