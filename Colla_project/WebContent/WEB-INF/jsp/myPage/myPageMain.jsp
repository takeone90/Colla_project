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
	$(function(){
		$(".myprofileImg").on("click", function(){
			$(".profileImg-modal").show();
		});// end myprofileImg click
		$("#profileImgForm input[type='button']").on("click", function() {
			$(".profileImg-modal").hide();
		});
		
		$("#btnFile").on("change", function(){
			if($(this)[0].files[0] != null){
				var formData = new FormData();
				var profileImg = $("input[name='profileImg']");
				var files = profileImg[0].files;
				for(var i=0;i<files.length;i++){
					formData.append("profileImg", files[i]);
				}
				$.ajax({
					url : "${contextPath}/updateProfileImg",
					processData : false,
					contentType : false,
					type : "post",
					data : formData,
					success:function(result){
						if(result){
							$(".profileImg-modal").hide();
							$("#myProfileImg").attr("src","${contextPath }/image?fileName=${member.profileImg}")
						}
					},error : function() {
						
					}
				});//end ajax
			}else{
				
			}
		});
		
		$("#profileImgForm").on("submit", function(){
			var formData = new FormData();
			var profileImg = $("input[name='profileImg']");
			
			return false;
		});
	});//end onload
	
</script>
<style type="text/css">
	.profileImg-modal{
		border: 1px solid black;
		width : 200px;
		padding: 10px;
		display: none;}
	.profileImg-modal > input{
		margin-bottom: 5px;}
		
	.myprofileImg{
		width : 150px;
		height : 150px;
		radius : 75px;
	}
	
</style>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp"%>
	<h1>마이페이지메인</h1>
	

	<div class="myprofileImg">
		<img alt="나의 프로필 사진" id="myProfileImg" src="${contextPath }/image?fileName=${member.profileImg}">
	</div>
	<p>이메일 : ${member.email}</p>
	<p>이름 : ${member.name}</p>
	<p>전화번호 : ${member.phone}</p>
	<!-- 삭제예정 start -->
	<button onclick="location.href='${contextPath}/myPageCheckPassForm'">회원정보관리</button>
	<button onclick="location.href='${contextPath}/myPageAlarmForm'">알림설정</button>
	<button onclick="location.href='${contextPath}/myPageLicenseForm'">라이센스</button>
	<!-- 삭제예정 end -->
	
	<!-- img update modal -->
	<!-- 프로필 편집 모달창 (수정할 예정~~) -->
	<div class="profileImg-modal">
		<form id="profileImgForm" enctype="multipart/form-data">
			<input type="file" id="btnFile" name="profileImg" value="사진 선택" accept=".jpg,.jpeg,.png,.gif,.bmp"><br>
			<input type="button" id="btnReset" value="기본이미지로 변경"><br>
			<input type="button" id="btnClose" value="닫기"><br>
		</form>
	</div>
</body>
</html>