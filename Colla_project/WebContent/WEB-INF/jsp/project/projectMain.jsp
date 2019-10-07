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
		$("#addProjectDiv").on("click",function(){
			$("#addProjectModal").fadeIn(300);
		});
		$("#closePjModal").on("click",function(){
			$("#addProjectModal").fadeOut(300);
			return false;
		});
		$(".modifyProject").on("click", function() {
			var pNum = $(this).attr("data-pNum");
			$(".pNum").val(pNum);
			$.ajax({
				url : "${contextPath}/getProject",
				data : {"pNum":pNum},
				dataType : "json",
				success : function(project){
					$("#pjName").val(project.pName);
					$("#pjDetail").val(project.pDetail);
				}
			});
			$("#modifyProjectModal").fadeIn(300);	
		});
		$("#closeModifyPjModal").on("click",function(){
			$("#modifyProjectModal").fadeOut(300);
			return false;
		});
		$("#closeMemberModal").on("click",function(){
			$("#addMemberModal").fadeOut(300);
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
		<div id="addProjectDiv" align="center">프로젝트 추가</div>
<!-- 		<button id="addProjectBtn">프로젝트 추가</button> -->
			<div id="projectArea">
				<c:forEach items="${projectList}" var="pl">
					<!-- 반복 -->
					<div class="project">
						<h3>${pl.pInfo.pName}</h3>
						<c:forEach var="tmp" items="${pl.pmList}">
							<c:if test="${sessionScope.user.num eq tmp.mNum}">
								<div class="projectInnerBtnBox">
									<a href="todoMain?pNum=${pl.pInfo.pNum}" class="todoListATag">Todo리스트</a>
									<a href="chatMain?crNum=${pl.pInfo.crNum}">채팅방</a>
									<!-- todoMain?pNum=1 이런 요청으로 가야함 -->
									<a href="#" class="modifyProject" data-pNum="${pl.pInfo.pNum}">수정하기</a>
									<a href="#" class="addMemberBtn" data-pNum="${pl.pInfo.pNum}">초대하기</a>
									<a href="#" class="exitProject" data-pNum="${pl.pInfo.pNum}">나가기</a>
								</div>
							</c:if>
						</c:forEach>
						<div class="projectDate">
							<p>
							<fmt:formatDate value="${pl.pInfo.pStartDate}" pattern="yyyy.MM.dd" />
					        <fmt:formatDate value="${pl.pInfo.pStartDate}" pattern="E"/>요일 
							</p>&nbsp;&nbsp;&nbsp;~&nbsp;&nbsp;&nbsp;
							<p>
							<fmt:formatDate value="${pl.pInfo.pEndDate}" pattern="yyyy.MM.dd" />
					        <fmt:formatDate value="${pl.pInfo.pEndDate}" pattern="E"/>요일 
							</p>
							</div>
						<div class="projectDetail">${pl.pInfo.pDetail}</div>
						
						<div class="progress-member"><div class="progress">진행률  <progress id="progressBar" value="${pl.pInfo.progress}" max="100" style="width:504px;"></progress></div>
							<div class="projectMember">
								<ul>
									<c:forEach items="${pl.pmList}" var="pm">
										<li><div class='profileImg' align="center"><img alt='프로필사진' src='${contextPath}/showProfileImg?num=${pm.mNum}' onclick="showProfileInfoModal(${pm.mNum})"></div>
										<p style="text-align:center;">${pm.mName}</p></li>
									</c:forEach>	
								</ul>
							</div>
						</div>
					</div>
					<!-- 반복 종료 -->
				</c:forEach>
			</div><!-- end projectArea -->
		</div><!-- end wsBodyContainer -->
		
		<%------------------------------------프로젝트 추가 모달  ---------------------------------------%>
		<div id="addProjectModal" class="attachModal ui-widget-content">
<!-- 			<div class="modalHead"> -->
<!-- 				<h3>프로젝트 만들기</h3> -->
<!-- 				<p style="margin-bottom: 26px;">프로젝트를 만들고 멤버를 초대하세요</p> -->
<!-- 			</div> -->
			
			<div class="header">
						<!--파도 위 내용-->
						<div class="inner-header flex">
							<g><path fill="#fff"
							d="M250.4,0.8C112.7,0.8,1,112.4,1,250.2c0,137.7,111.7,249.4,249.4,249.4c137.7,0,249.4-111.7,249.4-249.4
							C499.8,112.4,388.1,0.8,250.4,0.8z M383.8,326.3c-62,0-101.4-14.1-117.6-46.3c-17.1-34.1-2.3-75.4,13.2-104.1
							c-22.4,3-38.4,9.2-47.8,18.3c-11.2,10.9-13.6,26.7-16.3,45c-3.1,20.8-6.6,44.4-25.3,62.4c-19.8,19.1-51.6,26.9-100.2,24.6l1.8-39.7		
							c35.9,1.6,59.7-2.9,70.8-13.6c8.9-8.6,11.1-22.9,13.5-39.6c6.3-42,14.8-99.4,141.4-99.4h41L333,166c-12.6,16-45.4,68.2-31.2,96.2	
							c9.2,18.3,41.5,25.6,91.2,24.2l1.1,39.8C390.5,326.2,387.1,326.3,383.8,326.3z" /></g>
							</svg>
							<div class="loginBox-Head">
								<h3 style='font-weight: bolder; font-size: 24px'>프로젝트 만들기</h3>
								<p style="margin-bottom: 26px;">프로젝트를 만들고 멤버를 초대하세요</p>
							</div>
						</div>
						<!--파도 시작-->
						<div>
							<svg class="waves" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
							viewBox="0 24 150 28" preserveAspectRatio="none" shape-rendering="auto">
							<defs>
							<path id="gentle-wave" d="M-160 44c30 0 58-18 88-18s 58 18 88 18 58-18 88-18 58 18 88 18 v44h-352z" />
							</defs>
								<g class="parallax">
								<use xlink:href="#gentle-wave" x="48" y="0" fill="rgba(255,255,255,0.7" />
								<use xlink:href="#gentle-wave" x="48" y="3" fill="rgba(255,255,255,0.5)" />
								<use xlink:href="#gentle-wave" x="48" y="7" fill="#fff" />
								</g>
							</svg>
						</div><!--파도 end-->
			</div><!--header end-->
			
			<div class="modalBody">
				<form action="addProject" method="post">
					<input type="hidden" value="${_csrf.token}" name="${_csrf.parameterName}">
					<div class="addPjInputWrap">
						<div class="row">
							<h4>프로젝트 이름</h4>
							<div>
								<input type="hidden" value="${sessionScope.currWnum}" name="wNum">
								<input type="text" placeholder="project이름" name="pName" style="width:409px">
							</div>
						</div>
						<div class="row">
							<h4>프로젝트 내용</h4>
							<div>								
								<input type="text" placeholder="어떤 project인가요?" name="pDetail" style="width:409px">
							</div>
						</div>
						<div class="row">
							<h4>프로젝트 기간</h4>
							<div id="addPj-Date">
								<input type="date" name="startDate" placeholder="시작일을 입력하세요"> ~ 
								<input type="date" name="endDate" placeholder="종료일을 입력하세요">
							</div>
						</div>
						<div class="row">
							<h4>멤버 초대</h4>
							<ul class="addInviteMemberUL">
							<c:forEach items="${wsmList}" var="wsm">
								<c:if test="${wsm.mNum ne sessionScope.user.num}">
								<li onclick="checkInvitePjMember(this);">
								<div class='profileImg' align="center">
								<img alt='프로필사진' src='${contextPath}/showProfileImg?num=${wsm.mNum}'>
								</div>
								<p style="text-align:center;">${wsm.mName}</p>
								<input type="checkbox" value="${wsm.mNum}" name="mNumListForInvitePj" style="display:none;">
								</li>
								<script>
									function checkInvitePjMember(tag){
										let $checkInput = $(tag).find("input[name='mNumListForInvitePj']");
										$checkInput.prop('checked',function(){
											if($checkInput.is(":checked")){
												$(tag).removeClass("checkedLI");
											} else{
												$(tag).addClass("checkedLI");
											}			
											return !$(this).prop('checked');
										});
									}
								</script>
								</c:if>
							</c:forEach>
							
							
							</ul>
						</div>
						
					</div> <!-- end addWsInputWrap -->
					<div id="modalBtnDiv">
						<button type="submit">프로젝트 만들기</button>
						<button id="closePjModal">닫기</button>
					</div>
				</form>
			</div> <!-- end modalBody -->
		</div><!-- end addProjectModal -->
		<%------------------------------------프로젝트 수정 모달  ---------------------------------------%>
		<div id="modifyProjectModal" class="attachModal ui-widget-content">
<!-- 			<div class="modalHead"> -->
<!-- 				<h3>프로젝트 수정하기</h3> -->
<!-- 				<p>프로젝트를 수정합니다</p> -->
<!-- 			</div> -->
			
			<div class="header">
						<!--파도 위 내용-->
						<div class="inner-header flex">
							<g><path fill="#fff"
							d="M250.4,0.8C112.7,0.8,1,112.4,1,250.2c0,137.7,111.7,249.4,249.4,249.4c137.7,0,249.4-111.7,249.4-249.4
							C499.8,112.4,388.1,0.8,250.4,0.8z M383.8,326.3c-62,0-101.4-14.1-117.6-46.3c-17.1-34.1-2.3-75.4,13.2-104.1
							c-22.4,3-38.4,9.2-47.8,18.3c-11.2,10.9-13.6,26.7-16.3,45c-3.1,20.8-6.6,44.4-25.3,62.4c-19.8,19.1-51.6,26.9-100.2,24.6l1.8-39.7		
							c35.9,1.6,59.7-2.9,70.8-13.6c8.9-8.6,11.1-22.9,13.5-39.6c6.3-42,14.8-99.4,141.4-99.4h41L333,166c-12.6,16-45.4,68.2-31.2,96.2	
							c9.2,18.3,41.5,25.6,91.2,24.2l1.1,39.8C390.5,326.2,387.1,326.3,383.8,326.3z" /></g>
							</svg>
							<div class="loginBox-Head">
								<h3 style='font-weight: bolder; font-size: 24px'>프로젝트 수정하기</h3>
								<p style="margin-bottom: 26px;">프로젝트를 수정합니다</p>
							</div>
						</div>
						<!--파도 시작-->
						<div>
							<svg class="waves" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
							viewBox="0 24 150 28" preserveAspectRatio="none" shape-rendering="auto">
							<defs>
							<path id="gentle-wave" d="M-160 44c30 0 58-18 88-18s 58 18 88 18 58-18 88-18 58 18 88 18 v44h-352z" />
							</defs>
								<g class="parallax">
								<use xlink:href="#gentle-wave" x="48" y="0" fill="rgba(255,255,255,0.7" />
								<use xlink:href="#gentle-wave" x="48" y="3" fill="rgba(255,255,255,0.5)" />
								<use xlink:href="#gentle-wave" x="48" y="7" fill="#fff" />
								</g>
							</svg>
						</div><!--파도 end-->
			</div><!--header end-->
			
			<div class="modalBody">
				
				<form action="modifyProject" method="post">
					<input type="hidden" value="${_csrf.token}" name="${_csrf.parameterName}">
					<input type="hidden" name="pNum" class="pNum">
					<div class="modifyPjInputWrap">
						<div class="row">
							<h4>프로젝트 이름</h4>
							<div>
								<input type="hidden" value="${sessionScope.currWnum}" name="wNum">
								<input type="text" placeholder="project이름" name="pName" style="width:409px" id="pjName">
							</div>
						</div>
						<div class="row">
							<h4>프로젝트 내용</h4>
							<div>								
								<input type="text" placeholder="어떤 project인가요?" name="pDetail" style="width:409px" id="pjDetail">
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
						<button type="submit">프로젝트 수정하기</button>
						<button id="closeModifyPjModal">닫기</button>
					</div>
				</form>
			</div> <!-- end modalBody -->
		</div><!-- end modifyProjectModal -->
		
		
		<%------------------------------------멤버 추가 모달  ---------------------------------------%>
		<div id="addMemberModal" class="attachModal ui-widget-content">
<!-- 			<div class="modalHead"> -->
<!-- 				<h3>프로젝트 멤버 추가</h3> -->
<!-- 				<p>프로젝트에 멤버를 초대하세요</p> -->
<!-- 			</div> -->
			
			<div class="header">
						<!--파도 위 내용-->
						<div class="inner-header flex">
							<g><path fill="#fff"
							d="M250.4,0.8C112.7,0.8,1,112.4,1,250.2c0,137.7,111.7,249.4,249.4,249.4c137.7,0,249.4-111.7,249.4-249.4
							C499.8,112.4,388.1,0.8,250.4,0.8z M383.8,326.3c-62,0-101.4-14.1-117.6-46.3c-17.1-34.1-2.3-75.4,13.2-104.1
							c-22.4,3-38.4,9.2-47.8,18.3c-11.2,10.9-13.6,26.7-16.3,45c-3.1,20.8-6.6,44.4-25.3,62.4c-19.8,19.1-51.6,26.9-100.2,24.6l1.8-39.7		
							c35.9,1.6,59.7-2.9,70.8-13.6c8.9-8.6,11.1-22.9,13.5-39.6c6.3-42,14.8-99.4,141.4-99.4h41L333,166c-12.6,16-45.4,68.2-31.2,96.2	
							c9.2,18.3,41.5,25.6,91.2,24.2l1.1,39.8C390.5,326.2,387.1,326.3,383.8,326.3z" /></g>
							</svg>
							<div class="loginBox-Head">
								<h3 style='font-weight: bolder; font-size: 24px'>프로젝트 멤버 추가</h3>
								<p style="margin-bottom: 26px;">프로젝트에 멤버를 초대하세요</p>
							</div>
						</div>
						<!--파도 시작-->
						<div>
							<svg class="waves" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
							viewBox="0 24 150 28" preserveAspectRatio="none" shape-rendering="auto">
							<defs>
							<path id="gentle-wave" d="M-160 44c30 0 58-18 88-18s 58 18 88 18 58-18 88-18 58 18 88 18 v44h-352z" />
							</defs>
								<g class="parallax">
								<use xlink:href="#gentle-wave" x="48" y="0" fill="rgba(255,255,255,0.7" />
								<use xlink:href="#gentle-wave" x="48" y="3" fill="rgba(255,255,255,0.5)" />
								<use xlink:href="#gentle-wave" x="48" y="7" fill="#fff" />
								</g>
							</svg>
						</div><!--파도 end-->
			</div><!--header end-->
			
			<div class="modalBody">
				<form action="inviteProject" method="post">
					<input type="hidden" name="wNum" value="${sessionScope.currWnum}">
					<input type="hidden" class="invitePnum" name="pNum">
					<input type="hidden" value="${_csrf.token}" name="${_csrf.parameterName}">
					
					<div class="row">
							<h4>멤버 초대</h4>
							<ul class="addMemberUL">
							</ul>
							<script>
								$(function(){
									$(".addMemberBtn").on("click",function(){
										$(".invitePnum").val($(this).attr("data-pNum"));
										var addMemberUL = $(".addMemberUL");
										addMemberUL.empty();
										var pNum = $(this).attr("data-pNum");
										$.ajax({
											url : "${contextPath}/getPmList",
											data : {"pNum":pNum},
											dataType : "json",
											success : function(jsonPmList){
												$.each(jsonPmList,function(idx,item){
													var wsmList = item;
													
													var inviteMemberLI = $("<li onclick='checkInvitePjMember(this);'></li>");
													var profileImgTag = $("<div class='profileImg' align='center'><img alt='프로필사진' src='${contextPath}/showProfileImg?num="+wsmList.mNum+"'></div>");
													inviteMemberLI.append(profileImgTag);
													var memberNameTag = $("<p style='text-align:center;'>"+wsmList.mName+"</p>");
													var checkboxInputTag = $("<input type='checkbox' value='"+wsmList.mNum+"' name='mNumListForInvitePj' style='display:none;'>");
													inviteMemberLI.append(memberNameTag);
													inviteMemberLI.append(checkboxInputTag);
													addMemberUL.append(inviteMemberLI);
													
												});
												return false;
											},
											error : function(){
												alert("pmList불러오기 에러발생");
											}
											
										});
										$("#addMemberModal").fadeIn(300);
									});
								});
							</script>
						</div>
					<div id="modalBtnDiv">
						<button type="submit">멤버 초대하기</button>
						<button id="closeMemberModal">닫기</button>
					</div>
				</form>
			</div> <!-- end modalBody -->
		</div><!-- end addMemberModal -->
		
		
	</div><!-- end wsBody -->
</body>
</html>