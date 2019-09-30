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
		$("#closeModifyPjModal").on("click",function(){
			$("#modifyProjectModal").fadeOut(300);
			return false;
		});
		
		$(".exitProject").on("click",function(){
			if(confirm("프로젝트를 나가시겠습니까?")==true){
				$.ajax({
					url : "exitProject",
					data : {"pNum" : $(this).attr("data-pNum")},
					dataType : "json",
					success : function(result){
						alert("프로젝트 나가기 성공");
						location.reload();
					},
					error: function(request, status, error) {
						alert("프로젝트 나가기 실패");
					}
				});
			}else{
				return false;
			}
		});
	});<%--onload-function end--%>
	function openModifyProjectModal(){
		$(".pNum").val($(this).attr("data-pNum"));
		$("#modifyProjectModal").fadeIn(300);			
	}
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
				<c:forEach items="${projectList}" var="pl">
					<!-- 반복 -->
				<div class="project">
					<h3>${pl.pInfo.pName}</h3>
					<div class="projectInnerBtnBox">
						<a href="#">채팅방</a>
						<!-- todoMain?pNum=1 이런 요청으로 가야함 -->
						<a href="todoMain?pNum=${pl.pInfo.pNum}">Todo리스트</a>
						<a href="#" onclick='openModifyProjectModal();' data-pNum="${pl.pInfo.pNum}">수정</a>
						<a href="#" class="exitProject" data-pNum="${pl.pInfo.pNum}">나가기</a>
					</div>
					<div class="projectDetail">${pl.pInfo.pDetail}</div>
					<div class="progress">진척률 : ${pl.pInfo.progress}
						<div class="projectDate">
<%-- 						${pl.pInfo.pStartDate} ~ ${pl.pInfo.pEndDate} --%>
						<p>
						<fmt:formatDate value="${pl.pInfo.pStartDate}" pattern="yyyy.MM.dd" />
				        <fmt:formatDate value="${pl.pInfo.pStartDate}" pattern="E"/>요일 
						</p>&nbsp;&nbsp;&nbsp;~&nbsp;&nbsp;&nbsp;
						<p>
						<fmt:formatDate value="${pl.pInfo.pEndDate}" pattern="yyyy.MM.dd" />
				        <fmt:formatDate value="${pl.pInfo.pEndDate}" pattern="E"/>요일 
						</p>
						</div>
					</div>
					
					<div class="projectMember">
						<p>참여자 목록</p>
						<ul>
						<c:forEach items="${pl.pmList}" var="pm">
							<li>${pm.mName}</li>
						</c:forEach>	
						</ul>
					</div>
					
				</div><!-- 반복 종료 -->
				</c:forEach>
				
			</div><!-- end projectArea -->
		</div><!-- end wsBodyContainer -->
		
		<%------------------------------------프로젝트 추가 모달  ---------------------------------------%>
		<div id="addProjectModal" class="attachModal ui-widget-content">
			<div class="modalHead">
				<h3>프로젝트 만들기</h3>
			</div>
			<div class="modalBody">
				<p>프로젝트를 만들고 멤버를 초대하세요</p>
				<form action="addProject" method="post">
					<input type="hidden" value="${_csrf.token}" name="${_csrf.parameterName}">
					<div class="addPjInputWrap">
						<div class="row">
							<h4>프로젝트 이름</h4>
							<div>
								<input type="hidden" value="${sessionScope.currWnum}" name="wNum">
								<input type="text" placeholder="project이름" name="pName" style="width:465px">
							</div>
						</div>
						<div class="row">
							<h4>프로젝트 내용</h4>
							<div>								
								<input type="text" placeholder="어떤 project인가요?" name="pDetail" style="width:465px">
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
				</form>
			</div> <!-- end modalBody -->
		</div><!-- end addProjectModal -->
		<%------------------------------------프로젝트 수정 모달  ---------------------------------------%>
		<div id="modifyProjectModal" class="attachModal ui-widget-content">
			<div class="modalHead">
				<h3>프로젝트 수정하기</h3>
			</div>
			<div class="modalBody">
				<p>프로젝트를 수정합니다</p>
				<form action="modifyProject" method="post">
					<input type="hidden" value="${_csrf.token}" name="${_csrf.parameterName}">
					<input type="hidden" name="pNum" class="pNum">
					<div class="modifyPjInputWrap">
						<div class="row">
							<h4>프로젝트 이름</h4>
							<div>
<%-- 								<input type="hidden" value="${sessionScope.currWnum}" name="wNum"> --%>
								
								<input type="text" placeholder="project이름" name="pName" style="width:465px">
							</div>
						</div>
						<div class="row">
							<h4>프로젝트 내용</h4>
							<div>								
								<input type="text" placeholder="어떤 project인가요?" name="pDetail" style="width:465px">
							</div>
						</div>
						<div class="row">
							<h4>프로젝트 기간</h4>
							<div id="modifyPj-Date">
								<input type="date" name="startDate" placeholder="시작일을 입력하세요"> ~ 
								<input type="date" name="endDate" placeholder="종료일을 입력하세요">
							</div>
						</div>
					</div> <!-- end addWsInputWrap -->

					<div id="modalBtnDiv">
						<button type="submit">Project만들기</button>
						<button id="closeModifyPjModal">닫기</button>
					</div>
				</form>
			</div> <!-- end modalBody -->
		</div><!-- end modifyProjectModal -->
		
		
	</div><!-- end wsBody -->
</body>
</html>