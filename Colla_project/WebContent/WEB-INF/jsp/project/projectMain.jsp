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
			$("#addProjectModal").fadeIn(300);
		});
		$("#closePjModal").on("click",function(){
			$("#addProjectModal").fadeOut(300);
			return false;
		});
		$(".modifyProject").on("click", function() {
			$(".pNum").val($(this).attr("data-pNum"));
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
	
		<button id="addProjectBtn">프로젝트 추가</button>
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
						
						<div class="progress-member"><div class="progress">진행률  <progress id="progressBar" value="${pl.pInfo.progress}" max="100" style="width:300px;"></progress></div>
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
						<div class="row">
							<h4>프로젝트 기간</h4>
							<div id="addPj-Date">
								<input type="date" name="startDate" placeholder="시작일을 입력하세요"> ~ 
								<input type="date" name="endDate" placeholder="종료일을 입력하세요">
							</div>
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
			<div class="modalHead">
				<h3>프로젝트 멤버 추가</h3>
			</div>
			<div class="modalBody">
				<p>프로젝트에 멤버를 초대하세요</p>
				<form action="inviteProject" method="post">
					<input type="hidden" name="wNum" value="${sessionScope.currWnum}">
					<input type="hidden" class="invitePnum" name="pNum">
					<input type="hidden" value="${_csrf.token}" name="${_csrf.parameterName}">
					
					<div class="row">
							<h4>멤버 초대</h4>
							<ul class="addMemberUL">
							
<%-- 							<c:forEach items="${wsmList}" var="wsm"> --%>
<%-- 								<c:if test="${wsm.mNum ne sessionScope.user.num}"> --%>
<!-- 								<li onclick="checkInvitePjMember(this);"> -->
<!-- 								<div class='profileImg' align='center'> -->
<%-- 								<img alt='프로필사진' src='${contextPath}/showProfileImg?num=${wsm.mNum}'> --%>
<!-- 								</div> -->
<%-- 								<p style="text-align:center;">${wsm.mName}</p> --%>
<%-- 								<input type="checkbox" value="${wsm.mNum}" name="mNumListForInvitePj" style="display:none;"> --%>
<!-- 								</li> -->
<%-- 								</c:if> --%>
<%-- 							</c:forEach> --%>
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