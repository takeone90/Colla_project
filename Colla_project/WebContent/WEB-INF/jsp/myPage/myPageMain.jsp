<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>

<title>마이페이지 메인</title>
<link rel="stylesheet" type="text/css" href="css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="css/myPage.css"/>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp" %>
	<div id="wsBody">
	<input type="hidden" value="mypage" id="pageType">
		<div id="wsBodyContainer">
			<h3>마이페이지</h3>
			<div class="myPageInner">
				<div class="myPageContent">
						<p>${member.name}님, 환영합니다</p>
						<p>개인정보 보호 및 설정을 관리하여 나에게 맞는 방식으로 c0lla를 사용할 수 있습니다.</p>
						<div class="myPageModule" onclick="location.href='${contextPath}/myPageAccountForm'">
							<img class="YPzqGd" src="${contextPath }/img/mypage_content1.png"/>
							<p class="title">개인정보 보호</p>
							<p class="content">c0lla 계정에 저장된 데이터를 확인할 수 있습니다.</p>
							
						</div>
						<div class="myPageModule" onclick="location.href='${contextPath}/myPageAlarmForm'">
							<img class="YPzqGd" src="${contextPath }/img/mypage_content2.png"/>
							<p class="title">맞춤 설정</p>
							<p class="content">c0lla 사용 환경을 맞춤설정 하기 위해 어떤 활동을 저장할지 선택합니다.</p>
						</div>
						<div class="myPageModule" onclick="location.href='${contextPath}/myPageLicenseForm'">
							<img class="YPzqGd" src="${contextPath }/img/mypage_content3.png"/>
							<p class="title">라이선스 관리</p>
							<p class="content">c0lla 라이선스 구매내역을 확인할 수 있습니다.</p>
						</div>
					</div>
				</div>
			</div>
	</div>
</body>

</html>