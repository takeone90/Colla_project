<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
String contextPath = request.getContextPath();
request.setAttribute("contextPath", contextPath);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="google-signin-client_id" content="504860758033-8nonf1fgo3sk1c4sfv2dv4n52tciijjo.apps.googleusercontent.com">
<title>joinStep1</title>
<link rel="stylesheet" type="text/css" href="css/reset.css"/>
<link rel="stylesheet" type="text/css" href="css/base.css"/>
<link rel="stylesheet" type="text/css" href="css/headerMain.css"/>
<script src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous"></script>
<!-- 네이버 API -->
<script type="text/javascript" src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.0.js" charset="utf-8"></script>
<!-- 구글 API -->
<script src="https://apis.google.com/js/platform.js" async defer></script>
<script type="text/javascript">
$(function() {	
	$("#emailForm").on("submit", function(e) {
		e.preventDefault();
		var emailAddress = $("#emailAddress").val(); 
		if(emailAddress == "") {
			$("#checkSentence").text("필수 정보입니다.");
		} else {
			console.log("1 ajax실행");
			var data = $(this).serialize();
			$.ajax({
				url: "checkEmailDuplication",
				data: data,
				type: "post",
				dataType: "json",
				success: function(result) {
					if(result) { //이메일 중복임
						$("#checkSentence").text("이미 가입된 이메일입니다.");
					} else { //이메일 중복 아님
						location.href="${contextPath}/sendVerifyMail";
					}
				}
			}); //end ajax 
		}
		return false;
	})
	$("#emailAddress").on("blur", function() {
		var emailAddress = $("#emailAddress").val();
		if(emailAddress == "") {
			$("#checkSentence").text("이메일을 입력해주세요.");
		} else {
			var data = $(this).parent().serialize();
			console.log("2 ajax실행");
			$.ajax({
				url: "checkEmailDuplication",
				data: data,
				type: "post",
				dataType: "json",
				success: function(result) {
					if(result) { //이메일 중복임
						$("#checkSentence").text("이미 가입된 이메일입니다.");
					} else {
						$("#checkSentence").text("멋진 이메일이네요!");
					}
				},
				error: function(request, status, error) {
					alert("request:"+request+"\n"
							+"status:"+status+"\n"
							+"error:"+error+"\n");
				}
			}); //end ajax
		}
		return false;
	});
	/* 네이버 회원가입 API */
	var naverLogin = new naver.LoginWithNaverId({
			clientId: "kIhjMaimMjKNR7gcR2nf",
			callbackUrl: "http://localhost:8081/Colla_project/callBackJoin",
			isPopup: false, /* 팝업을 통한 연동처리 여부 */
			loginButton: {color: "green", type: 3, height: 60} /* 로그인 버튼의 타입을 지정 */
		});
	/* 설정정보를 초기화하고 연동을 준비 */
	naverLogin.init();
}); //end onload
/* 구글 회원가입 */
function onSignIn(googleUser) {
	var profile = googleUser.getBasicProfile();
	$("#email").val(profile.getId());
	$("#name").val(profile.getName());
	$("#pw").val("googleapipw");
	calls();
}
function calls() {
	$("#googleForm").submit();
}
function signOut() {
	var auth2 = gapi.auth2.getAuthInstance();
	auth2.signOut().then(function () {
		console.log('User signed out.');
	});
}
</script>
</head>
<body>
<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
	<form method="post" id="emailForm">
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
		EMAIL			
		<input type="email" name="emailAddress" id="emailAddress" placeholder="example@c0lla.com">
		<span id="checkSentence"></span>
		<input type="submit" value="인증 코드 발송">
	</form>
	또는		
	<div class="g-signin2" data-onsuccess="onSignIn"></div>
	<div id="naverIdLogin">네이버 계정 연동</div>
	

		<a href="#" onclick="signOut();">Sign out</a>
		
	<form method="post" id="googleForm" action="joinMemberAPI">
		<input type="hidden" name="email" id="email">
		<input type="hidden" name="name" id="name">
		<input type="hidden" name="pw" id="pw">
	</form>
</body>
</html>