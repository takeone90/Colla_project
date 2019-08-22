<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div class="container">
		<h1>Workspace</h1>
		<h2>Workspace List</h2>
		<div class="ws">
			<div class="wsHeader">
				<div class="wsTitle">
					<a href="chatMain"><h3>질수없조프로젝트1</h3></a>
				</div>
				<div class="wsBtns">펼치기</div>
			</div>
			<!-- wsBtns 클릭 시 아래 div들이 나옵니다 -->
			<div class="wsChatListBox">
				<h3>chat List</h3>
				<div class="chatList">
					<!-- forEach 안의 ul과 li -->
					<ul>
						<li>개발팀</li>
						<li>편집팀</li>
						<li>재무팀</li>
					</ul>
				</div>
			</div>
			<div class="wsMemberListBox">
				<h3>Member List</h3>
				<div class="MemberList">
					<ul>
						<li>이태권</li>
						<li>김미경</li>
						<li>김수빈</li>
						<li>박혜선</li>
					</ul>
				</div>
			</div>
		</div>
		
		
		
		<div class="ws">
			<div class="wsHeader">
				<div class="wsTitle">
					<a href="chatMain"><h3>질수없조프로젝트2</h3></a>
				</div>
				<div class="wsBtns">펼치기</div>
			</div>
			<!-- wsBtns 클릭 시 아래 div들이 나옵니다 -->
			<div class="wsChatListBox">
				<h3>chat List</h3>
				<div class="chatList">
					<!-- forEach 안의 ul과 li -->
					<ul>
						<li>개발팀</li>
						<li>편집팀</li>
						<li>재무팀</li>
					</ul>
				</div>
			</div>
			<div class="wsMemberListBox">
				<h3>Member List</h3>
				<div class="MemberList">
					<ul>
						<li>이태권</li>
						<li>김미경</li>
						<li>김수빈</li>
						<li>박혜선</li>
					</ul>
				</div>
			</div>
		</div>
	</div>
</body>
</html>