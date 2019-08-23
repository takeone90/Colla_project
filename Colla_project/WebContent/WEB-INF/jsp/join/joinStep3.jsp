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
	$("#name").on("blur", function() {
		nameReg();
	});
	
	$("#pw").on("blur", function() {
		pwReg();
	});
	
	$("#joinMemberForm").on("submit", function() {
		var nameResult = nameReg();
		var pwResult = pwReg()
		var checkBoxResult = checkBox();
		alert(nameResult + ", "+  pwResult + ", "+ checkBoxResult);
		if(nameResult && pwResult && checkBoxResult){
			alert("안녕");
		}else{
			return false;
		}
		alert("안녕");
	});
}); //end onload


function nameReg(){
	var name = $("#name").val();
	var nameReg = /^{1, 10}$/;
	result = nameReg.test(name);
	if(result) {
		$("#checkName").text("");
		return true;
	}else{
		$("#checkName").text("이름은 한 글자 이상 열 글자 이하로 입력해주세요.");
		return false;
	}
}
function pwReg(){
	var pw = $("#pw").val();
	var pwReg = /^{1, 20}$/;
	result = pwReg.test(pw);
	if(result) {
		$("#checkPw").text("");
		return true;
	}else{
		$("#checkPw").text("비밀번호는 한 글자 이상 스무 글자 이하로 입력해주세요.");
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