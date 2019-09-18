<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
	String contextPath = request.getContextPath();
	request.setAttribute("contextPath", contextPath);
%>
<title>라이선스관리</title>
<link rel="stylesheet" type="text/css" href="css/reset.css"/>
<link rel="stylesheet" type="text/css" href="css/base.css"/>
<link rel="stylesheet" type="text/css" href="css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="css/myPage.css"/>
<script src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous"></script>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp"%>
	<div id="wsBody">
	<input type="hidden" value="mypage" id="pageType">
		<div id="wsBodyContainer">
			<h3>라이선스</h3>
			<h4>라이선스 관리</h4>
			<div class="myPageInner">
				<div class ="myPageAccount">
					<div class="myPageContent">
						<div class="myPageLicense">
							<c:choose>
								<c:when test="${useLicense.endDate eq null }">
									<p><b>${member.name}님</b>, 라이선스 업그레이드를 통해 더 많은 서비스를 받아보세요</p>
									<a href="myPageAccountForm" class="btn">라이선스 보러가기</a>
								</c:when>
								<c:otherwise>
									<p>
										<b>${member.name}님</b>의 라이선스는 <span>${useLicense.endDate }</span> 종료 예정입니다
									</p>
									<a href="myPageAccountForm" class="btn">라이선스 연장</a>
									<a href="myPageAccountForm" class="btn">라이선스 변경</a>
									<div class="lcList">
										<h5>결제 내역</h5>
										<table>
											<tr>
												<td>라이선스 종류</td>
												<td>결제일</td>
												<td>만료일</td>
											</tr>
											<c:forEach items="${licenseList }" var="license">
												<tr>
													<td>${license.type }</td>
													<td>${license.startDate }</td>
													<td>${license.endDate }</td>
												</tr>
											</c:forEach>
										</table>
									</div>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
					</div>
					<div class="row btns btnR">
						<a href="myPageMainForm" class="btn">목록</a>
					</div>
					
				</div><!-- myPageInner -->
			</div>
		</div><!-- end wsBody -->
	</div>
</body>
</html>