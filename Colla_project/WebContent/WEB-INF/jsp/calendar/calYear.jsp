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
<title>calYear</title>
<script src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous"></script>
<script>
$(function() {
	var today = new Date();
	var year = today.getFullYear();
	var calYearTitle = $("#calYearTitle");
	calYearTitle.html(year+"년 ");
	
	var calendar = "<table border = '1'>";
	calendar += "<tr>";
	calendar += "<th>1월</th>";
	calendar += "<th>2월</th>";
	calendar += "<th>3월</th>";
	calendar += "<th>4월</th>";
	calendar += "</tr>";
	calendar += "<tr>";
	calendar += "<th>5월</th>";
	calendar += "<th>6월</th>";
	calendar += "<th>7월</th>";
	calendar += "<th>8월</th>";
	calendar += "</tr>";
	calendar += "<tr>";
	calendar += "<th>9월</th>";
	calendar += "<th>10월</th>";
	calendar += "<th>11월</th>";
	calendar += "<th>12월</th>";
	calendar += "</tr>";
	
	var calYearBody = $("#calYearBody");
	calYearBody.html(calendar);
});
</script>
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

	
	<h1 id="calYearTitle"></h1>
	<div id="calYearBody"></div>
</body>
</html>