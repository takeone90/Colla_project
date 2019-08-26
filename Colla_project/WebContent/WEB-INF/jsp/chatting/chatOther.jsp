<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>개별 채팅</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script>

$(function(){
	var crNum = $("#crNum").val();
	var str = crNum + "번 채팅방";
	$("#chatRoomInfo > p").text(str);
});
</script>
</head>
<body>
<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp" %>
<%@ include file="/WEB-INF/jsp/inc/navWs.jsp" %>
	<div id="wsBody">
		<div class="chatArea">
			<input type="hidden" value="${chatRoom.crNum}" id="crNum"> <!-- 개별채팅방에 해당 chatRoom 객체가 떠다님 -->
			
			<div class="chat">
				<div class="profileImg">
					<a href="#"> 이미지 <img alt="" src=""></a>
				</div>
				<div class="name">
					<p>
						이름 <span class="date">작성시간</span>
					</p>
				</div>
				<p class="content">메세지 내용</p>
			</div>
		</div>
		<div id="inputBox">
			<a id="attachBtn" href="#">첨부파일</a>
			<input type="text" id="chatInput" placeholder="메세지 작성부분">
			<a id="sendChat" href="#">전송</a>
		</div>
	</div>
</body>
</html>