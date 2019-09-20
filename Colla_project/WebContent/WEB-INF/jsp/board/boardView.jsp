<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<title>게시글 상세</title>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/board.css"/>

<script src="${contextPath}/lib/ckeditor4/ckeditor.js"></script>

<script type="text/javascript">
	const bNum = ${board.bNum};
	const mNum = ${sessionScope.user.num};
</script>
<script type="text/javascript" src="${contextPath}/js/boardReply.js"></script>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp" %>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp" %>
	
	<div id="wsBody">
	<input type="hidden" value="board" id="pageType">
		<div id="wsBodyContainer">
		
			<h3>자유게시판</h3>
			<h4>게시글 상세보기</h4>
			<div id="boardInner">
				<div id="boardDetail">
					<div class="row">
						<h5 id="title">
							<span>제목</span>
							<span class="bold">${board.bTitle }</span>
						</h5>
					</div>
					<div class="row clearFix">
						<div class="floatleft">
							<span>작성자</span>
							<span class="bold">${board.bType == 'anonymous'?'익명':board.mName }</span>
						</div>
						<div class="floatleft">
							<span>조회수</span> 
							<span class="bold">${board.readCnt }</span>
						</div>
						<div class="floatleft">
							<span>작성일</span>
							<span class="bold">
								<fmt:formatDate value="${board.bRegDate }" pattern="yyyy-MM-dd HH:mm:ss"/>
							</span>
						</div>
					</div>
					<div id="content" class="row">
						<pre>${board.bContent }</pre>
					</div>
					<c:if test="${fn:length(fList) > 0 }">
					<div class="row">
						<c:forEach items="${fList}" var="file">
							<p>
								<a href="${contextPath}/download?name=${file.fileName}">
									<i class="fas fa-save"></i>
									${file.originName }
								</a>
							</p>
						</c:forEach>
					</div>
					</c:if>
					<div class="row btns">
						<a href="checkPass?mode=modify&bNum=${board.bNum }" class="btn">수정</a>
						<a href="checkPass?mode=delete&bNum=${board.bNum }" class="btn">삭제</a>
						<a href="list?page=${listInf.page}&keyword=${listInf.keyword}&keywordType=${listInf.type}" class="btn">목록</a>
					</div>
				</div>
				<div id="boardReply">
					<h4>댓글</h4>
					<div id="replyWrap">
						<ul id="replyBox" class="clearFix">
							<li>댓글이 없습니다.</li>
						</ul>
						<form id="addReplyDiv">
							<div class="replyImg"><img src="${contextPath}/showProfileImg"></div>
							<div id="inputBox">
								<textarea rows="3" name="rContent"></textarea>
								<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
								<button class="btn" onclick="addReply(); sendAlarm(${sessionScope.currWnum},${board.mNum},${sessionScope.user.num},'reply',${board.bNum}); return false;">댓글 등록</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>