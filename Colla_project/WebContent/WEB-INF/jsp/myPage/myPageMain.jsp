<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
   String contextPath = request.getContextPath();
   request.setAttribute("contextPath", contextPath);
%>
<title>마이페이지 메인</title>
<script src="https://code.jquery.com/jquery-3.4.1.js"
   integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
   crossorigin="anonymous"></script>
<script type="text/javascript">
   
</script>
<style type="text/css">

#myPageMain {
   width: 500px;
   margin: 0 auto;
   text-align: center;
}
   
#myPageMain > .myProfileImg {
   width: 150px;
   height: 150px;
   border-radius: 75px;
   border: 1px solid #D3CDCD;
}

#myPageMain>div>p {
   display: inline-block;
}

#myPageMain>div>.title{
   width : 100px;
   text-align: right;
}

#myPageMain>div>.content{
   border-bottom: 1px solid black;
   width : 300px;
}
</style>
</head>
<body>
   <%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%>
   <%@ include file="/WEB-INF/jsp/inc/navWs.jsp"%>
   <div id="wsBody">
      <h3>마이페이지</h3>
      <div id="myPageMain">
         <img alt="나의 프로필 사진" class="myProfileImg" src="${contextPath }/showProfileImg?fileName=${member.profileImg}">
         <div>
            <p class="title">이메일</p>
            <p class="content">${member.email} </p>
         </div>
         <div>
            <p class="title">회원 이름</p>
            <p class="content">${member.name} </p>
         </div>
         <div>
            <p class="title">핸드폰 번호</p>
            <p class="content">${member.phone} &nbsp</p>
         </div>
      </div>
   </div>


   <!-- 삭제예정 start -->
   <div>
      <button onclick="location.href='${contextPath}/myPageCheckPassForm'">회원정보관리</button>
      <button onclick="location.href='${contextPath}/myPageAlarmForm'">알림설정</button>
      <button onclick="location.href='${contextPath}/myPageLicenseForm'">라이센스</button>
   </div>
   <!-- 삭제예정 end -->


</body>
</html>