<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>

<title>LOADING...</title>
<style>
	#loadingImg{
		margin:0 auto;
		width: 300px;
		position: fixed;
		top:35%;
		left:50%;
		margin-left:-150px;
		margin-top:-225px;
	}
	img{
		display:block; 
		width:100%;
	}
</style>
</head>
<body>
	<script>
		var info = "${param.info}";
		console.log(info);
		$(function(){
			if(info == "duplicatedLogin"){
				window.alert("동일한 아이디로 로그인되어 로그아웃합니다.");
				window.location.href="/loginForm";
			} else if(info == "duplicatedJoin") {
				window.alert("이미 회원가입된 아이디입니다.");
				window.location.href="/loginForm";
			} else {
				window.alert("메인으로 이동합니다.");
				window.location.href="/";
			}
		});
	</script>
	<div id="loadingImg">
		<img src="/img/loading.gif" alt="로딩이미지">
	</div>
</body>
</html>