<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채팅 메인</title>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/reset.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/base.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/chatMain.css"/>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script type="text/javascript" src="${contextPath}/js/stomp.js"></script>
<script type="text/javascript" src="${contextPath}/js/sockjs.js"></script>

<script type="text/javascript" src="lib/codemirror/lib/codemirror.js"></script>
<link rel="stylesheet" type="text/css" href="lib/codemirror/lib/codemirror.css"/>
<link rel="stylesheet" type="text/css" href="lib/codemirror/theme/gruvbox-dark.css"/>
<script type="text/javascript" src="lib/codemirror/addon/edit/closetag.js"></script>
<script type="text/javascript" src="lib/codemirror/addon/hint/show-hint.js"></script>
<script type="text/javascript" src="lib/codemirror/addon/hint/css-hint.js"></script>
<script type="text/javascript" src="lib/codemirror/mode/javascript/javascript.js"></script>
<script type="text/javascript" src="lib/codemirror/mode/css/css.js"></script>
<script type="text/javascript" src="lib/codemirror/mode/clike/clike.js"></script>
<script type="text/javascript" src="lib/codemirror/mode/xml/xml.js"></script>
<script type="text/javascript" src="lib/codemirror/mode/sql/sql.js"></script>
<script type="text/javascript" src="lib/codemirror/mode/php/php.js"></script>
<!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.32.0/codemirror.min.js"></script> -->
<!-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.32.0/codemirror.min.css" /> -->

<script>
var chatArea = $(".chat");
var favoriteArea;
	$(function(){
		loadChatFromDB();
		favoriteArea = $("#favoriteArea");
	
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
	
	//즐겨찾기 모달
	$(".openchatFavoriteModal").on("click",function(){
		favoriteArea.empty();
		showFavoriteList();
		$("#chatFavoriteModal").fadeIn(100);
	});
	$("#closechatFavorite").on("click",function(){
		$("#chatFavoriteModal").fadeOut(100);
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
	
	
	//select-box 값에 따라 codemirror mode를 바꾸는 과정
	$("#codeType").change(function(){
		type = $(this).val();
		editor.setOption("mode",type);
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
	//코드업로드 버튼 눌렸을 경우
	$(".codeUpload").on("click",function(){
		sendCode();
		chatArea.scrollTop($("#chatArea")[0].scrollHeight);
	});
	
	//파일업로드 버튼 눌렸을 경우
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


	//code형태 메세지 보내기
	function sendCode(){
		var code = editor.getValue();
// 		alert("userEmail :"+$("#userEmail").val()+", crNum : "+$("#crNum").val()+", code : "+code+", type : "+type);
		//잘 들어옴. type은 codemirror의 mode
		stompClient.send("/client/sendCode/"+$("#userEmail").val()+"/"+$("#crNum").val()+"/"+type,{},code);
		$("#addCodeModal").fadeOut(300);
	}

	//파일형태 메세지 보내기
	function sendFile(fileName,originName,cmNum){
		stompClient.send("/client/sendFile/"+$("#userEmail").val()+"/"+$("#crNum").val()+"/"+cmNum+"/"+originName,{},fileName);
	}

//과거메세지 불러오기
function loadChatFromDB(){
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
}
var textarea = $("#editor");
var editor = CodeMirror.fromTextArea(textarea,{
    lineNumbers: true,
    lineWrapping: true,
    theme: "eclipse",
    val: textarea.value
});

	//일반 메세지 보내기
	function sendMsg(){
		var msg = $("#chatInput").val();
		stompClient.send("/client/send/"+$("#userEmail").val()+"/"+$("#crNum").val(),{},msg);
		$("#chatInput").val("");
	}
	
	//즐겨찾기 등록,해제
	var favoriteResult;
	var cmNum;
	function chatFavorite(e){ 
	   var favoriteClassName = $(e).attr('class');
	   cmNum = $(e).attr('value');
	   if(favoriteClassName == "chatFavorite"){
	   	  $(".chatFavorite[value='"+cmNum+"']").addClass('on');
	      favoriteResult = 1;
	   }else{
	   	  $(".chatFavorite[value='"+cmNum+"']").removeClass('on');
	      favoriteResult = 0;
	   }

	   $.ajax({
	      url : "${contextPath}/chatFavorite",
	      data : {"favoriteResult" : favoriteResult,"cmNum":cmNum},
	      type : "post"
	   });//end ajax
	   
	   
	}//end favoirte()
	
	//받은 메시지 화면에 추가
	function addMsg(msgInfo, area){
		var msgType;
		var isFavoriteClass=(msgInfo.isFavorite == 0)?"chatFavorite":"chatFavorite on";
		if(msgInfo.mName == $("#userName").val()){
			msgType="myMsg";
		} else {
			msgType = "chatMsg";
		}
		var chatMsg = $("<div class='"+msgType+"'></div>");
		var imgTag = "<img alt='"+msgInfo.mName+"님의 프로필 사진' src='${contextPath}/showProfileImg?num="+ msgInfo.mNum+ "'></a>";
		var favorite = "<div class='"+isFavoriteClass+"' onclick='chatFavorite(this)' value = '"+ msgInfo.cmNum +"'></div>"; //즐겨찾기 아이콘
		var originName = getOriginName(msgInfo.cmContent);
		var date = new Date(msgInfo.cmWriteDate);
		var writeTime = date.getFullYear()+"-"+date.getMonth()+"-"+date.getDay()+" "+date.getHours()+"시"+date.getMinutes()+"분";

		var contentStr;
		var codeType;
		if(msgInfo.cmType=='message'){
			contentStr = msgInfo.cmContent;
		}else if(msgInfo.cmType=='file'){
			contentStr = "<a href='${contextPath}/download?name="+msgInfo.cmContent+"'>"+originName+"</a>";
		}else if(msgInfo.cmType.includes('code')){
			var cmType = msgInfo.cmType;
			codeType = cmType.substring(cmType.indexOf("_")+1);
			var contentStr = "<textarea class='codeMsg' id='codeMsg'>"+msgInfo.cmContent+"</textarea>";
// 			var codeMsg = CodeMirror.fromTextArea($('#codeMsg')[0],{
// 				mode : codeType,
// 				theme : "gruvbox-dark",
// 				lineNumbers : true,
// 				autoCloseTags : true
// 			});
// 				codeMsg.setSize("800", "30");
		}
		
		chatMsg.append("<div class='profileImg'><a href='#' class='openMemberInfo'>"+imgTag+"</a></div>");
		chatMsg.append("<div class='onlyMsgBox'><div class='name'><p>"+msgInfo.mName
				+"<span class='date'>"+writeTime
				+"</span></p></div>"+favorite+"<br><p class='content'>"
				+ contentStr
				+"</p></div>");
		chatArea.append(chatMsg);
// 		console.log(chatArea);
		
		if(msgInfo.cmType.includes('code')){
			console.log(chatArea.find("textarea:last()"));
			var codeMsg = CodeMirror.fromTextArea( chatArea.find("textarea:last()")[0] ,{
				mode : codeType,
				theme : "gruvbox-dark",
				lineNumbers : true,
				autoCloseTags : true,
				readOnly : true
			});
			codeMsg.setSize("800", "50");	
      
		if(!area){
			chatArea.append(chatMsg);
		}else{
			console.log(chatMsg);
			favoriteArea.append(chatMsg[0]);
		}
		
	}
	
	//즐겨찾기 리스트 그리기
	function showFavoriteList(){
		var crNum = $("#crNum").val();
		$.ajax({
			url : "${contextPath}/showChatFavoriteList",
			data : {"crNum":crNum},
			type : "post",
			dataType :"json",
			success : function(messageList){
				console.log(messageList);
				for(var i=0; i<messageList.length; i++){
					addMsg(messageList[i], "true");
				}
			},
			error : function(){
				alert("즐겨찾기 리스트 불러오기 실패");
			}
		});//end ajax
	}//end function

	function getOriginName(fileName){
		var idx = (fileName.indexOf("_")) + 1;
		var originName= fileName.substring(idx);
		return originName;
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
			<div class="chatFavoriteList">
				<button class="openchatFavoriteModal">즐겨찾기</button>
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
			<textarea id="chatInput" placeholder="메세지 작성부분"></textarea>
			<a id="sendChat" href="#">전송</a>
			</div>
		</div>
		<%---------------------------------------------채팅방 멤버추가모달 ----------------------------------------------------%>
		<div id="addCrMemberModal" class="attachModal">
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
		<div id="addFileModal" class="attachModal">
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
		<div id="addCodeModal" class="attachModal">
			<div class="modalHead" align="center">
				<h3 style="font-weight: bolder; font-size: 30px">코드 업로드</h3>
			</div>
			<br><br>
			<div class="modalBody">
				<form action="writeCode">
					<div class="row">
						<select name="codeType" id="codeType">
							<option value="text/x-java">java</option>
							<option value="javascript">javascript</option>
							<option value="css">css</option>
							<option value="xml">xml</option>
							<option value="sql">sql</option>
							<option value="php">php</option>
						</select>
						<textarea id="editor"></textarea>
						<script>
							//CodeMirror textArea를 만들고 mode를 설정할 수 있는 selectbox의 type을 선언하
							var type = $("#codeType option:selected").val();
							var editor = CodeMirror.fromTextArea($('#editor')[0],{
								mode : type,
								theme : "gruvbox-dark",
								lineNumbers : true,
								autoCloseTags : true
							});
							editor.setSize("500", "300");
						</script>
					</div>
					<div id="innerBtn"  align="center">
					<a href="#" class="codeUpload">업로드</a><br> 
					<a href="#" class="closeCodeModal">닫기</a><br>
					</div>
				</form>
			</div> <!-- end modalBody -->
		</div><!-- end addCodeModal -->
		
		
		<%---------------------------------------------지도첨부 모달 ----------------------------------------------------%>
		<div id="addLocationModal" class="attachModal">
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
		<div id="memberInfoModal" class="attachModal">
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
		<%---------------------------------------------즐겨찾기 모달 ----------------------------------------------------%>
		<div id="chatFavoriteModal">
			<div class="modalHead">
				<h3 style="font-weight: bolder; font-size: 30px">즐겨찾기</h3>
			</div>
			<br><br>
			<div class="modalBody">
				<p>즐겨찾기 리스트입니다.</p>
					<div id="favoriteArea">
					</div>
					<button id="closechatFavorite">닫기</button>
			</div> <!-- end modalBody -->
		</div>
		
	</div><!-- end wsBody -->
</body>
</html>