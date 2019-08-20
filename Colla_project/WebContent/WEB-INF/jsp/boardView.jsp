<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
    <c:set var="contextPath" value="<%=request.getContextPath() %>"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Board view</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
</head>
<body>
	<div class="container">
		<h1>board view</h1>
			<table class="table">

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
			<button class="button" onclick="history.go(-1)">뒤로가기</button>
	</div>
</body>
</html>