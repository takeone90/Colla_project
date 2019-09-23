<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>

<!-- 구글 -->
<meta name="google-signin-client_id"
	content="504860758033-8nonf1fgo3sk1c4sfv2dv4n52tciijjo.apps.googleusercontent.com">
<!-- 카카오 -->
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport"
	content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width" />
<title>로그인</title>
<link rel="stylesheet" type="text/css" href="css/headerMain.css"/>
<link rel="stylesheet" type="text/css" href="css/animate.css"/>
<link rel="stylesheet" type="text/css" href="css/login.css"/>
  
<!-- 네이버 -->
<script type="text/javascript" src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.0.js" charset="utf-8"></script>
<!-- 구글 -->
<script src="https://apis.google.com/js/platform.js" async defer></script>
<!-- 카카오 -->
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>

<script type="text/javascript">
$(function(){
	$("#loginForm").on("submit", function() {
		var emailResult = checkEmail();
		var pwResult = checkPw();
		if(emailResult && pwResult){
		} else {
			return false;
		}
	});
	/* 네이버 로그인 API */
	var naverLogin = new naver.LoginWithNaverId({
		clientId: "kIhjMaimMjKNR7gcR2nf",
		callbackUrl: "${contextPath}/callBackLogin",
		isPopup: false, /* 팝업을 통한 연동처리 여부 */
		loginButton: {color: "green", type: 2, height: 30, width: 90} /* 로그인 버튼의 타입을 지정 */
	});
	naverLogin.init(); /* 설정정보를 초기화하고 연동을 준비 */
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
	$("#kakaoLoginButton").on("click", function() {
		$("#kakao-login-btn").trigger("click");
	});
});//end onload
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
/* 이메일, 비밀번호 빈 칸 입력 시 */
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
</script>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
	<div id="loginBox" class="animated fadeIn">
		<div class="loginBox-Head">
			<h3 style='font-weight: bolder; font-size: 30px'>로그인</h3>
			<p>SIGN IN</p>
		</div>
		<div class="loginBox-Body">
			<form action="login" method="post" id="loginForm">	
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
				<div>
					<h4>EMAIL</h4>
					<input type="text" name="m_email" placeholder="이메일을 입력해주세요." id="email">
					<span id="checkEmailText"></span>
				</div>
				<div>
					<h4>PASSWORD</h4>
					<input type="password" name="m_pw" placeholder="비밀번호를 입력해주세요." id="pw">
					<span id="checkPwText"></span>
				</div>
				<div>
					<input type="submit" value="로그인">
				</div>
			</form>
			<div id="innerBtn">
				<!-- 구글 -->
				<button id="googleLoginButton">구글<span class="g-signin2" data-width="90" data-height="30" data-onsuccess="onSignIn"></span></button>
				<!-- 네이버 -->
				<button class="naverLoginButton">네이버<span id="naverIdLogin"></span></button>
				<!-- 카카오 -->
				<button id="kakaoLoginButton">카카오<span id="kakao-login-btn"></span><span href="http://developers.kakao.com/logout"></span></button>
				<span id="loginResultText">
					<c:if test='${param.login eq "false"}'>
						로그인 후 이용하세요.
					</c:if>
					<c:if test='${param.login eq "fail"}'>
						로그인에 실패하였습니다.
					</c:if>
				</span>
			</div>
		</div>
	</div>
	
	
	<form method="post" id="apiForm" action="login">
		<input type="hidden" name="m_email" id="emailOfApiForm">
		<input type="hidden" name="m_name" id="nameOfApiForm">
		<input type="hidden" name="m_pw" id="pwOfApiForm">
	</form>
</body>
</html>