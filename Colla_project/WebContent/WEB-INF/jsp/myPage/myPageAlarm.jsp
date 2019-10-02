<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>

<title>알람설정</title>
<link rel="stylesheet" type="text/css" href="css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="css/myPage.css"/>

<script type="text/javascript">
	$(function() {
		var arrayAlarm = [${setAlarm.workspace},${setAlarm.notice},${setAlarm.reply},${setAlarm.projectInvite},${setAlarm.todo}]; //워크스페이스, 보드, 댓글의 알림값이 배열에 저장된다 (0:알림수신x, 1:알림수신)
		for (var i = 0; i < arrayAlarm.length; i++) {
			if (arrayAlarm[i] == 0) { //설정 OFF
				$(".toggleFG:eq(" + i + ")").css('left', 0);
				$(".toggleBG:eq(" + i + ")").css('background', '#CCCCCC');
			} else { //설정 ON
				$(".toggleFG:eq(" + i + ")").css('left', 40);
				$(".toggleBG:eq(" + i + ")").css('background', '#61C3AF');
			}
		};		

		//토글 버튼 클릭 시  on/off
		for (var m = 0; m < 5; m++) {
			(function(i){
				$(".toggleBG:eq(" + i + ")").on("click", function() {
					console.log("선택한 알람 :  " + i)
					type = i;
					var left = $(".toggleFG:eq(" + i + ")").css('left');
					if (left == '40px') { //설정 OFF
						$(".toggleBG:eq(" + i + ")").css('background', '#CCCCCC');
						toggleActionStart($(".toggleFG:eq(" + i + ")"), 'TO_LEFT');
						result = 0;
						setAlarm(type,result);
					} else if (left == '0px') { //설정 ON
						$(".toggleBG:eq(" + i + ")").css('background', '#61C3AF');
						toggleActionStart($(".toggleFG:eq(" + i + ")"), 'TO_RIGHT');
						result = 1;
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
// 		console.log("ajax입성");
		$.ajax({
			url : "modifysetAlarm",
			data : {"type":type,"result":result},
			type : "get",
			dataType : "json"
		});
// 		console.log("type : " + type);
// 		console.log("result : " + result);
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
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp" %>
	<div id="wsBody">
	<input type="hidden" value="mypage" id="pageType">
		<div id="wsBodyContainer">
			<h3>마이페이지</h3>
			<h4>회원정보 관리</h4>
			<div class="myPageInner">
				<div class="myPageContent">
					<div class="myPageTitle">
						<p class="title">데이터 및 맞춤 설정</p>
						<p class="content">Colla 서비스를 더욱 유용하게 만드는데 도움을 주는 환경설정</p>
					</div>
					<div class="myPageContentRow myPageAlarmRow clearFix">
						<p class="title">워크스페이스 초대 알림</p>
						<p class="content">워크스페이스 초대 알림을 설정해주세요</p>
						<div class='toggleBG' id="wsBG">
							<button id='wsSetAlarm' class='toggleFG wsAlarm'></button>
						</div>
					</div>
					<div class="contentLine"></div>
					<div class="myPageContentRow myPageAlarmRow clearFix">
						<p class="title">공지알람</p>
						<p class="content">공지 알림을 설정해주세요</p>
						<div class='toggleBG' id="boardBG">
							<button id='boardSetAlarm' class='toggleFG boardAlarm'></button>
						</div>
					</div>
					<div class="contentLine"></div>
					<div class="myPageContentRow myPageAlarmRow clearFix">
						<p class="title">게시글 댓글 알림</p>
						<p class="content">댓글 알림을 설정해주세요</p>
						<div class='toggleBG' id="replyBG">
							<button id='replySetAlarm' class='toggleFG replyAlarm'></button>
						</div>
					</div>
					<div class="myPageContentRow myPageAlarmRow clearFix">
						<p class="title">프로젝트 초대 알림</p>
						<p class="content">프로젝트 초대 알림을 설정해주세요</p>
						<div class='toggleBG' id="replyBG">
							<button class='toggleFG replyAlarm'></button>
						</div>
					</div>
					<div class="myPageContentRow myPageAlarmRow clearFix">
						<p class="title">todo 알림</p>
						<p class="content">todo 알림을 설정해주세요</p>
						<div class='toggleBG' id="replyBG">
							<button class='toggleFG replyAlarm'></button>
						</div>
					</div>
					
				</div>
				<div class="row btns btnR">
					<a href="myPageMainForm" class="btn"><i class="fa fa-arrow-left" aria-hidden="true"></i> 이전</a>
				</div>
			</div>
		</div>
	</div>
</body>
</html>