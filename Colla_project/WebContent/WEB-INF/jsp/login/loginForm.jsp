<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<script src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous"></script>
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
	<button onclick="">네이버 계정 연동</button>
	
	<h3>
		<c:if test='${param.login eq "false"}'>
			로그인 후 이용하세요.
		</c:if>
		<c:if test='${param.login eq "fail"}'>
			로그인에 실패하였습니다.
		</c:if>
	</h3>
		
</body>
</html>