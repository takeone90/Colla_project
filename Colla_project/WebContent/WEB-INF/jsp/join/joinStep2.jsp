<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>

<title>joinStep2</title>
<link rel="stylesheet" type="text/css" href="css/headerMain.css"/>
<link rel="stylesheet" type="text/css" href="css/join.css" />
<script type="text/javascript">
$(function() {
	$("#verifyCodeForm").on("submit", function() {
		var data = $(this).serialize(); 
		$.ajax({
			url: "checkVerifyCode",
			data: data,
			type: "post",
			dataType: "json",
			success: function(result) {
				if(result) {
					//joinStep3 으로 이동하는 동작이 여기서 발생해야된다.
					location.href="${contextPath}/joinStep3";
				} else {
					$("#checkSentence").text("인증 코드가 일치하지 않습니다.");
				}
			}
		}); //end ajax 
		return false;
	})
}); //end onload
</script>
</head>
<body>
	<div id="wrap">
	<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
		<div id="joinAll">
			<section>
				<div id="joinBox" class="animated fadeIn">
					<!-- 파도 효과 시작 -->
					<div class="header">
						<!--파도 위 내용-->
						<div class="inner-header flex">
							<g><path fill="#fff"
							d="M250.4,0.8C112.7,0.8,1,112.4,1,250.2c0,137.7,111.7,249.4,249.4,249.4c137.7,0,249.4-111.7,249.4-249.4
							C499.8,112.4,388.1,0.8,250.4,0.8z M383.8,326.3c-62,0-101.4-14.1-117.6-46.3c-17.1-34.1-2.3-75.4,13.2-104.1
							c-22.4,3-38.4,9.2-47.8,18.3c-11.2,10.9-13.6,26.7-16.3,45c-3.1,20.8-6.6,44.4-25.3,62.4c-19.8,19.1-51.6,26.9-100.2,24.6l1.8-39.7		
							c35.9,1.6,59.7-2.9,70.8-13.6c8.9-8.6,11.1-22.9,13.5-39.6c6.3-42,14.8-99.4,141.4-99.4h41L333,166c-12.6,16-45.4,68.2-31.2,96.2	
							c9.2,18.3,41.5,25.6,91.2,24.2l1.1,39.8C390.5,326.2,387.1,326.3,383.8,326.3z" /></g>
							</svg>
							<div class="joinBox-Head">			
								<h3 style='font-weight: bolder; font-size: 30px'>회원가입</h3>
									<p>
										<i class="fas fa-circle" style="color: #DDB4AB"></i>&nbsp;&nbsp;
										<i class="fas fa-circle" style="color: #DA574E"></i>&nbsp;&nbsp;
										<i class="fas fa-circle" style="color: #DDB4AB"></i>
									</p>
							</div>
						</div>			
						<!--파도 시작-->
						<div>
							<svg class="waves" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
							viewBox="0 24 150 28" preserveAspectRatio="none" shape-rendering="auto">
							<defs>
							<path id="gentle-wave" d="M-160 44c30 0 58-18 88-18s 58 18 88 18 58-18 88-18 58 18 88 18 v44h-352z" />
							</defs>
								<g class="parallax">
								<use xlink:href="#gentle-wave" x="48" y="0" fill="rgba(255,255,255,0.7" />
								<use xlink:href="#gentle-wave" x="48" y="3" fill="rgba(255,255,255,0.5)" />
								<use xlink:href="#gentle-wave" x="48" y="7" fill="#fff" />
								</g>
							</svg>
						</div><!--파도 end-->
					</div><!--header end-->		
					<!--파도 아래 내용-->	
					<div class="content flex">				
						<div class="joinBox-Body">
							<form action="" method="post" id="verifyCodeForm">
								<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
								<div>
									<h4>인증 코드 입력</h4>
									<input type="text" name="inputVerifyCode" placeholder="인증 코드를 입력해주세요.">
									<span id="checkSentence"></span>
								</div>
								<%-- <input type="hidden" name="emailAddress" value="${param.emailAddress}"> --%>
								<div>
									<input type="button" onclick="location.href='resendVerifyMail'" value="인증 코드 재발송" class="joinFormButton">
								</div>
								<div>
									<input type="submit" value="다음단계" class="joinFormButton">
								</div>
							</form>
							<div>
								<span id="verifyResultText">
									<c:if test='${param.joinStep2 eq "false"}'>
										인증 코드가 일치하지 않습니다.
									</c:if>
								</span>
							</div>
						</div>			
					</div><!--Content ends-->
				</div>				
			</section>
		</div>
	</div> 	
</body>
</html>


<!-- 				<div class="joinBox"> -->
<!-- 					<div class="joinBox-Head"> -->
<!-- 						<h3 style='font-weight: bolder; font-size: 30px'>회원가입</h3> -->
<!-- 						<p> -->
<!-- 							<i class="fas fa-circle" style="color: #DDB4AB"></i>&nbsp;&nbsp; -->
<!-- 							<i class="fas fa-circle" style="color: #DA574E"></i>&nbsp;&nbsp; -->
<!-- 							<i class="fas fa-circle" style="color: #DDB4AB"></i> -->
<!-- 						</p> -->
<!-- 					</div> -->
<!-- 					<div class="joinBox-Body"> -->
<!-- 						<form action="" method="post" id="verifyCodeForm"> -->
<%-- 							<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"> --%>
<!-- 							<div> -->
<!-- 								<h4>인증 코드 입력</h4> -->
<!-- 								<input type="text" name="inputVerifyCode" placeholder="인증 코드를 입력해주세요."> -->
<!-- 								<span id="checkSentence"></span> -->
<!-- 							</div> -->
<%-- 							<input type="hidden" name="emailAddress" value="${param.emailAddress}"> --%>
<!-- 							<div> -->
<!-- 								<input type="button" onclick="location.href='resendVerifyMail'" value="인증 코드 재발송"> -->
<!-- 							</div> -->
<!-- 							<div> -->
<!-- 								<input type="submit" value="다음단계"> -->
<!-- 							</div> -->
<!-- 						</form> -->
<!-- 						<div> -->
<!-- 							<span id="verifyResultText"> -->
<%-- 								<c:if test='${param.joinStep2 eq "false"}'> --%>
<!-- 									인증 코드가 일치하지 않습니다. -->
<%-- 								</c:if> --%>
<!-- 							</span> -->
<!-- 						</div> -->
<!-- 					</div> -->
<!-- 				</div>	 -->