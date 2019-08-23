<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>joinStep3</title>
<script src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous"></script>
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
		alert(nameResult + ", "+  pwResult + ", "+ checkBoxResult);
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
	<form action="joinMember" method="post" id="joinMemberForm">
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
		회원가입
		EMAIL
		<input type="email" name="email" readonly="readonly" value="${emailAddress}">
		PASSWORD
		<input type="password" name="pw" id="pw">
		<span id="checkPw"></span>
		NAME
		<input type="text" name="name" id="name">
		<span id="checkName"></span>
		<input type="checkbox" id="checkbox" value="1">
		약관에 동의합니다.
		<span id="checkCheckBox"></span>
		<input type="submit" value="시작하기">
	</form>
</body>
</html>