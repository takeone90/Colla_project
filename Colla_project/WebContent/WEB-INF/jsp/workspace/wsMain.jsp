<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="<%=request.getContextPath()%>" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp" %>
<%@ include file="/WEB-INF/jsp/inc/navWs.jsp" %>
	<div id="wsBody">
		<h2>Workspace</h2>
		<h3>Workspace List</h3>
		<ul>
			<li class="ws">
				<h4>
					<a href="chatMain">질수없조프로젝트1</a>
				</h4>
				<div class="wsDetail">
					<div class="wsChatList">
						<p>chat List</p>
						<ul>
							<li>개발팀</li>
							<li>편집팀</li>
							<li>재무팀</li>
						</ul>
					</div>
					<div class="wsMember">
						<p>member List</p>
						<ul>
							<li>이태권</li>
							<li>김미경</li>
							<li>김수빈</li>
							<li>박혜선</li>
						</ul>
					</div>
				</div>
			</li>
		</ul>
		<div>
			<a href="#">나가기</a>
		</div>

	</div>
</body>
</html>