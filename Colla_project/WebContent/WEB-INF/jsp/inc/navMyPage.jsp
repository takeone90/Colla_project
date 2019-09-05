<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<div id="mypageNav">
	<input type="hidden" value="${sessionScope.currWnum}" id="currWnum">
	<div id="navContainer">
		<div id="aboutProfile">
			<a href="myPageMainForm">
				<img alt="나의 프로필 사진" src="${contextPath }/showProfileImg" />
			</a>
			<p>${sessionScope.user.name}님</p>
		</div>
		<select name="currWorkspace">
			<option value="1" selected>질수없조프로젝트</option>
			<option value="2"></option>
			<option value="3"></option>
		</select>
		<div id="myPageList">
			<h3>
				<a href="myPageMainForm">마이페이지</a>
			</h3>
			<ul>
				<li><a href="${contextPath}/myPageCheckPassForm">회원정보관리</a></li>
				<li><a href="${contextPath}/myPageAlarmForm">알림설정</a></li>
				<li><a href="${contextPath}/myPageLicenseForm">라이선스관리</a></li>
			</ul>
		</div>
		<hr>
		
	</div>
</div>
</body>
</html>