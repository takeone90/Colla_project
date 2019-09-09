<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath() %>"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Payment</title>
<link rel="stylesheet" type="text/css" href="${contextPath }/css/reset.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath }/css/base.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath }/css/headerMain.css"/>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
</head>
<body>
<script>
		var msg = "${param.msg}";
		if(msg=="cancel" || msg == "fail"){
			window.close();
		}
		function dataFunction(info){
			console.log(info);
// 			window.location.href = "${contextPath}/payment/result";
		}
		function openNewWin(){
			frm = document.getElementById("kakaoPayForm");
			window.open('', 'viewer', 'width=450, height=600');
			frm.action = "${contextPath }/payment/kakaoPay";
			frm.target = "viewer";
			frm.method = "post";
			frm.submit();
		}
</script>
	<div id="wrap">
		<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
		<section id="main-cover">
			<div id="container">
				<h1>카카오 페이</h1>
				<form id="kakaoPayForm">
					<button onclick="openNewWin();">카카오페이로 결제하기</button>
				</form>
			</div>
		</section>
		
		<%@ include file="/WEB-INF/jsp/inc/footerMain.jsp" %>
	</div>
</body>
</html>