<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>LOGIN</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
</head>
<body>
	<div class="container">
		<form action="login" method="post">
			<table class="table table-hover">
				<tr>
					<th>아이디 : </th>
					<td><input type="text" name="mId" placeholder="아이디를 입력하세요"></td>
				</tr>
				<tr>
					<th>비밀번호 : </th>
					<td><input type="password" name="mPassword" placeholder="비밀번호를 입력하세요"></td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<input type="submit" value="로그인">
						<input type="button" value="회원가입" onclick="location.href='join'">
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>