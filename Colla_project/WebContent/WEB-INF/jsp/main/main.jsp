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
//두번째 섹션
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
//세번째 섹션
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
//클릭하면 이미지 변경
$(function() {
	$(".main-function-details1").on("click", function() {
		$(".main-function-image1").css('z-index', 10);
		$(".main-function-image2").css('z-index', 1);
		$(".main-function-image3").css('z-index', 1);
	});	
	$(".main-function-details2").on("click", function() {
		$(".main-function-image1").css('z-index', 1);
		$(".main-function-image2").css('z-index', 10);
		$(".main-function-image3").css('z-index', 1);
	});	
	$(".main-function-details3").on("click", function() {
		$(".main-function-image1").css('z-index', 1);
		$(".main-function-image2").css('z-index', 1);
		$(".main-function-image3").css('z-index', 10);
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
					<div class="head-title"><p class="animated infinite pulse">오늘도 열심히 코딩</p></div>
					<div class="animated fadeInUp"><div class="head-body">Work Together.<br>
					This Is For Collaboration.<br>
					COLLA Will Provide The Best Service.</div>
					<div class="head-caption">질수없조는 지지 않아</div></div>
				</div>
			</section>
			
			<section id="main-intro" class="box">
				<div id="container">
					<div id="main-intro-ani">
						<div class="head-title">콜라 기능 소개</div>
<!-- 						<div class="head-body"></div> -->
<!-- 						<div class="head-caption"></div> -->
						<div class="main-function">
							<div class="main-function-images">
								<div class="main-function-image1">사진1</div>
								<div class="main-function-image2">사진2</div>
								<div class="main-function-image3">사진3</div>
							</div>
							<div class="main-function-details">
								<div class="main-function-details1">
									<p>기능1</p>
									<p>기능 설명1</p>
								</div>
								<div class="main-function-details2">
									<p>기능2</p>
									<p>기능 설명2</p>
								</div>
								<div class="main-function-details3">
									<p>기능3</p>
									<p>기능 설명3</p>
								</div>
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
		</div>	
		<a href="#" onclick="signOut();">Sign out</a>
		<%@ include file="/WEB-INF/jsp/inc/footerMain.jsp" %>
	</div>
</body>
</html>