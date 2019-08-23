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
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous"></script>
</head>
<body>
<!-- 
	https://blog.naver.com/coding-/221400113716
 -->
	<h1>알림설정</h1>
	<p>워크스페이스 초대 알림</p>
	<p>공지 알림</p>
	<p>게시글 댓글 알림</p>
	
	<input type="checkbox" id="wsAlarm">
	<input type="checkbox" id="boardAlarm">
	<input type="checkbox" id="replyAlarm">
</body>
</html>