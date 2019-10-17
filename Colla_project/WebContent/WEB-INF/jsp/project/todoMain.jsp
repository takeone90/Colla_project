<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>

<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/todo.css"/>
<title>Todo List</title>
<script>
	$(function(){
		
		<%----------------------------------------------------날짜포맷만들기 시작-------------------------------------------------%>
		Date.prototype.format = function(f) {
		    if (!this.valueOf()) return " ";
		 
		    var weekName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
		    var d = this;
		     
		    return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function($1) {
		        switch ($1) {
		            case "yyyy": return d.getFullYear();
		            case "yy": return (d.getFullYear() % 1000).zf(2);
		            case "MM": return (d.getMonth() + 1).zf(2);
		            case "dd": return d.getDate().zf(2);
		            case "E": return weekName[d.getDay()];
		            case "HH": return d.getHours().zf(2);
		            case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2);
		            case "mm": return d.getMinutes().zf(2);
		            case "ss": return d.getSeconds().zf(2);
		            case "a/p": return d.getHours() < 12 ? "오전" : "오후";
		            default: return $1;
		        }
		    });
		};
		 
		String.prototype.string = function(len){var s = '', i = 0; while (i++ < len) { s += this; } return s;};
		String.prototype.zf = function(len){return "0".string(len - this.length) + this;};
		Number.prototype.zf = function(len){return this.toString().zf(len);};
		<%-------------------------------------------------날짜포맷 종료--------------------------------------------------------%>
		
		
		$("#addTodo").on("click",function(){
			$("#addTodoModal").fadeIn(300);
		});
		$("#closeTodoModal").on("click",function(){
			$("#addTodoModal").fadeOut(300);
			return false;
		});
		$(".modifyTodoModalOpen").on("click",function(){
// 			alert($(this).attr("data-tdNum"));
			var tdNum = $(this).attr("data-tdNum");
			$(".tdNum").val(tdNum);
			$.ajax({
				url :"${contextPath}/getTodo",
				data : {"tdNum":tdNum},
				dataType : "json",
				success : function(td){
					$("#tdTitle").val(td.tdTitle);
					$("#tdContent").val(td.tdContent);
					var startDate = new Date(td.tdStartDate).format("yyyy-MM-dd");
					var endDate = new Date(td.tdEndDate).format("yyyy-MM-dd");
					$("#tdStartDate").val(startDate);
					$("#tdEndDate").val(endDate);
				}
			});
			$("#modifyTodoModal").fadeIn(300);
		});
		$("#closeModifyTodoModal").on("click",function(){
			$("#modifyTodoModal").fadeOut(300);
			return false;
		});
	});<%--onload function end--%>
	function removeTodo(tdNum){
		if(confirm("할일을 삭제하시겠습니까?")==true){
			location.href="removeTodo?tdNum="+tdNum;
		}
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
		<h2 style="display:inline-block;">${pName} </h2><h3 style="display:inline-block;margin-left:14px;"></h3>
		<div id="todoArea">
			<div id="currProjectProgress" align="left">
				진행률  <progress id="progressBar" value="${progress}" max="100"></progress>
			</div>
			<button id="backToProjectMain" onclick="location.href='projectMain?wNum=${sessionScope.currWnum}'">프로젝트 메인</button>
			<button id="addTodo">할 일 추가</button>
			<ul id="todoList">
				<!-- 아래는 반복적으로 생긴다 -->
				<c:if test="${empty tList}">
					<li style="text-align: center; margin-top: 136px; color: #9c9998;">할 일 추가 버튼으로 Todo를 추가하세요.</li>
				</c:if>
				
				<c:if test="${!empty tList}">
				<c:forEach items="${thisProjectTdList}" var="onePm">
					<li class="onePmMember" data-mNum="${onePm.mNum}">
						<div class="tdMemberInfo">
								<div class='profileImg' align="center">
									<img alt='프로필사진' src='${contextPath}/showProfileImg?num=${onePm.mNum}' onclick="showProfileInfoModal(${onePm.mNum});">
								</div>
								<p style="text-align:center;">${onePm.mName}</p>
						</div>
					<ul class="oneMemberTodoList collaScroll">
						<c:forEach items="${onePm.oneMemberTdList}" var="td" varStatus="s">
						<li class="todo" id="${td.tdNum}">
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
							<div class="tdInfo-titleContent">
								<h4>${td.tdTitle}</h4>
								<p>${td.tdContent}</p>
							</div>
						</div>
						<div class="todoInnerBtn" align="right">
							<div class="isComplete" data-tdNum="${td.tdNum}" data-isComplete="${td.isComplete}"onclick="checkComplete(${td.tdNum});">
							<input type="hidden" value="${td.isComplete}">
							<i class="fas fa-check"></i>&nbsp;Complete
							</div>
							<button class="modifyTodoModalOpen" data-tdNum="${td.tdNum}">수정</button>
							<button onclick="removeTodo(${td.tdNum});">삭제</button>
						</div>
						</li><%--end todo --%>
						</c:forEach>
						</ul>
					</li><%-- end onePmMember --%>
				</c:forEach>
			</c:if>
			</ul><%-- end todoList --%>
			<script>
	 		$(".oneMemberTodoList").sortable({
				update: function(event, ui) {
	            var result = $(this).sortable('toArray');
	            var pNum = $("#pNum").val();
	            var mNum = $(this).parent().attr("data-mNum");
		            $.ajax({
		            	url : "${contextPath}/resortingTodo",
		            	data : {"priorityArray":result,"pNum":pNum,"mNum":mNum},
		            	success : function(){
		            	}
		            });
	            }
			});
			</script>
			<script>
						$(function(){
							$(".isComplete[data-isComplete=1]").css({
								color:"#31b377",
								borderColor:"#31b377"
							});
							$(".isComplete[data-isComplete=0]").css({
								color:"#bdc3c3",
								borderColor:"#bdc3c3"
							});
						});
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
											isCompleteDiv.css({
												color:"#31b377",
												borderColor:"#31b377"
											});//눌러서 바뀐색깔임. 완료한 경우
											
										}else{
											isCompleteDiv.css({
												color:"#bdc3c3",
												borderColor:"#bdc3c3"
											});
										}
										$("#progressBar").val(progress);
									}
								});
							}
						</script>
		</div>
		</div><!-- end wsBodyContainer -->
	</div><!-- end wsBody -->
	
	<%------------------------------------할일 추가 모달  ---------------------------------------%>
		<div id="addTodoModal" class="attachModal ui-widget-content">

			
			<div class="header">
						<!--파도 위 내용-->
						<div class="inner-header flex">
							<g><path fill="#fff"
							d="M250.4,0.8C112.7,0.8,1,112.4,1,250.2c0,137.7,111.7,249.4,249.4,249.4c137.7,0,249.4-111.7,249.4-249.4
							C499.8,112.4,388.1,0.8,250.4,0.8z M383.8,326.3c-62,0-101.4-14.1-117.6-46.3c-17.1-34.1-2.3-75.4,13.2-104.1
							c-22.4,3-38.4,9.2-47.8,18.3c-11.2,10.9-13.6,26.7-16.3,45c-3.1,20.8-6.6,44.4-25.3,62.4c-19.8,19.1-51.6,26.9-100.2,24.6l1.8-39.7		
							c35.9,1.6,59.7-2.9,70.8-13.6c8.9-8.6,11.1-22.9,13.5-39.6c6.3-42,14.8-99.4,141.4-99.4h41L333,166c-12.6,16-45.4,68.2-31.2,96.2	
							c9.2,18.3,41.5,25.6,91.2,24.2l1.1,39.8C390.5,326.2,387.1,326.3,383.8,326.3z" /></g>
							</svg>
							<div class="loginBox-Head">
								<h3 style="font-size:24px;">할 일 추가</h3>
								<p style="margin-top:16px;font-size:13px;">Todo를 만들고 프로젝트 일정을 세분화 하세요</p>
							</div>
						</div>
						<!--파도 시작-->
						<div>
							<svg class="waves" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
							viewBox="0 24 150 28" preserveAspectRatio="none" shape-rendering="auto">
							<defs>
							<path id="gentle-wave" d="M-160 44c30 0 58-18 88-18s 58 18 88 18 58-18 88-18 58 18 88 18 v44h-352z" />
							</defs>
								<g class="parallax">
								<use xlink:href="#gentle-wave" x="48" y="0" fill="rgba(255,255,255,0.7" />
								<use xlink:href="#gentle-wave" x="48" y="3" fill="rgba(255,255,255,0.5)" />
								<use xlink:href="#gentle-wave" x="48" y="7" fill="#fff" />
								</g>
							</svg>
						</div><!--파도 end-->
			</div><!--header end-->
			
			<div class="modalBody">
				<form action="addTodo" method="post">
					<input type="hidden" value="${_csrf.token}" name="${_csrf.parameterName}">
					<div class="addPjInputWrap">
						<div class="row">
							<h4>작업 이름</h4>
							<div>
								<input type="text" placeholder="할 일 이름" name="tdTitle" style="width:409px">
							</div>
						</div>
						<div class="row">
							<h4>할 일 내용</h4>
							<div>								
								<input type="text" placeholder="무슨 일을 해야하나요?" name="tdContent" style="width:409px">
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
			<div class="header">
						<!--파도 위 내용-->
						<div class="inner-header flex">
							<g><path fill="#fff"
							d="M250.4,0.8C112.7,0.8,1,112.4,1,250.2c0,137.7,111.7,249.4,249.4,249.4c137.7,0,249.4-111.7,249.4-249.4
							C499.8,112.4,388.1,0.8,250.4,0.8z M383.8,326.3c-62,0-101.4-14.1-117.6-46.3c-17.1-34.1-2.3-75.4,13.2-104.1
							c-22.4,3-38.4,9.2-47.8,18.3c-11.2,10.9-13.6,26.7-16.3,45c-3.1,20.8-6.6,44.4-25.3,62.4c-19.8,19.1-51.6,26.9-100.2,24.6l1.8-39.7		
							c35.9,1.6,59.7-2.9,70.8-13.6c8.9-8.6,11.1-22.9,13.5-39.6c6.3-42,14.8-99.4,141.4-99.4h41L333,166c-12.6,16-45.4,68.2-31.2,96.2	
							c9.2,18.3,41.5,25.6,91.2,24.2l1.1,39.8C390.5,326.2,387.1,326.3,383.8,326.3z" /></g>
							</svg>
							<div class="loginBox-Head">
								<h3 style="font-size:24px;">일정 수정하기</h3>
								<p style="margin-top:16px;font-size:13px;">일정을 수정합니다</p>
							</div>
						</div>
						<!--파도 시작-->
						<div>
							<svg class="waves" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
							viewBox="0 24 150 28" preserveAspectRatio="none" shape-rendering="auto">
							<defs>
							<path id="gentle-wave" d="M-160 44c30 0 58-18 88-18s 58 18 88 18 58-18 88-18 58 18 88 18 v44h-352z" />
							</defs>
								<g class="parallax">
								<use xlink:href="#gentle-wave" x="48" y="0" fill="rgba(255,255,255,0.7" />
								<use xlink:href="#gentle-wave" x="48" y="3" fill="rgba(255,255,255,0.5)" />
								<use xlink:href="#gentle-wave" x="48" y="7" fill="#fff" />
								</g>
							</svg>
						</div><!--파도 end-->
			</div><!--header end-->
			
			<div class="modalBody">
				<form action="modifyTodo" method="post">
					<input type="hidden" value="${_csrf.token}" name="${_csrf.parameterName}">
					<input type="hidden" name="tdNum" class="tdNum">
					<div class="modifyTodoInputWrap">
						<div class="row">
							<h4>할 일 이름</h4>
							<div>
								<input type="text" placeholder="할 일 이름" name="tdTitle" style="width:409px" id="tdTitle">
							</div>
						</div>
						<div class="row">
							<h4>할 일 내용</h4>
							<div>								
								<input type="text" placeholder="무슨 일을 해야하나요?" name="tdContent" style="width:409px" id="tdContent">
							</div>
						</div>
						<div class="row">
							<h4>할 일 기간</h4>
							<div id="modifyTodo-Date">
								<input type="date" name="startDate" placeholder="시작일을 입력하세요" id="tdStartDate"> ~ 
								<input type="date" name="endDate" placeholder="종료일을 입력하세요" id="tdEndDate">
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