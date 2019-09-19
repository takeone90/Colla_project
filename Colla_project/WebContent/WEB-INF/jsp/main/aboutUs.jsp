<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>aboutUs</title>
<link rel="stylesheet" type="text/css" href="css/reset.css"/>
<link rel="stylesheet" type="text/css" href="css/base.css"/>
<link rel="stylesheet" type="text/css" href="css/headerMain.css"/>
<link rel="stylesheet" type="text/css" href="css/footerMain.css"/>
<link rel="stylesheet" type="text/css" href="css/main.css"/>
<link rel="stylesheet" type="text/css" href="css/animate.css"/>
<link rel="stylesheet" type="text/css" href="css/animationCheatSheet.css"/>
<script src="https://use.fontawesome.com/releases/v5.2.0/js/all.js"></script>
<script src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous"></script>
<script>
$(function() {
	$(".box").each(function() {
		$(this).on("mousewheel DOMMouseScroll", function(e) {
			e.preventDefault();
			var delta = 0;
			if(!event) {
				event = window.event;
			}
			if(event.wheelDelta) {
				delta = event.wheelDelta / 120;
			} else if(event.detail) {
				delta = -event.detail/3;
			}
			var moveTop = null;
			if(delta < 0) { //위에서 아래로
				if($(this).next() != undefined) {
					moveTop = $(this).next().offset().top;
				}
			} else { //아래서 위로
				if($(this).index() > 0) {
					if($(this).prev() != undefined) {
						moveTop = $(this).prev().offset().top;
					}
				} else  { //헤더 보이기
					moveTop = 0;
				}
			}
			$("html, body").stop().animate({
				scrollTop: moveTop + 'px'
			}, {
				duration: 800, complete: function () {
				}
			});
		})
	})
});
</script>
</head>
<body>
	<div id="wrap" >
		<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
		<div id="aboutUsAll">
			<section id="aboutUs-cover" class="box">
				<div id="container">
					<div id="head-all" class="animated infinite pulse">
						<div class="head-title"> TEAM NEVER LOSE </div>
						<div class="head-body"> Best Team In My Life <br>
						BLAH BLAH BLAH BLAH BLAH </div>
						<div class="head-caption"> 우리는 이런 팀 저런 팀 어떤 팀 </div>
					</div>
				</div>
			</section>
			<section id="aboutUs-member1" class="box">
				<div class="container">
					<div class="aboutUs-card">
						<div class="front card">
						 	이태권은
						 </div>
						<div class="back card">
							조장이다.
						</div>
					</div>
				</div>
			</section>
			<section id="aboutUs-member2" class="box">
				<div id="container">
					<div class="aboutUs-card">
						<div>김미경은</div>
						<div>은 팀원이다</div>
					</div>
				</div>
			</section>
			<section id="aboutUs-member3" class="box">
				<div id="container">
					<div class="aboutUs-card">
						<div>김수빈은</div>
						<div>은 팀원이다</div>
					</div>
				</div>
			</section>
			<section id="aboutUs-member4" class="box">
				<div id="container">
					<div class="aboutUs-card">
						<div>박혜선은</div>
						<div>은 팀원이다</div>
					</div>
				</div>
			</section>
			<div class="box"><%@ include file="/WEB-INF/jsp/inc/footerMain.jsp" %></div>
		</div>
		
	</div>
</body>
</html>