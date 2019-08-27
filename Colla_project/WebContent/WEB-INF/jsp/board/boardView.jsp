<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 상세</title>
<link rel="stylesheet" type="text/css" href="../css/reset.css"/>
<link rel="stylesheet" type="text/css" href="../css/base.css"/>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp" %>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp" %>
	
	<div id="wsBody">
		<h3>게시글 상세</h3>
		<div id="boardDetail">
			<div class="row">
				<h4 id="title">${board.bTitle }</h4>
			</div>
			<div class="row">
				<span>${board.mName }</span>
				<span>조회수 ${board.readCnt }</span>
				<span>
					<fmt:formatDate value="${board.bRegDate }" pattern="yyyy-MM-dd HH:mm:ss"/>
				</span>
			</div>
			<div class="row">
				<pre>${board.bContent }</pre>
			</div>
			<div class="row">
				<a href="modify">수정</a>
				<a href="delete">삭제</a>
			</div>
		</div>
		<div id="boardReply">
			<h3>댓글</h3>
			<ul id="replyBox">
				<li>
					<div class="replyImg"><img src="img/pic.jpg"></div>
					<div class="replyDetail">
						<p>
						</p>
						<p>
							댓글입니다~
						</p>
					</div>
				</li>
			</ul>
			<script type="text/javascript">
				
			</script>
			<div id="addReplyDiv">
				<form>
					<div class="replyImg"><img src="img/pic.jpg"></div>
					<input type="text" name="r_content" placeholder="내용을 입력해주세요"/>
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
					<button>댓글 추가</button>
				</form>
				
			</div>
		</div>
	</div>
</body>
</html>