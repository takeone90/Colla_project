<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<title>Payment</title>
<link rel="stylesheet" type="text/css"
	href="${contextPath }/css/headerMain.css" />
<link rel="stylesheet" type="text/css"
	href="${contextPath }/css/footerMain.css" />
<link rel="stylesheet" type="text/css"
	href="${contextPath }/css/main.css" />
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
</head>

<script>

</script>
<body>
	<div id="wrap">
		<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp"%>
		<div>
			<section id="paymentResult" class="paymentResult">
				<div id="container" class="clearFix">
					<i class="fa fa-gift" aria-hidden="true"></i>
					<h1>
						정상적으로 완료되었습니다!<br> 아래 주문 정보를 다시 한번 확인해주세요.
					</h1>
					<div class="paymentSuccessInfo clearFix">
						<div class="paymentContent">
							<p>결제일시</p>
							<p>주문번호</p>
							<p>상품명</p>
							<p>결제금액</p>
							<p>결제방법</p>
						</div>
						<div class="paymentContent">
							<c:set var="test" value="${param.approved_at }"></c:set>
							<input type ="hidden" id="test" value="${param.approved_at }"/>
<%-- 							<fmt:parseDate type = "both" var = "dateString" value="${param.approved_at }"></fmt:parseDate>
							<fmt:formatDate value="${dateString }" pattern="yyyy.MM.dd HH:mm:ss"/> --%>

							<p id="test">${param.approved_at }</p>
							<p>${param.partner_order_id }</p>
							<p>${param.item_name}</p>
							<p>${param.total }</p>
							<p>${param.payment_method_type}</p>
						</div>
					</div>
				</div>
			</section>
			<div class="box"><%@ include
					file="/WEB-INF/jsp/inc/footerMain.jsp"%></div>
		</div>
	</div>
</body>
</html>