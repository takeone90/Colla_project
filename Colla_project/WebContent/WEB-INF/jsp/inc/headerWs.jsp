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
			var profileImg = JSON.parse(jsonStr.body).profileImg;
			var isFavorite = JSON.parse(jsonStr.body).isFavorite;
			var cmNum = JSON.parse(jsonStr.body).cmNum;
			if(userId == $("#userName").val()){
				addMyMsg("message",userId,message,writeTime,originName,isFavorite,cmNum);
			}else{
				addMsg("message",userId,message,writeTime,originName,isFavorite,cmNum);
			}
			
			$("#chatArea").scrollTop($("#chatArea")[0].scrollHeight);
		});
		
		//파일메세지 구독
		stompClient.subscribe("/category/file/"+crNum, function(jsonStr) {
			var userId = JSON.parse(jsonStr.body).userId;
			var fileName = JSON.parse(jsonStr.body).fileName;
			var originName = JSON.parse(jsonStr.body).originName;
			var writeTime = JSON.parse(jsonStr.body).writeTime;
			var profileImg = JSON.parse(jsonStr.body).profileImg;
			var isFavorite = JSON.parse(jsonStr.body).isFavorite;
			var cmNum = JSON.parse(jsonStr.body).cmNum;
			if(userId == $("#userName").val()){
				addMyMsg("file",userId,fileName,writeTime,originName,isFavorite,cmNum);
			}else{
				addMsg("file",userId,fileName,writeTime,originName,isFavorite,cmNum);
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
	//채팅방이고 추가채팅방인 경우에만 나가기 버튼 활성화
	if($("#crNum").val()!="" && $("#crIsDefault").val()=="0"){
		$("#exitChatRoom").show();
	}
	
	
}); //onload function end

</script>
<div id="wsMainHeader">

	<input type="hidden" value="${chatRoom.crNum}" id="crNum">
	<input type="hidden" value="${chatRoom.crIsDefault}" id="crIsDefault">
	<div class="container">
		<h1 id="logo">
			<a href="${contextPath}/workspace"> <img src="${contextPath}/img/COLLA_LOGO_200px_brighten.png" />
			</a>
		</h1>

		<div id="chatRoomInfo">
			<p>채팅방 이름</p>
		</div>
		<div id="etcBox"><a href="exitChatRoom?crNum=${chatRoom.crNum}" id="exitChatRoom">채팅방 나가기</a></div>
		<div class="main-nav"></div>
	</div>
	
		
</div>