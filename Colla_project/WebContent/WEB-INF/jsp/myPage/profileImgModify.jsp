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
<title>개인정보</title>
<link rel="stylesheet" type="text/css" href="css/reset.css"/>
<link rel="stylesheet" type="text/css" href="css/base.css"/>
<link rel="stylesheet" type="text/css" href="css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="css/myPage.css"/>
<script src="https://code.jquery.com/jquery-3.4.1.js"
   integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
   crossorigin="anonymous">
</script>

<script type="text/javascript">
	var profileImgType = null;
	$(function() {
		var Img = $('.thumbNailImg');
		if(Img.width()>Img.height()){
			$('.thumbNailImg').attr("class","thumbNailImg landscape");
		}else{
			$('.thumbNailImg').attr("class","thumbNailImg portrait");
		}

		//이미지 업로드 전 미리보기
		$("#attachImgBtn").on('change', function() {
			if (this.files && this.files[0]) {
				var reader = new FileReader();
				reader.onload = function(e) {
					var tmpImg = $('.temp_img').attr("src", e.target.result);
					if(tmpImg.width()>tmpImg.height()){
						$('.thumbNailImg').attr("class","thumbNailImg landscape");
					}else{
						$('.thumbNailImg').attr("class","thumbNailImg portrait");
					}
					$('.thumbNailImg').attr("src", e.target.result);
				}
				reader.readAsDataURL(this.files[0]);
				//$("#profileImgType").val("profileImgType");
				$("#profileImgType").attr("value","profileImgType");
			}
		});//end change

		//기본이미지로 변경
		$("#defalutImgBtn").on("click", function() {
			$('.thumbNailImg').attr("src","${contextPath}/img/profileImage.png");
			//$("#profileImgType").val("defaultImg");
			$("#profileImgType").attr("value","defaultImg");
		});
	});//end onload
</script>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp"%>
	<div id="wsBody">
	<input type="hidden" value="mypage" id="pageType">
	<img src="" class="temp_img">
		<div id="wsBodyContainer">
			<h3>마이페이지</h3>
			<h4>프로필 수정</h4>
			<div class="myPageInner">
				<div class ="myPageModify">
					<p>프로필 이미지를 변경해주세요!</p>
					<form action="modifyProfileImg" class="profileImgForm" enctype="multipart/form-data" method="post">
						<div class="thumbnail-wrap">
							<div class="thumbnail">
								<div class="centered">
									<img alt="나의 프로필 사진" class="thumbNailImg portrait" src="${contextPath }/showProfileImg">
								</div>
							</div>
						</div>
						<div class="attachImgArea clearFix">		
							<input type="hidden" id="profileImgType" name="profileImgType"> 
							<input type="file" id="attachImgBtn" name="profileImg" value="사진 선택" accept="image/*" >
							<label for="attachImgBtn">프로필 변경</label>
							<input type="button" id="defalutImgBtn">
							<label for="defalutImgBtn">기본이미지 변경</label>
							<input type="hidden" name="profileImgType"><br>
						</div>
						<div class="row btns">
							<button class="btn">저장</button>
							<a href="myPageAccountForm" class="btn">취소</a>
						</div>
					</form>
				</div>
			</div><!-- myPageInner -->
		</div>
	</div><!-- end wsBody -->
	
</body>
</html>