<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>

<meta name="google-signin-client_id" content="504860758033-8nonf1fgo3sk1c4sfv2dv4n52tciijjo.apps.googleusercontent.com">
<title>COLLA</title>
<link rel="stylesheet" type="text/css" href="css/headerMain.css"/>
<link rel="stylesheet" type="text/css" href="css/footerMain.css"/>
<link rel="stylesheet" type="text/css" href="css/main.css"/>
<link rel="stylesheet" type="text/css" href="css/animate.css"/>
<link rel="stylesheet" type="text/css" href="css/animationCheatSheet.css"/>
<!-- 구글 API -->
<script src="https://apis.google.com/js/platform.js?onload=onLoad" async defer></script>
<script>
//구글 로그아웃
function signOut() {
	var auth2 = gapi.auth2.getAuthInstance();
	auth2.signOut().then(function () {
		console.log('User signed out.');
	});
	auth2.disconnect();
}
function onLoad() {
	gapi.load('auth2', function() {
	gapi.auth2.init();
	});
}
//두번째 섹션 animate
$(window).scroll(function() { //(윈도우 객체)사용자가 스크롤함
	$('#main-intro-ani').each(function(){
	var imagePos = $(this).offset().top; //좌표
	var topOfWindow = $(window).scrollTop(); //수직 위치(윈도우 객체의 스크롤이 몇 픽셀 이동?)
		if (imagePos < topOfWindow+300) {
			$(this).css({visibility:"visible"});
			$(this).addClass("animated fadeInUp");
		}
	});
});
//세번째 섹션 animate
$(window).scroll(function() {
	$('#main-partners-ani').each(function(){
	var imagePos = $(this).offset().top;
	var topOfWindow = $(window).scrollTop();
		if (imagePos < topOfWindow+300) {
			$(this).css({visibility:"visible"});
			$(this).addClass("animated fadeInUp");
		}
	});
});
//섹션 스크롤 이동
$(function() {
	$(".box").each(function() {
		$(this).on("mousewheel DOMMouseScroll", function(e) {
			e.preventDefault();
			var delta = 0;
			if(!event) {
				event = window.event;
			}
			if(event.wheelDelta) {
				delta = event.wheelDelta / 120;
			} else if(event.detail) {
				delta = -event.detail/3;
			}
			var moveTop = null;
			if(delta < 0) { //위에서 아래로
				if($(this).next() != undefined) {
					moveTop = $(this).next().offset().top;
				}
			} else { //아래서 위로
				if($(this).index() > 0) {
					if($(this).prev() != undefined) {
						moveTop = $(this).prev().offset().top;
					}
				} else  { //헤더 보이기
					moveTop = 0;
				}
			}
			$("html, body").stop().animate({
				scrollTop: moveTop + 'px'
			}, {
				duration: 800, complete: function () {
				}
			});
		})
	})	
});
//클릭하면 이미지 변경
$(function() {
	$(".main-function-details1").on("click", function() {
		$(".main-function-image1").css('z-index', 10);
		$(".main-function-image2").css('z-index', 1);
		$(".main-function-image3").css('z-index', 1);
		$(this).toggleClass('on');
		$(".main-function-details2").removeClass('on');
		$(".main-function-details3").removeClass('on');
	});
	$(".main-function-details2").on("click", function() {
		$(".main-function-image1").css('z-index', 1);
		$(".main-function-image2").css('z-index', 10);
		$(".main-function-image3").css('z-index', 1);
		$(".main-function-details1").removeClass('on');
		$(this).toggleClass('on');
		$(".main-function-details3").removeClass('on');
	});	
	$(".main-function-details3").on("click", function() {
		$(".main-function-image1").css('z-index', 1);
		$(".main-function-image2").css('z-index', 1);
		$(".main-function-image3").css('z-index', 10);
		$(".main-function-details1").removeClass('on');
		$(".main-function-details2").removeClass('on');
		$(this).toggleClass('on');
	});		
});
</script>
</head>
<body>
	<div id="wrap">
		<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
		<div id="welcome">
			<section id="main-cover" class="box">
				<div id="container">
					<div class="head-body-up animated fadeInUp">.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;.</div>
					<div class="head-body-down animated fadeInUp">가볍고 실속있는 협업 솔루션</div>
					<div class="head-title"><p class="animated fadeInUp">COLLA</p></div>
					<div class="head-caption animated fadeInUp">COLLA는 프로젝트를 중심으로<br>외부인들과 빠른 협업을 돕습니다.</div>
				</div>
			</section>
			
			<section id="main-intro" class="box">
				<div id="container">
					<div id="main-intro-ani">
						<div class="head-body"></div>
						<div class="main-function">
							<div class="main-function-images">
								<div class="main-function-image1">
								<div class="main-function-text">간단하게 프로젝트를 생성하고 그룹을 만드세요.</div>
								<img alt="1번 기능" src="img/mainSection_1.png"></div>
								<div class="main-function-image2">
								<div class="main-function-text">그룹에 맞는 채팅방을 만들고 협업할 수 있습니다.</div>
								<img alt="2번 기능" src="img/mainSection_2.png"></div>
								<div class="main-function-image3">
								<div class="main-function-text">쉽게 일정을 공유하고 관리할 수 있습니다.</div>
								<img alt="3번 기능" src="img/mainSection_3.png"></div>
							</div>
							<div class="main-function-details">
								<label class="clicked"><input type="radio" name="main-function-radio" id="radio1" value="1">
								<span class="main-function-details1"><span>가볍게<br><span class="bold">프로젝트</span> 생성</span></span></label>

								<label class="none-clicked"><input type="radio" name="main-function-radio" id="radio2" value="2">
								<span class="main-function-details2"><span>프로젝트 <span class="bold">채팅방</span>으로<br>원하는 멤버들과 채팅</span></span></label>
									
								<label class="none-clicked"><input type="radio" name="main-function-radio" id="radio3" value="3">
								<span class="main-function-details3"><span>멤버들과 <span class="bold">일정</span>을<br>공유하고 관리</span></span></label>
									
							</div>
						</div>
					</div>
				</div>
			</section>
			<section id="main-partners" class="box">
				<div id="container">
					<div id="main-partners-ani">
						<div class="head-body">COLLA와 함께하는 협력사</div>
						<div class="head-caption">Partners</div>
						<div class="partners-list">
							<div class="partner-logo">맡겨주</div>
							<div class="partner-logo">화랑</div>
							<div class="partner-logo">인삼</div>
							<div class="partner-logo">WeAre</div>
						</div>
					</div>
				</div>
			</section>
			<div><%@ include file="/WEB-INF/jsp/inc/footerMain.jsp" %></div>
		</div>	
		<a href="#" onclick="signOut();">Sign out</a>
	</div>
</body>
</html>