<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="member" value="<%=request.getSession().getAttribute(\"user\")%>" />
<script>
var sock;
var stompClient;
var msgInfo;

// window.onbeforeunload = function() {
// 	$.ajax({
// 		url : "/dropSession",
// 		cache : "false", //캐시사용금지
// 		method : "POST",
// 		data : $("#frm").serialize(),
// 		dataType: "html",
// 		async : false, //동기화설정(비동기화사용안함)
// 		success:function(args){   
// 			//$("#result").html(args);      
// 		},   
// 		error:function(e){  
// 			//alert(e.responseText);  
// 		}
// 	});
// }

function duplicateConnect(){
	sock = new SockJS("${contextPath}/chat");
	stompClient = Stomp.over(sock);
	stompClient.connect({},function(){
		
		<%----------------------------------------채팅메시지 구독부분----------------------------------------------%>
		var crNum = $("#crNum").val();
		//현재 workspace 로그인중인 멤버
		stompClient.subscribe("/category/loginMemberList/${currWnum}", function(data){
			let mList = JSON.parse(data.body);
			console.log(mList);
		});
		
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
		//알림구독
		var userNum = ${sessionScope.user.num};
		stompClient.subscribe("/category/alarm/"+userNum, function(alarm){
				alarmInfo = JSON.parse(alarm.body);
// 				alert(alarmInfo.mNumFrom+"님이 보낸"+alarmInfo.aType+"알림이 도착했습니다");
				$("#alarmOn").show();
		});
		<%-----------------------------------------------------------------------------------------------------%>
		
		//중복로그인알림
		stompClient.subscribe("/category/loginMsg/" + ${member.num},function(data){
			if(data.body=="duplicated"){
		        window.location.href="/logout?type=duplicated";
			}
	    });// end subcribe
		
	}); //end connect
}// end duplicateConnect
var hasNewAlarm;
function alarmOn(){
	
}
$(function(){
	var alarmToggleVal=0;
	$("#alarmDiv").on("click",function(){
		//종을 누르면 무조건 On표시는 꺼진다
		$("#alarmOn").hide();
		
		//알람Info 모달이 없을때
		if(alarmToggleVal==0){
			$("#alarmInfoDiv").animate({height:"400px"},200);
				alarmToggleVal = 1;
				//켜지면서 mNum의 알람리스트가 나와야한다
				$.ajax({
					<%----%>
				});
				
		//알람Info 모달 나와있어서 눌러서 끌때
		}else{
			$("#alarmInfoDiv").animate({height:"0px"},200);
				alarmToggleVal = 0;		
		}
	});
	
	
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
		<div id="alarmDiv">
			<div id="alarmOn"></div>
			<i class="fas fa-bell"></i>
		</div>
	</div>
	<div id="alarmInfoDiv">
		
	</div>
</div>