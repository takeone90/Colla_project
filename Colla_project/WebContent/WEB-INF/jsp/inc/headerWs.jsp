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
		<%----------------------------------------채팅메시지 구독부분----------------------------------------------%>
		var crNum = $("#crNum").val();
		//일반메세지 구독
		stompClient.subscribe("/category/msg/"+crNum,function(jsonStr){
			var userId = JSON.parse(jsonStr.body).userId;
			var message = JSON.parse(jsonStr.body).message;
			var originName = "";
			var writeTime = JSON.parse(jsonStr.body).writeTime;
			if(userId == $("#userName").val()){
				addMyMsg("message",userId,message,writeTime,originName);
			}else{
				addMsg("message",userId,message,writeTime,originName);
			}
			
			$("#chatArea").scrollTop($("#chatArea")[0].scrollHeight);
		});
		
		//파일메세지 구독
		stompClient.subscribe("/category/file/"+crNum, function(jsonStr) {
			var userId = JSON.parse(jsonStr.body).userId;
			var fileName = JSON.parse(jsonStr.body).fileName;
			var originName = JSON.parse(jsonStr.body).originName;
			var writeTime = JSON.parse(jsonStr.body).writeTime;
			if(userId == $("#userName").val()){
				addMyMsg("file",userId,fileName,writeTime,originName);
			}else{
				addMsg("file",userId,fileName,writeTime,originName);
			}
			$("#chatArea").scrollTop($("#chatArea")[0].scrollHeight);
		});
		<%-----------------------------------------------------------------------------------------------------%>
		
		stompClient.subscribe("/category/loginMsg/" + ${member.num},function(){
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
			<a href="${contextPath}/workspace"> <img src="${contextPath}/img/COLLA_LOGO_200px_brighten.png" />
			</a>
		</h1>

		<div id="chatRoomInfo">
			<p>채팅방 이름</p>
		</div>

		<div class="main-nav"></div>
	</div>
</div>