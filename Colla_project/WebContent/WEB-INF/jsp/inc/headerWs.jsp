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
		stompClient.subscribe("/category/newLogin/${sessionScope.user.num}", function(data){
			let newUser = JSON.parse(data.body);
			console.log(newUser);
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
				
					$.ajax({
						url : "${contextPath}/hasAlarm",
						data : {"mNum":userNum},
						dataType : "json",
						success : function(alarmList){
							if(alarmList!=""){
								$.each(alarmList,function(idx,alarm){
									$("#emptyAlarmMsg").remove();
									drawAlarmList(alarm);
									$(".alarmInfoDiv").show();
									$(".alarmInfo").show();
									return false;
								});
							}
						},
						error : function(){
							alert("알람리스트 불러오기 에러발생");
						}
					});
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

function sendAlarm(wNum,mNumTo,mNumFrom,aType,aDnum){
	stompClient.send("/client/sendAlarm/"+wNum+"/"+mNumTo+"/"+mNumFrom+"/"+aDnum,{},aType);
}

var hasNewAlarm;
function drawAlarmList(alarm){
	var alarmType;
	if(alarm.aType=="reply"){
		alarmType = "댓글";
	}else if(alarm.aType=="wInvite"){
		alarmType = "워크스페이스 초대";
	}else if(alarm.aType=="cInvite"){
		alarmType = "채팅방 초대";
	}
	var alarmInfoArea = $("#alarmInfoArea");
	var alarmProfileImg = $("<div class='profileImg'><img alt='프로필사진' src='${contextPath}/showProfileImg?num="+alarm.mNumFrom+"'></div>");
	var alarmInfoDiv = $("<div class='alarmInfoDiv'></div>");
	var date = new Date(alarm.aRegDate);
	var alarmTime = date.getFullYear()+"-"+(Number(date.getMonth())+Number(1))+"-"+date.getDate()+" "+date.getHours()+"시"+date.getMinutes()+"분";
	var alarmInfo = $("<div class='alarmInfo'><a class='goToURLaTag' href='${contextPath}/goToTargetURL?aNum="+alarm.aNum+"&wNum="+alarm.wNum+"&aType="+alarm.aType+"&aDnum="+alarm.aDnum+"'>"+alarm.mNameFrom+"님의 "+alarmType+"알림 </a><div class='deleteThisAlarm' onclick='deleteThisAlarm("+alarm.aNum+");'><i class='fas fa-times'></i></div></div>");
	var alarmTimeDiv = $("<div class='alarmRegDate'>"+alarmTime+"</div>");
	alarmInfo.append(alarmTimeDiv);
	alarmInfoDiv.append(alarmProfileImg);
	alarmInfoDiv.append(alarmInfo);
	alarmInfoArea.append(alarmInfoDiv);
	return false;
}
function deleteThisAlarm(aNum){
	var userNum = ${sessionScope.user.num};
	var alarmInfoArea = $("#alarmInfoArea");
	$.ajax({
		url : "${contextPath}/deleteThisAlarm",
		data : {"aNum":aNum,"mNum":userNum},
		dataType : "json",
		success : function(alarmList){
			alarmInfoArea.empty();
			var total = alarmList.length;
			$.each(alarmList,function(idx,alarm){
				drawAlarmList(alarm);
				$(".alarmInfoDiv").show();
				$(".alarmInfo").show();
			});
			if(total==0){
				var emptyAlarmMsg = $("<div id='emptyAlarmMsg' align='center'>알림이 없습니다.</div>");
				alarmInfoArea.append(emptyAlarmMsg);
			}
		},
		error : function(){
			alert("알람 삭제 에러발생");
		}
	});
}
$(function(){
	//화면 켜졌을때 알람 있으면 가져오기
	var mNum = ${member.num};
	$.ajax({
		url : "${contextPath}/hasAlarm",
		data : {"mNum":mNum},
		dataType : "json",
		success : function(alarmList){
			if(alarmList!=""){
				$("#alarmOn").show();
				$.each(alarmList,function(idx,alarm){
					drawAlarmList(alarm);
				});
			}else{
				var alarmInfoArea = $("#alarmInfoArea");
				var emptyAlarmMsg = $("<div id='emptyAlarmMsg' align='center'>알림이 없습니다.</div>");
				alarmInfoArea.append(emptyAlarmMsg);
			}
		},
		error : function(){
			alert("알람리스트 불러오기 에러발생");
		}
	});
	var alarmToggleVal=0;
	$("#alarmDiv").on("click",function(){
		//종을 누르면 무조건 On표시는 꺼진다
// 		$("#alarmOn").hide();
// 		$(".alarmInfo").hide();
		//알람Info 모달이 없을때
		if(alarmToggleVal==0){
			$("#alarmInfoArea").slideDown();//.animate({height:"400px"},200);
				alarmToggleVal = 1;
// 				$(".alarmInfoDiv").show();
// 				$(".alarmInfo").show();
				
		//알람Info 모달 나와있어서 눌러서 끌때
		}else{
			$("#alarmInfoArea").slideUp();//.animate({height:"0px"},200);
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
	<div id="alarmInfoArea">
		
	</div>
</div>