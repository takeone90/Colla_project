<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>

<title>Board List</title>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/board.css"/>
</head>

<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp" %>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp" %>
	<div id="wsBody">
	<input type="hidden" value="board" id="pageType">
		<div id="wsBodyContainer">
			<h3>자유게시판</h3>
			
			<div id="boardInner">
				<ul id="boardList">
					<li id="listHead">
						<div>No.</div>
						<div>제목</div>
						<div>작성일</div>
						<div>작성자</div>
						<div>조회수</div>
					</li>
					
					<c:if test="${listInf.boardCnt <= 0 }">
					<li>
						<p class="noBoard">해당 게시글이 없습니다.</p>
					</li>
					</c:if>
					<c:if test="${listInf.boardCnt > 0 }">
						<c:forEach items="${bList}" var="board">
						<li ${board.isNotice == 'y'?'class="noticeLi"':'' }>
							<div>${board.isNotice == 'y'?'<span class="noticeMark">공지</span>':board.bNum }</div>
							<div>
								<a href="${contextPath}/board/view?num=${board.bNum}">${board.bTitle } <span class="replyCount">[${board.replyCnt }]</span></a>
							</div>
							<div>
							<fmt:formatDate value="${board.bRegDate }" pattern="yyyy-MM-dd"/>
							</div>
							<div>${board.bType == 'anonymous'?'익명':board.mName }</div>
							<div>${board.readCnt }</div>
						</li>
						</c:forEach>
					</c:if>
				</ul>
			
				<a href="${contextPath}/board/write" id="writeBtn">글쓰기</a>
			
				<c:if test="${listInf.boardCnt > 0 }">
				<ul id=pagination>
					<li>
						<c:if test="${listInf.page >=6 }">
						<a href="list?page=1&keywordType=${listInf.type }&keyword=${listInf.keyword}&wNum=${sessionScope.currWnum}" id="firstPage" class="pagingIcon">
						</c:if>
						<c:if test="${listInf.page <6 }">
						<a href="javascript:void(0)" id="firstPage" class="disable pagingIcon">
						</c:if>						
							<i class="fas fa-angle-double-left"></i>
						</a>
					</li>
					
					<li>
						<c:if test="${listInf.page >=6 }">
						<a href="list?page=${listInf.startNum-1 }&keywordType=${listInf.type }&keyword=${listInf.keyword}&wNum=${sessionScope.currWnum}" id="prevPage" class="pagingIcon">
						</c:if>
						<c:if test="${listInf.page <6 }">
						<a href="javascript:void(0)" id="prevPage" class="disable pagingIcon">
						</c:if>						
							<i class="fas fa-angle-left"></i>
						</a>
					</li>
						
						<c:forEach var="i" begin="${listInf.startNum }" end="${listInf.endNum }">
						<c:if test="${i<=listInf.totalPage }">
							<li>
								<a href="list?page=${i}&keywordType=${listInf.type}&keyword=${listInf.keyword}&wNum=${sessionScope.currWnum}" ${listInf.page==i?'class=\"currPage\" onclick=\"return false;\"':'' }>${i}</a>
							</li>
						</c:if>
						</c:forEach>	
									
					<li>
						<c:if test="${listInf.page >= (listInf.totalPage - ((listInf.totalPage-1)%5))}">
						<a href="javascript:void(0)" id="nextPage" class="disable pagingIcon">
						</c:if>
						
						<c:if test="${listInf.page < (listInf.totalPage - ((listInf.totalPage-1)%5))}">
						<a href="list?page=${listInf.endNum+1}&keywordType=${listInf.type }&keyword=${listInf.keyword}&wNum=${sessionScope.currWnum}" id="nextPage" class="pagingIcon">
						</c:if>
							<i class="fas fa-angle-right"></i>
						</a>
					</li>
	
					<li>
						<c:if test="${listInf.page >= (listInf.totalPage - ((listInf.totalPage-1)%5))}">
						<a href="javascript:void(0)" id="lastPage" class="disable pagingIcon">
						</c:if>
						<c:if test="${listInf.page < (listInf.totalPage - ((listInf.totalPage-1)%5))}">
						<a href="list?page=${listInf.totalPage }&keywordType=${listInf.type }&keyword=${listInf.keyword}&wNum=${sessionScope.currWnum}" id="lastPage" class="pagingIcon">
						</c:if>
							<i class="fas fa-angle-double-right"></i>
						</a>
					</li>
				</ul>
				</c:if>
				<div id="searchWrap">
					<script>
					</script>
					<form action="list" id="boardSearchForm">
							<input type="hidden" name="wNum" value="${sessionScope.currWnum}">
						
						<select name="keywordType" id="keywordType">
							<option value="1" ${empty listInf.keyword || listInf.type eq 1?'selected':'' }>제목</option>
							<option value="2" ${not empty listInf.keyword && listInf.type eq 2?'selected':'' }>내용</option>
							<option value="3" ${not empty listInf.keyword && listInf.type eq 3?'selected':'' }>제목+내용</option>
							<option value="4" ${not empty listInf.keyword && listInf.type eq 4?'selected':'' }>작성자</option>
						</select>
						<input type="text" name="keyword" value="${listInf.keyword }"><button>검색</button>
					</form>
				</div>
			</div>
		</div>	
	</div>
</body>
</html>