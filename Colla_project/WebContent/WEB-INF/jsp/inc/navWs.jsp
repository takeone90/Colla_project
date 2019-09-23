<%@page import="org.springframework.web.context.request.SessionScope"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="<%=request.getContextPath() %>"/>
<script>
	function sendAlarm(wNum,mNumTo,mNumFrom,aType,aDnum){
		stompClient.send("/client/sendAlarm/"+wNum+"/"+mNumTo+"/"+mNumFrom+"/"+aDnum,{},aType);
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
		loadChatList();
		
		//프로필 이미지 누르면 모달 뜨게 하기
// 		$(".profileImg").on("click",function(){
// 			showProfileInfoModal();
// 		});
		
		
		//회원정보 모달 닫기
		$(".closeMemberInfo").on("click",function(){
			$("#memberInfoModal").fadeOut(100);
		});
	});
	function loadChatList(){
		var currWnum = $("#currWnum").val();
		var chatList = $(".chatList");
		var crNum = 
		$.ajax({
			data : {"currWnum":currWnum},
			url : "${contextPath}/getChatList",
			dataType :"json",
			success : function(d){
				chatList.empty();
				$.each(d,function(idx,item){
					var str='<li '+ ( ${sessionChatRoom.crNum} ==item.crNum?'class="currChat"':"")+'><a href="${contextPath}/chatMain?crNum='+item.crNum+'">'+item.crName+'</a></li>';
					chatList.append(str);
				});
			}
		});
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
			<h3>
				My Chats
			</h3>
			<ul class="chatList">
			</ul>
		</div>
		<div id="subfunction" align="center">
		<hr>
		<ul id="ws-subfunction" class="clearFix">
			<li>
				<a href="${contextPath}/calMonth">Calendar</a>
			</li>
			<li>
				<a href="${contextPath}/board/list">Board</a>
	    	</li>
		</ul>
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