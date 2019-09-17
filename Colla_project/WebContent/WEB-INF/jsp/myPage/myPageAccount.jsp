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
<title>개인정보</title>
<link rel="stylesheet" type="text/css" href="css/reset.css"/>
<link rel="stylesheet" type="text/css" href="css/base.css"/>
<link rel="stylesheet" type="text/css" href="css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="css/myPage.css"/>
<script src="https://code.jquery.com/jquery-3.4.1.js"
   integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
   crossorigin="anonymous"></script>
<script src="https://use.fontawesome.com/releases/v5.2.0/js/all.js"></script> <!-- font awsome -->
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp"%>
	<div id="wsBody">
	<input type="hidden" value="mypage" id="pageType">
		<div id="wsBodyContainer">
			<h3>마이페이지</h3>
			<h4>회원정보 관리</h4>
			<div class="myPageInner">
				<div class ="myPageAccount">
					<div class="myPageContent">
						<div class="myPageTitle">
							<p class="title">프로필</p>
							<p class="content">일부 정보가 Colla 서비스를 사용하는 다른 사람에게 표시될 수 있습니다.</p>
						</div>
						<div class="myPageContentRow clearFix" onclick="location.href='${contextPath}/profileImgModifyForm'">
							<p class="title">사진</p>
							<p class="content">사진을 추가하여 계정을 맞춤 설정합니다.</p>
							<div id="profileImg">
								<img alt="나의 프로필 사진" src="${contextPath }/showProfileImg" />
							</div>
						</div>
						<div class="contentLine"></div>
						<div class="myPageContentRow clearFix" onclick="location.href='${contextPath}/nameModifyForm'">
							<p class="title">이름</p>
							<p class="content">${requestScope.member.name}</p>
							<i class="fas fa-chevron-right"></i>
						</div>
						<div class="contentLine"></div>
						<div class="myPageContentRow clearFix" onclick="location.href='${contextPath}/pwModifyForm'">
							<div></div>
							<p class="title">비밀번호</p>
							<p class="content">${requestScope.member.pw}</p>
						</div>
					</div>
					<div class="myPageContent">
						<div class="myPageTitle">
							<p class="title">연락처 정보</p>
							<p class="content">일부 정보가 Colla 서비스를 사용하는 다른 사람에게 표시될 수 있습니다.</p>
						</div>
						<div class="myPageContentRow clearFix">
							<p class="title">계정</p>
							<p class="content">${requestScope.member.email}</p>
						</div>
						<div class="contentLine"></div>
						<div class="myPageContentRow clearFix" onclick="location.href='${contextPath}/phoneModifyForm'">
							<p class="title">핸드폰 번호</p>
							<p class="content">${requestScope.member.phone}</p>
						</div>
					</div>
					<div class="row btns">
						<a href="myPageMainForm" class="btn">목록</a>
					</div>
				</div>
			</div><!-- myPageInner -->
		</div>
	</div><!-- end wsBody -->
</body>
</html>