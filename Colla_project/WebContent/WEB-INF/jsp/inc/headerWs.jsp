<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="<%=request.getContextPath()%>" />
<c:set var="member" value="<%=request.getSession().getAttribute(\"user\")%>" />
<script type="text/javascript" src="${contextPath }/js/stomp.js"></script>
<script type="text/javascript" src="${contextPath }/js/sockjs.js"></script>
<script>
var sock;
var stompClient;
var msgInfo;
function duplicateConnect(){
	sock = new SockJS("${contextPath}/chat");
	stompClient = Stomp.over(sock);
	stompClient.connect({},function(){
		<%----------------------------------------채팅메시지 구독부분----------------------------------------------%>
		var crNum = $("#crNum").val();
		//일반메세지 구독
		stompClient.subscribe("/category/msg/"+crNum,function(cm){
				msgInfo = JSON.parse(cm.body);
				addMsg(msgInfo);
				$("#chatArea").scrollTop($("#chatArea")[0].scrollHeight);
		});
		
		//파일메세지 구독
		stompClient.subscribe("/category/file/"+crNum, function(cm) {
				msgInfo = JSON.parse(cm.body);
				addMsg(msgInfo);
				$("#chatArea").scrollTop($("#chatArea")[0].scrollHeight);
		});
		
		//코드메시지 구독
		stompClient.subscribe("/category/code/"+crNum, function(cm){
				msgInfo = JSON.parse(cm.body);
				addMsg(msgInfo);
				$("#chatArea").scrollTop($("#chatArea")[0].scrollHeight);
		});
		
		//map메시지 구독
		stompClient.subscribe("/category/map/"+crNum, function(cm){
				msgInfo = JSON.parse(cm.body);
				addMsg(msgInfo);
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
	
	var pageType = $("#pageType").val();
	if(pageType=="chatroom"){
		//채팅방이고 추가채팅방인 경우에만 나가기 버튼 활성화
		if($("#crNum").val()!="" && $("#isDefault").val()=="0"){
			$("#exitChatRoom").show();
		}
		//헤더에 채팅방과 워크스페이스 정보 바꾸기
		var isDefault = $("#isDefault").val();
		if(isDefault==1){ //기본채팅방이면
			$("#chatRoomInfo > p").text("기본채팅방");
			$(".addCrMember").hide();
		}else{
		 	var crName = $("#crName").val();
		 	$("#chatRoomInfo > p").text(crName);
		}
	}else if(pageType=="calendar"){
		$("#chatRoomInfo > p").text("캘린더");
	}else if(pageType=="board"){
		$("#chatRoomInfo > p").text("자유게시판");
	}else if(pageType=="workspace"){
		$("#chatRoomInfo > p").text("워크스페이스 메인");
	}
	
	
	
}); //onload function end

</script>
<div id="wsMainHeader">
	
<%-- 	<input type="hidden" value="${chatRoom.crNum}" id="crNum"> --%>
<%-- 	<input type="hidden" value="${chatRoom.crIsDefault}" id="crIsDefault"> --%>
	<div class="container">
		<h1 id="logo">
			<a href="${contextPath}/workspace"> <img src="${contextPath}/img/COLLA_LOGO_200px_brighten.png" />
			</a>
		</h1>

		<div id="chatRoomInfo">
			<p>페이지 이름</p>
		</div>
		<div id="etcBox"><a href="exitChatRoom?crNum=${chatRoom.crNum}" id="exitChatRoom">채팅방 나가기</a></div>
		<div class="main-nav"></div>
	</div>
	
		
</div>