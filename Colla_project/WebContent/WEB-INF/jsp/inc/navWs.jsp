<%@page import="org.springframework.web.context.request.SessionScope"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="<%=request.getContextPath() %>"/>
<script>
	function chatWith(mNum){	//1:1채팅
		$.ajax({
			url: "${contextPath}/addOneOnOne",
			data: {"mNum": mNum},
			success : function(result){
				if( result > 0 ){
					window.location.href="/chatMain?crNum="+result;
				} else {
					alert("1:1 채팅 실패");
				}
			},
			error : function(){
				alert("chatWith Ajax 오류");
			}
		});
	}
	function showProfileInfoModal(mNum){
			$.ajax({
				url : "${contextPath}/getMemberInfoForProfileImg",
				data : {"mNum":mNum},
				dataType : "json",
				success : function(member){
					var imgTag = $("<img alt='님의 프로필 사진' src='${contextPath}/showProfileImg?num="+ member.num+ "'>");
					var memberProfileImgDiv = $(".memberProfileImg");
					var memberProfileInfoDiv = $(".memberProfileInfo");
					memberProfileImgDiv.empty();
					memberProfileInfoDiv.empty();
					var modalProfileInfoTag = $("<h4>이름</h4><p>"+member.name+"</p><br><h4>이메일</h4><p>"+member.email+"</p><br><h4>연락처</h4><p>" + (!member.phone? '없습니다.' : member.phone) + "</p>");
					$("#memberInfoBody #oneOnOne").remove();
					if( mNum != ${sessionScope.user.num}){
						var oneOnOne = $("<a href='#' id='oneOnOne' onclick='chatWith("+mNum+")'>1:1 채팅</a>");
						$(".closeMemberInfo").before(oneOnOne);
					}
					memberProfileImgDiv.append(imgTag);
					memberProfileInfoDiv.append(modalProfileInfoTag);
				},
				error : function(){
					alert("프로필사진 정보 불러오기 에러발생");
				}
			});
		$("#memberInfoModal").fadeIn(100);
	}
	$(function(){
		if($("#currWnum").val()!="" && $("#pageType").val()!="workspace"){
			loadChatList();
			loadProjectList();	
		}
		if($("#currWnum").val()==""){
			$(".navListDiv").hide();
		}
		
		var pageType = $("#pageType").val();
		if(pageType=="chatroom"){
			$(".chatList").show();
			$("#myChatList h3 a").addClass("currPointer");
			$("#projectDiv h3 a").removeClass("currPointer");
			$("#boardDiv h3 a").removeClass("currPointer");
			$("#calendarDiv h3 a").removeClass("currPointer");
		}else if(pageType=="project" || pageType=="todoList"){
			$("#projectList").show();
			$("#projectDiv h3 a").addClass("currPointer");
			$("#myChatList h3 a").removeClass("currPointer");
			$("#boardDiv h3 a").removeClass("currPointer");
			$("#calendarDiv h3 a").removeClass("currPointer");
		}else if(pageType=="board"){
			$("#boardDiv h3 a").addClass("currPointer");
			$("#projectDiv h3 a").removeClass("currPointer");
			$("#myChatList h3 a").removeClass("currPointer");
			$("#calendarDiv h3 a").removeClass("currPointer");
		}else if(pageType=="calendar"){
			$("#calendarDiv h3 a").addClass("currPointer");
			$("#projectDiv h3 a").removeClass("currPointer");
			$("#boardDiv h3 a").removeClass("currPointer");
			$("#myChatList h3 a").removeClass("currPointer");
		}
		
		//회원정보 모달 닫기
		$(".closeMemberInfo").on("click",function(){
			$("#memberInfoModal").fadeOut(100);
		});
	});
	function loadChatList(){
		var currWnum = $("#currWnum").val();
		var chatList = $(".chatList");
		var crNum = "${sessionChatRoom.crNum}";
		$.ajax({
			data : {"currWnum":currWnum},
			url : "${contextPath}/getChatList",
			dataType :"json",
			success : function(d){
				chatList.empty();
				$.each(d,function(idx,item){
					if(item.pNum==0){
					var str='<li '+ ( crNum ==item.crNum?'class="currChat"':"")+' onclick="goToChatRoom('+item.crNum+')">'+item.crName+'</li>';						
					}else{
					var str='<li '+ ( crNum ==item.crNum?'class="currChat"':"")+' onclick="goToChatRoom('+item.crNum+')">'+item.crName+' <i class="fab fa-product-hunt"></i></li>';
					}
					chatList.append(str);
				});
			}
		});
	}
	function loadProjectList(){
		var currWnum = $("#currWnum").val();
		var mNum = ${sessionScope.user.num};
		var pNum;
		if("${sessionScope.pNum}"!=""){
			pNum = "${sessionScope.pNum}";
		}
		var projectList = $("#projectList");
		$.ajax({
			data : {"mNum":mNum,"wNum":currWnum},
			url : "${contextPath}/getAllProjectByMnumWnum",
			dataType : "json",
			success : function(pjList){
				projectList.empty();
// 				var defaultStr = $("<li id='projectMainLI' onclick='location.href=\"${contextPath}/projectMain?wNum="+currWnum+"\"'>프로젝트 메인</li>");
// 				projectList.append(defaultStr);
				$.each(pjList,function(idx,item){
					if(pNum!=""){
					var str='<li '+ ( pNum ==item.pNum?'class="currProject"':"")+' onclick="goToProject('+item.pNum+')">'+item.pName+'</li>';						
					}else{
					var str='<li onclick="goToProject('+item.pNum+')">'+item.pName+'</li>';	
					}
					projectList.append(str);
				});
			}
		});
	}
	function goToProject(pNum){
		location.href="${contextPath}/todoMain?pNum="+pNum;
	}
	function goToChatRoom(crNum){
		location.href="${contextPath}/chatMain?crNum="+crNum;
	}
</script>
<div id="wsNav">
	<input type="hidden" value="${sessionScope.currWnum}" id="currWnum">
	<input type="hidden" value="${sessionScope.wsName}" id="currWname">
	<div id="navContainer">
		<h1 id="logo">
			<a href="${contextPath}/workspace"> <img src="${contextPath}/img/COLLA_LOGO_200px_brighten.png" />
			</a>
		</h1>
		
		<div id="aboutProfile">
			<a href="${contextPath }/myPageMainForm">
				<img alt="나의 프로필 사진" src="${contextPath }/showProfileImg" />
			</a>
			<a href="${contextPath }/myPageMainForm"><p>${member.name}님</p></a>
			<%-- <p>${member.name}님</p> --%>
		</div>
		<!-- 로그아웃버튼 -->
		<div>
			<form action="logout" method="post">
				<input type="hidden" value="${_csrf.token}" name="${_csrf.parameterName}">
				<input type="submit" value="로그아웃" id="logoutBtn">
			</form>
		</div>
		<select name="currWorkspace" id="workspaceSelector">
			<option value="" selected disabled hidden>워크스페이스를 선택하세요</option>
		<c:forEach items="${sessionScope.workspaceList}" var="ws">
			<option class="wsSelectOption" value="${contextPath}/defaultChatMain?wNum=${ws.wsInfo.num}" ${sessionScope.currWnum eq ws.wsInfo.num?'selected':''}>${ws.wsInfo.name}</option>
		</c:forEach>
		</select>
		<script>
			var currWname = $("#currWname").val();
			$('#workspaceSelector').on('change', function() {
			    location.href= this.value;
			});
			$(function(){
				$(".navListDiv h3 .arrowBtn").on("click",function(){
					$(this).parent().next("ul").toggle();
				});
				
			});
		</script>
		<div id="projectDiv" class="navListDiv">
			<h3>
				<a href="${contextPath}/projectMain?wNum=${sessionScope.currWnum}">Project</a>
				<a href="#" class="arrowBtn">
					<i class="fas fa-angle-down"></i>
				</a>
			</h3>
			<ul id="projectList">
			</ul>
		</div>
		<div id="myChatList" class="navListDiv">
			<h3>
				<a href="${contextPath}/defaultChatMain?wNum=${sessionScope.currWnum}">Chat</a>
				<a href="#" class="arrowBtn">
					<i class="fas fa-angle-down"></i>
				</a>
			</h3>
			<ul class="chatList">
			</ul>
		</div>
		<div id="boardDiv" class="navListDiv">
			<h3>
			<a href="${contextPath}/board/list?wNum=${sessionScope.currWnum}">Board</a>
			</h3>
		</div>
		<div id="calendarDiv" class="navListDiv">
			<h3>
			<a href="${contextPath}/calMonth?wNum=${sessionScope.currWnum}">Calendar</a>
			</h3>
		</div>
		<div id="mainDiv">
			<h3>
			<a href="${contextPath}/"><i class="fas fa-angle-left"></i> 메인화면</a>
			</h3>
		</div>
		
	</div>
	<%---------------------------------------------회원정보 모달 ----------------------------------------------------%>
		<div id="memberInfoModal" class="attachModal">
<!-- 			<div class="modalHead"> -->
<!-- 				<h3 style="font-weight: bolder; font-size: 30px">회원정보</h3> -->
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
								<h3 style='font-weight: bolder; font-size: 24px'>회원정보</h3>
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
			
			<br>
			<div class="modalBody" id="memberInfoBody" align="center">
					<div class="memberProfileImg"></div>
					<div class="memberProfileInfo"></div>
					<div class="btns">
						<a href="#" class="closeMemberInfo">닫기</a>
					</div>
			</div> <!-- end modalBody -->
		</div><!-- end memberInfoModal -->
</div>