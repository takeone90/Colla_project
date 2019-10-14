<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>

<title>워크스페이스</title>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/workspace.css"/>
<script>

	var wNum;
	
	$(function(){	
		
		
		$(".exitWs a").on("click",function(){
			var thisWnum = $(this).attr("data-wnum");
			var thisWname = $(this).attr("data-wname");
			if(confirm(thisWname +" 워크스페이스를 나가시겠습니까?")==true){
				$.ajax({
// 					exitWs?wNum=${ws.wsInfo.num}
					url : "${contextPath}/exitWs",
					data : {"thisWnum" : thisWnum},
					success : function(){
						alert("워크스페이스 나가기 성공");
						location.reload();
					},
					error : function(){
						alert("워크스페이스 나가기 오류 발생");
					}
				});
			}else{
				return false;
			}
		});
		
		
		//WS추가 모달
		$("#openWsModal").on("click",function(){
// 			$(".addInviteMemberDiv").empty();
			$("#addWsModal").fadeIn(300);
		});
		$("#closeWsModal").on("click",function(){
			$("#addWsModal").fadeOut(300);
			return false;
		});
		//ChatRoom추가 모달
		$(".openChatModal").on("click",function(){
			wNum = $(this).attr("data-wnum");
			thisWsMemberList(wNum);
			$("#thisWnum").val(wNum);
			$(".addWnum").val(wNum); //채팅방 추가모달에 숨어있는 addWnum 부분에 wNum담기
			$("#addChatModal").fadeIn(300);
			return false;
		});
		$("#closeChatModal").on("click",function(){
			$("#addChatModal").fadeOut(300);
			return false;
		});
		//WS Member추가 모달
		$(".openAddMemberModal").on("click",function(){
// 			$(".addInviteMemberDiv").empty();
			wNum = $(this).attr("data-wnum");
			$(".addWnum").val(wNum); //멤버 추가모달에 숨어있는 addWnum 부분에 wNum담기
			$("#addMemberModal").fadeIn(300);
		});
		$("#closeMemberModal").on("click",function(){
			$("#addMemberModal").fadeOut(300);
			return false;
		});
		
		
		//모달 바깥쪽이 클릭되거나 다른 모달이 클릭될때 현재 모달 숨기기
		$("#wsBody").mouseup(function(e){
			if(!$("#addWsModal").is(e.target) && $("#addWsModal").has(e.target).length===0)
			$("#addWsModal").fadeOut(300);
			if(!$("#addChatModal").is(e.target) && $("#addChatModal").has(e.target).length===0)
			$("#addChatModal").fadeOut(300);
			if(!$("#addMemberModal").is(e.target) && $("#addMemberModal").has(e.target).length===0)
			$("#addMemberModal").fadeOut(300);
			if(!$("#alarmInfoArea").is(e.target) && $("#alarmInfoArea").has(e.target).length===0){
				$("#alarmInfoArea").slideUp();
				alarmToggleVal = 0;	
				$("#deleteAllAlarm").remove();
			}
			return false;
		});
		
		
		
		//워크스페이스 하나 숨기고 닫기
		$(".showWsDetail").on("click",function(){
			if( $(this).children().hasClass('fa-angle-down')){
				$(this).parent().addClass('openedWs');
				$(this).children().attr('class','fas fa-angle-up');				
			}else{
				$(this).parent().removeClass('openedWs');
				$(this).children().attr('class','fas fa-angle-down');
			}	
			$(this).next().toggle(300);
			return false;
		});
		
		//멤버 추가버튼의 + 눌렀을때
		$(".addInviteInput").on("click",function(){
			var addInviteMemberDiv = $(".addInviteMemberDiv");
			var inputTag = $("<input type='text' placeholder='초대할멤버 이메일' name='targetUserList'>");
			addInviteMemberDiv.append(inputTag);
		});
		$(".removeInviteInput").on("click",function(){
			var addInviteMemberDiv = $(".addInviteMemberDiv");
			var lastInputTag = addInviteMemberDiv.find("input:last");
			lastInputTag.remove();
		});
		
	});// onload.function end
	function thisWsMemberList(wNum){
			var wsMemberList = $("#wsMemberList");
			var mNum = $("#mNum").val();
			$.ajax({
				url : "${contextPath}/thisWsMemberList",
				data : {"wNum":wNum},
				dataType : "json",
				success : function(d){
					wsMemberList.empty();
					$.each(d,function(idx,item){
						if(item.num!=mNum){
							var str='<label><li><input type="checkbox" value="'+item.num+'" name="mNumList">'+item.name+'</li></label>';
							wsMemberList.append(str);	
						}
						
					});
				},
				error : function(){
					alert("wsMemberList 띄우기 에러발생");
				}
			});
	}
</script>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp"%>
	<div id="wsBody">
		<input type="hidden" value="workspace" id="pageType">
		<input type="hidden" value="${sessionScope.user.num}" id="mNum">
		<div id="wsBodyContainer"> 
		<h2>워크스페이스 목록</h2>
		<c:if test="${empty workspaceList}">
			<p class="emptyMsg">워크스페이스가 없습니다</p>
		</c:if>
		<ul>
			<c:forEach items="${workspaceList}" var="ws">
				<li class="ws">
					<h3><a href="chatMain?crNum=${ws.defaultCrNum}">${ws.wsInfo.name}</a></h3>
					<h3 class="subService"><a href="projectMain?wNum=${ws.wsInfo.num}">프로젝트</a></h3>
					<h3 class="subService"><a href="board/list?wNum=${ws.wsInfo.num}">게시판</a></h3>
					<h3 class="subService"><a href="calMonth?wNum=${ws.wsInfo.num}">일정관리</a></h3>
					<a href="#" class="showWsDetail"><i class="fas fa-angle-down"></i></a>
					<%---------------------------상세보기 버튼 클릭 시 펼쳐질 wsDetail--------------------%>
					<div class="wsDetail">
						<input type="hidden" value="${ws.num}" id="wNum">
						<div class="test1">
						<div class="wsPjList">
							<p>프로젝트 리스트</p>
							<ul>
							<c:if test="${empty ws.pjList}">
								<p class="emptyMsg">프로젝트가 없습니다</p>
							</c:if>
							<c:forEach items="${ws.pjList}" var="pj">
									<li><a href="todoMain?pNum=${pj.pNum}">${pj.pName}</a></li>
							</c:forEach>
							</ul>
						</div>
						
						<div class="wsChatList">
							<p>채팅 리스트</p>
							<ul>
							<c:forEach items="${ws.crList}" var="cr">
								<c:if test="${cr.pNum ne 0}">
									<li><a href="chatMain?crNum=${cr.crNum}"><i class="fab fa-product-hunt"></i> ${cr.crName}</a></li>
								</c:if>
								<c:if test="${cr.pNum eq 0}">
									<li><a href="chatMain?crNum=${cr.crNum}">${cr.crName}</a></li>
								</c:if>
									
							</c:forEach>
								<a href="#" class="openChatModal" data-wnum="${ws.wsInfo.num}">+</a>
							</ul>
						</div>
						</div>
						<div class="test2">
						<div class="wsMember">
						<p>참여자 리스트</p>
						<ul>
						<c:forEach items="${ws.mList}" var="m"><!-- workspacemember 테이블 만들고 그 테이블리스트를 여기 넣는다 -->
							<c:forEach items="${ws.mlList}" var="ml">
								<c:if test="${m.email eq ml.key}">
									<c:set var="mlResult" value="1"/>			
								</c:if>
							</c:forEach>
							<c:choose>
								<c:when test="${mlResult eq 1}">
										<li>${m.name}</li>
									<c:set var="mlResult" value="0"/>
								</c:when>
								<c:otherwise>
										<li><div class='profileImg' align="center"><img alt='프로필사진' src='${contextPath}/showProfileImg?num=${m.num}' onclick="showProfileInfoModal(${m.num})"></div>
										<p>${m.name}</p></li>
								</c:otherwise>
							</c:choose>
						</c:forEach>
							<li class="addWsmBtnLi"><a href="#" class="openAddMemberModal" data-wnum="${ws.wsInfo.num}">+</a></li>
						</ul>
						</div>
					</div><!-- wsDetail end -->
					</div>
					
					<div class="exitWs">
<%-- 						<a href="exitWs?wNum=${ws.wsInfo.num}"><i class="fas fa-sign-out-alt"></i></a> --%>
						<a href="#" data-wnum="${ws.wsInfo.num}" data-wname="${ws.wsInfo.name}"><i class="fas fa-sign-out-alt"></i></a>
					</div>
				</li>
			</c:forEach>
			
		</ul>
		<div id="openWsDiv" align="center">
		<a href="#" id="openWsModal">+</a>
		</div>
		
<!-- 		<a href="#" id="removeEmptyChatRoom">빈 채팅방 제거하기</a> -->

		<%------------------------------------워크스페이스 추가 모달  ---------------------------------------%>
		<div id="addWsModal" class="attachModal ui-widget-content">
<!-- 			<div class="modalHead"> -->
<!-- 				<h3>Workspace 만들기</h3> -->
<!-- 				<p>Workspace를 만들고 멤버를 초대하세요</p> -->
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
								<h3 style='font-weight: bolder; font-size: 24px'>Workspace 만들기</h3>
								<p>Workspace를 만들고 멤버를 초대하세요.</p>
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
							<div class="addInviteMemberDiv">
								<input type="text" placeholder="초대할멤버 이메일" name="targetUserList">
							</div>
							<div class="inviteRoundBox" align="center">
								<a href="#" class="addInviteInput">추가</a>
								<a href="#" class="removeInviteInput">삭제</a>
							</div>
						</div>
					</div> <!-- end addWsInputWrap -->

					<div id="modalBtnDiv">
						<button type="submit">생성</button>
						<button id="closeWsModal">닫기</button>
					</div>
				</form>
			</div> <!-- end modalBody -->
		</div><!-- end addWsModal -->
		
		<%------------------------------------채팅방 추가 모달  ---------------------------------------%>
		<div id="addChatModal" class="attachModal ui-widget-content">
<!-- 			<div class="modalHead"> -->
<!-- 				<h3>채팅방 만들기</h3> -->
<!-- 				<p>채팅방을 만들고 멤버를 초대하세요</p> -->
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
								<h3 style='font-weight: bolder; font-size: 24px'>채팅방 만들기</h3>
								<p>채팅방을 만들고 멤버를 초대하세요.</p>
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
								<ul id="wsMemberList">
								</ul>
						</div>
					</div> <!-- end addChatInputWrap -->

					<div id="modalBtnDiv" align="center">
						<button type="submit">채팅방 만들기</button>
						<button id="closeChatModal">닫기</button>
					</div>
				</form>
			</div> <!-- end modalBody -->
		</div><!-- end addChatModal -->
		
		<%------------------------------------멤버 추가 모달  ---------------------------------------%>
		<div id="addMemberModal" class="attachModal ui-widget-content">
<!-- 			<div class="modalHead"> -->
<!-- 				<h3>Workspace 멤버 추가</h3> -->
<!-- 				<p>Workspace에 멤버를 초대하세요</p> -->
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
								<h3 style='font-weight: bolder; font-size: 24px'>Workspace 멤버 추가</h3>
								<p>Workspace에 멤버를 초대하세요</p>
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
				<form action="inviteMember" method="post">
					<input type="hidden" class="addWnum" name="wNum">
					<input type="hidden" value="${_csrf.token}" name="${_csrf.parameterName}">
					<div class="addMemberInputWrap">
						<div class="row">
							<h4>멤버 초대</h4>
							<div class="addInviteMemberDiv">
								<input type="text" placeholder="초대할멤버 이메일" name="targetUserList">
							</div>
							<div class="inviteRoundBox" align="center">
								<a href="#" class="addInviteInput">추가</a>
								<a href="#" class="removeInviteInput">삭제</a>
							</div>
						</div>
					</div> <!-- end addMemberInputWrap -->

					<div id="modalBtnDiv">
						<button type="submit">멤버 초대하기</button>
						<button id="closeMemberModal">닫기</button>
					</div>
				</form>
			</div> <!-- end modalBody -->
		</div><!-- end addMemberModal -->
		
		
		
		</div><!-- end wsBodyContainer -->
	</div><!-- end wsBody -->
</body>
</html>