<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="<%=request.getContextPath()%>" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>워크스페이스</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<style>
#addWsModal{
	display : none;
	position : fixed;
	top : 30%;
	left : 30%;
	width : 500px;
	height : 350px;
	background-color: #e1e4e8;
	text-align: center;
	border-radius: 10px;
}
#addChatModal{
	display : none;
	position : fixed;
	top : 30%;
	left : 30%;
	width : 500px;
	height : 350px;
	background-color: #e1e4e8;
	text-align: center;
	border-radius: 10px;
}
#addMemberModal{
	display : none;
	position : fixed;
	top : 30%;
	left : 30%;
	width : 500px;
	height : 250px;
	background-color: #e1e4e8;
	text-align: center;
	border-radius: 10px;
}
/* 네비게이션의 채팅방리스트와 게시판, 캘린더는 wsMain페이지에서는 숨겼습니다. */
#myChatList{
	display: none;
}
#ws-subfunction{
	display: none;
}
#chatRoomInfo{
	display: none;
}
.wsDetail{
display : none;
}
</style>
<script>
	var wNum;

	$(function(){
		//WS추가 모달
		$(".openWsModal").on("click",function(){
			$("#addWsModal").fadeIn(300);
		});
		$("#closeWsModal").on("click",function(){
			$("#addWsModal").fadeOut(300);
			return false;
		});
		//ChatRoom추가 모달
		$(".openChatModal").on("click",function(){
			var wNum = $(this).attr("data-wnum");
			$(".addWnum").val(wNum); //채팅방 추가모달에 숨어있는 addWnum 부분에 wNum담기
			$("#addChatModal").fadeIn(300);
		});
		$("#closeChatModal").on("click",function(){
			$("#addChatModal").fadeOut(300);
			return false;
		});
		//WS Member추가 모달
		$(".openAddMemberModal").on("click",function(){
			var wNum = $(this).attr("data-wnum");
			$(".addWnum").val(wNum); //멤버 추가모달에 숨어있는 addWnum 부분에 wNum담기
			$("#addMemberModal").fadeIn(300);
		});
		$("#closeMemberModal").on("click",function(){
			$("#addMemberModal").fadeOut(300);
			return false;
		});
		
		
		//모달 바깥쪽이 클릭되거나 다른 모달이 클릭될때 현재 모달 숨기기
		$("#wsBody").mouseup(function(e){
			if($("#addWsModal").has(e.target).length===0)
			$("#addWsModal").fadeOut(300);
			if($("#addChatModal").has(e.target).length===0)
			$("#addChatModal").fadeOut(300);
			if($("#addMemberModal").has(e.target).length===0)
			$("#addMemberModal").fadeOut(300);
			return false;
		});
		
		
		
		//워크스페이스 하나 숨기고 닫기
		$(".showWsDetail").on("click",function(){
			$(this).next().toggle();
			return false;
		});
		
	});
	
</script>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp"%>
	<div id="wsBody">
		<h2>Workspace</h2>
		<h3>Workspace List</h3>
		<ul>
		
			<c:forEach items="${workspaceList}" var="ws">
				<li class="ws">
					<h4>${ws.wsInfo.name}</h4>
					<button class="showWsDetail">워크스페이스 상세보기</button> <!-- 누르면 ws.wsInfo.num인 wsDetail만 열려야한다 -->

					<div class="wsDetail">
						<input type="hidden" value="${ws.num}" id="wNum">
						<div class="wsChatList">
							<p>채팅리스트</p>
							<ul>
							<c:forEach items="${ws.crList}" var="cr">
								<li><a href="chatMain?crNum=${cr.crNum}">${cr.crName}</a></li>
							</c:forEach>
								<button class="openChatModal" data-wnum="${ws.wsInfo.num}"> 채팅방 추가(+)</button>
							</ul>
						</div>
						
						
						<div class="wsMember">
						<p>참여자 목록</p>
						<ul>
						<c:forEach items="${ws.mList}" var="m"><!-- workspacemember 테이블 만들고 그 테이블리스트를 여기 넣는다 -->
							<li>${m.name}</li>
						</c:forEach>
							<button class="openAddMemberModal" data-wnum="${ws.wsInfo.num}"> 멤버 추가(+)</button>
						</ul>
						</div>
					</div>
					<div>
						<a href="#">워크스페이스 나가기</a>
					</div>
				</li>
			</c:forEach>
			
		</ul>
		<div>
			<button class="openWsModal">워크스페이스 추가</button>
		</div>
		<!-- 임시로 만든 로그아웃버튼 -->
		<div>
			<form action="logout" method="post">
			<input type="hidden" value="${_csrf.token}" name="${_csrf.parameterName}">
			<input type="submit" value="임시 로그아웃 버튼">
			</form>
		</div>


		<%------------------------------------워크스페이스 추가 모달  ---------------------------------------%>
		<div id="addWsModal">
			<div class="modalHead">
				<h3>Workspace 만들기</h3>
			</div>
			<div class="modalBody">
				<p>Workspace를 만들고 멤버를 초대하세요</p>
				<form action="addWs" method="post">
					<input type="hidden" value="${_csrf.token}" name="${_csrf.parameterName}">
					<div class="addWsInputWrap">
						<div class="row">
							<h4>Workspace 이름</h4>
							<div>
								<input type="text" placeholder="workspace이름" name="wsName">
							</div>
						</div>
						<div class="row">
							<h4>멤버 초대</h4>
							<div>
								<input type="text" placeholder="초대할멤버 이메일" name="targetUser">
							</div>
							<div>
								<a href="#">멤버추가버튼</a>
							</div>
						</div>
					</div> <!-- end addWsInputWrap -->

					<div>
						<button type="submit">workspace만들기</button>
						<button id="closeWsModal">닫기</button>
					</div>
				</form>
			</div> <!-- end modalBody -->
		</div><!-- end addWsModal -->
		
		<%------------------------------------채팅방 추가 모달  ---------------------------------------%>
		<div id="addChatModal">
			<div class="modalHead">
				<h3>채팅방 만들기</h3>
			</div>
			<div class="modalBody">
				<p>채팅방을 만들고 멤버를 초대하세요</p>
				<form action="addChat" method="post">
					<input type="hidden" class="addWnum" name="wNum">
					<input type="hidden" value="${_csrf.token}" name="${_csrf.parameterName}">
					<div class="addChatInputWrap">
						<div class="row">
							<h4>채팅방 이름</h4>
							<div>
								<input type="text" placeholder="채팅방 이름" name="crName">
							</div>
						</div>
						<div class="row">
							<h4>멤버 초대</h4>
								<ul>
<%-- 									<c:forEach items="${wsMemberList}" var="wsm"> --%>
<%-- 										<li><input type="checkbox" value="${wsm.num}" name="wsmList">${wsm.name}</li> --%>
<%-- 									</c:forEach> --%>
								</ul>
							<div>
								<a href="#">멤버추가버튼</a>
							</div>
						</div>
					</div> <!-- end addChatInputWrap -->

					<div>
						<button type="submit">채팅방 만들기</button>
						<button id="closeChatModal">닫기</button>
					</div>
				</form>
			</div> <!-- end modalBody -->
		</div><!-- end addChatModal -->
		
		<%------------------------------------멤버 추가 모달  ---------------------------------------%>
		<div id="addMemberModal">
			<div class="modalHead">
				<h3>Workspace 멤버 추가</h3>
			</div>
			<div class="modalBody">
				<p>Workspace에 멤버를 초대하세요</p>
				<form action="inviteMember" method="post">
					<input type="hidden" class="addWnum" name="wNum">
					<input type="hidden" value="${_csrf.token}" name="${_csrf.parameterName}">
					<div class="addMemberInputWrap">
						<div class="row">
							<h4>멤버 초대</h4>
							<div>
								<!-- wsNum을 알고있어야한다! -->
								<input type="text" placeholder="초대할 멤버를 입력하세요" name="targetUser">
							</div>
							
						</div>
					</div> <!-- end addMemberInputWrap -->

					<div>
						<button type="submit">멤버 초대하기</button>
						<button id="closeMemberModal">닫기</button>
					</div>
				</form>
			</div> <!-- end modalBody -->
		</div><!-- end addMemberModal -->
		
		
		
		
	</div><!-- end wsBody -->
</body>
</html>