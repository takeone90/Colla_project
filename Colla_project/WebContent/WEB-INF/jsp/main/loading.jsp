<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>

<title>LOADING...</title>
</head>
<body>
	<script>
		var info = "${param.info}";
		$(function(){
			if(info == "duplicatedLogin"){
				alert("동일한 아이디로 로그인되어 로그아웃합니다.");
				window.location.href="/loginForm";
			}
		});
	</script>
	<div>
		<img style="display:block; width:100%;height:100%;" src="/img/loading.gif" alt="로딩이미지">
	</div>
</body>
</html>