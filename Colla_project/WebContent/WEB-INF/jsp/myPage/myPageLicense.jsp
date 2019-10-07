<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<title>라이선스관리</title>
<link rel="stylesheet" type="text/css" href="css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="css/myPage.css"/>
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
									<p><b>${member.name}님</b>, 라이선스 업그레이드를 통해 더 많은 서비스를 받아보세요.</p>
									<a href="${contextPath}/pricing" class="btn">라이선스 보러가기</a>
								</c:when>
								<c:otherwise>
									<p>
										<b>${member.name}</b>님, 현재 <span>${useLicense.type }</span>을 이용중입니다.<br>해당 라이선스는 ${useLicense.endDate }</b> 종료 예정입니다.
									</p>
									<a href="${contextPath }/pricing" class="btn">라이선스 보러가기</a>
									<div class="lcList">
										<h5>결제 내역</h5>
										<table>
											<tr>
												<td>주문번호</td>
												<td>주문일</td>
												<td>라이선스</td>
												<td>시작일</td>
												<td>종료일</td>
												<td>결제 금액</td>
												<td>결제 수단</td>
											</tr>
											<c:forEach items="${licenseList }" var="licenseList">
												<tr>
													<td>${licenseList.ORDERID }</td>
													<td><fmt:formatDate value="${licenseList.PAYDATE }" pattern="yyyy-MM-dd"/></td>
													<td>${licenseList.TYPE }</td>
													<td><fmt:formatDate value="${licenseList.STARTDATE }" pattern="yyyy-MM-dd"/></td>
													<td><fmt:formatDate value="${licenseList.ENDDATE }" pattern="yyyy-MM-dd"/></td>
													<td>${licenseList.AMOUNT }</td>
													<td>${licenseList.PAYMETHOD }</td>
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
						<a href="myPageMainForm" class="btn"><i class="fa fa-arrow-left" aria-hidden="true"></i> 이전</a>
					</div>
					
				</div><!-- myPageInner -->
			</div>
		</div><!-- end wsBody -->
	</div>
</body>
</html>