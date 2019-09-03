<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="<%=request.getContextPath()%>" />
<c:set var="member" value="<%=request.getSession().getAttribute(\"user\")%>" />
<script type="text/javascript" src="js/stomp.js"></script>
<script type="text/javascript" src="js/sockjs.js"></script>
<script>
var sock;
var stompClient;
function duplicateConnect(){
	sock = new SockJS("${contextPath}/chat");
	stompClient = Stomp.over(sock);
	stompClient.connect({},function(){
		stompClient.subscribe("/category/msg/" + ${member.num},function(){
			alert("로그인 요청 시도가 있었습니다.");
			$.ajax({ 
				url : "${contextPath}/dropSession"
			});
			location.href="main";
		});// end subcribe
	}); //end connect
}// end duplicateConnect

$(function(){
	duplicateConnect();
}); //onload function end

</script>
<div id="wsMainHeader">
	<div class="container">
		<h1 id="logo">
			<a href="${contextPath}/workspace"> <img
				src="../img/COLLA_LOGO_200px_brighten.png" />
			</a>
		</h1>

		<div id="chatRoomInfo">
			<p>채팅방 이름</p>
		</div>

		<div class="main-nav"></div>
	</div>
</div>