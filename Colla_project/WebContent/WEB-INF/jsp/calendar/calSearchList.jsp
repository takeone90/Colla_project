<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
String contextPath = request.getContextPath();
request.setAttribute("contextPath", contextPath);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>calSearchList</title>
</head>
<body>
	<form action="calSearchList">
		<input type="text" name="calSearch" placeholder="검색어를 입력해주세요.">
		<input type="submit" value="검색">
	</form>
	<button onclick="">일정 추가</button>
	<label><input type="checkbox" name="calType" id="calType" value="project">프로젝트</label>
	<label><input type="checkbox" name="calType" id="calType" value="vacation">휴가</label>
	<label><input type="checkbox" name="calType" id="calType" value="event">행사</label>
	<button onclick="location.href='${contextPath}/calMonth'">월간</button>
	<button onclick="location.href='${contextPath}/calYear'">연간</button>
	
</body>
</html>