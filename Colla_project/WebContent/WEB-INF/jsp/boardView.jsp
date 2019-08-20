<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Board View</title>
</head>
<body>
	<h1> board view </h1>
	<table>
		<tr>
			<th>글 번호</th>
			<td>${board.num }</td>
		</tr>
		<tr>
			<th>글쓴이</th>
			<td>${writer}</td>
		</tr>
		<tr>
			<th>작성일</th>
			<td>${board.regDate }</td>
		</tr>
		<tr>
			<th>제목</th>
			<td>${board.title }</td>
		</tr>
		<tr>
			<th>내용</th>
			<td>${board.content }</td>
		</tr>
		<tr>
			<th>조회수</th>
			<td>${board.readCount}</td>
		</tr>
	</table>
	
</body>
</html>