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
</script>
</head>
<body>
	<div id="wrap">
		<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
		<section id="main-cover">
			<div id="container">
				<h1>커버 이미지, 슬라이드?</h1>
			</div>
		</section>
		
		<section id="main-intro">
			<div id="container">
				<h1>콜라 장점 소개</h1>
			</div>
		</section>
		
		<section id="main-coworker">
			<div id="container">
				<h1>협력사 로고와 이름</h1>
			</div>
		</section>
			
		<a href="#" onclick="signOut();">Sign out</a>
		
		<%@ include file="/WEB-INF/jsp/inc/footerMain.jsp" %>
	</div>
</body>
</html>