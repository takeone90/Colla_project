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
<script src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous"></script>
<script type="text/javascript">
$(function() {
	$("#emailForm").on("submit", function() {
		var data = $(this).serialize(); 
		$.ajax({
			url: "emailDuplicationCheck",
			data: data,
			type: "post",
			dataType: "json",
			success: function(result) {
				if(result) { //이메일 중복임
					$("#checkSentence").text("이미 가입된 이메일입니다.");
				} else { //이메일 중복 아님
					location.href="${contextPath}/testMail";
				}
			}
		}); //end ajax 
		return false;
	})
}); //end onload
</script>
</head>
<body>
<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
	<form method="post" id="emailForm">
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
		EMAIL			
		<input type="email" name="emailAddress" placeholder="example@c0lla.com">
		<span id="checkSentence"></span>
		<input type="submit" value="인증 코드 발송">
	</form>
	<!-- <input type="button" onclick="location.href='joinStep2'" value="다음 단계"><br> -->
	또는		
	<button onclick="">구글 계정 연동</button>	
	<button onclick="">네이버 계정 연동</button>
	
</body>
</html>