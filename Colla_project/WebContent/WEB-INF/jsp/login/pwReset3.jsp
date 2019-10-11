<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>

<title>pwReset</title>
<link rel="stylesheet" type="text/css" href="css/headerMain.css"/>
<link rel="stylesheet" type="text/css" href="css/animate.css"/>
<link rel="stylesheet" type="text/css" href="css/join.css"/>
<script type="text/javascript">

</script>
</head>
<body>
	<div id="wrap">
	<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
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
								<h3 style='font-weight: bolder; font-size: 30px'>비밀번호 재설정</h3>
									<p>
										본인 인증이 완료되었습니다. 
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
					<div class="content box2 flex">				
						<div class="joinBox-Body">
							<form action="" method="post" id="resetForm">
								<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
								<div class="noticePwDiv"><span id="noticePw"></span></div>
								<div>
									<h4>아래 비밀번호로 로그인 해주세요.</h4>
									<p id="rePw">${rePw }</p>
								</div>
								<div id="joinBtnInLoginForm">
									<input type="button" value="로그인" class="loginFormButton" onclick="location.href='${contextPath}/loginForm'">
								</div>
							</form>
						</div>			
					</div>
				</div>				
			</section>
		</div>
	</div> 	
</body>
</html>