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
   crossorigin="anonymous"></script>
</script>
<script type="text/javascript">
	var profileImgType = null;
	$(function() {
		// [닫기]버튼 클릭 시, 모달창 닫힘
		$(".closeProfileImgModal").on("click", function() {
			closeModal();
		});

		// 프로필 이미지 선택 시 모달 창 출력
		$("#profileModify").on("click", function() {
			$("#profileModifyModal").show();
		});
		$("#nameModify").on("click", function() {
			$("#nameModifyModal").show();
		});

		//이미지 업로드 전 미리보기
		$("#attachImgBtn").on('change', function() {
			if (this.files && this.files[0]) {
				var reader = new FileReader();
				reader.onload = function(e) {
					$('.thumbNailImg').attr("src", e.target.result);
				}
				reader.readAsDataURL(this.files[0]);
			}
		});//end change

		//기본이미지로 변경
		$("#defalutImgBtn").on("click", function() {
			$('.thumbNailImg').attr("src","${contextPath}/img/profileImage.png");
			profileImgType = "defaultImg";
		});

		//[저장] 버튼 클릭 시 동작하는 이벤트
		$(".profileImgUpload").on("click", function() {
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
						$('#profileModify > #profileImg > img').attr("src", "${contextPath}/showProfileImg");
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
		$("#profileModifyModal").hide();
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
			<h4>회원정보 관리</h4>
			<div class="myPageInner">
				<div class="myPageContent">
					<div class="myPageTitle">
						<p class="title">프로필</p>
						<p class="content">일부 정보가 Colla 서비스를 사용하는 다른 사람에게 표시될 수 있습니다.</p>
					</div>
					<div id="profileModify" class="myPageContentRow clearFix">
						<p class="title">사진</p>
						<p class="content">사진을 추가하여 계정을 맞춤 설정합니다.</p>
						<div id="profileImg">
							<img alt="나의 프로필 사진" src="${contextPath }/showProfileImg" />
						</div>
					</div>
					<div class="contentLine"></div>
					<div id="nameModify" class="myPageContentRow clearFix">
						<p class="title">이름</p>
						<p class="content">${requestScope.member.name}</p>
					</div>
					<div class="contentLine"></div>
					<div class="myPageContentRow clearFix">
						<div></div>
						<p class="title">비밀번호</p>
						<p class="content">${requestScope.member.pw}</p>
					</div>
				</div>
				<div class="myPageContent">
					<div class="myPageTitle">
						<p class="title">연락처 정보</p>
						<p class="content">일부 정보가 Colla 서비스를 사용하는 다른 사람에게 표시될 수 있습니다.</p>
					</div>
					<div class="myPageContentRow clearFix">
						<p class="title">계정</p>
						<p class="content">${requestScope.member.email}</p>
					</div>
					<div class="contentLine"></div>
					<div class="myPageContentRow clearFix">
						<p class="title">핸드폰 번호</p>
						<p class="content">${requestScope.member.phone}</p>
					</div>
				</div>
				<button>마이페이지 메인으로 이동</button>
			</div><!-- myPageInner -->
		</div>
		<%--------------------------------------------- 프로필 이미지 수정 모달 ----------------------------------------------------%>
		<div id="profileModifyModal" class="attachModal">
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
		<%--------------------------------------------- 이름 수정 모달 ----------------------------------------------------%>
		<div id="nameModifyModal" class="attachModal">
			<div class="modalHead">
				<h3 style="font-weight: bolder; font-size: 30px">닉네임</h3>
			</div>
			<br>
			<br>
			<div class="modalBody">
				<p>프로필 닉네임을 변경해주세요!</p>
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