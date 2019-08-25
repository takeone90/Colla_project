<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
	String contextPath = request.getContextPath();
	request.setAttribute("contextPath", contextPath);
%>
<title>Insert title here</title>
<style type="text/css">
.toggleBG {
	background: #CCCCCC;
	width: 70px;
	height: 30px;
	border: 1px solid #CCCCCC;
	border-radius: 15px;
}

.toggleFG {
	background: #FFFFFF;
	width: 30px;
	height: 30px;
	border: none;
	border-radius: 15px;
	position: relative;
	left: 0px;
}
</style>

<script src="https://code.jquery.com/jquery-3.4.1.js"
	integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
	crossorigin="anonymous"></script>
<script type="text/javascript">
	$(function() {
		var arrayAlarm = [${wsAlarm},${boardAlarm},${replyAlarm}]; //워크스페이스, 보드, 댓글의 알림값이 배열에 저장된다 (0:알림수신x, 1:알림수신)
		for (var i = 0; i < arrayAlarm.length; i++) {
			if (arrayAlarm[i] == 1) { //설정 ON
				$(".toggleFG:eq(" + i + ")").css('left', 0);
				$(".toggleBG:eq(" + i + ")").css('background', '#61C3AF');
			} else { //설정 OFF
				$(".toggleFG:eq(" + i + ")").css('left', 40);
				$(".toggleBG:eq(" + i + ")").css('background', '#CCCCCC');
			}
		}

		//토글 버튼 클릭 시  on/off
		for (var m = 0; m < 3; m++) {
			(function(i){
				$(".toggleBG:eq(" + i + ")").on("click", function() {
					type = i;
					var left = $(".toggleFG:eq(" + i + ")").css('left');
					if (left == '40px') { //설정 ON
						$(".toggleBG:eq(" + i + ")").css('background', '#61C3AF');
						toggleActionStart($(".toggleFG:eq(" + i + ")"), 'TO_LEFT');
						result = 1;
						setAlarm(type,result);
					} else if (left == '0px') { //설정 OFF
						$(".toggleBG:eq(" + i + ")").css('background', '#CCCCCC');
						toggleActionStart($(".toggleFG:eq(" + i + ")"), 'TO_RIGHT');
						result = 0;
						setAlarm(type,result);
					}
				});
			})(m);
		}
		
	}); //end onload

	//ajax
	function setAlarm(type,result){
		//type > 0:워크스페이스, 1:공지, 2:댓글
		//result > 0:설정ON, 1:설정OFF
		console.log("ajax입성");
		$.ajax({
			url : "testmodifysetAlarm",
			data : {"type":type,"result":result},
			type : "get",
			dataType : "json"
		});
		console.log("type : " + type);
		console.log("result : " + result);
	}
	// 토글 버튼 이동 모션 함수
	function toggleActionStart(toggleBtn, LR) {
		// 0.01초 단위로 실행
		var intervalID = setInterval(function() {
			// 버튼 이동
			var left = parseInt(toggleBtn.css('left'));
			left += (LR == 'TO_RIGHT') ? 5 : -5;
			if (left >= 0 && left <= 40) {
				left += 'px';
				toggleBtn.css('left', left);
			}
		}, 10);
		setTimeout(function() {
			clearInterval(intervalID);
		}, 201);
	}

	function getToggleBtnState(toggleBtnId) {
		const left_px = parseInt($('#' + toggleBtnId).css('left'));
		return (left_px > 0) ? "on" : "off";
	}
</script>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp"%>
	<h1>알림 설정</h1>
	워크스페이스 초대 알림
	<div class='toggleBG' id="wsBG">
		<button id='wsSetAlarm' class='toggleFG wsAlarm'></button>
	</div>

	공지 알림
	<div class='toggleBG' id="boardBG">
		<button id='boardSetAlarm' class='toggleFG boardAlarm'></button>
	</div>

	게시글 댓글 알림
	<div class='toggleBG' id="replyBG">
		<button id='replySetAlarm' class='toggleFG replyAlarm'></button>
	</div>

</body>
</html>