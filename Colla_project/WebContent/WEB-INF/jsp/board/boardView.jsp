<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="contextPath" value="<%=request.getContextPath() %>"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 상세</title>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/reset.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/base.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/board.css"/>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="https://use.fontawesome.com/releases/v5.2.0/js/all.js"></script> <!-- font awsome -->
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
					<p>렝쓰 : ${fn:length(fList)}</p>
					<p>이름 : ${fList[0].originName}</p>
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
					<div class="row">
						<a href="checkPass?mode=modify&bNum=${board.bNum }">수정</a>
						<a href="checkPass?mode=delete&bNum=${board.bNum }">삭제</a>
						<a href="list?page=${listInf.page}&keyword=${listInf.keyword}&keywordType=${listInf.type}">목록</a>
					</div>
				</div>
				<div id="boardReply">
					<h3>댓글</h3>
					<ul id="replyBox" class="clearFix">
					</ul>
					<form id="addReplyDiv">
						<div class="replyImg"><img src="${contextPath}/showProfileImg"></div>
						<div id="inputBox">
							<textarea rows="2" cols="50" name="rContent"></textarea>
							<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
							<button onclick="addReply(); return false;">댓글 추가</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>