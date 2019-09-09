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
<title>개인정보 수정</title>
<link rel="stylesheet" type="text/css" href="css/reset.css"/>
<link rel="stylesheet" type="text/css" href="css/base.css"/>
<link rel="stylesheet" type="text/css" href="css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="css/navMyPage.css"/>
<link rel="stylesheet" type="text/css" href="css/myPage.css"/>
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
		$(".myProfileImg").on("click", function() {
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
		$(".btnReset").on(
				"click",
				function() {
					$('.thumbNailImg').attr("src",
							"${contextPath}/img/profileImage.png");
					profileImgType = "defaultImg";
				});

		//[저장] 버튼 클릭 시 동작하는 이벤트
		$(".profileImgForm").on(
				"submit",
				function() {
					var formData = new FormData();
					var profileImgFile = $("input[name='profileImg']");
					var files = profileImgFile[0].files;

					for (var i = 0; i < files.length; i++) {
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
							if (data) {
								$('.myProfileImg').attr("src", "${contextPath}/showProfileImg");
								closeModal();
							} else {
								alert("프로필 변경에 실패하였습니다");
							}
						}
					});//end ajax
					return false;
				});//submit end
	});//end onload

	function closeModal() {
		$(".thumbNailImg").attr("src", "${contextPath}/showProfileImg");
		profileImgType = null;
		$(".profileImg-modal").hide();
	};
</script>
<style type="text/css">
#myPageModify {
	width : 800px;
	margin: 0 auto;
	text-align: center;
}

#myPageModify > div {
	text-align: center;
	display: inline-block;
}

#myPageModify>div:last-child div > *{
	display: inline-block;
}

#myPageModify>div:last-child div > .title{
	color : red;
}

#myPageModify>div:last-child div > .content{
	color : blue;
}




.profileImg-modal {
	border: 1px solid black;
	width: 300px;
	height: 300px;
	padding: 10px;
	display: none;
	position: absolute;
	top: 35%;
	left: 35%;
	background-color: white;
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
	<%@ include file="/WEB-INF/jsp/inc/navMyPage.jsp"%>
	<div id="wsBody">
		<input type="hidden" value="mypage" id="pageType">
		<h3>마이페이지</h3>
		<h4>회원정보 관리</h4>
		<div id="myPageModify">
			<div>
				<img alt="나의 프로필 사진" class="myProfileImg"
					src="${contextPath }/showProfileImg">
			</div>
			<div>
				<form action="modifyMember" method="post">
					<div>
						<p class="title">이메일</p>
						<input type="text" name="email" value="${member.email}"
							class="content">
					</div>
					<div>
						<p class="title">이름</p>
						<input type="text" name="name" value="${member.name}"
							class="content">
					</div>
					<div>
						<p class="title">비밀번호</p>
						<input type="tel" name="pw" value="${member.pw}" class="content">
					</div>
					<div>
						<p class="title">전화번호</p>
						<input type="tel" name="phone" value="${member.phone}"
							class="content">
					</div>
					<button>수정</button>
				</form>
			</div>
		</div>
		<div id="deleteMember">
			<a href="#">회원 탈퇴하기(누르면 바로 탈퇴되고 메인으로 추방)</a>
		</div>
	</div>


	<!-- 프로필 수정 모달-->
	<div class="profileImg-modal">
		<form class="profileImgForm" enctype="multipart/form-data">
			<img alt="나의 프로필 사진" class="thumbNailImg" src="${contextPath }/showProfileImg">
			<input type="file" class="btnFile" name="profileImg" value="사진 선택" accept="image/*" multiple><br> 
			<input type="button" class="btnReset" value="기본이미지로 변경"><br> 
			<input type="submit" class="btnSave" value="저장"><br> 
			<input type="button" class="btnClose" value="닫기"><br>
		</form>
	</div>

</body>
</html>