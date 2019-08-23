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
</style>
<script>
	$(function(){
		$("#openModal").on("click",function(){
			$("#addWsModal").fadeIn(300);
		});
		$("#closeModal").on("click",function(){
			$("#addWsModal").fadeOut(300);
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
		
			<c:forEach items="${wsList}" var="ws">
				<li class="ws">
					<h4>
						<a href="chatMain">${ws.name}</a>
					</h4>
					<div class="wsDetail">
						<div class="wsChatList">
							<p>chat List</p>
							<ul>
								<li>개발팀</li>
								<li>편집팀</li>
								<li>재무팀</li>
							</ul>
						</div>
						
						
						<div class="wsMember">
						<p>member List</p>
						<ul>
						<c:forEach items="${mList}" var="m"><!-- workspacemember 테이블 만들고 그 테이블리스트를 여기 넣는다 -->
								<li>${m.name}</li>
						</c:forEach>
						</ul>
						</div>
					</div>
					<div>
						<a href="#">나가기</a>
					</div>
				</li>
			</c:forEach>
			
		</ul>
		<div>
			<button id="openModal">워크스페이스 추가</button>
		</div>


		<!------------------------------------워크스페이스 추가 모달  --------------------------------------->
		<div id="addWsModal">
			<div class="modalHead">
				<h3>Workspace 만들기</h3>
			</div>
			<div class="modalBody">
				<p>Workspace를 만들고 멤버를 초대하세요</p>
				<form action="addWs" method="post">
					<input type="hidden" value="${_csrf.token}"
						name="${_csrf.parameterName}">
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
						<button id="closeModal">닫기</button>
					</div>
				</form>
			</div> <!-- end modalBody -->
		</div><!-- end addWsModal -->
	</div><!-- end wsBody -->
	
  

</body>
</html>