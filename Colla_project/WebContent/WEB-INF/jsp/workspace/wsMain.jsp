<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="<%=request.getContextPath()%>" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<style>

</style>
<script>

</script>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp"%>
	<div id="wsBody">
		<h2>Workspace</h2>
		<h3>Workspace List</h3>
		<ul>
			<li class="ws">
				<h4>
					<a href="chatMain">질수없조프로젝트1</a>
				</h4>
				<div class="wsDetail">
					<div class="wsChatList">
						<p>chat List</p>
						<ul>
							<li>개발팀</li>
							<li>편집팀</li>
							<li>재무팀</li>
						</ul>
					</div>
					<div class="wsMember">
						<p>member List</p>
						<ul>
							<li>이태권</li>
							<li>김미경</li>
							<li>김수빈</li>
							<li>박혜선</li>
						</ul>
					</div>
				</div>
				<div>
					<a href="#">나가기</a>
				</div>
			</li>
		</ul>
		<div>
			<a href="">워크스페이스 추가</a>
		</div>


		<!------------------------------------워크스페이스 추가 모달  --------------------------------------->
		<div id="addWsModal">
			<div class="modalHead">
				<h3>Workspace 만들기</h3>
			</div>
			<div class="modalBody">
				<p>Workspace를 만들고 멤버를 초대하세요</p>
				<form action="addWs" method="post">
					<input type="hidden" value="${_csrf.token}"
						name="${_csrf.parameterName}">
					<div class="addWsInputWrap">
						<div class="row">
							<h4>Workspace 이름</h4>
							<div>
								<input type="text" placeholder="workspace이름">
							</div>
						</div>
						<div class="row">
							<h4>멤버 초대</h4>
							<div>
								<input type="text" placeholder="초대할멤버1">
							</div>
							<div>
								<input type="text" placeholder="초대할멤버2">
							</div>
							<div>
								<a href="#">멤버추가버튼</a>
							</div>
						</div>
					</div> <!-- end addWsInputWrap -->

					<div>
						<button>workspace만들기</button>
						<button>닫기</button>
					</div>
				</form>
			</div> <!-- end modalBody -->
		</div><!-- end addWsModal -->
	</div><!-- end wsBody -->
	
	
	
	
	
<!-- <div class="wrap"> -->
<!--   <label for="modal" class="button">워크스페이스 추가</label> -->
<!-- </div> -->
<!-- <input type="checkbox" id="modal" class="hidden"> -->
<!-- <div class="box_modal"> -->
<!--   <label for="modal" class="closer">x</label> -->
  
<!--   <div id="addWsModal"> -->
<!-- 			<div class="modalHead"> -->
<!-- 				<h3 align="center">Workspace 만들기</h3> -->
<!-- 			</div> -->
<!-- 			<div class="modalBody"> -->
<!-- 				<p align="center">Workspace를 만들고 멤버를 초대하세요</p> -->
<!-- 				<form action="addWs" method="post"> -->
<%-- 					<input type="hidden" value="${_csrf.token}" --%>
<%-- 						name="${_csrf.parameterName}"> --%>
<!-- 					<div class="addWsInputWrap"> -->
<!-- 						<div class="row"> -->
<!-- 							<h4 align="center">Workspace 이름</h4> -->
<!-- 							<div align="center"> -->
<!-- 								<input type="text" placeholder="workspace이름"> -->
<!-- 							</div> -->
<!-- 						</div> -->
<!-- 						<div class="row"> -->
<!-- 							<h4 align="center">멤버 초대</h4> -->
<!-- 							<div align="center"> -->
<!-- 								<input type="text" placeholder="초대할멤버1"> -->
<!-- 							</div> -->
<!-- 							<div align="center"> -->
<!-- 								<input type="text" placeholder="초대할멤버2"> -->
<!-- 							</div> -->
<!-- 							<div align="center"> -->
<!-- 								<a href="#">멤버추가버튼</a> -->
<!-- 							</div> -->
<!-- 						</div> -->
<!-- 					</div> end addWsInputWrap -->

<!-- 					<div align="center"> -->
<!-- 						<button>workspace만들기</button> -->
<!-- 						<button>닫기</button> -->
<!-- 					</div>  -->
<!-- 				</form> -->
<!-- 			</div>end modalBody -->
<!-- 		</div>end addWsModal -->
  

</body>
</html>