<%@page import="org.springframework.web.context.request.SessionScope"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="<%=request.getContextPath() %>"/>
<script>
	
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
					var modalProfileInfoTag = $("<h3>이름</h3><p>"+member.name+"</p><br><h3>이메일</h3><p>"+member.email+"</p><br><h3>연락처</h3><p>"+member.phone+"</p>");
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
		if($("#pageType").val()!="workspace"){
			loadChatList();
			loadProjectList();	
		}
		
		var pageType = $("#pageType").val();
		if(pageType=="chatroom"){
			$(".chatList").show();
			$("#myChatList h3").addClass("currPointer");
			$("#projectDiv h3").removeClass("currPointer");
			$("#boardDiv h3 a").removeClass("currPointer");
			$("#calendarDiv h3 a").removeClass("currPointer");
		}else if(pageType=="project" || pageType=="todoList"){
			$("#projectList").show();
			$("#projectDiv h3").addClass("currPointer");
			$("#myChatList h3").removeClass("currPointer");
			$("#boardDiv h3 a").removeClass("currPointer");
			$("#calendarDiv h3 a").removeClass("currPointer");
		}else if(pageType=="board"){
			$("#boardDiv h3 a").addClass("currPointer");
			$("#projectDiv h3").removeClass("currPointer");
			$("#myChatList h3").removeClass("currPointer");
			$("#calendarDiv h3 a").removeClass("currPointer");
		}else if(pageType=="calendar"){
			$("#calendarDiv h3 a").addClass("currPointer");
			$("#projectDiv h3").removeClass("currPointer");
			$("#boardDiv h3 a").removeClass("currPointer");
			$("#myChatList h3").removeClass("currPointer");
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
					var str='<li '+ ( crNum ==item.crNum?'class="currChat"':"")+' onclick="goToChatRoom('+item.crNum+')"><i class="fab fa-product-hunt"></i> '+item.crName+'</li>';
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
				var defaultStr = $("<li id='projectMainLI' onclick='location.href=\"${contextPath}/projectMain?wNum="+currWnum+"\"'>프로젝트 메인</li>");
				projectList.append(defaultStr);
				$.each(pjList,function(idx,item){
					if(pNum!=""){
					var str='<li '+ ( pNum ==item.pNum?'class="currProject"':"")+' onclick="goToProject('+item.pNum+')">'+item.pName+'</li>';						
					}else{
					var str='<li onclick="goToProject('+item.pNum+')">'+item.pName+'</li>';	
					}
					projectList.append(str);
				});
			},
			error : function(){
				alert("불러오기 에러발생");
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
			<p>${member.name}님</p>
		</div>
		<!-- 로그아웃버튼 -->
		<div>
			<form action="logout" method="post">
				<input type="hidden" value="${_csrf.token}" name="${_csrf.parameterName}">
				<input type="submit" value="로그아웃" id="logoutBtn">
			</form>
		</div>
		<select name="currWorkspace" id="workspaceSelector">
		<c:forEach items="${sessionScope.workspaceList}" var="ws">
			<option class="wsSelectOption" value="${contextPath}/defaultChatMain?wNum=${ws.wsInfo.num}" ${sessionScope.currWnum eq ws.wsInfo.num?'selected':''}>${ws.wsInfo.name}</option>
		</c:forEach>
		</select>
		<script>
			var currWname = $("#currWname").val();
			$('#workspaceSelector').on('change', function() {
			    location.href= this.value;
			});
		</script>
		<div id="myChatList">
		<script>
			$(function(){
				$("#myChatList h3").on("click",function(){
					$(".chatList").toggle();
				});
				$("#projectDiv h3").on("click",function(){
					$("#projectList").toggle();
				})
			});
			
		</script>
			<h3>Chat <i class="fas fa-angle-down"></i></h3>
			<ul class="chatList">
			</ul>
		</div>
		<div id="projectDiv">
			<h3>
<%-- 				<a href="projectMain?wNum=${sessionScope.currWnum}">Project</a> --%>
				Project
				<i class="fas fa-angle-down"></i>
			</h3>
			<ul id="projectList">
			</ul>
		</div>
		<div id="boardDiv">
			<h3>
				<a href="${contextPath}/board/list?wNum=${sessionScope.currWnum}">Board</a>
			</h3>
		</div>
		<div id="calendarDiv">
			<h3>
				<a href="${contextPath}/calMonth?wNum=${sessionScope.currWnum}">Calendar</a>
			</h3>
		</div>
		<div id="mainDiv">
			<h3>
				<a href="${contextPath}/"><i class="fas fa-arrow-left"></i> Main</a>
			</h3>
		</div>
		
	</div>
	<%---------------------------------------------회원정보 모달 ----------------------------------------------------%>
		<div id="memberInfoModal" class="attachModal">
			<div class="modalHead">
				<h3 style="font-weight: bolder; font-size: 30px">회원정보</h3>
			</div>
			<br>
			<div class="modalBody" id="memberInfoBody" align="center">
					<div class="memberProfileImg"></div>
					<div class="memberProfileInfo"></div>
					<a href="#" class="closeMemberInfo">닫기</a>
			</div> <!-- end modalBody -->
		</div><!-- end memberInfoModal -->
</div>