<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FAQ</title>
<link rel="stylesheet" type="text/css" href="css/reset.css"/>
<link rel="stylesheet" type="text/css" href="css/base.css"/>
<link rel="stylesheet" type="text/css" href="css/headerMain.css"/>
<link rel="stylesheet" type="text/css" href="css/footerMain.css"/>
<link rel="stylesheet" type="text/css" href="css/main.css"/>
<script src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous"></script>
<script>  


$(function() {
	var questions = document.getElementsByClassName("question");
	var i;
	for(i=0; i<questions.length; i++) {
	 	questions[i].addEventListener("click", function() {
	 		this.classList.toggle("active");
	 		var answer = this.nextElementSibling;
	 		if (answer.style.display === "block") {
	 			answer.style.display = "none";
	 		} else {
	 		    answer.style.display = "block";
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
						<button class="question">질문 1 이건 어떻게 하냐?</button>
						<div class="answer">
							<p>답변1...<br>어쩌구<br>어쩌구</p>
						</div>
						<button class="question">질문 2 저건 어떻게 하냐?</button>
						<div class="answer">
							<p>답변2...<br>어쩌구<br>어쩌구</p>
						</div>
						<button class="question">질문 3 이건 어떻게 하냐?</button>
						<div class="answer">
							<p>답변3...<br>어쩌구<br>어쩌구</p>
						</div>
						<button class="question">질문 4 저건 어떻게 하냐?</button>
						<div class="answer">
							<p>답변4...<br>어쩌구<br>어쩌구</p>
						</div>
						<button class="question">질문 5 이건 어떻게 하냐?</button>
						<div class="answer">
							<p>답변5...<br>어쩌구<br>어쩌구</p>
						</div>
					</div>
				</div>
			</section>
			
			<section id="">
				<div id="container">
					<h1>질의응답1</h1>
				</div>
			</section>
			
			<section id="">
				<div id="container">
					<h1>질의응답2</h1>
				</div>
			</section>
		</div>
		<%@ include file="/WEB-INF/jsp/inc/footerMain.jsp" %>
	</div>
</body>
</html>