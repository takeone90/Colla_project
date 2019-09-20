<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="google-signin-client_id" content="504860758033-8nonf1fgo3sk1c4sfv2dv4n52tciijjo.apps.googleusercontent.com">
<title>COLLA</title>
<link rel="stylesheet" type="text/css" href="css/reset.css"/>
<link rel="stylesheet" type="text/css" href="css/base.css"/>
<link rel="stylesheet" type="text/css" href="css/headerMain.css"/>
<link rel="stylesheet" type="text/css" href="css/footerMain.css"/>
<link rel="stylesheet" type="text/css" href="css/main.css"/>
<link rel="stylesheet" type="text/css" href="css/animate.css"/>
<link rel="stylesheet" type="text/css" href="css/animationCheatSheet.css"/>
<script src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous"></script>
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
	$('#main-coworker-ani').each(function(){
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
// 		$(".main-function-details1").toggleClass('on');
// 		$(".main-function-details2").toggleClass('on');
// 		$(".main-function-details3").toggleClass('on');
	});	
	$(".main-function-details2").on("click", function() {
		$(".main-function-image1").css('z-index', 1);
		$(".main-function-image2").css('z-index', 10);
		$(".main-function-image3").css('z-index', 1);
// 		$(".main-function-details1").toggleClass('on');
// 		$(".main-function-details2").toggleClass('on');
// 		$(".main-function-details3").toggleClass('on');
	});	
	$(".main-function-details3").on("click", function() {
		$(".main-function-image1").css('z-index', 1);
		$(".main-function-image2").css('z-index', 1);
		$(".main-function-image3").css('z-index', 10);
// 		$(".main-function-details1").toggleClass('on');
// 		$(".main-function-details2").toggleClass('on');
// 		$(".main-function-details3").toggleClass('on');
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
					<div class="head-body">가볍고 실속있는 협업 솔루션</div>
					<div class="head-title"><p class="animated fadeInUp">COLLA</p></div>
					<div class="head-caption animated fadeInUp">COLLA는 프로젝트를 중심으로<br>외부인들과 빠른 협업을 돕습니다.</div>
				</div>
			</section>
			
			<section id="main-intro" class="box">
				<div id="container">
					<div id="main-intro-ani">
						<div class="head-body">간단하게 프로젝트를 생성하고 그룹을 만드세요!</div>
						<div class="main-function">
							<div class="main-function-images">
								<div class="main-function-image1">사진1</div>
								<div class="main-function-image2">사진2</div>
								<div class="main-function-image3">사진3</div>
							</div>
							<div class="main-function-details">
							
								<input type="radio" name="main-function-radio">
								<label class="clicked"><span class="main-function-details1"><span>가볍게<br>프로젝트 생성</span></span></label>

								<input type="radio" name="main-function-radio">
								<label class="none-clicked"><span class="main-function-details2"><span>프로젝트 채팅방으로<br>원하는 멤버들과 채팅</span></span></label>
									
								<input type="radio" name="main-function-radio">
								<label class="none-clicked"><span class="main-function-details3"><span>멤버들과 일정을<br>공유하고 관리</span></span></label>
									
							</div>
						</div>
					</div>
				</div>
			</section>
			
			<section id="main-coworker" class="box">
				<div id="container">
					<div id="main-coworker-ani">
						<div class="head-title">협력사 로고와 이름</div>
						<div class="head-body">Work Together.<br>
						This Is For Collaboration.<br>
						COLLA Will Provide The Best Service.</div>
						<div class="head-caption">질수없조는 지지 않아</div>
					</div>
				</div>
			</section>
			<div class="box"><%@ include file="/WEB-INF/jsp/inc/footerMain.jsp" %></div>
		</div>	
		<a href="#" onclick="signOut();">Sign out</a>
		
	</div>
</body>
</html>