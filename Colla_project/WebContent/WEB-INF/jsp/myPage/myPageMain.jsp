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
<link rel="stylesheet" type="text/css" href="css/reset.css"/>
<link rel="stylesheet" type="text/css" href="css/base.css"/>
<link rel="stylesheet" type="text/css" href="css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="css/myPage.css"/>
<script src="https://code.jquery.com/jquery-3.4.1.js"
   integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
   crossorigin="anonymous"></script>
<script type="text/javascript">
	var profileImgType = null;
	$(function() {
		
		// 프로필 이미지 변경 모달
		$("#profileImg").on("click",function(){
		$("#profileImgModal").fadeIn(300);
		});
		$(".closeProfileImgModal").on("click",function(){
			$("#profileImgModal").fadeOut(300);
			return false;
		});
		
		//모달 바깥쪽이 클릭되거나 다른 모달이 클릭될때 현재 모달 숨기기
		$("#wsBody").mouseup(function(e){
			if($("#profileImgModal").has(e.target).length===0)
				$("#profileImgModal").fadeOut(300);
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
		$("#defalutImgBtn").on(
				"click",
				function() {
					$('.thumbNailImg').attr("src",
							"${contextPath}/img/profileImage.png");
					profileImgType = "defaultImg";
				});

		//[업로드] 버튼 클릭 시 동작하는 이벤트
		$(".profileImgUpload").on("click",function() {
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
						$('#profileImg > img').attr("src","${contextPath}/showProfileImg");
						$('#aboutProfile > a >img').attr("src","${contextPath}/showProfileImg");
						closeModal();
					} else {
						alert("프로필 변경에 실패하였습니다");
					}
				}
			}); //end ajax
			return false;
		}); //end profileImgUpload
	
	}); //end onload

	function closeModal() {
		$(".thumbNailImg").attr("src", "${contextPath}/showProfileImg");
		profileImgType = null;
		$("#profileImgModal").fadeOut(300);
	};
</script>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp"%>
	<div id="wsBody">
	<input type="hidden" value="mypage" id="pageType">
		<div id="wsBodyContainer">
			<h3>마이페이지</h3>
			<div id="myPageMain" class="clearFix">
				<div class="myPageContent">
					<h5>회원정보 관리</h5>
					<div id="profileImg">
						<img alt="나의 프로필 사진" src="${contextPath }/showProfileImg" />
					</div>
					<div id="profileInfo">
						<div class="clearFix">
							<p class="title">회원 이름</p>
							<p class="content">${requestScope.member.name} </p>
						</div>
						<div class="clearFix">
							<p class="title">이메일</p>
							<p class="content">${requestScope.member.email} </p>
						</div>
						<div class="clearFix">
							<p class="title">가입일</p>
							<p class="content">${requestScope.member.regDate}&nbsp</p>
						</div>
						<div class="clearFix">
							<p class="title">핸드폰 번호</p>
							<p class="content">${requestScope.member.phone}&nbsp</p>
						</div>
					</div>
				</div>
				<div class="myPageContent">
				
				</div>
				<div class="myPageContent">
				
				</div>
			</div>
		</div>
		<%---------------------------------------------회원정보 모달 ----------------------------------------------------%>
		<div id="profileImgModal" class="attachModal">
			<div class="modalHead">
				<h3 style="font-weight: bolder; font-size: 30px">프로필 이미지</h3>
			</div>
			<br>
			<br>
			<div class="modalBody">
				<p>프로필 이미지를 변경해주세요!</p>
				<div class="row">
					<p>
						<form class="profileImgForm" enctype="multipart/form-data">
							<div id="profileImg">
								<img alt="나의 프로필 사진" class="thumbNailImg" src="${contextPath }/showProfileImg">
							</div>
							<div class="attachImgArea" class="attachModal">
								
								<input type="file" id="attachImgBtn" name="profileImg" value="사진 선택" accept="image/*" multiple>
								<label for="attachImgBtn">프로필 변경</label>
								
								<input type="button" id="defalutImgBtn">
								<label for="defalutImgBtn">기본이미지 변경</label>
							</div>
						</form>
					</p>
				</div>
				<div id="innerBtn">
					<a href="#" class="profileImgUpload">업로드</a><br>
					<a href="#" class="closeProfileImgModal">닫기</a><br>
				</div>
			</div><!-- end modalBody -->
		</div><!-- end memberInfoModal -->

	</div><!-- end wsBody -->

	
</body>
</html>