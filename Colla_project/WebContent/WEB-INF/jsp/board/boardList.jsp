<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Board List</title>
<link rel="stylesheet" type="text/css" href="../css/reset.css"/>
<link rel="stylesheet" type="text/css" href="../css/base.css"/>
<link rel="stylesheet" type="text/css" href="../css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="../css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="../css/board.css"/>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
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
		width:10%;
	}
	#boardList div:nth-child(3){
		width:55%;
	}
	#boardList div:nth-child(4){
		width:10%;
	}
	#boardList div:nth-child(5){
		width:10%;
	}
	#boardList div:nth-child(6){
		width:10%;
	}
</style>
</head>

<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp" %>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp" %>
	<div id="wsBody">
		<h3>공지 &amp; 익명 게시판</h3>
		<ul id="boardList">
			<li id="listHead">
				<div>No.</div>
				<div>종류</div>
				<div>제목</div>
				<div>작성일</div>
				<div>작성자</div>
				<div>조회수</div>
			</li>
			
			<c:forEach items="${bList}" var="board">
			<li>
				<div>${board.bNum }</div>
				<div>
					<c:choose>
						<c:when test="${board.bType eq 'notice'}">
							공지
						</c:when>
						<c:when test="${board.bType eq 'anonymous'}">
							익명
						</c:when>
						<c:otherwise >
							일반
						</c:otherwise>
					</c:choose>
				</div>
				<div>
					<a href="../board/view?num=${board.bNum}">${board.bTitle } <span class="replyCount">[0]</span></a>
				</div>
				<div>
				<fmt:formatDate value="${board.bRegDate }" pattern="yyyy-MM-dd"/>
				</div>
				<div>${board.mName }</div>
				<div>${board.readCnt }</div>
			</li>
			</c:forEach>
		</ul>
		
		<ul id=pagination>
			<li><a href="#" class="currPage">1</a></li>
			<li><a href="#">2</a></li>
			<li><a href="#">3</a></li>
			<li><a href="#">4</a></li>
			<li><a href="#">5</a></li>
		</ul>
		
		<a href="../board/write">글쓰기</a>
		<div id="searchWrap">
			<form action="list">
				<select name="keywordType" id="keywordType">
					<option value="t">제목</option>
					<option value="c">내용</option>
					<option value="tc">제목+내용</option>
					<option value="a">작성자</option>
				</select>
				<input type="text" name="keyword" placeholder="검색어">
				<button>검색</button>
			</form>
		</div>
	</div>
</body>
</html>