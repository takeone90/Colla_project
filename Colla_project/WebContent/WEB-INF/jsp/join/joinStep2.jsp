<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>joinStep2</title>
</head>
<body>
	<form action="" method="post">
		회원가입
		인증 코드 입력
		<input type="text" name="code??" placeholder="인증 코드를 입력해주세요.">
		<input type="submit" value="재발송">
		<button onclick="">다음 단계</button>	
	</form>
	<h3>
		<c:if test='${param.joinStep2 eq "false"}'>
			인증 코드가 일치하지 않습니다.
		</c:if>
	</h3>
</body>
</html>