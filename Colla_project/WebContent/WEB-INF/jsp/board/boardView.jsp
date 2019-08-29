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
<link rel="stylesheet" type="text/css" href="../css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="../css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="../css/board.css"/>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script type="text/javascript">
	const bNum = ${board.bNum};
	const mNum = ${sessionScope.user.num};
</script>
<script type="text/javascript" src="../js/boardReply.js"></script>
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
				<a href="checkPass?mode=modify&bNum=${board.bNum }">수정</a>
				<a href="checkPass?mode=delete&bNum=${board.bNum }">삭제</a>
				<a href="list">목록</a>
			</div>
		</div>
		<div id="boardReply">
			<h3>댓글</h3>
			<ul id="replyBox" class="clearFix">
			</ul>
			<form id="addReplyDiv">
				<div class="replyImg"><img src="../img/pic.jpg"></div>
				<div id="inputBox">
					<textarea rows="2" cols="50" name="rContent"></textarea>
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
					<button>댓글 추가</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>