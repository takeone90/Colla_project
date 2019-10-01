<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>

<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/todo.css"/>
<title>Todo List</title>
<script>
	$(function(){
		$("#todoList").disableSelection();
		$("#todoList").sortable({
				update: function(event, ui) {
	            var result = $(this).sortable('toArray');
	            var pNum = $("#pNum").val();
		            $.ajax({
		            	url : "${contextPath}/resortingTodo",
		            	data : {"priorityArray":result,"pNum":pNum},
		            	success : function(){
// 		            		alert("데이터보내기 성공");
		            	},
		            	error : function(){
		            		alert("정렬 에러발생");
		            	}
		            });
	            }
		});
		
		$(".isComplete[data-isComplete=1]").attr("style","background-color:#E5675A");
		$(".isComplete[data-isComplete=0]").attr("style","background-color:#e0e0e0");
		
		
		$("#addTodo").on("click",function(){
			$("#addTodoModal").fadeIn(300);
		});
		$("#closeTodoModal").on("click",function(){
			$("#addTodoModal").fadeOut(300);
			return false;
		});
		$(".modifyTodoModalOpen").on("click",function(){
// 			alert($(this).attr("data-tdNum"));
			$(".tdNum").val($(this).attr("data-tdNum"));
			$("#modifyTodoModal").fadeIn(300);
		});
		$("#closeModifyTodoModal").on("click",function(){
			$("#modifyTodoModal").fadeOut(300);
			return false;
		});
	});<%--onload function end--%>
	
	function checkComplete(tdNum){
		var isCompleteDiv = $(".isComplete[data-tdNum="+tdNum+"]");
		$.ajax({
			url : "${contextPath}/toggleComplete",
			data : {"tdNum":tdNum},
			dataType : "json",
			success : function(completeAndProgress){
				var isComplete = completeAndProgress.isComplete;
				var progress = completeAndProgress.progress;
				if(isComplete==1){
					isCompleteDiv.css("backgroundColor","#E5675A");//눌러서 바뀐색깔임. 완료한 경우
					
				}else{
					isCompleteDiv.css("backgroundColor","#ebebeb");
				}
				$("#progressBar").val(progress);
			}
		});
	}
</script>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp"%>
	<div id="wsBody">
		<input type="hidden" value="todoList" id="pageType">
		<input type="hidden" value="${sessionScope.user.num}" id="mNum">
		<input type="hidden" value="${pNum}" id="pNum">
		<input type="hidden" value="${sessionScope.currWnum}" id="currWnum">
		<div id="wsBodyContainer"> 
		<h2 style="display:inline-block;">${pName} </h2><h3 style="display:inline-block;margin-left:14px;">Todo List</h3>
		<button id="backToProjectMain" onclick="location.href='projectMain?wNum=${sessionScope.currWnum}'">프로젝트 메인</button>
		<button id="addTodo">할 일 추가</button>
		<div id="todoArea">
			<div id="currProjectProgress" align="left">
				진행률  <progress id="progressBar" value="${progress}" max="100" style="width:71%;"></progress>
			</div>
			
			<ul id="todoList">
				<!-- 아래는 반복적으로 생긴다 -->
				<c:forEach items="${tList}" var="td" varStatus="s">
					<li class="todo" id="${s.index}">
					<div class="isComplete" data-tdNum="${td.tdNum}" data-isComplete="${td.isComplete}"onclick="checkComplete(${td.tdNum});">
						<input type="hidden" value="${td.isComplete}">
					</div>
					<div class="tdDate">
						<p>
						<fmt:formatDate value="${td.tdStartDate}" pattern="yyyy.MM.dd" />
				        <fmt:formatDate value="${td.tdStartDate}" pattern="E"/>요일 
						</p>&nbsp;&nbsp;&nbsp;~&nbsp;&nbsp;&nbsp;
						
						<p>
						<fmt:formatDate value="${td.tdEndDate}" pattern="yyyy.MM.dd" />
				        <fmt:formatDate value="${td.tdEndDate}" pattern="E"/>요일 
						</p>
					</div>
					<div class="tdInfo">
						
						<div class="tdMemberInfo">
							<div class='profileImg' align="center">
								<img alt='프로필사진' src='${contextPath}/showProfileImg?num=${td.mNumTo}'>
							</div>
							<p style="text-align:center;">${td.mName}</p>
						</div>
						<div class="tdInfo-titleContent">
							<h4>${td.tdTitle}</h4>
							<p>${td.tdContent}</p>
						</div>
					</div>
<!-- 					<div class="tdPriority"> -->
<!-- 					</div> -->
					
					<div class="todoInnerBtn" align="right">
						<button class="modifyTodoModalOpen" data-tdNum="${td.tdNum}">수정</button>
						<button onclick="location.href='removeTodo?tdNum=${td.tdNum}'">삭제</button>
					</div>
			</li><%--end todo --%>
				</c:forEach>
			
			
			
			</ul>
			
			
		</div>
		</div><!-- end wsBodyContainer -->
	</div><!-- end wsBody -->
	
	<%------------------------------------할일 추가 모달  ---------------------------------------%>
		<div id="addTodoModal" class="attachModal ui-widget-content">
			<div class="modalHead">
				<h3>할 일 추가</h3>
			</div>
			<div class="modalBody">
				<p style="margin-top:16px;font-size:13px;">Todo를 만들고 프로젝트 일정을 세분화 하세요</p>
				<form action="addTodo" method="post">
					<input type="hidden" value="${_csrf.token}" name="${_csrf.parameterName}">
					<div class="addPjInputWrap">
						<div class="row">
							<h4>작업 이름</h4>
							<div>
								<input type="text" placeholder="할 일 이름" name="tdTitle" style="width:465px">
							</div>
						</div>
						<div class="row">
							<h4>할 일 내용</h4>
							<div>								
								<input type="text" placeholder="무슨 일을 해야하나요?" name="tdContent" style="width:465px">
							</div>
						</div>
						<div class="row">
							<h4>할 일 멤버</h4>
							<ul class="selectTodoMemberUL">
							<c:forEach items="${pmList}" var="pm">
								<li onclick="checkTodoMember(this);">
								<div class='profileImg' align="center">
								<img alt='프로필사진' src='${contextPath}/showProfileImg?num=${pm.mNum}'>
								</div>
								<p style="text-align:center;">${pm.mName}</p>
								<input type="radio" value="${pm.mNum}" name="mNum" style="display:none;">
								</li>
								<script>
									function checkTodoMember(tag){
										let $checkInput = $(tag).find("input[type='radio']");
										$checkInput.prop('checked',function(){
											$(".selectTodoMemberUL li").removeClass("checkedLI");
											$checkInput.prop('checked', true);
											$(tag).addClass("checkedLI");
										});
									}
								</script>
							</c:forEach>
							</ul>
						</div>
						<div class="row">
							<h4>할 일 기간</h4>
							<div id="addTodo-Date">
								<input type="date" name="startDate" placeholder="시작일을 입력하세요"> ~ 
								<input type="date" name="endDate" placeholder="종료일을 입력하세요">
							</div>
						</div>
					</div> <!-- end addWsInputWrap -->

					<div id="modalBtnDiv">
						<button type="submit">할 일 추가</button>
						<button id="closeTodoModal">닫기</button>
					</div>
				</form>
			</div> <!-- end modalBody -->
		</div><!-- end addTodoModal -->
		<%------------------------------------프로젝트 수정 모달  ---------------------------------------%>
		<div id="modifyTodoModal" class="attachModal ui-widget-content">
			<div class="modalHead">
				<h3>일정 수정하기</h3>
			</div>
			<div class="modalBody">
				<p style="margin-top:16px;font-size:13px;">일정을 수정합니다</p>
				<form action="modifyTodo" method="post">
					<input type="hidden" value="${_csrf.token}" name="${_csrf.parameterName}">
					<input type="hidden" name="tdNum" class="tdNum">
					<div class="modifyTodoInputWrap">
						<div class="row">
							<h4>할 일 이름</h4>
							<div>
								<input type="text" placeholder="할 일 이름" name="tdTitle" style="width:465px">
							</div>
						</div>
						<div class="row">
							<h4>할 일 내용</h4>
							<div>								
								<input type="text" placeholder="무슨 일을 해야하나요?" name="tdContent" style="width:465px">
							</div>
						</div>
						<div class="row">
							<h4>할 일 기간</h4>
							<div id="modifyTodo-Date">
								<input type="date" name="startDate" placeholder="시작일을 입력하세요"> ~ 
								<input type="date" name="endDate" placeholder="종료일을 입력하세요">
							</div>
						</div>
							<div class="row">
							<h4>할 일 멤버</h4>
								<ul class="selectTodoMemberUL">
								<c:forEach items="${pmList}" var="pm">
									<li onclick="checkTodoMember(this);">
									<div class='profileImg' align="center">
									<img alt='프로필사진' src='${contextPath}/showProfileImg?num=${pm.mNum}'>
									</div>
									<p style="text-align:center;">${pm.mName}</p>
									<input type="radio" value="${pm.mNum}" name="mNum" style="display:none;">
									</li>
								</c:forEach>
								</ul>
							</div>
					</div> <!-- end addWsInputWrap -->

					<div id="modalBtnDiv">
						<button type="submit">할 일 수정하기</button>
						<button id="closeModifyTodoModal">닫기</button>
					</div>
				</form>
			</div> <!-- end modalBody -->
		</div><!-- end modifyTodoModal -->
</body>
</html>