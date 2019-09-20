<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="member" value="<%=request.getSession().getAttribute(\"user\")%>" />
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
	            url : "${contextPath}/removeSession?type=duplicationLogin"
	         });
	         location.href="main";
	      });// end subcribe
		
	}); //end connect
}// end duplicateConnect
$(function(){
	
	
	
	duplicateConnect();
	
	var pageType = $("#pageType").val();
	if(pageType=="chatroom"){
		//헤더에 채팅방과 워크스페이스 정보 바꾸기
		var isDefault = $("#isDefault").val();
		if(isDefault==1){ //기본채팅방이면
			$("#chatRoomInfo > p").text("기본채팅방");
			$(".addCrMember").hide();
		}else{
		 	var crName = $("#crName").val();
		 	$("#chatRoomInfo > p").text(crName);
		}
	}else if(pageType=="workspace"){
		$("#chatRoomInfo > p").text("워크스페이스");
	}else{
		$("#chatRoomInfo > p").text("${sessionScope.wsName}");
	}
	
	
	
}); //onload function end

</script>
<div id="wsMainHeader">
	
<%-- 	<input type="hidden" value="${chatRoom.crNum}" id="crNum"> --%>
<%-- 	<input type="hidden" value="${chatRoom.crIsDefault}" id="crIsDefault"> --%>
	<div class="container">
		<div id="chatRoomInfo">
			<p>페이지 이름</p>
		</div>
	</div>
</div>