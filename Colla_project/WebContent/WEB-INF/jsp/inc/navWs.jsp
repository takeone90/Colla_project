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
		$.ajax({
			data : {"currWnum":currWnum},
			url : "${contextPath}/getChatList",
			dataType :"json",
			success : function(d){
				chatList.empty();
				$.each(d,function(idx,item){
					var str='<li><a href="${contextPath}/chatMain?crNum='+item.crNum+'">'+item.crName+'</a></li>';
						chatList.append(str);
					});
			}
		});
	}
</script>
<div id="wsNav">
	<input type="hidden" value="${sessionScope.currWnum}" id="currWnum">
	<div id="navContainer">
		<div id="aboutProfile">
			<a href="${contextPath }/myPageMainForm">
				<img alt="나의 프로필 사진" src="${contextPath }/showProfileImg" />
			</a>
			<p>${member.name}님</p>
		</div>
		<select name="currWorkspace">
			<option value="1" selected>질수없조프로젝트</option>
			<option value="2"></option>
			<option value="3"></option>
		</select>
		<div id="myChatList">
			<h3>
				My Chats
			</h3>
			<ul class="chatList">
			</ul>
		</div>
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