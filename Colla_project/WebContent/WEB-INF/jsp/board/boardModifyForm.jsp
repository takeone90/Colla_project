<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath() %>"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 작성</title>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/reset.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/base.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp" %>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp" %>
	<script>
		$(function(){
			$("#modifyForm").submit(function(){
				if (!$("#title").val().trim()){
					alert("제목을 입력해주세요.");
					$("#title").focus().val("");
					return false;
				} else if (!$("#content").val().trim()){
					alert("내용을 입력해주세요.");
					$("#content").focus().val("");
					return false;
				}
			});
		});
	</script>
	<div id="wsBody">
		<h3>게시글 작성</h3>
		<div id="inputWrap">
			<form id="modifyForm" action="${contextPath}/board/modify" method="post">
				<div class="row">
					<label>
						말머리
						<select id="boardType" name="boardType">
							<option value="default" ${board.bType=='default'?'selected':''}>일반</option>
							<option value="notice" ${board.bType=='notice'?'selected':''}>공지</option>
							<option value="anonymous" ${board.bType=='anonymous'?'selected':''}>익명</option>
						</select>
					</label>
				</div>
				<div class="row">
					<label>
						제목
						<input id="title" type="text" name="title"  value="${board.bTitle }">
					</label>
				</div>
				<div class="row">
					<label>
						내용
						<textarea id="content" name="content" cols="70" rows="10">${board.bContent }</textarea>
					</label>
				</div>
				<div id="btns">
					<input type="hidden" name="bNum" value="${board.bNum}">
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
					<button>등록</button>
					<a href="${contextPath }/board/view?num=${board.bNum}">취소</a>
				</div>
			</form>
		</div>
	</div>
</body>
</html>