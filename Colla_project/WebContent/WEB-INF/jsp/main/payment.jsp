<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>

<title>Payment</title>
<link rel="stylesheet" type="text/css" href="${contextPath }/css/headerMain.css"/>
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
</head>
<body>
<script>
		var msg = "${param.msg}";
		if(msg=="cancel" || msg == "fail"){
			window.close();
		}
		function dataFunction(info){
			$("#total").val(info.amount.total);
			$("#partner_order_id").val(info.partner_order_id);
			$("#approved_at").val(info.approved_at);
			$("#item_name").val(info.item_name);
			$("#payment_method_type").val(info.payment_method_type);
			$("#resultForm").submit();
			
		}
		function openNewWin(){
			frm = document.getElementById("kakaoPayForm");
			window.open('', 'viewer', 'width=450, height=600');
			frm.action = "${contextPath }/payment/kakaoPay";
			frm.target = "viewer";
			frm.method = "post";
			frm.submit();
		}
</script>
	<div id="wrap">
		<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
		<section id="main-cover">
			<div id="container">
				<h1>카카오 페이</h1>
				<form id="kakaoPayForm">
					<button onclick="openNewWin();">카카오페이로 결제하기</button>
				</form>
				<form action="result" id="resultForm" method="post">
					<input type="hidden" name="total" id="total">
					<input type="hidden" name="partner_order_id" id="partner_order_id">
					<input type="hidden" name="approved_at" id="approved_at">
					<input type="hidden" name="item_name" id="item_name">
					<input type="hidden" name="payment_method_type" id="payment_method_type">
				</form>
			</div>
		</section>
		
		<%@ include file="/WEB-INF/jsp/inc/footerMain.jsp" %>
	</div>
</body>
</html>