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
		//[]
		$("#profileImgForm input[type='button']").on("click", function() {
			$(".profileImg-modal").hide();
		});
		
		//첨부파일 변경시 발생하는 이벤트
		//$("#btnFile").on("change", function(){
			
		//[저장] 버튼 클릭 시 동작하는 이벤트
		$("#profileImgForm").on("submit",function(){
			var formData = new FormData();
			var profileImgFile = $("input[name='profileImg']");
			var files = profileImgFile[0].files;
			for(var i=0;i<files.length;i++){
				formData.append("profileImg", files[i]);
			}
			$.ajax({
				url : "${contextPath}/modifyProfileImg?type=profileImg",
				processData : false,
				contentType : false,
				type : "post",
				data : formData,
				success:function(result){
					alert("업로드 완료!");}
			});//end ajax
		});//submit end
		
	});//end onload
	
</script>
<style type="text/css">
	.profileImg-modal{
		border: 1px solid black;
		width : 300px;
		height : 300px;
		padding: 10px;
		display: none;
		position: absolute;
		top: 35%;
		left: 35%;
		}
	.profileImg-modal > input{
		margin-bottom: 5px;}
		
	#myProfileImg,#thumbNailImg{
		width : 150px;
		height : 150px;
		border-radius: 75px;
		border: 1px solid black;
	}

</style>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp"%>
	<h1>마이페이지메인</h1>
	

	<div class="myprofileImg">
		<img alt="나의 프로필 사진" id="myProfileImg">
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
			<!--  
			<img alt="나의 프로필 사진" id="thumbNailImg" src="${contextPath }/getProfileImg?type=thumbnail&fileName=${member.profileImg}">
			-->
			<input type="file" id="btnFile" name="profileImg" value="사진 선택" accept=".jpg,.jpeg,.png,.gif,.bmp"><br>
			<input type="submit" id="btnSave" value="저장"><br>
			<input type="button" id="btnReset" value="기본이미지로 변경"><br>
			<input type="button" id="btnClose" value="닫기"><br>
		</form>
	</div>
	
	<!-- 
	
		$("#profileImgForm").on("submit",function(){
			if($(this)[0].files[0] != null){
				var formData = new FormData();
				var profileImg = $("input[name='profileImg']");
				var files = profileImg[0].files;
				for(var i=0;i<files.length;i++){
					formData.append("profileImg", files[i]);
				}
				$.ajax({
					url : "${contextPath}/modifyProfileImg?type=profileimg",
					processData : false,
					contentType : false,
					type : "post",
					data : formData,
					success:function(result){
						alert("db저장 성공");
					},error : function() {
						
					}
				});//end ajax
			}else{
				//첨부한 파일이 없는 경우, 아무런 이벤트도 일어나지 않는다
			}
		});
	
	 -->
</body>
</html>