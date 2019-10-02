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
$(function(){
	//결제 금액 세자리마다 콤마 찍기
	var itemAmountVal = $("#itemAmount").text();
	var itemAmount = itemAmountVal.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	$("#itemAmount").text(itemAmount);
})//end onload function

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
						<div>
							<p>주문번호</p>
							<p>${param.partner_order_id }</p>
						</div>
						<div>
							<p>결제일</p>
							<p>${param.approved_at }</p>
						</div>

						<div>
							<p>상품명</p>
							<p>${param.item_name}</p>
						</div>
						<div>
							<p>결제금액</p>
							<p><span id="itemAmount">${param.total }</span> 원</p>
						</div>
						<div>
							<p>결제방법</p>
							<p>${param.payment_method_type}</p>
						</div>
					</div><!-- end paymentSuccessInfo -->
				</div>
			</section>
			<div class="box"><%@ include file="/WEB-INF/jsp/inc/footerMain.jsp"%></div>
		</div>
	</div>
</body>
</html>