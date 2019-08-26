<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Board List</title>
<link rel="stylesheet" type="text/css" href="../css/reset.css"/>
<link rel="stylesheet" type="text/css" href="../css/base.css"/>
<style type="text/css">
	.container{width: 1200px;}
	#boardList {
		width:100%;
	}
	#boardList li:after{
		content:"";
		display:block;
		clear:both;
	}
	#boardList div{
		float:left;
		text-align:center;
	}
	#boardList div:nth-child(1){
		width:5%;
	}
	#boardList div:nth-child(2){
		width:65%;
	}
	#boardList div:nth-child(3){
		width:10%;
	}
	#boardList div:nth-child(4){
		width:10%;
	}
	#boardList div:nth-child(5){
		width:10%;
	}
</style>
</head>

<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp" %>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp" %>
	<div class="container">
		<h3>공지 &amp; 익명 게시판</h3>
		<ul id="boardList">
			<li id="listHead">
				<div>No.</div>
				<div>제목</div>
				<div>작성일</div>
				<div>작성자</div>
				<div>조회수</div>
			</li>
<!-- 			<li> -->
<!-- 				<div>공지</div> -->
<!-- 				<div>대체 휴무 관련하여 공지합니다. [2]</div> -->
<!-- 				<div>2018-08-23</div> -->
<!-- 				<div>김미경</div> -->
<!-- 				<div>25</div> -->
<!-- 			</li> -->
<!-- 			<li> -->
<!-- 				<div>76</div> -->
<!-- 				<div>부장님 가발이셨네요...또르르 [5]</div> -->
<!-- 				<div>2018-08-20</div> -->
<!-- 				<div>익명</div> -->
<!-- 				<div>99</div> -->
<!-- 			</li> -->
			
			<c:forEach items="${bList}" var="board">
			<li>
				<div>${board.bNum }</div>
				<div>${board.bTitle } <span class="replyCount">[0]</span></div>
				<div>${board.bRegDate }</div>
				<div>${board.mName }</div>
				<div>${board.readCnt }</div>
			</li>
			</c:forEach>
			<a href="../board/write">글쓰기</a>
			
		</ul>
	</div>
</body>
</html>