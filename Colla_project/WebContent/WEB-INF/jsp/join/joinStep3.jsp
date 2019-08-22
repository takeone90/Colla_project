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
		var name = $("#name").val();
		var nameReg = /^{1, 10}$/;
		result = nameReg.test(name);
		if(!result) {
			$("#checkName").text("이름은 한 글자 이상 열 글자 이하로 입력해주세요.");
		} 
	});
	
	$("#pw").on("blur", function() {
		var pw = $("#pw").val();
		var pwReg = /^{1, 20}$/;
		result = pwReg.test(pw);
		if(!result) {
			$("#checkPw").text("비밀번호는 한 글자 이상 스무 글자 이하로 입력해주세요.");
		}
	});
	
	$("#joinMemberForm").on("submit", function() {
		var result = $("#checkbox").is("checked");
		alert(result);
		if(!result) {
			$("#checkCheckBox").text("약관 동의는 필수입니다.");
			return false;
		} else {
			$("#checkCheckBox").text("");
			return false;
		}
	});
});

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