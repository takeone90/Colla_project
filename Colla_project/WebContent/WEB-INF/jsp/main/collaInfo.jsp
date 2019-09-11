<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>collaInfo</title>
<link rel="stylesheet" type="text/css" href="css/reset.css"/>
<link rel="stylesheet" type="text/css" href="css/base.css"/>
<link rel="stylesheet" type="text/css" href="css/headerMain.css"/>
<link rel="stylesheet" type="text/css" href="css/footerMain.css"/>
<link rel="stylesheet" type="text/css" href="css/main.css"/>
<link rel="stylesheet" type="text/css" href="css/animate.css"/>
<link rel="stylesheet" type="text/css" href="css/animationCheatSheet.css"/>
<script src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous"></script>
<script type="text/javascript">
$(window).scroll(function() {
	$('#tmp').each(function(){
	var imagePos = $(this).offset().top;
	var topOfWindow = $(window).scrollTop();
		if (imagePos < topOfWindow+200) {
			$(this).addClass("slideUp");
		}
	});
});
$('#tmp').click(function() {
	$(this).addClass("slideUp");
});
</script>
</head>
<body>
	<div id="wrap">
		<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
		<div id="collaInfoAll">
			<section id="">
				<div id="container">
					<div id="tmp" class="slideUp">
					<div class="head-title"> COLLA </div>
					<div class="head-body">Work.<br>
					With Your Coworkers.<br>
					COLLA will provide the best service.</div>
					<div class="head-caption">COLLA에 어떤 기능들이 있는지 살펴볼까요?</div>
					</div>
				</div>
			</section>
			
			<section id="">
				<div id="container">
					<h1>콜라 기능 소개2</h1>
				</div>
			</section>
			
			<section id="">
				<div id="container">
					<h1>콜라 기능 소개3</h1>
				</div>
			</section>
		</div>
		<%@ include file="/WEB-INF/jsp/inc/footerMain.jsp" %>
	</div>
</body>
</html>