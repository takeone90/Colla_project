<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<div id="wsNav">
	<div>
		<div>
			<a href="myPageMainForm">
				<img alt="나의 프로필 사진" src="img/pic.jpg" style="width:50px;">
			</a>
		</div>
		<div>
			<p>${sessionScope.user.name}님 반갑습니다^^</p>
		</div>
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
	
	<ul id="ws-subfunction">
		<li>
			<a>Calendar</a>
		</li>
		<li>
			<a>Board</a>
		</li>
	</ul>
</div>