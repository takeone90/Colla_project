<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
	String contextPath = request.getContextPath();
	request.setAttribute("contextPath", contextPath);
%>
<title>회원가입</title>
</head>
<body>
	<h1>회원가입 정보 입력</h1>
	<form action="${contextPath}/member/join" method="post">
		<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token}">
		<table>
			<tr>
				<th>아이디</th>
				<td><input type="text" name="mId"></td>
			</tr>
			<tr>
				<th>비밀번호</th>
				<td><input type="password" name="mPassword"></td>
			</tr>
			<tr>
				<th>이름</th>
				<td><input type="text" name="mName"></td>
			</tr>
			<tr>
				<th>이메일</th>
				<td><input type="text" name="mEmail"></td>
			</tr>
			<tr>
				<td colspan="2"><input type="submit" value="회원가입"></td>
			</tr>
		</table>
		
		<fieldset>
				<legend> 회원가입 정보 입력 </legend>
				<ul>
					<li><input type="text" name="M_USERID"
						placeholder="아이디를 입력하세요"></li>
					<li><input type="text" name="M_NAME" placeholder="이름을 입력하세요"></li>
					<li><input type="email" name="M_EMAIL"
						placeholder="이메일을 입력하세요"></li>
					<li><input type="password" name="M_PW"
						placeholder="비밀번호를 입력하세요"></li>
					<li><input type="submit" value="회원가입"></li>
				</ul>
			</fieldset>
	</form>
</body>
</html>