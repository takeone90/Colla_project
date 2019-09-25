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
<link rel="stylesheet" type="text/css" href="css/headerMain.css"/>
<link rel="stylesheet" type="text/css" href="css/animate.css"/>
<link rel="stylesheet" type="text/css" href="css/join.css"/>
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
// 				var data = $(this).parent().serialize();
				console.log("2 ajax실행");
				$.ajax({
					url : "checkEmailDuplication",
					data : {"emailAddress":emailAddress},
					type : "post",
					dataType : "json",
					success : function(result) {
						if (result) { //이메일 중복임
							$("#checkSentence").text("이미 가입된 이메일입니다.");
						} else { //이메일 중복이 아님
							$("#checkSentence").text("멋진 이메일이네요!");
						}
					},
					error : function(request, status, error) {
						alert("blur");
// 						alert("request:" + request + "\n" + "status:"
// 								+ status + "\n" + "error:" + error
// 								+ "\n");
					}
				}); //end ajax
			}
			return false;
		});
		/* 네이버 회원가입 API */
		var naverLogin = new naver.LoginWithNaverId({
			clientId : "kIhjMaimMjKNR7gcR2nf",
			callbackUrl : "${contextPath}/callBackJoin",
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
	<div id="wrap">
	<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp"%>
		<div id="joinAll">
			<section>	
				<div id="joinBox" class="animated fadeIn">
					<!-- 파도 효과 시작 -->
					<div class="header">
						<!--파도 위 내용-->
						<div class="inner-header flex">
							<g><path fill="#fff"
							d="M250.4,0.8C112.7,0.8,1,112.4,1,250.2c0,137.7,111.7,249.4,249.4,249.4c137.7,0,249.4-111.7,249.4-249.4
							C499.8,112.4,388.1,0.8,250.4,0.8z M383.8,326.3c-62,0-101.4-14.1-117.6-46.3c-17.1-34.1-2.3-75.4,13.2-104.1
							c-22.4,3-38.4,9.2-47.8,18.3c-11.2,10.9-13.6,26.7-16.3,45c-3.1,20.8-6.6,44.4-25.3,62.4c-19.8,19.1-51.6,26.9-100.2,24.6l1.8-39.7		
							c35.9,1.6,59.7-2.9,70.8-13.6c8.9-8.6,11.1-22.9,13.5-39.6c6.3-42,14.8-99.4,141.4-99.4h41L333,166c-12.6,16-45.4,68.2-31.2,96.2	
							c9.2,18.3,41.5,25.6,91.2,24.2l1.1,39.8C390.5,326.2,387.1,326.3,383.8,326.3z" /></g>
							</svg>
							<div class="joinBox-Head">
								<h3 style='font-weight: bolder; font-size: 30px'>회원가입</h3>
								<p>
									<i class="fas fa-circle" style="color: #DA574E"></i>&nbsp;&nbsp;
									<i class="fas fa-circle" style="color: #DDB4AB"></i>&nbsp;&nbsp;
									<i class="fas fa-circle" style="color: #DDB4AB"></i>
								</p>
							</div>
						</div>			
						<!--파도 시작-->
						<div>
							<svg class="waves" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
							viewBox="0 24 150 28" preserveAspectRatio="none" shape-rendering="auto">
							<defs>
							<path id="gentle-wave" d="M-160 44c30 0 58-18 88-18s 58 18 88 18 58-18 88-18 58 18 88 18 v44h-352z" />
							</defs>
								<g class="parallax">
								<use xlink:href="#gentle-wave" x="48" y="0" fill="rgba(255,255,255,0.7" />
								<use xlink:href="#gentle-wave" x="48" y="3" fill="rgba(255,255,255,0.5)" />
								<use xlink:href="#gentle-wave" x="48" y="7" fill="#fff" />
								</g>
							</svg>
						</div><!--파도 end-->
					</div><!--header end-->		
					<!--파도 아래 내용-->	
					<div class="content flex">			
						<div class="joinBox-Body">
							<form method="post" id="emailForm">
								<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"> 
								<div>
									<h4>EMAIL</h4> 
									<input type="email" name="emailAddress" id="emailAddress" placeholder="example@c0lla.com">
									<span id="checkSentence"></span>
								</div>
								<div>
									<input type="submit" value="인증 코드 발송" class="joinFormButton">
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
					</div><!--Content ends-->
				</div>			
			</section>
		</div>
	</div> 		
	<form method="post" id="apiForm" action="joinMemberAPI">
		<input type="hidden" name="email" id="email"> 
		<input type="hidden" name="name" id="name">
		<input type="hidden" name="pw" id="pw">
	</form>
</body>
</html>