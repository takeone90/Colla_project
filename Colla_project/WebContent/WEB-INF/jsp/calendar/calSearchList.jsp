<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" type="text/css" href="css/reset.css" />
<link rel="stylesheet" type="text/css" href="css/base.css" />
<link rel="stylesheet" type="text/css" href="css/headerWs.css" />
<link rel="stylesheet" type="text/css" href="css/navWs.css" />
<script src="https://code.jquery.com/jquery-3.4.1.js"
	integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
	crossorigin="anonymous"></script>
<script type="text/javascript">
	$(function() {
// 		var type1 = $("#calType1").prop("checked");
// 		var type2 = $("#calType2").prop("checked");
// 		var type3 = $("#calType3").prop("checked");
	});
</script>
<title>calSearchList</title>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp"%>
	<div id="wsBody">
		<div id="wsBodyContainer">
			<form action="calSearchList">
				<select name="searchType">
					<option value="1">제목</option>
					<option value="2">내용</option>
					<option value="3">제목+내용</option>
					<option value="4">작성자</option>
				</select> 
				<input type="text" name="searchKeyword" placeholder="검색어를 입력해주세요.">
				<input type="submit" value="검색">
			</form>
			<label><input type="checkbox" name="calType" id="calType1" value="project" checked="checked">프로젝트</label>
			<label><input type="checkbox" name="calType" id="calType2" value="vacation" checked="checked">휴가</label>
			<label><input type="checkbox" name="calType" id="calType3" value="event" checked="checked">행사</label>
			<button onclick="location.href='${contextPath}/calMonth'">달력 전체보기</button>
			<table>
				<tr>
					<th>제목</th>
					<th>내용</th>
					<th>시작일</th>
					<th>종료일</th>
					<th>작성자</th>
				</tr>
				<c:forEach items="${searchedCalendarList}" var="schedule">
					<tr>
						<td>${schedule.title}</td>
						<td>${schedule.content}</td>
						<td>${schedule.startDate}</td>
						<td>${schedule.endDate}</td>
						<td>${schedule.mName}</td>
					</tr>
				</c:forEach>
			</table>
			
			<!-- 페이징 -->
			<div id="navigation">
				<c:if test="${startPage != 1}">
			 		<a href="calSearchList?page=1&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}">◀◀ </a>
			 		<a href="calSearchList?page=${param.page-1}&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}"> ◀</a>
				</c:if>
				<c:forEach var="pageNum" begin="${startPage}" end="${endPage < totalPageCount ? endPage:totalPageCount}">
					<c:choose>
						<c:when test="${pageNum==param.page}">
							<b>${pageNum}</b>
						</c:when>
						<c:otherwise>
							<a href="calSearchList?page=${pageNum}&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}">${pageNum}</a>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			 	<c:if test="${endPage < totalPageCount}">
			 		<a href="calSearchList?page=${param.page+1}&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}">▶ </a>
			 		<a href="calSearchList?page=${totalPageCount}&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}"> ▶▶</a>
				</c:if>
			</div>

		</div>
	</div>
</body>
</html>