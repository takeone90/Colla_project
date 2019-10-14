<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<title>Payment</title>
<link rel="stylesheet" type="text/css" href="${contextPath }/css/headerMain.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath }/css/footerMain.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath }/css/main.css"/>
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
</head>

<script>
	var tmpToday = null;
	$(function(){
		$("#startDate").val(new Date().toISOString().substring(0,10)); //시작일을 오늘날짜로 셋팅
		var tmpEndDate = new Date($("#startDate").val()); //시작일을 기준으로
		var tmpEndDateVal = tmpEndDate.getDate(); //날짜를 받아오고
		tmpEndDate.setDate(tmpEndDateVal+30);//+30일 한 값을 다시 셋팅 해준 뒤 
		$("#endDate").val(tmpEndDate.toISOString().substring(0,10)); //종료일 영역에 셋팅 해준다
		tmpToday = new Date().setHours(0,0,0,0); //시작일과 비교할 오늘날짜 셋팅
		
		//시작일이 변경되면 종료일도 자동으로 변경한다
		$("#startDate").on("change",function(){
			var changeDate = new Date($("#startDate").val());
			var tmpDate = new Date(changeDate).setHours(0,0,0,0);//비교할 데이터값 셋팅

			if(tmpDate < tmpToday){
				$("#checkDateText").text("시작일을 오늘 이후로 설정해주세요");
			}else{
				$("#checkDateText").text("");
			}
			changeDate.setDate(changeDate.getDate()+30);
			$("#endDate").val(changeDate.toISOString().substring(0,10));
		});
		
		//종료일이 변경되면 시작일도 자동으로 변경한다
		$("#endDate").on("change",function(){
			var changeDate = new Date($("#endDate").val());
			changeDate.setDate(changeDate.getDate()-30);
			$("#startDate").val(changeDate.toISOString().substring(0,10));
			var tmpDate = new Date($("#startDate").val()).setHours(0,0,0,0);
			if(tmpDate < tmpToday){
				$("#checkDateText").text("시작일을 오늘 이후로 설정해주세요");
			}else{
				$("#checkDateText").text("");
			}
		});
		
		//선택한 타입에 따른 라이선스 정보 보여주기
		showInfo();
		$("#typeSelect").on("change",function(){
			showInfo();
		})
		//
		$("#name").on("blur", function() {
			nameReg();
		});
		$("#phone").on("blur", function() {
			phoneReg();
		});
		$("#checkbox").on("change", function() {
			checkBox();
		});
	    $( ".datepicker" ).datepicker({
	    	dateFormat: 'yy-mm-dd',
	        changeMonth: true,
	        changeYear: true
	    });
		
	});//end onload

var msg = "${param.msg}";
if(msg=="cancel" || msg == "fail"){
	window.close();
}

function dataFunction(info,tmpDateStr){
	$("#total").val(info.amount.total);
	$("#partner_order_id").val(info.partner_order_id);
	$("#approved_at").val(tmpDateStr);
	$("#item_name").val(info.item_name);
	$("#payment_method_type").val(info.payment_method_type);
	$("#resultForm").submit();		
}
			
function openNewWin(){
	var nameResult = nameReg();
	var phoneResult = phoneReg();
	var checkBoxResult = checkBox();
	var startDateResult = startDateCheck();
	if(nameResult&&phoneResult&&checkBoxResult&&startDateResult){
		frm = document.getElementById("kakaoPayForm");
		var data = $(this).serialize();
		window.open('', 'viewer', 'width=450, height=600');
		frm.action = "${contextPath }/payment/kakaoPay";
		frm.data = data;
		frm.target = "viewer";
		frm.method = "post";
		frm.submit();	
	}else{
		return false;
	}	
}

//선택한 라이선스에 따라 정보 보여주기
function showInfo(){
	var tmpType = $("#typeSelect").val();
	if(tmpType == 'Personal'){
		$("#amount").val(10000);
		$(".personalInfo").css({visibility:"visible"});
		$(".businessInfo").css({visibility:"hidden"});
		$(".enterpriseInfo").css({visibility:"hidden"});
	}else if(tmpType == 'Business'){
		$("#amount").val(50000);
		$(".businessInfo").css({visibility:"visible"});
		$(".personalInfo").css({visibility:"hidden"});
		$(".enterpriseInfo").css({visibility:"hidden"});
	}else if(tmpType == 'Enterprise'){
		$("#amount").val(100000);
		$(".enterpriseInfo").css({visibility:"visible"});
		$(".personalInfo").css({visibility:"hidden"});
		$(".businessInfo").css({visibility:"hidden"});
	}
}

//이름, 핸드폰번호, 이용약관 빈칸 입력시	 
function nameReg() {
	var name = $("#name").val();
	if (name == "") {
		$("#checkNameText").text("이름을 입력해주세요.");
		return false;
	}else {
		$("#checkNameText").text("");
		return true;
	}
}

function phoneReg() {
	var phone = $("#phone").val();
	if (phone == "") {
		$("#checkPhoneText").text("핸드폰번호를 입력해주세요.");
		return false;
	}else {
		$("#checkPhoneText").text("");
		return true;
	}
}

function checkBox() {
	var result = $("#checkbox").is(":checked");
	if (!result) {
		$("#checkboxText").text("이용약관은 필수입니다.");
		return false;
	}else {
		$("#checkboxText").text("");
		return true;
	}
}

//시작일이 오늘 이전인 경우  체크
function startDateCheck(){
	var startDate = new Date($("#startDate").val());
	var tmpDate = new Date(startDate).setHours(0,0,0,0);
	if(tmpDate < tmpToday){
		return false;
	}else{
		return true;
	}
}

</script>
<body>
	<div id="wrap">
		<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
		<div>
			<section id="paymentAll">
				<div id="container" class="clearFix">
					<h1>COLLA 서비스를 이용해보세요</h1>
					<form id="kakaoPayForm" onsubmit="return false;">
						<input type="hidden" name="num" value="${mNum }">
						<input type="hidden" name="amount" id="amount">
						<h4>라이선스 정보</h4>
						<select id="typeSelect" name="type">
							<option value="Personal" <c:if test="${type eq 'Personal'}">selected="selected"</c:if>>Personal</option>
							<option value="Business" <c:if test="${type eq 'Business'}">selected="selected"</c:if>>Business</option>
							<option value="Enterprise" <c:if test="${type eq 'Enterprise'}">selected="selected"</c:if>>Enterprise</option>
						</select>
						<p>라이센스 이용기간을 설정해주세요<span> (시작일 기준으로 30일  자동 설정됩니다)</span></p>
						<input type="text" id="startDate" name="startDate" class="datepicker"> ~ <input type="text" id="endDate" name="endDate" class="datepicker">
						<br><span id="checkDateText" class="checkText"></span>
						<h4>주문자 정보</h4>
						<p>이름 <span id="checkNameText" class="checkText"></span></p>
						<input type="text" id="name" name="name" value="${member.name}">
						<p>핸드폰번호 <span id="checkPhoneText" class="checkText"></span></p>
						<input type="text" id="phone" name="phone" value="${member.phone}">
						<span id="checkPhoneText"></span>
						<h4>결제 정보</h4>
						<input type="radio" name="payment" value="kakaoPay" id="kakaoPay" checked="checked">
						<label for="kakaoPay"><img src="${contextPath }/img/kakao_payment.png"></label>
						<input type="radio" name="payment" value="naverPay" id="naverPay">
						<label for="naverPay"><img src="${contextPath }/img/naver_payment.png"></label>
						<div class="paymentCheckbox">
							<input type="checkbox" id="checkbox" value="1" class="joinCheckboxInput">COLLA에서 제공하는 서비스 약관에 동의합니다.
							<span id="checkboxText" class="checkText"></span>
						</div>
						<button id="paymentBtn" onclick="openNewWin()">결제하기</button>
					</form>
					<div class="infoArea">
						<div class="licenseInfo personalInfo" class="clearFix">
						<h5>Personal</h5>
						<h5>10,000</h5>
						<ul>
							<li>멤버 1명</li>
							<li>워크스페이스 1개</li>
							<li>프로젝트 1개</li>
							<li>채팅방 1개</li>
						</ul>
					</div>
					<div class="licenseInfo businessInfo" class="clearFix">
						<h5>Business</h5>
						<h5>50,000</h5>
						<ul>
							<li>멤버 10명</li>
							<li>워크스페이스 10개</li>
							<li>프로젝트 10개</li>
							<li>채팅방 10개</li>
						</ul>
					</div>
					<div class="licenseInfo enterpriseInfo" class="clearFix">
						<h5>Enterprise</h5>
						<h5>100,000</h5>
						<ul>
							<li>멤버 무제한</li>
							<li>워크스페이스 무제한</li>
							<li>프로젝트 무제한</li>
							<li>채팅방 무제한</li>
						</ul>
					</div>
						
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