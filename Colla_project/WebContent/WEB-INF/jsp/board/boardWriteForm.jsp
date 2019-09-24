<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>

<title>게시글 작성</title>
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
			CKEDITOR.replace('content',{
				filebrowserImageUploadUrl: "${contextPath}/board/ckeditorUpload",
			});
			
			$("#writeForm").submit(function(){
				if( !$("#pw").val().trim() ){
					alert("글을 수정하고 삭제할 때 사용하실\n비밀번호를 입력해주세요.");
					$("#pw").focus().val("");
					return false;
				} else if (!$("#title").val().trim()){
					alert("제목을 입력해주세요.");
					$("#title").focus().val("");
					return false;
				} else if (!$("#cke_content iframe").contents().find("body").text().trim()){
					alert("내용을 입력해주세요.");
					$("#cke_content iframe").contents().find("body").focus().val("");
					return false;
				}
			});
		});
	</script>
	<div id="wsBody">
	<input type="hidden" value="board" id="pageType">
		<div id="wsBodyContainer">
		
			<h3>자유게시판</h3>
			<h4>새 게시글 작성</h4>
			<div id="boardInner">
				<div id="inputWrap">
					<form id="writeForm" action="${contextPath}/board/write" method="post" enctype="multipart/form-data">
						<div class="row clearFix">
							<label class="floatleft">
								<span>게시글 종류</span>
								<select id="boardType" name="boardType">
									<option value="default">일반</option>
									<option value="notice">공지</option>
									<option value="anonymous">익명</option>
								</select>
							</label>
							
							<label class="floatleft">
								<span>글 비밀번호</span>
								<input id="pw" type="password" name="pw" placeholder="글 비밀번호를 입력해주세요">
							</label>
						</div>
						<div class="row clearFix">
							<label class="floatleft">
								<span>제목</span>
								<input id="title" type="text" name="title" placeholder="제목을 입력해주세요">
							</label>
							<label class="floatleft" id="writer">
								<span>작성자</span>
								<input type="text" disabled value="${member.name }" >
							</label>
						</div>
						<div class="row">
							<textarea id="content" name="content" cols="70" rows="10"></textarea>
						</div>
						<div class="row clearFix">
							<label for="file" class="floatleft">
								<span>파일 첨부</span>
							</label>
							<div id="uploadArea" class="floatleft">
								<span>Choose a file or Drag it here.</span>
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
							<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
							<button class="btn">등록</button>
							<a class="btn" href="list?page=${listInf.page}&keyword=${listInf.keyword}&keywordType=${listInf.type}">취소</a>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>