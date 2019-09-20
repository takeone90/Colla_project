<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>

<title>비밀번호 확인</title>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/board.css"/>
</head>
<body>
	<c:if test="${ not empty param.msg }"  >
		<script>
			$(function(){
				alert("비밀번호가 일치하지 않습니다.");
				history.replaceState('','','checkPass?bNum=${updateMap.bNum}&mode=modify');
			})
 		</script> 
	</c:if>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp" %>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp" %>
	<div id="wsBody">
	<input type="hidden" value="board" id="pageType">
		<div id="wsBodyContainer">
			<h3>자유게시판</h3>
			<h4>게시글 비밀번호 확인</h4>
			<div id="boardInner" class="checkPassInner">
				<form id="passForm" action="checkPass" method="post">
					<label for="pw">게시글 비밀번호</label>
					<input type="password" name="pw" id="pw" placeholder="비밀번호를 입력해주세요">
					<input type="hidden" name="bNum" value="${updateMap.bNum }">
					<input type="hidden" name="mode" value="${updateMap.mode }">
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
					<button class="btn">확인</button>
					<a class="btn" href="${contextPath }/board/view?num=${updateMap.bNum}">취소</a>
					<script>
					</script>
				</form>
			</div>
		</div>
	</div>
</body>
</html>