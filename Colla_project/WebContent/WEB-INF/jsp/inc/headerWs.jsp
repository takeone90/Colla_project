<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<div id="wsMainHeader">
	<div class="container">
		<h1 id="logo">
			<a href="${contextPath}/workspace">
				<img src="${contextPath}/img/COLLA_LOGO_200px_brighten.png"/>
			</a>
		</h1>
		
		<div id="chatRoomInfo">
			<p>채팅방 이름</p>
		</div>
		
		<div class="main-nav">
		</div>
	</div>
</div>