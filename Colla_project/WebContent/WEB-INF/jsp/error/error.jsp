<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>
<c:set var="contextPath" value="<%=request.getContextPath() %>"/>
<title>에러화면</title>
</head>
<body>
	<div>
		<h1>잘못된 접근입니다.</h1>
		<a href="${contextPath}/"><i class="fas fa-angle-left"></i>메인화면으로</a>
	</div>
</body>
</html>