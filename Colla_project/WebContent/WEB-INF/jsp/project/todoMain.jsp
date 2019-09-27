<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>

<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/todo.css"/>
<title>Todo List</title>
<script>
	$(function(){
		$("#todoList").sortable();
		$("#todoList").disableSelection();
		
		$("#addTodo").on("click",function(){
			$("#addTodoModal").fadeIn(300);
		});
		$("#closeTodoModal").on("click",function(){
			$("#addTodoModal").fadeOut(300);
			return false;
		});
		$(".modifyTodoModalOpen").on("click",function(){
			$("#modifyTodoModal").fadeIn(300);
		});
		$("#closeModifyTodoModal").on("click",function(){
			$("#modifyTodoModal").fadeOut(300);
			return false;
		});
	});
</script>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp"%>
	<div id="wsBody">
		<input type="hidden" value="todoList" id="pageType">
		<input type="hidden" value="${sessionScope.user.num}" id="mNum">
		<div id="wsBodyContainer"> 
		<h2>[프로젝트 이름] Todo List</h2>
		<button id="addTodo">할 일 추가</button>
		<div id="todoArea">
			<div id="currProjectProgress" align="center">
				현재 프로젝트 전체 진행률 ~~
			</div>
			
			<ul id="todoList">
				<!-- 아래는 반복적으로 생긴다 -->
			<li class="todo">
					<div class="isComplete">
						할일 완료 여부
					</div>
					<div class="tdInfo">
						<h4>할일 제목(tdTitle)</h4>
						<p>할 일 내용(tdContent)</p>
						<div class="tdMemberInfo">
							<p>일할 사람</p>
						</div>
					</div>
<!-- 					<div class="tdPriority"> -->
<!-- 					</div> -->
					<div class="tdDate">
						시작일 : <p>2019년 8월</p>
						종료일 : <p>2019년 10월</p>
					</div>
					<div class="todoInnerBtn" align="right">
						<button class="modifyTodoModalOpen">수정</button>
						<button>삭제</button>
					</div>
			</li><%--end project --%>
			
			<li class="todo">
					<div class="isComplete">
						할일 완료 여부
					</div>
					<div class="tdInfo">
						<h4>할일 제목(tdTitle)</h4>
						<p>할 일 내용(tdContent)</p>
						<div class="tdMemberInfo">
							<p>일할 사람</p>
						</div>
					</div>
<!-- 					<div class="tdPriority"> -->
<!-- 					</div> -->
					<div class="tdDate">
						시작일 : <p>2019년 8월</p>
						종료일 : <p>2019년 10월</p>
					</div>
					<div class="todoInnerBtn" align="right">
						<button class="modifyTodoModalOpen">수정</button>
						<button>삭제</button>
					</div>
			</li><%--end project --%>
			
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
				<p>Todo를 만들고 프로젝트 일정을 세분화 하세요</p>
<!-- 				<form action="addWs" method="post"> -->
<%-- 					<input type="hidden" value="${_csrf.token}" name="${_csrf.parameterName}"> --%>
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
							<div class="addTodoMemberDiv">
								<input type="text" placeholder="작업할 프로젝트 멤버" name="todoMemberList" style="width:465px">
							</div>
							<div class="addTodoRoundBox" align="center">
								<a href="#" class="addTodoInput">+</a>
							</div>
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
<!-- 				</form> -->
			</div> <!-- end modalBody -->
		</div><!-- end addTodoModal -->
		<%------------------------------------프로젝트 수정 모달  ---------------------------------------%>
		<div id="modifyTodoModal" class="attachModal ui-widget-content">
			<div class="modalHead">
				<h3>일정 수정하기</h3>
			</div>
			<div class="modalBody">
				<p>일정을 수정합니다</p>
<!-- 				<form action="addWs" method="post"> -->
<%-- 					<input type="hidden" value="${_csrf.token}" name="${_csrf.parameterName}"> --%>
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
					</div> <!-- end addWsInputWrap -->

					<div id="modalBtnDiv">
						<button type="submit">할 일 수정하기</button>
						<button id="closeModifyTodoModal">닫기</button>
					</div>
<!-- 				</form> -->
			</div> <!-- end modalBody -->
		</div><!-- end modifyTodoModal -->
</body>
</html>