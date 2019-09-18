<%@page import="org.springframework.web.context.request.SessionScope"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="<%=request.getContextPath() %>"/>
<script>
	$(function(){
		loadChatList();
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
		<div id="aboutProfile">
			<a href="${contextPath }/myPageMainForm">
				<img alt="나의 프로필 사진" src="${contextPath }/showProfileImg" />
			</a>
			<p>${member.name}님</p>
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
</div>