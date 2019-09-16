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
	$('#collaInfo-function1-ani').each(function(){
	var imagePos = $(this).offset().top;
	var topOfWindow = $(window).scrollTop();
		if (imagePos < topOfWindow+500) { /* 숫자가 클수록 빨리 등장 */
			$(this).css({visibility:"visible"});
			$(this).addClass("animated slideInRight");
		}
	});
});
$(window).scroll(function() {
	$('#collaInfo-function2-ani').each(function(){
	var imagePos = $(this).offset().top;
	var topOfWindow = $(window).scrollTop();
		if (imagePos < topOfWindow+500) {
			$(this).css({visibility:"visible"});
			$(this).addClass("animated slideInLeft");
		}
	});
});
$(window).scroll(function() {
	$('#collaInfo-function3-ani').each(function(){
	var imagePos = $(this).offset().top;
	var topOfWindow = $(window).scrollTop();
		if (imagePos < topOfWindow+500) {
			$(this).css({visibility:"visible"});
			$(this).addClass("animated slideInRight");
		}
	});
});
</script>
</head>
<body>
	<div id="wrap">
		<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
		<div id="collaInfoAll">
			<section id="collaInfo-cover">
				<div id="container">
					<div id="collaInfo-cover-ani" class="animated zoomIn">
						<div class="head-title"> COLLAboration </div>
						<div class="head-body">이제 쉽게 공유하고 협업할 수 있습니다.</div>
						<div class="head-caption">COLLA에 어떤 기능들이 있는지 살펴볼까요?</div>
					</div>
				</div>
			</section>
			
			<section id="collaInfo-function1">
				<div id="container">
					<div class="collaInfo-functions">
						<div id="collaInfo-function1-stable">
							<div>그림1</div>
						</div>
						<div id="collaInfo-function1-ani">
							<div class="head-title"> WorkSpace </div>
							<div class="head-body">가볍게 워크 스페이스 생성</div>
						</div>
					</div>
				</div>
			</section>
			
			<section id="collaInfo-function2">
				<div id="container">
					<div class="collaInfo-functions">
						<div id="collaInfo-function2-ani">
							<div class="head-title"> Chatting </div>
							<div class="head-body">워크 스페이스 채팅방에서 원하는 사람들과 채팅</div>
						</div>
						<div id="collaInfo-function2-stable">
							<div>그림2</div>
						</div>
					</div>
				</div>
			</section>
			
			<section id="collaInfo-function3">
				<div id="container">
					<div class="collaInfo-functions">
						<div id="collaInfo-function3-stable">
							<div>그림3</div>
						</div>
						<div id="collaInfo-function3-ani">
							<div class="head-title"> Calendar </div>
							<div class="head-body">팀원들(?)과 일정을 공유하고 관리</div>
						</div>
					</div>
				</div>
			</section>
		</div>
		<%@ include file="/WEB-INF/jsp/inc/footerMain.jsp" %>
	</div>
</body>
</html>