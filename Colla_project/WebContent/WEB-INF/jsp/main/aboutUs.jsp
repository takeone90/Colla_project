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
<script src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous"></script>
<script>

</script>
</head>
<body>
	<div id="wrap">
		<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
		<div id="aboutUsAll">
			<section id="aboutUs-cover">
				<div id="container">
					<div id="head-all" class="animated infinite pulse">
						<div class="head-title"> TEAM NEVER LOSE </div>
						<div class="head-body"> Best Team In My Life <br>
						BLAH BLAH BLAH BLAH BLAH </div>
						<div class="head-caption"> 우리는 이런 팀 저런 팀 어떤 팀 </div>
					</div>
				</div>
			</section>
			<section id="aboutUs-member1">
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
			<section id="aboutUs-member2">
				<div id="container">
					<div class="aboutUs-card">
						<div>김미경은</div>
						<div>은 팀원이다</div>
					</div>
				</div>
			</section>
			<section id="aboutUs-member3">
				<div id="container">
					<div class="aboutUs-card">
						<div>김수빈은</div>
						<div>은 팀원이다</div>
					</div>
				</div>
			</section>
			<section id="aboutUs-member4">
				<div id="container">
					<div class="aboutUs-card">
						<div>박혜선은</div>
						<div>은 팀원이다</div>
					</div>
				</div>
			</section>
		</div>
		<%@ include file="/WEB-INF/jsp/inc/footerMain.jsp" %>
	</div>
</body>
</html>