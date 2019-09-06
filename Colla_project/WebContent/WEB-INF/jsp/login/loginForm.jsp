<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="google-signin-client_id" content="504860758033-8nonf1fgo3sk1c4sfv2dv4n52tciijjo.apps.googleusercontent.com">
<title>로그인</title>
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
$(function(){
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
	$("#email").val(profile.getId());
	$("#name").val(profile.getName());
	$("#pw").val("googleapipw");
	calls();
}
function calls() {
	$("#googleForm").submit();
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
	<button onclick="">구글 계정 연동</button>
	<div class="g-signin2" data-onsuccess="onSignIn"></div>
	<button onclick="">네이버 계정 연동</button>
	<div id="naverIdLogin"></div>
	<h3>
		<c:if test='${param.login eq "false"}'>
			로그인 후 이용하세요.
		</c:if>
		<c:if test='${param.login eq "fail"}'>
			로그인에 실패하였습니다.
		</c:if>
	</h3>

	<form method="post" id="googleForm" action="login">
		<input type="hidden" name="m_email" id="email">
		<input type="hidden" name="m_name" id="name">
		<input type="hidden" name="m_pw" id="pw">
	</form>
</body>
</html>