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
<title>joinStep1</title>
<link rel="stylesheet" type="text/css" href="css/headerMain.css" />
<link rel="stylesheet" type="text/css" href="css/join.css" />

<!-- 네이버 -->
<script type="text/javascript"
	src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.0.js"
	charset="utf-8"></script>
<!-- 구글 -->
<script src="https://apis.google.com/js/platform.js" async defer></script>
<!-- 카카오 -->
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>

<script type="text/javascript">
	$(function() {
		$("#emailForm").on("submit", function(e) {
			e.preventDefault();
			var emailAddress = $("#emailAddress").val();
			if (emailAddress == "") {
				$("#checkSentence").text("필수 정보입니다.");
			} else {
				console.log("1 ajax실행");
				var data = $(this).serialize();
				$.ajax({
					url : "checkEmailDuplication",
					data : data,
					type : "post",
					dataType : "json",
					success : function(result) {
						if (result) { //이메일 중복임
							$("#checkSentence").text("이미 가입된 이메일입니다.");
						} else { //이메일 중복 아님
							location.href = "${contextPath}/sendVerifyMail";
						}
					}
				}); //end ajax 
			}
			return false;
		})
		$("#emailAddress").on("blur", function() {
					var emailAddress = $("#emailAddress").val();
					if (emailAddress == "") {
						$("#checkSentence").text("이메일을 입력해주세요.");
					} else {
						var data = $(this).parent().serialize();
						console.log("2 ajax실행");
						$.ajax({
							url : "checkEmailDuplication",
							data : data,
							type : "post",
							dataType : "json",
							success : function(result) {
								if (result) { //이메일 중복임
									$("#checkSentence").text("이미 가입된 이메일입니다.");
								} else {
									$("#checkSentence").text("멋진 이메일이네요!");
								}
							},
							error : function(request, status, error) {
								alert("request:" + request + "\n" + "status:"
										+ status + "\n" + "error:" + error
										+ "\n");
							}
						}); //end ajax
					}
					return false;
				});
		/* 네이버 회원가입 API */
		var naverLogin = new naver.LoginWithNaverId({
			clientId : "kIhjMaimMjKNR7gcR2nf",
			callbackUrl : "http://localhost:8081/Colla_project/callBackJoin",
			isPopup : false, /* 팝업을 통한 연동처리 여부 */
			loginButton : {color: "white", type: 1, height: 35} /* 로그인 버튼의 타입을 지정 */
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
						$("#email").val(res.kaccount_email);
						$("#name").val(res.properties.nickname);
						$("#pw").val("kakaoapipw");
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
	}); //end onload
	/* 구글 회원가입 API */

	function onSignIn(googleUser) {
		var profile = googleUser.getBasicProfile();
		$("#email").val(profile.getEmail());
		$("#name").val(profile.getName());
		$("#pw").val("googleapipw");
		calls();
	}
	function calls() {
		$("#apiForm").submit();
	}
</script>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp"%>
	
	<div class="joinBox">
		<div class="joinBox-Head">
			<h3 style='font-weight: bolder; font-size: 30px'>회원가입</h3>
			<p>
				<i class="fas fa-circle" style="color: #DA574E"></i>&nbsp;&nbsp;
				<i class="fas fa-circle" style="color: #DDB4AB"></i>&nbsp;&nbsp;
				<i class="fas fa-circle" style="color: #DDB4AB"></i>
			</p>
		</div>
		<div class="joinBox-Body">
			<form method="post" id="emailForm">
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"> 
				<div>
					<h4>EMAIL</h4> 
					<input type="email" name="emailAddress" id="emailAddress" placeholder="example@c0lla.com">
					<span id="checkSentence"></span>
				</div>
				<div>
					<input type="submit" value="인증 코드 발송">
				</div>
			</form>
			<div id="innerBtn">
				<!-- 구글 -->
				<button id="googleLoginButton">구글<span class="g-signin2" data-width="90" data-height="30" data-onsuccess="onSignIn"></span></button>
				<!-- 네이버 -->
				<button class="naverLoginButton">네이버<span id="naverIdLogin"></span></button>
				<!-- 카카오 -->
				<button id="kakaoLoginButton">카카오<span id="kakao-login-btn"></span><span href="http://developers.kakao.com/logout"></span></button>
			</div>
		</div>
	</div>
	
	<form method="post" id="apiForm" action="joinMemberAPI">
		<input type="hidden" name="email" id="email"> 
		<input type="hidden" name="name" id="name">
		<input type="hidden" name="pw" id="pw">
	</form>
</body>
</html>