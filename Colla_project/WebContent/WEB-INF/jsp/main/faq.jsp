<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>

<meta name="viewport" content="width=device-width, initial-scale=1">
<title>FAQ</title>
<link rel="stylesheet" type="text/css" href="css/headerMain.css"/>
<link rel="stylesheet" type="text/css" href="css/footerMain.css"/>
<link rel="stylesheet" type="text/css" href="css/main.css"/>
<script>  
$(function() {
	$(".FAQ-box").click(function() {
		if($(this).children(".answer").css("display")=="none") { //열기
			$(this).children(".answer").css({display : 'block', color : 'blue'}); //해당 답변창 열기
			$(this).css({height : 'auto', 'background-color' : '#10344a'}); //박스 크기 늘리기
			$(this).children(".question").css({color : 'white'}); //질문 글씨색 바꾸기
			$(this).children(".question").children(".icon").css({transform:'rotate(180deg)',transition:'all 0.4s'}); //화살표 회전
			
			$(".FAQ-box").not($(this)).css({'background-color' : 'white'}); //다른 박스 색깔 바꾸기
			$(".answer").not($(this).children(".answer")).css({display : 'none'}); //다른 답변창 닫기
			$(".question").not($(this).children(".question")).css({color : 'black'}); //다른 답변창 질문 글씨색 바꾸기
			$(".question").not($(this).children(".question")).children(".icon").css({transform:'rotate(0deg)',transition:'all 0.4s'}); //다른 화살표 회전
			
		} else { //닫기
			$(this).children(".answer").css({display : 'none', color : 'blue'}); //해당 답변창 열기
			$(this).css({'background-color' : 'white'});
			$(this).children(".question").css({color : 'black'}); //질문 글씨색 바꾸기
			$(this).children(".question").children(".icon").css({transform:'rotate(0deg)',transition:'all 0.4s'}); //화살표 회전
		}
	})
	//고객으로부터 이메일 받기
	$("#FAQ-email-Form").on("submit", function(e) {
		e.preventDefault();
		var FAQname = $("#FAQname").val();
		var FAQemail = $("#FAQemail").val();
		var FAQtitle = $("#FAQtitle").val();
		var FAQcontent = $("#FAQcontent").val();
		if (FAQname == "" || FAQemail == "" || FAQtitle == "" || FAQcontent == "") {
			$("#checkSentence").text("빈칸이 있습니다.");
		} else {
			var data = $(this).serialize();
			console.log(data);
			$.ajax({
				url : "sendFAQMail",
				data : data,
				type : "post",
				dataType : "json",
				success : function(result) {
					if (result) {
						alert("빠른 시일 내로 답변 드리겠습니다.");
						$("#FAQname").val("");
						$("#FAQemail").val("");
						$("#FAQtitle").val("");
						$("#FAQcontent").val("");
					} else { //이메일 중복 아님
						alert("전송에 실패하였습니다.");
					}
				}
			}); //end ajax 
		}
		return false;
	})
});
</script>  
</head>
<body>
	<div id="wrap">
		<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
		<div id="faqAll">
			<section id="">
				<div id="container">
					<div class="head-title" lang="en"> FAQ </div>
					<div class="head-body"> Frequently Asked Questions <br></div>
					<div class="head-caption"> 궁금하신 게 있으신가요? 친절하게 알려드릴게요. </div>
					<div class="FAQs">
						<div class="FAQs-left">
							<div class="FAQ-box"> <!-- 질문 1개 -->
								<div class="question">
									<div>Q</div>라이선스 기간이 끝났는데 어떻게 해야하나요?<p class="icon"><i class="fas fa-angle-down"></i></p>
								</div> <!-- 제목 -->
								<div class="answer">
									<div class="a">A</div>
									<div class="answer-detail" style="width: 478px;">
									마이페이지의 라이선스 관리 메뉴를 이용하여 라이선스를 구매하실 수 있습니다.
									</div>
								</div> <!-- 내용 -->
							</div>
							<div class="FAQ-box"> <!-- 질문 1개 -->
								<div class="question">
									<div>Q</div>게시판에 공지글을 등록하려면 어떻게 해야하나요?<p class="icon"><i class="fas fa-angle-down"></i></p>
								</div> <!-- 제목 -->
								<div class="answer">
									<div class="a">A</div>
									<div class="answer-detail" style="width: 478px;">
									글쓰기 상단에 게시글 타입을 설정하여 공지글과 익명글, 일반글 로 분류할 수 있습니다.
									</div>
								</div> <!-- 내용 -->
							</div>
							<div class="FAQ-box"> <!-- 질문 1개 -->
								<div class="question">
									<div>Q</div>캘린더에 새로운 일정은 어떻게 추가하나요?<p class="icon"><i class="fas fa-angle-down"></i></p>
								</div> <!-- 제목 -->
								<div class="answer">
									<div class="a">A</div>
									<div class="answer-detail" style="width: 478px;">
									캘린더 화면의 일정추가 버튼은 물론이고, 달력의 빈곳을 클릭하거나 드래그하여 일정을 추가할 수 있습니다.
									</div>
								</div> <!-- 내용 -->
							</div>
							<div class="FAQ-box"> <!-- 질문 1개 -->
								<div class="question">
									<div>Q</div>다른 OS에서도 구동이 가능한가요?<p class="icon"><i class="fas fa-angle-down"></i></p>
								</div> <!-- 제목 -->
								<div class="answer">
									<div class="a">A</div>
									<div class="answer-detail" style="width: 478px;">
									모든 OS에서 구동할 수 있습니다.
									</div>
								</div> <!-- 내용 -->
							</div>
							<div class="FAQ-box"> <!-- 질문 1개 -->
								<div class="question">
									<div>Q</div>회원 탈퇴는 어디에서 할 수 있나요?<p class="icon"><i class="fas fa-angle-down"></i></p>
								</div> <!-- 제목 -->
								<div class="answer">
									<div class="a">A</div>
									<div class="answer-detail" style="width: 478px;">
									마이페이지의 개인정보 보호 탭으로 이동하여 탈퇴하기 버튼을 누르시면 됩니다.
									</div>
								</div> <!-- 내용 -->
							</div>
						</div>
						<div class="FAQs-right">
							<div class="FAQ-box"> <!-- 질문 1개 -->
								<div class="question">
									<div>Q</div>즐겨찾기를 등록한 채팅은 어떻게 확인하나요?<p class="icon"><i class="fas fa-angle-down"></i></p>
								</div> <!-- 제목 -->
								<div class="answer">
									<div class="a">A</div>
									<div class="answer-detail" style="width: 478px;">
									채팅방 오른쪽의 슬라이드 메뉴를 열어서 즐겨찾기 탭을 선택하시면 됩니다.
									</div>
								</div> 
							</div>
							<div class="FAQ-box"> 
								<div class="question">
									<div>Q</div>라이선스를 중간에 환불받을 수 있나요?<p class="icon"><i class="fas fa-angle-down"></i></p>
								</div> 
								<div class="answer">
									<div class="a">A</div>
									<div class="answer-detail" style="width: 478px;">
									라이선스를 구매한 당일은 100% 환불이 가능하며, 이후 사용일과 잔여일에 따라 삭감 환불이 진행됩니다.
									</div>
								</div> 
							</div>
							<div class="FAQ-box"> 
								<div class="question">
									<div>Q</div>잘못 결제한 라이선스를 취소할 수 있나요?<p class="icon"><i class="fas fa-angle-down"></i></p>
								</div> 
								<div class="answer">
									<div class="a">A</div>
									<div class="answer-detail" style="width: 478px;">
									라이선스를 취소하면 환불절차가 진행됩니다. 라이선스를 구매한 당일은 100% 환불이 가능하며, 이후 사용일과 잔여일에 따라 삭감 환불이 진행됩니다.
									</div>
								</div> 
							</div>
							<div class="FAQ-box"> 
								<div class="question">
									<div>Q</div>한 계정으로 여러 대 PC에서 사용이 가능한가요?<p class="icon"><i class="fas fa-angle-down"></i></p>
								</div> 
								<div class="answer">
									<div class="a">A</div>
									<div class="answer-detail" style="width: 478px;">
									COLLA는 중복로그인을 방지하여 하나의 계정은 한 PC에서만 이용 가능합니다.
									</div>
								</div> 
							</div>
							<div class="FAQ-box"> 
								<div class="question">
									<div>Q</div>워크스페이스에 멤버를 초대하려면 어떻게 하나요?<p class="icon"><i class="fas fa-angle-down"></i></p>
								</div> 
								<div class="answer">
									<div class="a">A</div>
									<div class="answer-detail" style="width: 478px;">
									워크스페이스 메인화면의 회원초대 기능을 이용하여 초대메일을 발송할 수 있습니다.
									</div>
								</div> 
							</div>
						</div>
					</div>
				</div>
			</section>
			<section id="ask">
				<div id="container">
					<div class="head-title" lang="en"> Q&A </div>
<!-- 					<div class="head-body"> Ask By Email <br></div> -->
					<div class="head-caption"> 궁금증이 해결되시지 않으셨나요? 이메일로 답변해드리겠습니다. </div>
					<div class="FAQ-email">
						<form method="post" id="FAQ-email-Form">
							<div class="FAQ-email-name">
								<span>이름</span>
								<input type="text" name="name" id="FAQname">
							</div>
							<div class="FAQ-email-receive">
								<span>답장 받을 이메일</span>
								<input type="text" name="email" id="FAQemail">
							</div>
							<div class="FAQ-email-title">
								<span>제목</span>
								<input type="text" name="title" id="FAQtitle" class="FAQ-email-input">
							</div>
							<div class="FAQ-email-content">
								<span>내용</span>
								<textarea rows="10" cols="80" name="content" id="FAQcontent" class="FAQ-email-content"></textarea>
							</div>
							<div>
								<input type="submit" value="전송" class="FAQ-email-button btn">
								<span id="checkSentence"></span>
							</div>
						</form>
					</div>
				</div>
			</section>
			<div><%@ include file="/WEB-INF/jsp/inc/footerMain.jsp" %></div>
		</div>
	</div>
</body>
</html>