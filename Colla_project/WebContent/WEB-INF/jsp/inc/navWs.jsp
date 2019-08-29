<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="<%=request.getContextPath() %>"/>
<div id="wsNav">
	<div id="navContainer">
		<div id="aboutProfile">
			<a href="myPageMainForm">
				<img alt="나의 프로필 사진" src="../img/pic.jpg" />
			</a>
			<p>${sessionScope.user.name}님</p>
		</div>
		<select name="currWorkspace">
			<option value="1" selected>질수없조프로젝트</option>
			<option value="2"></option>
			<option value="3"></option>
		</select>
		<div id="myChatList">
			<h3>
				My Chats
			</h3>
			<ul class="chatList">
				<c:forEach items="${chatRoomList}" var="cr">
				<li>
					<a href="chatMain?crNum=${cr.crNum}">${cr.crName}</a>
				</li>
				</c:forEach>
			</ul>
		</div>
		<hr>
		<ul id="ws-subfunction" class="clearFix">
			<li>
				<a href="${contextPath}/calMonth">Calendar</a>
			</li>
			<li>
				<a href="board/list">Board</a>
	    	</li>
		</ul>
	</div>
</div>