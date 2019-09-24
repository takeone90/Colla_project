<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>
<title>joinStep3</title>
<link rel="stylesheet" type="text/css" href="css/headerMain.css"/>
<link rel="stylesheet" type="text/css" href="css/animate.css"/>
<link rel="stylesheet" type="text/css" href="css/join.css"/>
<script type="text/javascript">
$(function() {
	$("#pw").on("blur", function() {
		pwReg();
	});
	$("#name").on("blur", function() {
		nameReg();
	});
	$("#joinMemberForm").on("submit", function() {
		var pwResult = pwReg();
		var nameResult = nameReg();
		var checkBoxResult = checkBox();
		if(nameResult && pwResult && checkBoxResult){
		}else{
			return false;
		}
	});
}); //end onload
function pwReg(){
	var pw = $("#pw").val();
	var pwReg = /^[A-Za-z0-9]{1,20}$/;
	result = pwReg.test(pw);
	if(result) {
		$("#checkPw").text("");
		return true;
	}else{
		$("#checkPw").text("비밀번호는 1~20자리로 입력해주세요.");
		return false;
	}
}
function nameReg(){
	var name = $("#name").val();
	var nameReg = /^[\w\Wㄱ-ㅎㅏ-ㅣ가-힣]{2,20}$/;
	result = nameReg.test(name);
	if(result) {
		$("#checkName").text("");
		return true;
	}else{
		$("#checkName").text("이름은 2~10자리 이내로 입력해주세요.");
		return false;
	}
}
function checkBox(){
	var result = $("#checkbox").is(":checked");
	if(!result) {
		$("#checkCheckBox").text("약관 동의는 필수입니다.");
		return false;
	} else {
		return true;
	}
}
</script>
</head>
<body>
<% String emailAddress = (String)session.getAttribute("emailAddress"); %>
	<div id="wrap">
	<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
		<div id="joinAll">
			<section class="joinStep3-section">
				<div id="joinBox" class="animated fadeIn">
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
									<i class="fas fa-circle" style="color: #DDB4AB"></i>&nbsp;&nbsp;
									<i class="fas fa-circle" style="color: #DDB4AB"></i>&nbsp;&nbsp;
									<i class="fas fa-circle" style="color: #DA574E"></i>
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
							<form action="joinMember" method="post" id="joinMemberForm">
								<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
								<div>
									<h4>EMAIL</h4>
									<input type="email" name="email" readonly="readonly" value="${emailAddress}">
								</div>
								<div>
									<h4>PASSWORD</h4>
									<input type="password" name="pw" id="pw">
									<span id="checkPw"></span>
								</div>
								<div>
									<h4>NAME</h4>
									<input type="text" name="name" id="name">
									<span id="checkName"></span>
								</div>
								<div class="joinCheckbox">
									<input type="checkbox" id="checkbox" value="1" class="joinCheckboxInput">
									COLLA에서 제공하는 서비스 약관에 동의합니다.
									<span id="checkCheckBox"></span>
								</div>
								<div>
									<input type="submit" value="시작하기" class="joinFormButton">
								</div>
							</form>
						</div>
					</div><!--Content ends-->
				</div>	
			</section>
		</div>
	</div> 		
</body>
</html>