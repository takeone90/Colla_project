<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>

<title>joinStep3</title>
<link rel="stylesheet" type="text/css" href="css/headerMain.css"/>
<link rel="stylesheet" type="text/css" href="css/join.css" />
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
<%
String emailAddress = (String)session.getAttribute("emailAddress");
%>
<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
	<div class="joinBox">
		<div class="joinBox-Head">
			<h3 style='font-weight: bolder; font-size: 30px'>회원가입</h3>
			<p>
				<i class="fas fa-circle" style="color: #DDB4AB"></i>&nbsp;&nbsp;
				<i class="fas fa-circle" style="color: #DDB4AB"></i>&nbsp;&nbsp;
				<i class="fas fa-circle" style="color: #DA574E"></i>
			</p>
		</div>
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
				<div>
					<input type="checkbox" id="checkbox" value="1">
					COLLA에서 제공하는 서비스 약관에 동의합니다.
					<span id="checkCheckBox"></span>
				</div>
				<div>
					<input type="submit" value="시작하기">
				</div>
			</form>
		</div>
	</div>	
</body>
</html>