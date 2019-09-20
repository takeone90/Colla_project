<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>

<title>개인정보</title>
<link rel="stylesheet" type="text/css" href="css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="css/myPage.css"/>
<script type="text/javascript">

</script>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp"%>
	<div id="wsBody">
	<input type="hidden" value="mypage" id="pageType">
		<div id="wsBodyContainer">
			<h3>마이페이지</h3>
			<h4>핸드폰 번호 수정</h4>
			<div class="myPageInner">
				<div class ="myPageModify">
					<p>핸드폰 번호를 변경해주세요!</p>
					<form action="modifyPhone" class="modifyPhone" enctype="multipart/form-data" method="post">
						<input type="text" name="phone" value="${member.phone}" class="content" placeholder="핸드폰 번호를 입력해주세요">
						<div class="row btns">
							<button class="btn">저장</button>
							<a href="myPageAccountForm" class="btn">취소</a>
						</div>
					</form>
				</div>
			</div><!-- myPageInner -->
		</div>

	</div><!-- end wsBody -->
</body>
</html>