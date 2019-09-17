<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="<%=request.getContextPath()%>" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>워크스페이스</title>
<link rel="stylesheet" type="text/css" href="css/reset.css"/>
<link rel="stylesheet" type="text/css" href="css/base.css"/>
<link rel="stylesheet" type="text/css" href="css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="css/workspace.css"/>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="https://use.fontawesome.com/releases/v5.2.0/js/all.js"></script> <!-- font awsome -->
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
			
			if($(this).children().attr('class')=='fas fa-angle-down'){
				$(this).children().attr('class','fas fa-angle-up');				
			}else{
				$(this).children().attr('class','fas fa-angle-down');
			}
			$(this).next().toggle(300);
			return false;
		});
		
		
	});// onload.function end
	function thisWsMemberList(wNum){
			var wsMemberList = $("#wsMemberList");
			$.ajax({
				url : "${contextPath}/thisWsMemberList",
				data : {"wNum":wNum},
				dataType : "json",
				success : function(d){
					wsMemberList.empty();
					$.each(d,function(idx,item){
						var str='<label><li><input type="checkbox" value="'+item.num+'" name="mNumList">'+item.name+'</li></label>';
							wsMemberList.append(str);
					});
				},
				error : function(){
					alert("wsMemberList 띄우기 에러발생");
				}
			});
	}
	
	//참여자 목록
	function loginMemberInfo(msgInfo){
	
		
	}

</script>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp"%>
	<div id="wsBody">
		<input type="hidden" value="workspace" id="pageType">
		<div id="wsBodyContainer"> 
		<h2>Workspace</h2>
		<h3>Workspace List</h3>
		<ul>
			<c:forEach items="${workspaceList}" var="ws">
				<li class="ws">
					<h3>${ws.wsInfo.name}</h3>
					<a href="#" class="showWsDetail"><i class="fas fa-angle-down"></i></a>
					<%---------------------------상세보기 버튼 클릭 시 펼쳐질 wsDetail--------------------%>
					<div class="wsDetail">
						<input type="hidden" value="${ws.num}" id="wNum">
						<div class="wsChatList">
							<p>채팅리스트</p>
							<ul>
							<c:forEach items="${ws.crList}" var="cr">
								<div class="crRoundBox">
									<li><a href="chatMain?crNum=${cr.crNum}">${cr.crName}</a></li>
								</div>
							</c:forEach>
								<a href="#" class="openChatModal" data-wnum="${ws.wsInfo.num}">+</a>
							</ul>
						</div>
						
						
						<div class="wsMember">
						<p>참여자 목록</p>
						<ul>
						<c:forEach items="${ws.mList}" var="m"><!-- workspacemember 테이블 만들고 그 테이블리스트를 여기 넣는다 -->
							<c:forEach items="${ws.mlList}" var="ml">
								<c:if test="${m.email eq ml.key}">
									<c:set var="mlResult" value="1"/>			
								</c:if>
							</c:forEach>
							<c:choose>
								<c:when test="${mlResult eq 1}">
									<div class="wsmRoundBoxOn">
										<li>${m.name}</li>
									</div>
									<c:set var="mlResult" value="0"/>
								</c:when>
								<c:otherwise>
									<div class="wsmRoundBox">
										<li>${m.name}</li>
									</div>
								</c:otherwise>
							</c:choose>
						</c:forEach>
							<a href="#" class="openAddMemberModal" data-wnum="${ws.wsInfo.num}">+</a>
						</ul>
						</div>
					</div><!-- wsDetail end -->
					
					
					<div id="exitWs">
						<a href="exitWs?wNum=${ws.wsInfo.num}" style="color:red">워크스페이스 나가기</a>
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
			<input type="submit" value="임시 로그아웃 버튼" id="logoutBtn">
			
			</form>
			
		</div>
<!-- 		<a href="#" id="removeEmptyChatRoom">빈 채팅방 제거하기</a> -->

		<%------------------------------------워크스페이스 추가 모달  ---------------------------------------%>
		<div id="addWsModal" class="attachModal">
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
								<a href="#">+</a>
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
		<div id="addChatModal" class="attachModal">
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
								<ul id="wsMemberList">
								</ul>
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
		<div id="addMemberModal" class="attachModal">
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
		
		
		
		</div><!-- end wsBodyContainer -->
	</div><!-- end wsBody -->
</body>
</html>