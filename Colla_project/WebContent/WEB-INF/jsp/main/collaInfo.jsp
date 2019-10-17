<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>

<title>collaInfo</title>
<link rel="stylesheet" type="text/css" href="css/headerMain.css"/>
<link rel="stylesheet" type="text/css" href="css/footerMain.css"/>
<link rel="stylesheet" type="text/css" href="css/main.css"/>
<link rel="stylesheet" type="text/css" href="css/animate.css"/>
<link rel="stylesheet" type="text/css" href="css/animationCheatSheet.css"/>
<script type="text/javascript">
//2 섹션 animate
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
//3 섹션 animate
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
//4 섹션 animate
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
//5 섹션 animate
$(window).scroll(function() {
	$('#collaInfo-function4-ani').each(function(){
	var imagePos = $(this).offset().top;
	var topOfWindow = $(window).scrollTop();
		if (imagePos < topOfWindow+500) {
			$(this).css({visibility:"visible"});
			$(this).addClass("animated slideInLeft");
		}
	});
});
//6 섹션 animate
$(window).scroll(function() {
	$('#collaInfo-function5-ani').each(function(){
	var imagePos = $(this).offset().top;
	var topOfWindow = $(window).scrollTop();
		if (imagePos < topOfWindow+500) {
			$(this).css({visibility:"visible"});
			$(this).addClass("animated slideInRight");
		}
	});
});
//섹션 스크롤 이동
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
	<div id="wrap">
		<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
		<div id="collaInfoAll">
			<section id="collaInfo-cover" class="box">
				<div id="container">
					<div id="collaInfo-cover-ani" class="animated zoomIn">
						<div class="head-title" lang="en"><p>COLLA</p><p class="boration">boration</p></div>
						<div class="head-body">이제 쉽게 공유하고 협업할 수 있습니다.</div>
						<div class="head-caption">COLLA에 어떤 기능들이 있는지 살펴볼까요?</div>
						<div class="head-arrow"><i class="fas fa-angle-double-down"></i></div>
					</div>
				</div>
			</section>
			
			<section id="collaInfo-function1" class="box">
				<div id="container">
					<div class="collaInfo-functions">
						<div id="collaInfo-function1-stable">
							<div><img src="${contextPath }/img/mac_wsMain.png"></div>
						</div>
						<div id="collaInfo-function1-ani">
							<div class="function-title" lang="en">Workspace</div>
							<div class="function-body">쉽고 빠르게 워크스페이스 생성</div>
							<div class="function-caption">워크스페이스는 COLLA에서 정의하는 프로젝트 단위입니다.<br>
								워크스페이스는 사용에 따라 조직이 될 수도 있고,<br> 개별 프로젝트가 될 수도 있습니다.<br>
								이렇게 만들어진 워크스페이스마다<br> 프로젝트, 채팅, 게시판, 일정을 따로 관리할 수 있습니다.
							</div>
						</div>
					</div>
				</div>
			</section>
			
			<section id="collaInfo-function2" class="box">
				<div id="container">
					<div class="collaInfo-functions">
						<div id="collaInfo-function2-ani">
							<div class="function-title" lang="en">Project</div>
							<div class="function-body">프로젝트 진행상황을 공유</div>
							<div class="function-caption">워크스페이스에서 다양한 프로젝트를 생성하세요.<br>
								프로젝트 참여자들을 한눈에 확인하고<br>멤버에게 각각 할일을 부여할 수 있습니다.<br>
								프로젝트 진척률을 확인하며 업무 효율을 증진시킬 수 있습니다.
							</div>
						</div>
						<div id="collaInfo-function2-stable">
							<div><img src="${contextPath }/img/mac_pjMain.png"></div>
						</div>
					</div>
				</div>
			</section>
			
			<section id="collaInfo-function3" class="box">
				<div id="container">
					<div class="collaInfo-functions">
						<div id="collaInfo-function3-stable">
							<div><img src="${contextPath }/img/mac_chatMain.png"></div>
						</div>
						<div id="collaInfo-function3-ani">
							<div class="function-title" lang="en">Chatting</div>
							<div class="function-body">멤버들과 실시간 채팅</div>
							<div class="function-caption">COLLA는 워크스페이스 멤버들과의 실시간 채팅 서비스를 제공합니다.<br>
								파일, 코드, 지도를 첨부할 수 있는 제공합니다.<br>채팅방은 사용 목적에 따라 부서별, 계열사별 등 다양한<br>
								소그룹을 묶어내고 소통할 수 있는 편리함을 제공합니다.
							</div>
						</div>
					</div>
				</div>
			</section>
			
			<section id="collaInfo-function4" class="box">
				<div id="container">
					<div class="collaInfo-functions">
						<div id="collaInfo-function4-ani">
							<div class="function-title" lang="en">Board</div>
							<div class="function-body">멤버들과 자유롭게 소통하는 게시판</div>
							<div class="function-caption">COLLA는 워크스페이스 멤버들 모두가 자유롭게 소통할 수 있는 게시판을 제공합니다.<br>
								주요사항을 공지로 상단에 띄을 수 있고,<br>파일 첨부는 물론<br>
								동영상 스트리밍 기능 또한 제공합니다.
							</div>
						</div>
						<div id="collaInfo-function4-stable">
							<div><img src="${contextPath }/img/mac_boardMain.png"></div>
						</div>
					</div>
				</div>
			</section>
			
			<section id="collaInfo-function5" class="box">
				<div id="container">
					<div class="collaInfo-functions">
						<div id="collaInfo-function5-stable">
							<div><img src="${contextPath }/img/mac_calMain.png"></div>
						</div>
						<div id="collaInfo-function5-ani">
							<div class="function-title" lang="en">Calendar</div>
							<div class="function-body">멤버들과 일정을 공유하고 관리</div>
							<div class="function-caption">COLLA는 워크스페이스 멤버들과 함께<br>
								공유하고 관리할 수 있는 공유 캘린더 기능을 제공합니다.<br>
								어느 채팅방에 있건 같은 워크스페이스 멤버라면<br>
								누구든지 공유 캘린더를 이용하고 일정을 추가, 삭제, 수정할 수 있습니다.
							</div>
						</div>
					</div>
				</div>
			</section>
			
			<div class="box"><%@ include file="/WEB-INF/jsp/inc/footerMain.jsp" %></div>
		</div>
	</div>
</body>
</html>