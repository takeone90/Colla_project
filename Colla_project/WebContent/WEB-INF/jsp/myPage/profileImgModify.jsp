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
<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.5/cropper.css"/>
<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.5/cropper.min.css"/>
<script src="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.5/cropper.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.5/cropper.min.js"></script>

<script type="text/javascript">
	var profileImgType = null;
	var cropper = null;
	var croppedCanvas = null;
	var roundedCanvas = null;
	var roundImg = null;
	var profileImgType = null;
	$(function() {		
		//이미지 크롭 모달 닫기
		$(".closeCropImgModal").on("click",function(){
			$("#CropImgModal").fadeOut(300);
			return false;
		});

		//이미지 크롭 모달 보여주기
		 $("#attachImgBtn").on('change', function() { // 첨부파일이 변경되면
			 if (this.files && this.files[0]) {
					var reader = new FileReader();
					reader.onload = function(e) {
						$("#CropImgModal").fadeIn(300); // 이미지 크롭 모달창을 띄운다
						$('#cropImg').attr("src", e.target.result); // 모달의 이미지영역에 선택한 이미지를 노출하고
						var cropImg = document.getElementById('cropImg');
						croppable = false;
						cropper = new Cropper(cropImg,{ //모달의 이미지 영역에 크로퍼 객체를 생성 하고, 옵션을 설정한다 
							 viewMode: 1,
							 aspectRatio : 1,
							 ready:function(){
								 croppable = true; // 모달창이 켜졌다면, 해당 값은 true가 된다
							 }
						});
						
					}
					reader.readAsDataURL(this.files[0]);
					//$("#profileImgType").val("profileImgType");
				}// end if	
		 	});//end change
				
		//크롭 모달창에서 [확인] 선택시 
		$(".cropImgBtn").on('click',function(){
			$("#profileImgType").attr("value","profileImgType");			
			if(!croppable){
				return; //선택한 영역이 없다면 return
			}
			
			croppedCanvas = cropper.getCroppedCanvas(); //해당 이미지를 저장하기 위한 객체를 생성한다
			roundedCanvas = getRoundedCanvas(croppedCanvas); //선택한 영역의 좌표값을  roundedCanvas에 넣어준다
			$('.thumbNailImg').attr('src',roundedCanvas.toDataURL()); // 가져온 이미지 데이터를 썸네일 이미지에 뿌려준다
			$("#CropImgModal").fadeOut(300);//해당 모달 창을 닫는다
			return false;
		});		 

		//기본이미지로 변경
		$("#defalutImgBtn").on("click", function() {
			$('.thumbNailImg').attr("src","${contextPath}/img/profileImage.png");
			$("#profileImgType").attr("value","defaultImg");
		});
		
		//"btn imgUpload"
		$(".profileImgForm").on("submit", function(){
			profileImgType = $("#profileImgType").val();
			var formData = new FormData();
			if(profileImgType == "profileImgType"){
				cropper.getCroppedCanvas().toBlob(function (blob) {
					  formData.append('croppedImage', blob);
					  formData.append('profileImgType', profileImgType);
					  // Use `jQuery.ajax` method for example
					  $.ajax({
						url : "${contextPath}/modifyProfileImg",
					    method: "post",
					    data: formData,
					    processData: false,
					    contentType: false,
					    success:function(){
					    	location.href="${contextPath}/myPageAccountForm";
					    }
					  }); //end ajax
				});//end toBolb
			}else{
				  formData.append('profileImgType', profileImgType);
				  $.ajax({
					url : "${contextPath}/modifyProfileImg",
				    method: "post",
				    data: formData,
				    processData: false,
				    contentType: false,
				    success:function(){
				    	location.href="${contextPath}/myPageAccountForm";
				    }
				  }); //end ajax
			}
			return false;
		});
	});//end onload
	
	//crop한 영역 canvas로 만들기
	function getRoundedCanvas(sourceCanvas){
		var canvas = document.createElement('canvas');
		var context = canvas.getContext('2d');
		var width = sourceCanvas.width;
		var height = sourceCanvas.height;
		canvas.width = width;
		canvas.height = height;
		context.imageSmoothingEnabled = false;
		context.imageSmoothingQuality = 'high';
     	context.drawImage(sourceCanvas, 0, 0, width, height);
	    context.globalCompositeOperation = 'destination-in';
	    context.beginPath();
	    context.arc( width / 2, height / 2, Math.min(width, height)/2, 0, 2*Math.PI, true);
	    context.fill();
	    return canvas;
	}
	
	

</script>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp"%>
	<div id="wsBody">
	<input type="hidden" value="mypage" id="pageType">
		<div id="wsBodyContainer">
			<h3>마이페이지</h3>
			<h4>프로필 수정</h4>
			<div class="myPageInner">
				<div class ="myPageModify">
					<p>프로필 이미지를 변경해주세요!</p>	
					<form class="profileImgForm" enctype="multipart/form-data" method="post">
						<div id="profileImg">
							<img alt="나의 프로필 사진" class="thumbNailImg" src="${contextPath }/showProfileImg">
						</div>
						<div class="attachImgArea clearFix">		
							<input type="hidden" id="profileImgType" name="profileImgType"> 
							<input type="file" id="attachImgBtn" name="profileImg" value="사진 선택" accept="image/*" multiple>
							<label for="attachImgBtn">프로필 변경</label>
							<input type="button" id="defalutImgBtn">
							<label for="defalutImgBtn">기본이미지 변경</label>
						</div>
						<div class="row btns">
							<button class="btn imgUpload" >적용</button>
							<a href="myPageAccountForm" class="btn">취소</a>
						</div>
					</form>
				</div>
			</div><!-- myPageInner -->
		</div>
		<%---------------------------------------------프로필 이미지 크롭 모달 ----------------------------------------------------%>
		<div id="CropImgModal" class="attachModal">
			<div class="modalHead">
				<h3 style="font-weight: bolder; font-size: 30px">프로필 이미지 선택</h3>
			</div>
			<br>아래 영역을 설정해주세요<br>
			<div class="modalBody">
				<form id="addImgForm" method="post" enctype="multipart/form-data">
					<div>
						<img src="" id="cropImg">
					</div>
					<div id="innerBtn">
						<a href="#" class="cropImgBtn">확인</a><br> 
						<a href="#" class="closeCropImgModal">닫기</a>
					</div>
				</form>
			</div> <!-- end modalBody -->
		</div><!-- end addFileModal -->
	</div><!-- end wsBody -->
</body>
</html>