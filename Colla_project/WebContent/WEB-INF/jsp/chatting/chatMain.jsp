<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채팅 메인</title>
<link rel="stylesheet" type="text/css" href="css/reset.css"/>
<link rel="stylesheet" type="text/css" href="css/base.css"/>
<link rel="stylesheet" type="text/css" href="css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="css/navWs.css"/>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script type="text/javascript" src="js/stomp.js"></script>
<script type="text/javascript" src="js/sockjs.js"></script>
<style>
	#addCrMemberModal{
	display : none;
	position : fixed;
	top : 30%;
	left : 30%;
	width : 500px;
	height : 340px;
	background-color: white;
	text-align: center;
	align-content : center;
	border-radius: 10px;
}
.row ul{
	list-style: none;
	padding-left: 0px;
}
.chatMsg{
	position: relative;
	opacity: 1;
	background-color: #ebe6e6;
	border-bottom : 0.5px solid #bdbbbb;
}
.myMsg{
	position: relative;
	opacity: 1;
	background-color: #deeafc;
	border-bottom : 0.5px solid #bdbbbb;
}
.chat{
	position: static;
	background-color: white;
	height : 500px;
 	overflow-y:scroll;
}
.name > p {
	font-weight: bolder;
}
.date{
	font-weight: normal;
	font-size: 5px;
}
</style>
<script>
var chatArea;
$(function(){
	//헤더에 채팅방과 워크스페이스 정보 바꾸기
	var isDefault = $("#isDefault").val();
	if(isDefault==1){ //기본채팅방이면
		$("#chatRoomInfo > p").text("기본채팅방");
		$(".addCrMember").hide();
	}else{
	 	var crName = $("#crName").val();
	 	$("#chatRoomInfo > p").text(crName);
	}
	
	//Chat Member추가 모달
	$(".openAddCrMemberModal").on("click",function(){
		$("#addCrMemberModal").fadeIn(300);
	});
	$("#closeCrMemberModal").on("click",function(){
		$("#addCrMemberModal").fadeOut(300);
		return false;
	});
	
	//모달 바깥쪽이 클릭되거나 다른 모달이 클릭될때 현재 모달 숨기기
	$("#wsBody").mouseup(function(e){
		if($("#addCrMemberModal").has(e.target).length===0)
		$("#addCrMemberModal").fadeOut(300);
		return false;
	});
	
	
	<%--채팅 연결 및 전송--%>
	chatArea = $(".chat");
	connect();
	$("#sendChat").on("click",function(){
			sendMsg();
			chatArea.scrollTop($("#chatArea")[0].scrollHeight);
	});
	$("#chatInput").keydown(function(key){
		if(key.keyCode==13){
			sendMsg();
			chatArea.scrollTop($("#chatArea")[0].scrollHeight);
		}
	});
	var crNum = $("#crNum").val();
	$.ajax({
		url : "${contextPath}/loadPastMsg",
		data : {"crNum":crNum},
		dataType :"json",
		success : function(d){
			$.each(d,function(idx,item){
				loadPastMsg(item.mName,item.cmContent);
			});
		},
		error : function(){
			alert("채팅내역 불러오기 실패");
		}
	});
	
	
});//onload-function end
	var sock;
	var stompClient;
	function connect(){
		sock = new SockJS("${contextPath}/chat");
		stompClient = Stomp.over(sock);
		stompClient.connect({},function(){
// 			connectMsg();
			var crNum = $("#crNum").val();
			stompClient.subscribe("/category/msg/"+crNum,function(jsonStr){
				var userId = JSON.parse(jsonStr.body).userId;
				var message = JSON.parse(jsonStr.body).message;
				if(userId == $("#userName").val()){
					addMyMsg(userId,message);
				}else{
					addMsg(userId,message);
				}
				
				$("#chatArea").scrollTop($("#chatArea")[0].scrollHeight);
			});
			
		});
	}
	function sendMsg(){
		var msg = $("#chatInput").val();
		stompClient.send("/client/send/"+$("#userEmail").val()+"/"+$("#crNum").val(),{},msg);
		$("#chatInput").val("");
	}
	
	
	function addMsg(userId,msg){
		var chatMsg = $("<div class='chatMsg'></div>");
		chatMsg.append("<div class='profileImg'><a href='#'>이미지<img alt='' src=''></a></div>");
		chatMsg.append("<div class='name'><p>"+userId+" <span class='date'>10:36</span></p></div>");
		chatMsg.append("<p class='content'>"+msg+"</p>");
		chatArea.append(chatMsg);
	}
	function addMyMsg(userId,msg){
		var chatMsg = $("<div class='myMsg'></div>");
		chatMsg.append("<div class='profileImg'><a href='#'>이미지<img alt='' src=''></a></div>");
		chatMsg.append("<div class='name'><p>"+userId+" <span class='date'>10:36</span></p></div>");
		chatMsg.append("<p class='content'>"+msg+"</p>");
		chatArea.append(chatMsg);
	}
	function loadPastMsg(userId,msg){
		var myId = $("#userName").val();
		var chatMsg;
		if(userId == myId){//지금은 불러온 메세지중에 작성자 이름이 현재 로그인되있는 이름과같으면 myMsg 로 처리함
			chatMsg = $("<div class='myMsg'></div>");
		}else{
			chatMsg = $("<div class='chatMsg'></div>");
		}
		chatMsg.append("<div class='profileImg'><a href='#'>이미지<img alt='' src=''></a></div>");
		chatMsg.append("<div class='name'><p>"+userId+" <span class='date'>10:36</span></p></div>");
		chatMsg.append("<p class='content'>"+msg+"</p>");
		chatArea.append(chatMsg);
	}	
	
// 	function connectMsg(){
// 		var userName= $("#userName").val();
// 		var msg = userName + "님이 접속했습니다";
// 		stompClient.send("/client/send",{},msg);
// 	}

	
</script>
</head>
<body>
<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp" %>
<%@ include file="/WEB-INF/jsp/inc/navWs.jsp" %>
	<div id="wsBody">
		<input type="hidden" value="${chatRoom.crIsDefault}" id="isDefault">
		<input type="hidden" value="${chatRoom.crName}" id="crName">
		<input type="hidden" value="${sessionScope.user.name}" id="userName">
		<input type="hidden" value="${sessionScope.user.email}" id="userEmail">
		<input type="hidden" value="${chatRoom.crNum}" id="crNum">
		<div class="chatArea">
			<div class="addCrMember">
			<button class="openAddCrMemberModal">채팅방 초대</button>
			</div>
			<div class="chat" id="chatArea">
			</div>
		</div>
		<div id="inputBox">
			<a id="attachBtn" href="#">첨부파일</a>
			<input type="text" id="chatInput" placeholder="메세지 작성부분">
			<a id="sendChat" href="#">전송</a>
		</div>
		
		<%---------------------------------------------채팅방 멤버추가모달 ----------------------------------------------------%>
		<div id="addCrMemberModal">
			<div class="modalHead">
				<h3 style="font-weight: bolder; font-size: 30px">채팅방 초대</h3>
			</div>
			<br><br>
			<div class="modalBody">
				<p>채팅방에 멤버를 초대하세요</p>
				<form action="inviteChatMember" method="post">
					<input type="hidden" class="addCrNum" name="crNum" value="${chatRoom.crNum}">
					<input type="hidden" value="${wNum}" name="wNum">
					<input type="hidden" value="${_csrf.token}" name="${_csrf.parameterName}">
					<br><br>
					<div class="addCrMemberInputWrap">
						<div class="row">
							<h4>워크스페이스 회원목록</h4>
								<ul>
									<c:forEach items="${wsMemberList}" var="wsm">
										<li><input type="checkbox" value="${wsm.num}" name="wsmList">${wsm.name}</li>
									</c:forEach>
								</ul>
						</div>
					</div> <!-- end addCrMemberInputWrap -->

					<div>
						<button type="submit">멤버 초대하기</button>
						<button id="closeCrMemberModal">닫기</button>
					</div>
				</form>
			</div> <!-- end modalBody -->
		</div><!-- end addMemberModal -->
		
		
		
	</div><!-- end wsBody -->
</body>
</html>