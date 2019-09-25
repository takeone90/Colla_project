<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>

<title>Payment</title>
<link rel="stylesheet" type="text/css" href="${contextPath }/css/headerMain.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath }/css/footerMain.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath }/css/main.css"/>
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
</head>

<script>
	$(function(){
		$("#startDate").val(new Date().toISOString().substring(0,10)); //시작일을 오늘날짜로 셋팅
		var tmpEndDate = new Date($("#startDate").val());
		var tmpEndMonth = tmpEndDate.getMonth();
		tmpEndDate.setMonth(tmpEndMonth+1);
		$("#endDate").val(tmpEndDate.toISOString().substring(0,10));
		$("#startDate").on("change",function(){//시작일이 변경되면 종료일도 자동으로 변경한다
			var tmpDate = new Date($("#startDate").val());
			var tmpMonth = tmpDate.getMonth();
			tmpDate.setMonth(tmpMonth+1);
			$("#endDate").val(tmpDate.toISOString().substring(0,10));
		});//end startDate change
	});//end onload
	
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
			var data = $(this).serialize();
			window.open('', 'viewer', 'width=450, height=600');
			frm.action = "${contextPath }/payment/kakaoPay";
			frm.data = data;
			frm.target = "viewer";
			frm.method = "post";
			frm.submit();
		}
</script>
<body>
	<div id="wrap">
		<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
		<div>
			<section id="paymentAll">
				<div id="container">
					<h1>COLLA 서비스를 이용해보세요</h1>
					<form id="kakaoPayForm">
						<div class="clearFix">
							<div>${type}</div>
							<div>${amount}</div>
						</div>
						<p>라이센스 이용기간을 설정해주세요<span>시작일 기준으로 30일 계산됩니다</span><p>
						<input type="date" id="startDate" name="startDate">
						<input type="date" id="endDate" name="endDate" readonly="readonly">
						<input type="hidden" name="mNum" value="${mNum }">
						<input type="hidden" name="type" value="${type}" readonly="readonly">
						<input type="hidden" name="amount" value="${amount}" readonly="readonly">

						<button onclick="openNewWin();">카카오페이로 결제하기</button>
					</form>
					<div id="licenseInfo">
						라이센스 정보를 뿌려줌
						라이센스 정보를 뿌려줌
						라이센스 정보를 뿌려줌
						라이센스 정보를 뿌려줌
					</div>
					<form action="result" id="resultForm" method="post">
						<input type="hidden" name="total" id="total">
						<input type="hidden" name="partner_order_id" id="partner_order_id">
						<input type="hidden" name="approved_at" id="approved_at">
						<input type="hidden" name="item_name" id="item_name">
						<input type="hidden" name="payment_method_type" id="payment_method_type">
					</form>
				</div>
			</section>
			<div class="box"><%@ include file="/WEB-INF/jsp/inc/footerMain.jsp" %></div>
		</div>
	</div>
</body>
</html>