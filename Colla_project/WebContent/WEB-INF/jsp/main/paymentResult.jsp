<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>

<title>Payment</title>
<link rel="stylesheet" type="text/css" href="${contextPath }/css/headerMain.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath }/css/footerMain.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath }/css/main.css"/>
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
</head>
<body>
	<div id="wrap">
		<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
		<section id="paymentAll">
			<div id="container">
				<h1>카카오 페이 결제가 정상적으로 완료되었습니다!</h1>
				<p id="paymentInfo"></p>
				<div>
					<p>결제일시 : ${param.approved_at }</p>
					<p>주문번호 : ${param.partner_order_id }</p>
					<p>상품명 : ${param.item_name}</p>
					<p>결제금액 : ${param.total }</p>
					<p>결제방법 : ${param.payment_method_type}</p>
				
				</div>
			</div>
		</section>
		
		<div class="box"><%@ include file="/WEB-INF/jsp/inc/footerMain.jsp" %></div>
	</div>
</body>
</html>