<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
</style>
<script>

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
});
</script>
</head>
<body>
<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp" %>
<%@ include file="/WEB-INF/jsp/inc/navWs.jsp" %>
	<div id="wsBody">
		<input type="hidden" value="${chatRoom.crIsDefault}" id="isDefault">
		<input type="hidden" value="${chatRoom.crName}" id="crName">
		<div class="chatArea">
			<div class="addCrMember">
			<button class="openAddCrMemberModal">채팅방 초대</button>
			</div>
			<div class="chat">
				<div class="profileImg">
					<a href="#"> 이미지 <img alt="" src=""></a>
				</div>
				<div class="name">
					<p>
						이름 <span class="date">작성시간</span>
					</p>
				</div>
				<p class="content">메세지 내용</p>
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