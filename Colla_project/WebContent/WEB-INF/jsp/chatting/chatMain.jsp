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
	//회원정보 모달
	$(".openMemberInfo").on("click",function(){
		$("#memberInfoModal").fadeIn(100);
	});
	$(".closeMemberInfo").on("click",function(){
		$("#memberInfoModal").fadeOut(100);
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
		if($("#memberInfoModal").has(e.target).length===0)
			$("#memberInfoModal").fadeOut(300);
		return false;
	});
	//첨부파일Detail 숨기고 닫기
	$("#attachBtn").on("click",function(){
		$(".attachDetail").toggle(300);
		return false;
	});
	
	<%--채팅 연결 및 전송--%>
	chatArea = $(".chat");
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
	
	//과거메세지 불러오기
	var crNum = $("#crNum").val();
	$.ajax({
		url : "${contextPath}/loadPastMsg",
		data : {"crNum":crNum},
		dataType :"json",
		success : function(d){
			$.each(d,function(idx,item){
				addMsg(item);
				chatArea.scrollTop($("#chatArea")[0].scrollHeight);
			});
		},
		error : function(){
			alert("채팅내역 불러오기 실패");
		}
	});
	

	//파일업로드에서 업로드 <a>태그가 눌렸을때
	$(".fileUploadBtn").on("click",function(){
		var addFileForm = $("#addFileForm")[0];
		var formData = new FormData(addFileForm);
		$.ajax({
			url : "${contextPath}/uploadFile",
			data : formData,
			processData : false,
			contentType : false,
			enctype: "multipart/form-data",
			type : "post",
			dataType : "json",
			success : function(jsonStr){
				var cmNum = jsonStr.cmNum;
				var fileName = jsonStr.fileName;
				var originName = jsonStr.originName;
				sendFile(fileName,originName,cmNum);
				$("#addFileModal").fadeOut(300);
			},
			error : function(){
				alert("파일전송 에러발생");
			}
		});
	});
});//onload-function end
//파일형태 메세지 보내기
function sendFile(fileName,originName,cmNum){
	stompClient.send("/client/sendFile/"+$("#userEmail").val()+"/"+$("#crNum").val()+"/"+cmNum+"/"+originName,{},fileName);
}

var textarea = $("#editor");
var editor = CodeMirror.fromTextArea(textarea,{
    lineNumbers: true,
    lineWrapping: true,
    theme: "eclipse",
    val: textarea.value
});

	<%-------------------------------------------------------WebSocket 연결부분은 headerWs로 넘어갔습니다.-----------------------------------------------------%>
	//일반 메세지 보내기
	function sendMsg(){
		var msg = $("#chatInput").val();
		stompClient.send("/client/send/"+$("#userEmail").val()+"/"+$("#crNum").val(),{},msg);
		$("#chatInput").val("");
	}
	
	//미경 시작
	//즐겨찾기 등록,해제를 하는 함수
	var favoriteResult;
	var favoriteCmNum;
	function chatFavorite(e){ 
	   var favoriteClassName = $(e).attr('class');
	   if(favoriteClassName == "chatFavorite"){
	      $(e).attr('class','chatFavoriteOn');
	      favoriteCmNum = $(e).attr('value');
	      favoriteResult = 1;
	   }else{
	      $(e).attr('class','chatFavorite');
	      favoriteCmNum = $(e).attr('value');
	      favoriteResult = 0;
	   }
	   console.log("cmNum :" + favoriteCmNum);
	   console.log("결과 :" + favoriteResult);
	   $.ajax({
	      url : "${contextPath}/chatFavorite",
	      data : {"favoriteResult" : favoriteResult,"favoriteCmNum":favoriteCmNum},
	      type : "post",
	      dataType : "json",
	      success : function(result){
	         if(result){
	            alert("컨트롤 입성 성공!");
	         }
	      }
	   });//end ajax
	}//end favoirte()
	
	//받은 메시지 화면에 추가
	function addMsg(msgInfo){
		var msgType;
		if(msgInfo.mName == $("#userName").val()){
			msgType="myMsg";
		} else {
			msgType = "chatMsg";
		}
		var chatMsg = $("<div class='"+msgType+"'></div>");
		var imgTag = "<img alt='"+msgInfo.mName+"님의 프로필 사진' src='${contextPath}/showProfileImg?num="+ msgInfo.mNum+ "'></a>";
		var favorite = "<div class='chatFavorite' onclick='chatFavorite(this)' value = '"+ msgInfo.cmNum +"'></div>"; //즐겨찾기 아이콘
		var originName = getOriginName(msgInfo.cmContent);
		var date = new Date(msgInfo.cmWriteDate);
		var writeTime = date.getFullYear()+"-"+date.getMonth()+"-"+date.getDay()+" "+date.getHours()+"시"+date.getMinutes()+"분";
		
		chatMsg.append("<div class='profileImg'><a href='#' class='openMemberInfo'>"+imgTag+"</a></div>");
		chatMsg.append("<div class='onlyMsgBox'><div class='name'><p>"+msgInfo.mName+" <span class='date'>"+writeTime+"</span></p></div>"+favorite+"<br><p class='content'>"+( msgInfo.cmType=='message'?msgInfo.cmContent : "<a href='${contextPath}/download?name="+msgInfo.cmContent+"'>"+originName+"</a>" )+"</p></div>");
		chatArea.append(chatMsg);
	}
	
	function getOriginName(fileName){
		var idx = fileName.indexOf("_")+1;
		var originName= fileName.substring(idx);
		return originName;
	}
	
	
</script>

<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.5.0/styles/androidstudio.min.css">
<script src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.5.0/highlight.min.js"></script>
<script>hljs.initHighlightingOnLoad();</script>
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
			<div id="chatInputInstance">
			<a href="#" id="attachBtn">첨부파일</a>
			<input type="text" id="chatInput" placeholder="메세지 작성부분">
			<a id="sendChat" href="#">전송</a>
			</div>
		</div>
		<div>
			<pre><code class="java">
			for(int i=0;i<10;i++)
			</code></pre>
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

					<div id="innerBtn">
						<a href="#" class="fileUploadBtn">업로드</a><br> 
						<a href="#" class="closeFileModal">닫기</a>
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
					<div id="innerBtn">
					<a href="#" class="codeUpload">업로드</a><br> 
					<a href="#" class="closeCodeModal">닫기</a><br>
					</div>
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
					<div id="innerBtn">
					<a href="#" class="locationUpload">업로드</a><br> 
					<a href="#" class="closeLocationModal">닫기</a><br>
					</div>
				</form>
			</div> <!-- end modalBody -->
		</div><!-- end addLocationModal -->
		<%---------------------------------------------회원정보 모달 ----------------------------------------------------%>
		<div id="memberInfoModal">
			<div class="modalHead">
				<h3 style="font-weight: bolder; font-size: 30px">회원정보</h3>
			</div>
			<br><br>
			<div class="modalBody">
				<p>회원정보입니다</p>
					<div class="row">
					<p>내용~</p>
					</div>
					<a href="#" class="closeMemberInfo">닫기</a><br>
			</div> <!-- end modalBody -->
		</div><!-- end memberInfoModal -->
		
		
	</div><!-- end wsBody -->
</body>
</html>