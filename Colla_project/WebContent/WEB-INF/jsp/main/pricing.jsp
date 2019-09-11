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
						<div class="price-each-col" data-plan="1">
							<div class="price-bg personal-color">
								<div class="col-root __prc_pad">
									<div class="price-info">
										<div class="text-container __prc_pad">
											<div class="price-title">Personal</div>  
											<div class="price-desc">비캔버스를 오직 개인용 노트로 사용하고자 하는 개인을 위한 플랜.</div>   
											<div class="price-info-head">
												<div class="price-value-container">
													<div class="price-amount-view">
														<div class="monthly-price month-view">
															<div class="price-currency-unit price-currency">$</div>
															<div class="price-value">4.99</div>
														</div>
														<div class="yearly-price year-view">
														<div class="price-currency-unit price-currency">$</div>
														<div class="price-value">3.99</div>
													</div>
													<div class="price-currency-unit price-per">/ 월</div>  
												</div>
											</div>
										</div>  
										<div class="plan-info-button">   
										<div class="primary-button-container">
											<button class="btn price-btn btn-p-l btn-w main-action-button price-personal-btn" type="button" data-plan="trial" data-name="" data-config="" data-url-month="/upgrade/v2/product/plan_df3a651fa13a79e5746ffabbcef83b253d23f891d13e26e9bc334e0f?locale=ko&amp;utc=1568167113490" data-url-year="/upgrade/v2/product/plan_df3a651fa13a79e5746ffabbcef838253d23f891d13e26e9bc334e0f?locale=ko&amp;utc=1568167113490" data-action="start_trial" data-current="false" data-hidden=""> 무료 평가판 시작 </button>
										</div>    
									</div>  
									<div class="price-item-container">   
										<div class="price-item">
											<svg class="price-check" xmlns="http://www.w3.org/2000/svg" width="16" height="12" viewBox="0 0 16 12">
												<g fill="none" fill-rule="nonzero">
													<path d="M-4-6h24v24H-4z"></path>
													<path fill="#0052E2" d="M14.505 0L16 1.44 5.038 12 0 7.147l1.495-1.44L5.038 9.12z"></path>
												</g>
											</svg>
										<div class="price-item-text"> 멤버 1명 </div>
									</div>  
									<div class="price-item">
										<svg class="price-check" xmlns="http://www.w3.org/2000/svg" width="16" height="12" viewBox="0 0 16 12">
											<g fill="none" fill-rule="nonzero">
												<path d="M-4-6h24v24H-4z"></path>
												<path fill="#0052E2" d="M14.505 0L16 1.44 5.038 12 0 7.147l1.495-1.44L5.038 9.12z"></path>
											</g>
										</svg>
										<div class="price-item-text"> 무제한 캔버스 생성 </div>
									</div>  
									<div class="price-item">
										<svg class="price-check" xmlns="http://www.w3.org/2000/svg" width="16" height="12" viewBox="0 0 16 12">
											<g fill="none" fill-rule="nonzero">
												<path d="M-4-6h24v24H-4z"></path>
												<path fill="#0052E2" d="M14.505 0L16 1.44 5.038 12 0 7.147l1.495-1.44L5.038 9.12z"></path>
											</g>
										</svg>
										<div class="price-item-text"> 100 GB의 저장공간 </div>
									</div>  
									<div class="price-item">
										<svg class="price-check" xmlns="http://www.w3.org/2000/svg" width="16" height="12" viewBox="0 0 16 12">
											<g fill="none" fill-rule="nonzero">
												<path d="M-4-6h24v24H-4z"></path>
												<path fill="#0052E2" d="M14.505 0L16 1.44 5.038 12 0 7.147l1.495-1.44L5.038 9.12z"></path>
											</g>
										</svg>
										<div class="price-item-text"> 화상/음성 회의 (월 180분) </div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
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