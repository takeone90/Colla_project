<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp"%>

<title>개인정보</title>
<link rel="stylesheet" type="text/css" href="css/headerWs.css" />
<link rel="stylesheet" type="text/css" href="css/navWs.css" />
<link rel="stylesheet" type="text/css" href="css/myPage.css" />
</head>
<script>
	$(function() {
		$("input[name='pw']").focus().val("");
		$(".myPageCheckPass").on("submit", function() {
			var data = $(this).serialize();
			$.ajax({
				url : "${contextPath}/myPageCheckPass",
				data : data,
				type : "post",
				dataType : "json",
				success : function(result) {
					if (result) {//비밀번호 일치
						location.href = "${contextPath}/pwModifyForm"
					} else {//비밀번호 불일치
						$("#checkPwSentence").text("비밀번호를 확인해주세요");
					}
				}
			});//end ajax
			return false;
		});
	});//end onloadFunction
</script>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp"%>
	<div id="wsBody">
		<input type="hidden" value="mypage" id="pageType">
		<div id="wsBodyContainer">
			<h3>마이페이지</h3>
			<h4>비밀번호 수정</h4>
			<div class="myPageInner">
				<div class="myPageModify">
					<p>기존 비밀번호를 입력해주세요!</p>
					<form action="myPageCheckPass" class="myPageCheckPass"
						method="post">
						<input type="password" name="pw" placeholder="비밀번호"
							class="content">
						<div id="checkPwSentence"></div>
						<div class="row btns">
							<button class="btn">확인</button>
							<a href="myPageAccountForm" class="btn">취소</a>
						</div>
					</form>
				</div>
			</div>
			<!-- myPageInner -->
		</div>

	</div>
	<!-- end wsBody -->
</body>
</html>