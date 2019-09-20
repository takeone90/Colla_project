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
							<img class="YPzqGd" src="https://www.gstatic.com/identity/boq/accountsettingsmobile/aboutme_scene_316x112_371ea487b68d0298cc54522403223de1.png" srcset="https://www.gstatic.com/identity/boq/accountsettingsmobile/aboutme_scene_632x224_24f4bd684b00a64177aa9fda65f88db6.png 2x, https://www.gstatic.com/identity/boq/accountsettingsmobile/aboutme_scene_948x336_24f1d276593f5da5641e3666e6117d02.png 3x, https://www.gstatic.com/identity/boq/accountsettingsmobile/aboutme_scene_1264x448_c62fe60e3bb1b8642822a028568898c4.png 4x" aria-hidden="true">
							<p class="title">개인정보 보호</p>
							<p class="content">c0lla 계정에 저장된 데이터를 확인할 수 있습니다.</p>
							
						</div>
						<div class="myPageModule" onclick="location.href='${contextPath}/myPageAlarmForm'">
							<img class="YPzqGd" src="https://www.gstatic.com/identity/boq/accountsettingsmobile/privacycheckup_scene_316x112_3343d1d69c2d68a4bd3d28babd1f9e80.png" srcset="https://www.gstatic.com/identity/boq/accountsettingsmobile/privacycheckup_scene_632x224_011a9cdb010104781157b7d83b000673.png 2x, https://www.gstatic.com/identity/boq/accountsettingsmobile/privacycheckup_scene_948x336_64afce37ceb4716bde21ca2572add2d2.png 3x, https://www.gstatic.com/identity/boq/accountsettingsmobile/privacycheckup_scene_1264x448_e11496d496d0f3433f240aef3907d086.png 4x" aria-hidden="true">
							<p class="title">맞춤 설정</p>
							<p class="content">c0lla 사용 환경을 맞춤설정 하기 위해 어떤 활동을 저장할지 선택합니다.</p>
						</div>
						<div class="myPageModule" onclick="location.href='${contextPath}/myPageLicenseForm'">
							<img class="YPzqGd" src="https://www.gstatic.com/identity/boq/accountsettingsmobile/purchases_scene_316x112_5829767c1386429746abba74a1f7d253.png" srcset="https://www.gstatic.com/identity/boq/accountsettingsmobile/purchases_scene_632x224_0a59bc4e6723bc1d779467c8ac0a301c.png 2x, https://www.gstatic.com/identity/boq/accountsettingsmobile/purchases_scene_948x336_d4037d8f799303d20947e056eee4cf9c.png 3x, https://www.gstatic.com/identity/boq/accountsettingsmobile/purchases_scene_1264x448_c1b7e09e67ff72829661e434532b4206.png 4x" aria-hidden="true">
							<p class="title">라이선스 관리</p>
							<p class="content">c0lla 라이선스 구매내역을 확인할 수 있습니다.</p>
						</div>
					</div>
					<div class="row btns btnR">
						<a href="myPageMainForm" class="btn">목록</a>
					</div>
				</div>
			</div>
	</div>
</body>

</html>