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
	var questions = document.getElementsByClassName("question");
	var i;
	for(i=0; i<questions.length; i++) {
	 	questions[i].addEventListener("click", function() {
	 		this.classList.toggle("active"); //클래스가 존재한다면 제거하고 false, 존재하지 않으면 추가하고 true
	 		var answer = this.nextElementSibling;
	 		if (answer.style.maxHeight) { //닫기
	 			answer.style.maxHeight = null;
	 			$(this).children().css({transform:'rotate(0deg)',transition:'all 0.4s'});
	 		} else { //열기
	 		    answer.style.maxHeight = answer.scrollHeight+"px";
	 		   $(this).children().css({transform:'rotate(180deg)',transition:'all 0.4s'});
	 		}
	 	});
	}
});
</script>  
</head>
<body>
	<div id="wrap">
		<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
		<div id="faqAll">
			<section id="">
				<div id="container">
					<div class="head-title"> FAQ </div>
					<div class="head-body"> Frequently Asked Questions <br></div>
					<div class="head-caption"> 궁금하신 게 있으신가요? 친절하게 알려드릴게요. </div>
					<div class="questions">
						<button class="question" id="tmp">질문 1 이건 어떻게 하냐?<p class="icon"><i class="fas fa-angle-down"></i></p></button>
						<div class="answer">
							<p class="answerDetail">답변1...<br>어쩌구<br>어쩌구</p>
						</div>
						<button class="question">질문 2 저건 어떻게 하냐?<p class="icon"><i class="fas fa-angle-down"></i></p></button>
						<div class="answer">
							<p class="answerDetail">답변2...<br>어쩌구<br>어쩌구</p>
						</div>
						<button class="question">질문 3 이건 어떻게 하냐?<p class="icon"><i class="fas fa-angle-down"></i></p></button>
						<div class="answer">
							<p class="answerDetail">답변3...<br>어쩌구<br>어쩌구</p>
						</div>
						<button class="question">질문 4 저건 어떻게 하냐?<p class="icon"><i class="fas fa-angle-down"></i></p></button>
						<div class="answer">
							<p class="answerDetail">답변4...<br>어쩌구<br>어쩌구</p>
						</div>
						<button class="question">질문 5 이건 어떻게 하냐?<p class="icon"><i class="fas fa-angle-down"></i></p></button>
						<div class="answer">
							<p class="answerDetail">답변5...<br>어쩌구<br>어쩌구</p>
						</div>
					</div>
				</div>
			</section>
		</div>
		<%@ include file="/WEB-INF/jsp/inc/footerMain.jsp" %>
	</div>
</body>
</html>