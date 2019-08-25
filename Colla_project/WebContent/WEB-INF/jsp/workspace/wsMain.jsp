<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="<%=request.getContextPath()%>" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>워크스페이스 메인</title>
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
.wsDetail{
display : none;
}
</style>
<script>
	var wNum;

	$(function(){
		$("#openWsModal").on("click",function(){
			$("#addWsModal").fadeIn(300);
		});
		$("#closeWsModal").on("click",function(){
			$("#addWsModal").fadeOut(300);
			return false;
		});
		
		$("#openChatModal").on("click",function(){
			$("#addChatModal").fadeIn(300);
		});
		$("#closeChatModal").on("click",function(){
			$("#addChatModal").fadeOut(300);
			return false;
		});
		
		//워크스페이스 하나 숨기고 닫기
		$("#showWsDetail").on("click",function(){
			wNum = $("#wNum").val(); //눌렀을때 wNum을 쿼리에서 쓸수있게됐다.
			$(".wsDetail").toggle();
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
		
			<c:forEach items="${wsList}" var="ws">
				<li class="ws">
					<h4>${ws.name}</h4>
					<button id="showWsDetail">워크스페이스 상세보기</button>
					
					<div class="wsDetail">
						<input type="hidden" value="${ws.num}" id="wNum">
						<div class="wsChatList">
							<p>채팅리스트</p>
							<ul>
							<c:forEach items="${crList}" var="cr">
							<c:choose>
								<c:when  test="${cr.crName eq '기본채팅방'}">
									<li><a href="chatMain">${cr.crName}</a></li>
								</c:when>
								<c:otherwise>
									<li><a href="#">${cr.crName}</a></li>
								</c:otherwise>
							</c:choose>
								
							</c:forEach>
								<button id="openChatModal"> 채팅방 추가(+)</button>
							</ul>
						</div>
						
						
						<div class="wsMember">
						<p>참여자 목록</p>
						<ul>
						<c:forEach items="${mList}" var="m"><!-- workspacemember 테이블 만들고 그 테이블리스트를 여기 넣는다 -->
							<li>${m.name}</li>
						</c:forEach>
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
			<button id="openWsModal">워크스페이스 추가</button>
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
								<input type="text" placeholder="초대할멤버1" name="targetUser1">
							</div>
							<div>
								<input type="text" placeholder="초대할멤버2" name="targetUser2">
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
							<div>
								<input type="text" placeholder="초대할멤버1" name="targetUser1">
							</div>
							<div>
								<input type="text" placeholder="초대할멤버2" name="targetUser2">
							</div>
							<div>
								<a href="#">멤버추가버튼</a>
							</div>
						</div>
					</div> <!-- end addWsInputWrap -->

					<div>
						<button type="submit">채팅방 만들기</button>
						<button id="closeChatModal">닫기</button>
					</div>
				</form>
			</div> <!-- end modalBody -->
		</div><!-- end addWsModal -->
		
		
		
		
		
		
	</div><!-- end wsBody -->
</body>
</html>