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

	var profileImgType = null;
	$(function() {
		// [닫기]버튼 클릭 시, 모달창 닫힘
		$(".btnClose").on("click", function() {
			closeModal();
		});
		
		
		// 프로필 이미지 선택 시 모달 창 출력
		$(".myprofileImg").on("click", function() {
			console.log("모달 리셋 됨??" + profileImgType);
			$(".profileImg-modal").show();
		});

		//이미지 업로드 전 미리보기
		$(".btnFile").on('change', function() {
			if (this.files && this.files[0]) {
				var reader = new FileReader();
				reader.onload = function(e) {
					$('.thumbNailImg').attr("src", e.target.result);
				}
				reader.readAsDataURL(this.files[0]);
			}
		});//end change
		
		//기본이미지로 변경
		$(".btnReset").on("click",function(){
			$('.thumbNailImg').attr("src", "${contextPath}/img/profileImage.png");
			profileImgType = "defaultImg";
			console.log("기본이미지 선택시 ???" + profileImgType);
		});

		
		//[저장] 버튼 클릭 시 동작하는 이벤트
		$(".profileImgForm").on("submit", function() {
			var formData = new FormData();
			var profileImgFile = $("input[name='profileImg']");
			var files = profileImgFile[0].files;
			
			for(var i=0;i<files.length;i++){
				formData.append("profileImg", files[i]);	
			}
			formData.append("profileImgType", profileImgType);
			
			
			$.ajax({
				url : "${contextPath}/modifyProfileImg",
				processData : false,
				contentType : false,
				data : formData,
				type : "post",
				success : function(data) {
					if(data){
						$('.myProfileImg').attr("src","${contextPath}/showProfileImg");
						closeModal();					
					}else{
						alert("프로필 변경에 실패하였습니다");
					}
				}
			});//end ajax
			return false;
		});//submit end
	});//end onload
	
	function closeModal(){
		$(".thumbNailImg").attr("src","${contextPath}/showProfileImg");
		profileImgType = null;
		$(".profileImg-modal").hide();
	};
	
	
</script>
<style type="text/css">
.profileImg-modal {
	border: 1px solid black;
	width: 300px;
	height: 300px;
	padding: 10px;
	display: none;
	position: absolute;
	top: 35%;
	left: 35%;
}

.profileImg-modal>input {
	margin-bottom: 5px;
}

.myProfileImg, .thumbNailImg {
	width: 150px;
	height: 150px;
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
		<img alt="나의 프로필 사진" class="myProfileImg" src="${contextPath }/showProfileImg?fileName=${member.profileImg}">
		
	</div>
	<p>이메일 : ${member.email}</p>
	<p>이름 : ${member.name}</p>
	<p>전화번호 : ${member.phone}</p>

	<!-- 삭제예정 start -->
	<button onclick="location.href='${contextPath}/myPageCheckPassForm'">회원정보관리</button>
	<button onclick="location.href='${contextPath}/myPageAlarmForm'">알림설정</button>
	<button onclick="location.href='${contextPath}/myPageLicenseForm'">라이센스</button>
	<!-- 삭제예정 end -->

	<div class="profileImg-modal">
		<form class="profileImgForm" enctype="multipart/form-data">
			<img alt="나의 프로필 사진" class="thumbNailImg" src="${contextPath }/showProfileImg?fileName=${member.profileImg}">
			<input type="file" class="btnFile" name="profileImg" value="사진 선택" multiple><br> 
			<input type="button" class="btnReset" value="기본이미지로 변경"><br> 
			<input type="submit" class="btnSave" value="저장"><br> 
			<input type="button" class="btnClose" value="닫기"><br>
		</form>
	</div>
</body>
</html>