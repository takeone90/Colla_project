<%@page import="org.springframework.web.context.request.SessionScope"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp"%>

<title>pricing</title>
<link rel="stylesheet" type="text/css" href="css/headerMain.css" />
<link rel="stylesheet" type="text/css" href="css/footerMain.css" />
<link rel="stylesheet" type="text/css" href="css/main.css" />
</head>
<script>
	function showPaymentPage(type) {
		var user = $("#user").val();
		var userLicense = $("#userLicense").val();
		if(!user){
			var tmpResult = confirm("로그인 후 사용 가능한 서비스 입니다. 로그인 하시겠습니까?");
			if(tmpResult){
				location.href="${contextPath}/loginForm";	
			}
		}else{
			if(userLicense){
				alert("사용중인 라이선스가 있어 구매가 불가능합니다.");
			}else{
				location.href="${contextPath}/payment/kakaoPay?type="+type;				
			}
		}
	}
</script>
<body>
	<div id="wrap">
		<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp"%>
		<input type="hidden" id="user" value="${sessionScope.user}">
		<input type="hidden" id="userLicense" value="${sessionScope.userLicense}">
		<div id="pricingAll">
			<section id="pricing-head">
				<div id="container">
					<div class="head-title">가격 정책</div>
					<div class="head-body">High Quality At A Reasonable Price.</div>
					<div class="head-caption">오늘부터 합리적인 가격으로 COLLA를 시작해보세요.</div>
					<div class="price-box-inside">
						<div class="price-each-col">
							<div class="price-title">Personal</div>
							<div class="price-desc">
								혼자서 사용하시겠어요?<br>탁월한 선택입니다.
							</div>
							<div class="price-amount-view">
								<div class="price-value">10,000</div>
								<div class="price-unit">/ 월</div>
							</div>
							<div class="price-detail">
								<div>
									<svg class="price-check" xmlns="http://www.w3.org/2000/svg"
										width="16" height="12" viewBox="0 0 16 12">
										<g fill="none" fill-rule="nonzero">
										<path d="M-4-6h24v24H-4z"></path>
										<path fill="#0052E2"
											d="M14.505 0L16 1.44 5.038 12 0 7.147l1.495-1.44L5.038 9.12z"></path></g></svg>
									<div class="price-detail-content">멤버 1명</div>
								</div>
								<div>
									<svg class="price-check" xmlns="http://www.w3.org/2000/svg"
										width="16" height="12" viewBox="0 0 16 12">
										<g fill="none" fill-rule="nonzero">
										<path d="M-4-6h24v24H-4z"></path>
										<path fill="#0052E2"
											d="M14.505 0L16 1.44 5.038 12 0 7.147l1.495-1.44L5.038 9.12z"></path></g></svg>
									<div class="price-detail-content">워크스페이스 1개</div>
								</div>
								<div>
									<svg class="price-check" xmlns="http://www.w3.org/2000/svg"
										width="16" height="12" viewBox="0 0 16 12">
										<g fill="none" fill-rule="nonzero">
										<path d="M-4-6h24v24H-4z"></path>
										<path fill="#0052E2"
											d="M14.505 0L16 1.44 5.038 12 0 7.147l1.495-1.44L5.038 9.12z"></path></g></svg>
									<div class="price-detail-content">채팅방 1개</div>
								</div>
								<div>
									<svg class="price-check" xmlns="http://www.w3.org/2000/svg"
										width="16" height="12" viewBox="0 0 16 12">
										<g fill="none" fill-rule="nonzero">
										<path d="M-4-6h24v24H-4z"></path>
										<path fill="#0052E2"
											d="M14.505 0L16 1.44 5.038 12 0 7.147l1.495-1.44L5.038 9.12z"></path></g></svg>
									<div class="price-detail-content">또 뭐가 있지</div>
								</div>
							</div>
							<div>
								<button class="price-start-button" onclick="showPaymentPage('Personal')">무료 평가판 시작</button>							
							</div>
						</div>

						<div class="price-each-col">
							<div class="price-title">Business</div>
							<div class="price-desc">
								소규모 기업 어쩌구<br>강하게 추천합니다!
							</div>
							<div class="price-amount-view">
								<div class="price-value">50,000</div>
								<div class="price-unit">/ 월</div>
							</div>
							<div class="price-detail">
								<div>
									<svg class="price-check" xmlns="http://www.w3.org/2000/svg"
										width="16" height="12" viewBox="0 0 16 12">
										<g fill="none" fill-rule="nonzero">
										<path d="M-4-6h24v24H-4z"></path>
										<path fill="#0052E2"
											d="M14.505 0L16 1.44 5.038 12 0 7.147l1.495-1.44L5.038 9.12z"></path></g></svg>
									<div class="price-detail-content">멤버 10명</div>
								</div>
								<div>
									<svg class="price-check" xmlns="http://www.w3.org/2000/svg"
										width="16" height="12" viewBox="0 0 16 12">
										<g fill="none" fill-rule="nonzero">
										<path d="M-4-6h24v24H-4z"></path>
										<path fill="#0052E2"
											d="M14.505 0L16 1.44 5.038 12 0 7.147l1.495-1.44L5.038 9.12z"></path></g></svg>
									<div class="price-detail-content">워크스페이스 10개</div>
								</div>
								<div>
									<svg class="price-check" xmlns="http://www.w3.org/2000/svg"
										width="16" height="12" viewBox="0 0 16 12">
										<g fill="none" fill-rule="nonzero">
										<path d="M-4-6h24v24H-4z"></path>
										<path fill="#0052E2"
											d="M14.505 0L16 1.44 5.038 12 0 7.147l1.495-1.44L5.038 9.12z"></path></g></svg>
									<div class="price-detail-content">채팅방 10개</div>
								</div>
								<div>
									<svg class="price-check" xmlns="http://www.w3.org/2000/svg"
										width="16" height="12" viewBox="0 0 16 12">
										<g fill="none" fill-rule="nonzero">
										<path d="M-4-6h24v24H-4z"></path>
										<path fill="#0052E2"
											d="M14.505 0L16 1.44 5.038 12 0 7.147l1.495-1.44L5.038 9.12z"></path></g></svg>
									<div class="price-detail-content">또 뭐가 있지</div>
								</div>
							</div>
							<div>
								<button class="price-start-button" onclick="showPaymentPage('Business')">무료 평가판 시작</button>
							</div>
						</div>

						<div class="price-each-col">
							<div class="price-title">Enterprise</div>
							<div class="price-desc">
								대기업 어쩌구<br>더 큰 성과를 낼 수 있을 거예요!
							</div>
							<div class="price-amount-view">
								<div class="price-value">100,000</div>
								<div class="price-unit">/ 월</div>
							</div>
							<div class="price-detail">
								<div>
									<svg class="price-check" xmlns="http://www.w3.org/2000/svg"
										width="16" height="12" viewBox="0 0 16 12">
										<g fill="none" fill-rule="nonzero">
										<path d="M-4-6h24v24H-4z"></path>
										<path fill="#0052E2"
											d="M14.505 0L16 1.44 5.038 12 0 7.147l1.495-1.44L5.038 9.12z"></path></g></svg>
									<div class="price-detail-content">멤버 무제한</div>
								</div>
								<div>
									<svg class="price-check" xmlns="http://www.w3.org/2000/svg"
										width="16" height="12" viewBox="0 0 16 12">
										<g fill="none" fill-rule="nonzero">
										<path d="M-4-6h24v24H-4z"></path>
										<path fill="#0052E2"
											d="M14.505 0L16 1.44 5.038 12 0 7.147l1.495-1.44L5.038 9.12z"></path></g></svg>
									<div class="price-detail-content">워크스페이스 무제한</div>
								</div>
								<div>
									<svg class="price-check" xmlns="http://www.w3.org/2000/svg"
										width="16" height="12" viewBox="0 0 16 12">
										<g fill="none" fill-rule="nonzero">
										<path d="M-4-6h24v24H-4z"></path>
										<path fill="#0052E2"
											d="M14.505 0L16 1.44 5.038 12 0 7.147l1.495-1.44L5.038 9.12z"></path></g></svg>
									<div class="price-detail-content">채팅방 무제한</div>
								</div>
								<div>
									<svg class="price-check" xmlns="http://www.w3.org/2000/svg"
										width="16" height="12" viewBox="0 0 16 12">
										<g fill="none" fill-rule="nonzero">
										<path d="M-4-6h24v24H-4z"></path>
										<path fill="#0052E2"
											d="M14.505 0L16 1.44 5.038 12 0 7.147l1.495-1.44L5.038 9.12z"></path></g></svg>
									<div class="price-detail-content">또 뭐가 있지</div>
								</div>
							</div>
							<div>
								<button class="price-start-button" onclick="showPaymentPage('Enterprise')">무료 평가판 시작</button>
							</div>
						</div>
					</div>
				</div>
			</section>
		</div>
		<%@ include file="/WEB-INF/jsp/inc/footerMain.jsp"%>
	</div>
</body>
</html>