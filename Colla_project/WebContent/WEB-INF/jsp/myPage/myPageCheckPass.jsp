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
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.4.1.js"
	integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
	crossorigin="anonymous"></script>
<style type="text/css">
#myPageCheckPass form * {
	display: inline-block;
}

#myPageCheckPass form .title {
	width: 150px;
	text-align: right;
}

#myPageCheckPass form .content {
	width: 300px;
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp"%>
	<div id="wsBody">
		<h3>마이페이지</h3>
		<h4>회원정보 관리</h4>
		<div id="myPageCheckPass">
			<form action="myPageCheckPass" method="post">
				<p class="title">비밀번호 확인</p>
				<input type="password" name="pw" class="content">
				<button>확인</button>
			</form>
		</div>
	</div>

	<h3>
		<c:if test='${param.checkPass eq "fail"}'>
			비밀번호를 확인해주세요
		</c:if>
	</h3>
</body>
</html>