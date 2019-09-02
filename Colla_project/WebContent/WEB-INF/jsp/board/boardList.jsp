<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath() %>"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Board List</title>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/reset.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/base.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/board.css"/>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<style type="text/css">
	#wsBodyContainer{
		width: 80%;
		margin: 0 auto;	
	}
	#boardList {
		width:100%;
	}
	#boardList li{
		margin-bottom:6px;
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
	.replyCount{
		color:#E5675A;
		font-size:14px;
	}
	a.currPage{
		color:#E5675A;
		cursor:default;
	}
	.reverse {
		transform:rotate(180deg);
	}
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="https://use.fontawesome.com/releases/v5.2.0/js/all.js"></script> <!-- font awsome -->
</head>

<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp" %>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp" %>
	<div id="wsBody">
		<div id="wsBodyContainer">
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
						<a href="${contextPath}/board/view?num=${board.bNum}">${board.bTitle } <span class="replyCount">[${board.replyCnt }]</span></a>
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
				<li><a href="list?page=1" id="firstPage"><i class="fas fa-step-backward"></i></a>
				<li><a href="list?page=${listInf.startNum-1>0?listInf.startNum-1:1}" id="prevPage" ${instInf.startNum }><i class="fas fa-play reverse"></i></a>
				</li>
					<c:forEach var="i" begin="${listInf.startNum }" end="${listInf.endNum }">
					<c:if test="${i<=listInf.totalPage }">
						<li>
							<a href="list?page=${i}" ${param.page==i?'class=\"currPage\" onclick=\"return false;\"':'' }>${i}</a>
						</li>
					</c:if>
					</c:forEach>				
				<li><a href="list?page=${listInf.endNum+1>listInf.totalPage?listInf.totalPage:listInf.endNum+1 }" id="nextPage"><i class="fas fa-play"></i></a></li>
				<li><a href="list?page=${listInf.totalPage }" id="lastPage"><i class="fas fa-step-forward"></i></a></li>
			</ul>
			
			<a href="${contextPath}/board/write">글쓰기</a>
			<div id="searchWrap">
				<script>
// 					$(function(){
// 						$("#searchWrap form").submit(function(){
// 							let $keyword = $("input[name='keyword']").val().trim();
// 							if(!$keyword){
// 								alert("검색어를 입력해주세요.");
// 								return false;
// 							}
// 						});
// 					})
				</script>
				<form action="list">
					<select name="keywordType" id="keywordType">
						<option value="1" ${empty listInf.keyword || listInf.type eq 1?'selected':'' }>제목</option>
						<option value="2" ${not empty listInf.keyword && listInf.type eq 2?'selected':'' }>내용</option>
						<option value="3" ${not empty listInf.keyword && listInf.type eq 3?'selected':'' }>제목+내용</option>
						<option value="4" ${not empty listInf.keyword && listInf.type eq 4?'selected':'' }>작성자</option>
					</select>
					<input type="text" name="keyword" placeholder="검색어" value="${listInf.keyword }">
					<button>검색</button>
				</form>
			</div>
		</div>
	</div>
</body>
</html>