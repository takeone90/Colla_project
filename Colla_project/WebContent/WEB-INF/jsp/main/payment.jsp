<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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
		showInfo();
		$("#typeSelect").on("change",function(){
			showInfo();
			
		})
	});//end onload
	

		/* 
		$("#kakaoPayForm").on("submit"(function(){
			var tmpCheckBox = checkBox();
			if(true){
				alert("약관 동의는 필수 입니다.");
				$("#checkboxText").text("약관 동의는 필수입니다.");
				return false;
			}
// 			else{
// 				frm = document.getElementById("kakaoPayForm");
// 				var data = $(this).serialize();
// 				window.open('', 'viewer', 'width=450, height=600');
// 				frm.action = "${contextPath }/payment/kakaoPay";
// 				frm.data = data;
// 				frm.target = "viewer";
// 				frm.method = "post";
// 				frm.submit();
// 			}
			return false;
		});
		 */
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
	var nameResult = nameReg();
	var phoneResult = phoneReg();
	var checkBoxResult = checkBox();
	if(nameResult&&phoneResult&&checkBoxResult){
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
		return true;
	}
}

function phoneReg() {
	var phone = $("#phone").val();
	if (phone == "") {
		$("#checkPhoneText").text("핸드폰번호를 입력해주세요.");
		return false;
	}else {
			return true;
	}
}

function checkBox() {
	var result = $("#checkbox").is(":checked");
	if (!result) {
		$("#checkboxText").text("이용약관은 필수입니다.");
		return false;
	}else {
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
						<input type="hidden" name="mNum" value="${mNum }">
						<input type="hidden" name="amount" id="amount">
						<h4>라이선스 정보</h4>
						<select id="typeSelect" name="type">
							<option value="Personal" <c:if test="${type eq 'Personal'}">selected="selected"</c:if>>Personal</option>
							<option value="Business" <c:if test="${type eq 'Business'}">selected="selected"</c:if>>Business</option>
							<option value="Enterprise" <c:if test="${type eq 'Enterprise'}">selected="selected"</c:if>>Enterprise</option>
						</select>
						<p>라이센스 이용기간을 설정해주세요<span> (시작일 기준으로 30일  자동 설정됩니다)</span></p>
						<input type="date" id="startDate" name="startDate"> ~ <input type="date" id="endDate" name="endDate" readonly="readonly">
						
						<h4>주문자 정보</h4>
						<p>이름 <span id="checkNameText" class="checkText"></span></p>
						<input type="text" id="name" name="name" value="${name}">
						<p>핸드폰번호 <span id="checkPhoneText" class="checkText"></span></p>
						<input type="text" id="phone" name="phone" value="${phone}">
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
							<li>채팅방 1개</li>
							<li> 또 뭐가 있지</li>
							<li> 또 뭐가 있지</li>
						</ul>
					</div>
					<div class="licenseInfo businessInfo" class="clearFix">
						<h5>Business</h5>
						<h5>50,000</h5>
						<ul>
							<li>멤버 1명</li>
							<li>워크스페이스 1개</li>
							<li>채팅방 1개</li>
							<li> 또 뭐가 있지</li>
							<li> 또 뭐가 있지</li>
						</ul>
					</div>
					<div class="licenseInfo enterpriseInfo" class="clearFix">
						<h5>Enterprise</h5>
						<h5>100,000</h5>
						<ul>
							<li>멤버 1명</li>
							<li>워크스페이스 1개</li>
							<li>채팅방 1개</li>
							<li> 또 뭐가 있지</li>
							<li> 또 뭐가 있지</li>
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