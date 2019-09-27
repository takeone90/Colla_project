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
					
			</li><%--end project --%>
			
			</ul>
			
			
		</div>
		</div><!-- end wsBodyContainer -->
	</div><!-- end wsBody -->
</body>
</html>