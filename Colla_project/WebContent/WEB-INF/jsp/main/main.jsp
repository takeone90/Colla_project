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
$(window).scroll(function() {
	$('#tmp1').each(function(){
	var imagePos = $(this).offset().top;
	var topOfWindow = $(window).scrollTop();
		if (imagePos < topOfWindow+300) {
			$(this).addClass("slideUp");
		}
	});
});
$('#tmp1').click(function() {
	$(this).addClass("slideUp");
});
$(window).scroll(function() {
	$('#tmp2').each(function(){
	var imagePos = $(this).offset().top;
	var topOfWindow = $(window).scrollTop();
		if (imagePos < topOfWindow+300) {
			$(this).addClass("slideUp");
		}
	});
});
$('#tmp2').click(function() {
	$(this).addClass("slideUp");
});
</script>
</head>
<body>
	<div id="wrap">
		<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
		<div id="welcome">
			<section id="main-cover">
				<div id="container">
					<div class="head-title"><p class="animated infinite pulse">오늘도 열심히 코딩</p></div>
					<div class="animated bounceInUp"><div class="head-body">Work Together.<br>
					This Is For Collaboration.<br>
					COLLA Will Provide The Best Service.</div>
					<div class="head-caption">질수없조는 지지 않아</div></div>
				</div>
			</section>
			
			<section id="main-intro">
				<div id="container">
					<div id="tmp1">
						<div class="head-title">콜라 장점 소개</div>
						<div class="head-body">Work Together.<br>
						This Is For Collaboration.<br>
						COLLA Will Provide The Best Service.</div>
						<div class="head-caption">질수없조는 지지 않아</div>
					</div>
				</div>
			</section>
			
			<section id="main-coworker">
				<div id="container">
					<div id="tmp2">
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