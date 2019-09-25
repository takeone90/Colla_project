<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>

<title>개인정보</title>
<link rel="stylesheet" type="text/css" href="css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="css/myPage.css"/>
<link rel="stylesheet" type="text/css" href="css/base.css"/>
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
						<div class="myPageContentRow clearFix modifyRow" onclick="location.href='${contextPath}/profileImgModifyForm'">
							<p class="title">사진</p>
							<p class="content">사진을 추가하여 계정을 맞춤 설정합니다.</p>
							<div id="profileImg">
								<img alt="나의 프로필 사진" src="${contextPath }/showProfileImg" />
							</div>
						</div>
						<div class="contentLine"></div>
						<div class="myPageContentRow clearFix modifyRow" onclick="location.href='${contextPath}/nameModifyForm'">
							<p class="title">이름</p>
							<p class="content">${requestScope.member.name}</p>
							<p><i class="fas fa-chevron-right"></i></p>
						</div>
						<div class="contentLine"></div>
						<div class="myPageContentRow clearFix modifyRow" onclick="location.href='${contextPath}/checkPassForm'">
							<div></div>
							<p class="title">비밀번호</p>
							<p class="content">******</p>
							<p><i class="fas fa-chevron-right"></i></p>
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
						<div class="myPageContentRow clearFix modifyRow" onclick="location.href='${contextPath}/phoneModifyForm'">
							<p class="title">핸드폰 번호</p>
							<p class="content">${requestScope.member.phone}</p>
							<p><i class="fas fa-chevron-right"></i></p>
						</div>
					</div>
					<div class="myPageAccountRow">
						<p>COLLA를 더 이상 이용하지 않는다면 <a href="removeMember" class="removeMember"> 탈퇴하기</a></p>
						<div class="row btns btnR">
							<a href="myPageMainForm" class="btn"><i class="fa fa-arrow-left" aria-hidden="true"></i> 이전</a>
						</div>
					</div>
				</div>
			</div><!-- myPageInner -->
		</div>
	</div><!-- end wsBody -->
</body>
</html>