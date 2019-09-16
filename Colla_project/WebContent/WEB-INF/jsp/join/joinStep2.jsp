<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix="c"%>
<% 
String contextPath = request.getContextPath();
request.setAttribute("contextPath", contextPath);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>joinStep2</title>
<link rel="stylesheet" type="text/css" href="css/reset.css"/>
<link rel="stylesheet" type="text/css" href="css/base.css"/>
<link rel="stylesheet" type="text/css" href="css/headerMain.css"/>
<link rel="stylesheet" type="text/css" href="css/join.css" />
<script src="https://kit.fontawesome.com/ac21eff7ec.js"></script>
<script src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous"></script>
<script type="text/javascript">
$(function() {
	$("#verifyCodeForm").on("submit", function() {
		var data = $(this).serialize(); 
		$.ajax({
			url: "checkVerifyCode",
			data: data,
			type: "post",
			dataType: "json",
			success: function(result) {
				if(result) {
					//joinStep3 으로 이동하는 동작이 여기서 발생해야된다.
					location.href="${contextPath}/joinStep3";
				} else {
					$("#checkSentence").text("인증 코드가 일치하지 않습니다.");
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

	<div class="joinBox">
		<div class="joinBox-Head">
			<h3 style='font-weight: bolder; font-size: 30px'>회원가입</h3>
			<p>
				<i class="fas fa-circle" style="color: #DDB4AB"></i>&nbsp;&nbsp;
				<i class="fas fa-circle" style="color: #DA574E"></i>&nbsp;&nbsp;
				<i class="fas fa-circle" style="color: #DDB4AB"></i>
			</p>
		</div>
		<div class="joinBox-Body">
		
			<form action="" method="post" id="verifyCodeForm">
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
				<div>
					<h4>인증 코드 입력</h4>
					<input type="text" name="inputVerifyCode" placeholder="인증 코드를 입력해주세요.">
					<span id="checkSentence"></span>
				</div>
				<%-- <input type="hidden" name="emailAddress" value="${param.emailAddress}"> --%>
				<div>
					<input type="button" onclick="location.href='resendVerifyMail'" value="인증 코드 재발송">
				</div>
				<div>
					<input type="submit" value="다음단계">
				</div>
			</form>
			<div>
				<span id="verifyResultText">
					<c:if test='${param.joinStep2 eq "false"}'>
						인증 코드가 일치하지 않습니다.
					</c:if>
				</span>
			</div>
		</div>
	</div>	
</body>
</html>