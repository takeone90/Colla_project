<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>pricing</title>
<link rel="stylesheet" type="text/css" href="css/reset.css"/>
<link rel="stylesheet" type="text/css" href="css/base.css"/>
<link rel="stylesheet" type="text/css" href="css/headerMain.css"/>
<link rel="stylesheet" type="text/css" href="css/footerMain.css"/>
<link rel="stylesheet" type="text/css" href="css/main.css"/>
<script src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous"></script>
</head>
<body>
	<div id="wrap">
		<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
		<div id="pricingAll">
			<section id="pricing-head">
				<div id="container">
					<div class="head-title"> 가격 정책 </div>
					<div class="head-body">Work.<br>
					With Your Coworkers.<br>
					COLLA will provide the best service.</div>
					<div class="head-caption">오늘부터 합리적인 가격으로 COLLA를 시작해보세요.</div>
					<div class="box-inside">
						<div class="price-each-col">
							<div class="price-title">Personal</div>
							<div class="price-desc">혼자서 사용하시겠어요?<br>탁월한 선택입니다.<br><br></div>
							<div class="price-amount-view">
								<div class="monthly-price month-view">
									<div class="price-value">10000</div>
								</div>
								<div class="price-currency-unit price-per">/ 월</div>
							</div>
						</div>
						<div class="price-each-col">
							<div class="price-title">Personal</div>
							<div class="price-desc">혼자서 사용하시겠어요?<br>탁월한 선택입니다.</div>  
						</div>
						<div class="price-each-col">
							<div class="price-title">Personal</div>
							<div class="price-desc">혼자서 사용하시겠어요?<br>탁월한 선택입니다.</div>  
						</div>
					</div>	
				</div>
								
			</section>
			
			<section id="">
				<div id="container">
					<h1>가격 정책2</h1>
				</div>
			</section>
			
			<section id="">
				<div id="container">
					<h1>가격 정책3</h1>
				</div>
			</section>
		</div>
		<%@ include file="/WEB-INF/jsp/inc/footerMain.jsp" %>
	</div>
</body>
</html>