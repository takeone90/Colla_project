<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<!-- 구글 -->
<meta name="google-signin-client_id"
	content="504860758033-8nonf1fgo3sk1c4sfv2dv4n52tciijjo.apps.googleusercontent.com">
<!-- 카카오 -->
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport"
	content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width" />
<title>로그인</title>
<link rel="stylesheet" type="text/css" href="css/reset.css"/>
<link rel="stylesheet" type="text/css" href="css/base.css"/>
<link rel="stylesheet" type="text/css" href="css/headerMain.css"/>
<script src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous"></script>
<!-- 네이버 -->
<script type="text/javascript" src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.0.js" charset="utf-8"></script>
<!-- 구글 -->
<script src="https://apis.google.com/js/platform.js" async defer></script>
<!-- 카카오 -->
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript">
$(function(){
	$("#g-signin2").on("click", function() {
		
	})
	
	$("#loginForm").on("submit", function() {
		var emailResult = checkEmail();
		var pwResult = checkPw();
		if(emailResult && pwResult){
		}else{
			return false;
		}
	});
	/* 네이버 로그인 API */
	var naverLogin = new naver.LoginWithNaverId({
		clientId: "kIhjMaimMjKNR7gcR2nf",
		callbackUrl: "http://localhost:8081/Colla_project/callBackLogin",
		isPopup: false, /* 팝업을 통한 연동처리 여부 */
		loginButton: {color: "green", type: 3, height: 60} /* 로그인 버튼의 타입을 지정 */
	});
	/* 설정정보를 초기화하고 연동을 준비 */
	naverLogin.init();
	
	/* 카카오 회원가입 API */
	Kakao.init('1f6b481e9aa9a7ae0b621fee3692c041'); 
	Kakao.Auth.createLoginButton({ // 카카오 로그인 버튼을 생성합니다.
		container : '#kakao-login-btn',
		success : function(authObj) {
			Kakao.API.request({
				url : '/v1/user/me',
				success : function(res) {
					$("#emailOfApiForm").val(res.kaccount_email);
					$("#nameOfApiForm").val(res.properties.nickname);
					$("#pwOfApiForm").val("kakaoapipw");
					calls();
				},
				fail : function(error) {
					alert(JSON.stringify(error));
				}
			});
		},
		fail : function(err) {
			alert(JSON.stringify(err));
		}
	});
});//end onload
function checkEmail(){
	var email = $("#email").val();
	if(email == "") {
		$("#checkEmailText").text("이메일을 입력해주세요.");
		return false;
	}else{
		$("#checkEmailText").text("");
		return true;
	}
}
function checkPw(){
	var pw = $("#pw").val();
	if(pw == "") {
		$("#checkPwText").text("비밀번호를 입력해주세요.");
		return false;
	}else{
		$("#checkPwText").text("");
		return true;
	}
}
/* 구글 로그인 */
function onSignIn(googleUser) {
	var profile = googleUser.getBasicProfile();
	$("#emailOfApiForm").val(profile.getEmail());
	$("#nameOfApiForm").val(profile.getName());
	$("#pwOfApiForm").val("googleapipw");
	calls();
}
function calls() {
	$("#apiForm").submit();
}
</script>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
	<form action="login" method="post" id="loginForm">	
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
		<input type="text" name="m_email" placeholder="이메일을 입력해주세요." id="email">
		<span id="checkEmailText"></span>
		<input type="password" name="m_pw" placeholder="비밀번호를 입력해주세요." id="pw">
		<span id="checkPwText"></span>
		<input type="submit" value="로그인">
	</form>
	<!-- 구글 -->
	<div class="g-signin2" id="g-signin2" data-onsuccess="onSignIn"></div>
	<!-- 네이버 -->
	<div id="naverIdLogin"></div>
	<!-- 카카오 -->
	<a id="kakao-login-btn"></a>
	<a href="http://developers.kakao.com/logout"></a>
	<h3>
		<c:if test='${param.login eq "false"}'>
			로그인 후 이용하세요.
		</c:if>
		<c:if test='${param.login eq "fail"}'>
			로그인에 실패하였습니다.
		</c:if>
	</h3>
	<form method="post" id="apiForm" action="login">
		<input type="hidden" name="m_email" id="emailOfApiForm">
		<input type="hidden" name="m_name" id="nameOfApiForm">
		<input type="hidden" name="m_pw" id="pwOfApiForm">
	</form>
</body>
</html>