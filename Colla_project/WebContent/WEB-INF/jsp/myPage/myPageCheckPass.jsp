<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>

<title>개인정보</title>
<link rel="stylesheet" type="text/css" href="css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="css/myPage.css"/>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp"%>
	<div id="wsBody">
	<input type="hidden" value="mypage" id="pageType">
		<div id="wsBodyContainer">
			<h3>마이페이지</h3>
			<h4>비밀번호 수정</h4>
			<div class="myPageInner">
				<div class ="myPageModify">
					<p>기존 비밀번호를 입력해주세요!</p>
					<form action="myPageCheckPass" class="myPageCheckPass" method="post">
						<input type="password" name="pw" placeholder="비밀번호" class="content">
						<c:if test="${checkPass eq fail}">
							<p class="checkPass">비밀번호를 확인해주세요</p>
						</c:if>
						<div class="row btns">
							<button class="btn">확인</button>
							<a href="myPageAccountForm" class="btn">취소</a>
						</div>
					</form>
				</div>
			</div><!-- myPageInner -->
		</div>

	</div><!-- end wsBody -->
</body>
</html>