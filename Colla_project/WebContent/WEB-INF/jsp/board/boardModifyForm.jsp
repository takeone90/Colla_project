<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 작성</title>
<link rel="stylesheet" type="text/css" href="../css/reset.css"/>
<link rel="stylesheet" type="text/css" href="../css/base.css"/>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp" %>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp" %>
	<script>
		$(function(){
			$("#writeForm").submit(function(){
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
			<form id="modifyForm" action="../board/modify" method="post">
				<div class="row">
					<label>
						말머리
						<select id="boardType" name="boardType">
							<option value="default">일반</option>
							<option value="noice">공지</option>
							<option value="anonymous">익명</option>
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
						<textarea id="content" name="content" cols="70" rows="10">${board.Content }</textarea>
					</label>
				</div>
				<div id="btns">
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
					<button>등록</button>
					<a href="#" onclick="window.location.replace('list')">취소</a>
				</div>
			</form>
		</div>
	</div>
</body>
</html>