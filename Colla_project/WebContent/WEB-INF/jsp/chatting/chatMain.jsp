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
<link rel="stylesheet" type="text/css" href="css/chatMain.css"/>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script type="text/javascript" src="js/stomp.js"></script>
<script type="text/javascript" src="js/sockjs.js"></script>

<script>
var chatArea = $(".chat");
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
	
	
	//파일업로드 모달
	$(".openFileUploadModal").on("click",function(){
		$("#addFileModal").fadeIn(300);
	});
	$(".closeFileModal").on("click",function(){
		$("#addFileModal").fadeOut(300);
		return false;
	});
	
	$("#addFileForm").on("submit",function(){
		var formData = new FormData();
		var chatFile = $("input[name='chatFile']");
		var files = chatFile[0].files;
		for (var i = 0; i < files.length; i++) {
			formData.append("chatFile", files[i]);
		}
		$.ajax({
			url : "${contextPath}/fileUpload",
			data : {"formData" : formData},
			dataType : "json",
			success : function(d){
				alert(d);
			},
			error : function(){
				alert("파일업로드 오류 발생");
			}
		});
		return false;
	});
	
	//코드업로드 모달
	$(".openCodeModal").on("click",function(){
		$("#addCodeModal").fadeIn(300);
	});
	$(".closeCodeModal").on("click",function(){
		$("#addCodeModal").fadeOut(300);
		return false;
	});
	
	//지도업로드 모달
	$(".openLocationModal").on("click",function(){
		$("#addLocationModal").fadeIn(300);
	});
	$(".closeLocationModal").on("click",function(){
		$("#addLocationModal").fadeOut(300);
		return false;
	});
	
	//모달 바깥쪽이 클릭되거나 다른 모달이 클릭될때 현재 모달 숨기기
	$("#wsBody").mouseup(function(e){
		if($("#addCrMemberModal").has(e.target).length===0)
		$("#addCrMemberModal").fadeOut(300);
		if($("#addFileModal").has(e.target).length===0)
			$("#addFileModal").fadeOut(300);
		if($("#addCodeModal").has(e.target).length===0)
			$("#addCodeModal").fadeOut(300);
		if($("#addLocationModal").has(e.target).length===0)
			$("#addLocationModal").fadeOut(300);
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
	$(".fileUploadBtn").on("click",function(){
		sendFile();
		chatArea.scrollTop($("#chatArea")[0].scrollHeight);
	});
	});
	var crNum = $("#crNum").val();
	$.ajax({
		url : "${contextPath}/loadPastMsg",
		data : {"crNum":crNum},
		dataType :"json",
		success : function(d){
			$.each(d,function(idx,item){
				var writeDate = new Date(item.cmWriteDate);
				var writeTime = writeDate.getFullYear()+"-"+writeDate.getMonth()+"-"+writeDate.getDay()+" "+writeDate.getHours()+"시"+writeDate.getMinutes()+"분";
				loadPastMsg(item.mName,item.cmContent,writeTime);
				chatArea.scrollTop($("#chatArea")[0].scrollHeight);
			});
		},
		error : function(){
			alert("채팅내역 불러오기 실패");
		}
	});
	
	
	//첨부파일Detail 숨기고 닫기
	$("#attachBtn").on("click",function(){
		$(this).prev().toggle(300);
		return false;
	});
	
});//onload-function end

	<%-------------------------------------------------------WebSocket 연결과 채팅메세지 박스-----------------------------------------------------%>
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
				var writeTime = JSON.parse(jsonStr.body).writeTime;
				if(userId == $("#userName").val()){
					addMyMsg(userId,message,writeTime);
				}else{
					addMsg(userId,message,writeTime);
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

// 	메시지 박스 태그를 생성하는 함수
	function appendMsg(msgType,userId,msg,writeTime){
		var chatMsg = $("<div class='"+msgType+"'></div>");
		chatMsg.append("<div class='profileImg'><a href='#'><img alt='' src=''></a></div>");
		chatMsg.append("<div class='name'><p>"+userId+" <span class='date'>"+writeTime+"</span></p></div><br>");
		chatMsg.append("<p class='content'>"+msg+"</p>");
		chatArea.append(chatMsg);
	}
	//받은 메시지 화면에 추가
	function addMsg(userId,msg,writeTime){
		var msgType = "chatMsg";
		appendMsg(msgType,userId,msg,writeTime);
	}
	//내가 쓴 메시지 화면에 추가
	function addMyMsg(userId,msg,writeTime){
		var msgType = "myMsg";
		appendMsg(msgType,userId,msg,writeTime);
	}
	//과거 메시지 화면에 추가
	function loadPastMsg(userId,msg,writeTime){
		var myId = $("#userName").val();
		var msgType;
		if(userId == myId){//지금은 불러온 메세지중에 작성자 이름이 현재 로그인되있는 이름과같으면 myMsg 로 처리함
			msgType = "myMsg";
		}else{
			msgType = "chatMsg";
		}
		appendMsg(msgType,userId,msg,writeTime);
	}	
	
	
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
			<div class="attachDetail">
				<div class="attach"><a href="#" class="openFileUploadModal">파일첨부</a></div>
				<div class="attach"><a href="#" class="openCodeModal">코드첨부</a></div>
				<div class="attach"><a href="#" class="openLocationModal">지도첨부</a></div>
			</div>
			<a href="#" id="attachBtn">첨부파일</a>
			<input type="text" id="chatInput" placeholder="메세지 작성부분">
			<a id="sendChat" href="#">전송</a>
			<div>
				<p id="attachedFileName"></p>
			</div>
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
		
		
		
		<%---------------------------------------------파일첨부 모달 ----------------------------------------------------%>
		<div id="addFileModal">
			<div class="modalHead">
				<h3 style="font-weight: bolder; font-size: 30px">파일 업로드</h3>
			</div>
			<br><br>
			<div class="modalBody">
				<p>업로드 할 파일을 선택하세요</p>
				<form id="addFileForm" method="post" enctype="multipart/form-data">
					<input type="hidden" class="addCrNum" name="crNum" value="${chatRoom.crNum}">
					<input type="hidden" value="${wNum}" name="wNum">
					<input type="hidden" value="${sessionScope.user.num}" name="mNum">
					<input type="hidden" value="${_csrf.token}" name="${_csrf.parameterName}">
					<br><br>
					<div class="addFileInputWrap">
						<div class="row">
							<input type="file" class="btnFile" name="chatFile" value="파일 선택" accept="image/*" multiple>
						</div>
					</div> <!-- end addFileInputWrap -->

					<div>
						<input type="submit" class="fileUploadBtn" value="업로드"><br> 
						<input type="button" class="closeFileModal" value="닫기"><br>
					</div>
				</form>
			</div> <!-- end modalBody -->
		</div><!-- end addFileModal -->
		
		
		<%---------------------------------------------코드첨부 모달 ----------------------------------------------------%>
		<div id="addCodeModal">
			<div class="modalHead">
				<h3 style="font-weight: bolder; font-size: 30px">코드 업로드</h3>
			</div>
			<br><br>
			<div class="modalBody">
				<p>추가할 코드의 종류를 선택하세요</p>
				<form action="writeCode">
					<div class="row">
						<p> java javascript c c++ c# python </p>
					</div>
					<input type="submit" class="codeUpload" value="업로드"><br> 
					<input type="button" class="closeCodeModal" value="닫기"><br>
					
				</form>
			</div> <!-- end modalBody -->
		</div><!-- end addCodeModal -->
		
		
		<%---------------------------------------------지도첨부 모달 ----------------------------------------------------%>
		<div id="addLocationModal">
			<div class="modalHead">
				<h3 style="font-weight: bolder; font-size: 30px">지도 업로드</h3>
			</div>
			<br><br>
			<div class="modalBody">
				<p>멤버들과 위치를 공유할 수 있습니다</p>
				<form action="locationUpload">
					<div class="row">
						<p> 지도~ </p>
					</div>
					<input type="submit" class="locationUpload" value="업로드"><br> 
					<input type="button" class="closeLocationModal" value="닫기"><br>
					
				</form>
			</div> <!-- end modalBody -->
		</div><!-- end addLocationModal -->
		
		
		
	</div><!-- end wsBody -->
</body>
</html>