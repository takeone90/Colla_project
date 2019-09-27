<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>

<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/project.css"/>
<title>프로젝트 메인</title>
<script>
	$(function(){
		//Project추가 모달
		$("#addProjectBtn").on("click",function(){
//	 		$(".addWnum").val(wNum); //멤버 추가모달에 숨어있는 addWnum 부분에 wNum담기
			$("#addProjectModal").fadeIn(300);
		});
		$("#closePjModal").on("click",function(){
			$("#addProjectModal").fadeOut(300);
			return false;
		});	
	});<%--onload-function end--%>
	
</script>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp"%>
	<div id="wsBody">
		<input type="hidden" value="project" id="pageType">
		<input type="hidden" value="${sessionScope.user.num}" id="mNum">
		<div id="wsBodyContainer"> 
		<h2>Project List</h2>
		<button id="addProjectBtn">프로젝트 추가</button>
			<div id="projectArea">
				
				<div class="project">
					<h3>프로젝트 이름</h3>
					<div class="projectInnerBtnBox">
						<a href="#">채팅방</a>
						<a href="#">Todo리스트</a>
						<a href="#">수정</a>
						<a href="#">삭제</a>
					</div>
					<div class="projectDetail">프로젝트 설명~</div>
					<div class="progress">프로젝트 진척률
						<div class="projectDate">프로젝트 기간</div>
					</div>
					
					<div class="projectMember">
						<p>참여자 목록</p>
						<ul>
							<li>아무개1</li>
							<li>아무개2</li>
							<li>아무개3</li>
						</ul>
					</div>
					
				</div>
				
				
			</div><!-- end projectArea -->
		</div><!-- end wsBodyContainer -->
		
		<%------------------------------------프로젝트 추가 모달  ---------------------------------------%>
		<div id="addProjectModal" class="attachModal ui-widget-content">
			<div class="modalHead">
				<h3>프로젝트 만들기</h3>
			</div>
			<div class="modalBody">
				<p>프로젝트를 만들고 멤버를 초대하세요</p>
<!-- 				<form action="addWs" method="post"> -->
<%-- 					<input type="hidden" value="${_csrf.token}" name="${_csrf.parameterName}"> --%>
					<div class="addPjInputWrap">
						<div class="row">
							<h4>프로젝트 이름</h4>
							<div>
<%-- 								<input type="hidden" value="${sessionScope.currWnum}" name="wNum"> --%>
								
								<input type="text" placeholder="project이름" name="pName" style="width:465px">
							</div>
						</div>
						<div class="row">
							<h4>멤버 초대</h4>
							<div class="addInviteMemberDiv">
								<input type="text" placeholder="초대할멤버 이메일" name="targetUserList" style="width:465px">
							</div>
							<div class="addInviteRoundBox" align="center">
								<a href="#" class="addInviteInput">+</a>
							</div>
						</div>
						<div class="row">
							<h4>프로젝트 기간</h4>
							<div id="addPj-Date">
								<input type="date" name="startDate" placeholder="시작일을 입력하세요"> ~ 
								<input type="date" name="endDate" placeholder="종료일을 입력하세요">
							</div>
						</div>
					</div> <!-- end addWsInputWrap -->

					<div id="modalBtnDiv">
						<button type="submit">Project만들기</button>
						<button id="closePjModal">닫기</button>
					</div>
<!-- 				</form> -->
			</div> <!-- end modalBody -->
		</div><!-- end addWsModal -->
		
	</div><!-- end wsBody -->
</body>
</html>