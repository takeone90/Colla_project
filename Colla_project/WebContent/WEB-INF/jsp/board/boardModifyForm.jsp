<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>

<title>게시글 작성</title>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/board.css"/>

<script src="${contextPath}/lib/ckeditor4/ckeditor.js"></script>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp" %>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp" %>
	<script>
		$(function(){
			CKEDITOR.replace('content');
			
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
	<input type="hidden" value="board" id="pageType">
		<div id="wsBodyContainer">
		
			<h3>자유게시판</h3>
			<h4>게시글 수정</h4>
			<div id="boardInner">
				<div id="inputWrap">
					<form id="modifyForm" action="${contextPath}/board/modify" method="post" enctype="multipart/form-data">
						<div class="row">
							<label>
								<span>게시글 종류</span>
								<select id="boardType" name="boardType">
									<option value="default" ${board.bType=='default'?'selected':''}>일반</option>
									<option value="notice" ${board.bType=='notice'?'selected':''}>공지</option>
									<option value="anonymous" ${board.bType=='anonymous'?'selected':''}>익명</option>
								</select>
							</label>
						</div>
						<div class="row">
							<label>
								<span>제목</span>
								<input id="title" type="text" name="title"  value="${board.bTitle }">
							</label>
						</div>
						<div class="row">
							<textarea id="content" name="content" cols="70" rows="10">${board.bContent }</textarea>
						</div><div class="row clearFix">
							<label for="file" class="floatleft">
								<span>파일 첨부</span>
							</label>
							<div id="uploadArea" class="floatleft">
								<span class="${ fn:length(fList) > 0?'on':'' }">
									<c:if test="${ fn:length(fList) > 0 }">
										<c:forEach items="${fList }" var="file" varStatus="stat">
											파일 ${stat.index+1} : ${file.originName} <br/>
										</c:forEach>
									</c:if>
									<c:if test="${ fn:length(fList) == 0 }">
										Choose a file or Drag it here.
									</c:if>
								</span>
								<input multiple="multiple" id="file" type="file" name="file" >
							</div>
							<script type="text/javascript">
								$(function(){
									$("#file").change(function(){
										let $span = $("#uploadArea span");
										console.log(this.files);
										$span.empty();
										if(this.files.length>0){
											$span.addClass("on");
											$.each(this.files, function(idx,item){
												$span.append("파일 "+ (idx+1) +" : "+item.name+"<br/>");
											})
										} else {
											$span.removeClass("on");
											$span.text("Choose a file or Drag it here.");
										}
									})
								})
							</script>
						</div>
						<div id="btns">
							<input type="hidden" name="bNum" value="${board.bNum}">
							<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
							<button class="btn">등록</button>
							<a class="btn" href="${contextPath }/board/view?num=${board.bNum}">취소</a>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>