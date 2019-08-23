<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
String contextPath = request.getContextPath();
request.setAttribute("contextPath", contextPath);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>joinStep1</title>
<link rel="stylesheet" type="text/css" href="css/reset.css"/>
<link rel="stylesheet" type="text/css" href="css/base.css"/>
<link rel="stylesheet" type="text/css" href="css/headerMain.css"/>
<script src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous"></script>
<script type="text/javascript">
$(function() {
	$("#emailForm").on("submit", function(e) {
		e.preventDefault();
		var emailAddress = $("#emailAddress").val(); 
		if(emailAddress == "") {
			$("#checkSentence").text("필수 정보입니다.");
		} else {
			console.log("1 ajax실행");
			var data = $(this).serialize();
			$.ajax({
				url: "checkEmailDuplication",
				data: data,
				type: "post",
				dataType: "json",
				success: function(result) {
					if(result) { //이메일 중복임
						$("#checkSentence").text("이미 가입된 이메일입니다.");
					} else { //이메일 중복 아님
						location.href="${contextPath}/sendVerifyMail";
					}
				}
			}); //end ajax 
		}
		return false;
	})
	$("#emailAddress").on("blur", function() {
		var emailAddress = $("#emailAddress").val();
		if(emailAddress == "") {
			$("#checkSentence").text("이메일을 입력해주세요.");
		} else {
			var data = $(this).parent().serialize();
			console.log("2 ajax실행");
			$.ajax({
				url: "checkEmailDuplication",
				data: data,
				type: "post",
				dataType: "json",
				success: function(result) {
					if(result) { //이메일 중복임
						$("#checkSentence").text("이미 가입된 이메일입니다.");
					} else {
						$("#checkSentence").text("멋진 이메일이네요!");
					}
				},
				error: function(request, status, error) {
					alert("request:"+request+"\n"
							+"status:"+status+"\n"
							+"error:"+error+"\n");
				}
			}); //end ajax
		}
		return false;
	});
}); //end onload
</script>
</head>
<body>
<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
	<form method="post" id="emailForm">
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
		EMAIL			
		<input type="email" name="emailAddress" id="emailAddress" placeholder="example@c0lla.com">
		<span id="checkSentence"></span>
		<input type="submit" value="인증 코드 발송">
	</form>
	또는		
	<button onclick="">구글 계정 연동</button>	
	<button onclick="">네이버 계정 연동</button>
</body>
</html>