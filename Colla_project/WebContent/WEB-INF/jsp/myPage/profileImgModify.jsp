<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>개인정보</title>
<link rel="stylesheet" type="text/css" href="css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="css/myPage.css"/>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
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
	var cropImg = null;
	$(function() {		
		//이미지 크롭 모달 보여주기
		 $("#attachImgBtn").on('change', function() { //첨부파일이 변경되면
			 if (this.files && this.files[0]) {
					var reader = new FileReader();
					reader.onload = function(e) {
						$("#cropImgModal").fadeIn(300); // 이미지 크롭 모달창을 띄운다
						$('#cropImg').attr("src", e.target.result); // 모달의 이미지영역에 선택한 이미지를 노출하고
						cropImg = document.getElementById('cropImg');
						croppable = false;
						cropper = new Cropper(cropImg,{ //모달의 이미지 영역에 크로퍼 객체를 생성 하고, 옵션을 설정한다 
							 viewMode: 1,
							 aspectRatio : 1
						});
					}
					reader.readAsDataURL(this.files[0]);
					cropper.destroy();//크롭이미지 선택 영역 초기화
				}// end if	
		 	});//end change
				
		//크롭 모달창에서 [확인] 선택시 
		$(".cropImgBtn").on('click',function(){
			$("#profileImgType").attr("value","profileImgType");			
			croppedCanvas = cropper.getCroppedCanvas(); //해당 이미지를 저장하기 위한 객체를 생성한다
			roundedCanvas = getRoundedCanvas(croppedCanvas); //선택한 영역의 좌표값을  roundedCanvas에 넣어준다
			$('.thumbNailImg').attr('src',roundedCanvas.toDataURL()); // 가져온 이미지 데이터를 썸네일 이미지에 뿌려준다
			$("#attachImgBtn").val("");//첨부파일 초기화
			$("#cropImgModal").fadeOut(300);//해당 모달 창을 닫는다
			return false;
		});
		 	
		//이미지 크롭 모달 닫기
		$(".closeCropImgModal").on("click",function(){
			$("#attachImgBtn").val("");//첨부파일 초기화
			$("#cropImgModal").fadeOut(300);
			return false;
		});
		 		
		//모달 바깥쪽이 클릭되거나 다른 모달이 클릭될때 현재 모달 숨기기
		$("#wsBody").mousedown(function(e){
			if(!$("#cropImgModal").is(e.target) && $("#cropImgModal").has(e.target).length===0)
				$("#cropImgModal").fadeOut(300);
			//return false;
		});

		//기본이미지로 변경
		$("#defalutImgBtn").on("click", function() {
			$('.thumbNailImg').attr("src","${contextPath}/img/profileImage.png");
			$("#profileImgType").attr("value","defaultImg");
		});
		
		//[적용] 선택시 (실제 db에 적용됨)
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
		$("#cropImgModal .header").on("mousedown", function(){
			$(".attachModal").draggable();
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
	    context.arc( width/2, height/2, Math.min(width, height)/2, 0, 2*Math.PI, true);
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
				<div class ="myPageModify profileModify">
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
							<label for="defalutImgBtn">기본이미지</label>
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
		<div id="cropImgModal" class="attachModal ui-widget-content">
				<div class="header">
				<!--파도 위 내용-->
				<div class="inner-header flex">
					<g>
					<path fill="#fff"
						d="M250.4,0.8C112.7,0.8,1,112.4,1,250.2c0,137.7,111.7,249.4,249.4,249.4c137.7,0,249.4-111.7,249.4-249.4
							C499.8,112.4,388.1,0.8,250.4,0.8z M383.8,326.3c-62,0-101.4-14.1-117.6-46.3c-17.1-34.1-2.3-75.4,13.2-104.1
							c-22.4,3-38.4,9.2-47.8,18.3c-11.2,10.9-13.6,26.7-16.3,45c-3.1,20.8-6.6,44.4-25.3,62.4c-19.8,19.1-51.6,26.9-100.2,24.6l1.8-39.7		
							c35.9,1.6,59.7-2.9,70.8-13.6c8.9-8.6,11.1-22.9,13.5-39.6c6.3-42,14.8-99.4,141.4-99.4h41L333,166c-12.6,16-45.4,68.2-31.2,96.2	
							c9.2,18.3,41.5,25.6,91.2,24.2l1.1,39.8C390.5,326.2,387.1,326.3,383.8,326.3z" /></g>
					</svg>
					<div class="loginBox-Head">
						<h3 style="font-weight: bolder; font-size: 30px; margin-bottom: 11px;">프로필 이미지 선택</h3>
						<p>아래 영역을 설정해주세요</p>
					</div>
				</div>
				<!--파도 시작-->
				<div>
					<svg class="waves" xmlns="http://www.w3.org/2000/svg"
						xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 24 150 28"
						preserveAspectRatio="none" shape-rendering="auto">
							<defs>
							<path id="gentle-wave"
							d="M-160 44c30 0 58-18 88-18s 58 18 88 18 58-18 88-18 58 18 88 18 v44h-352z" />
							</defs>
								<g class="parallax">
								<use xlink:href="#gentle-wave" x="48" y="0"
							fill="rgba(255,255,255,0.7" />
								<use xlink:href="#gentle-wave" x="48" y="3"
							fill="rgba(255,255,255,0.5)" />
								<use xlink:href="#gentle-wave" x="48" y="7" fill="#fff" />
								</g>
							</svg>
				</div>
				<!--파도 end-->
			</div>
			<!--header end-->
			<br>
			<div class="modalBody">
				<form id="addImgForm" method="post" enctype="multipart/form-data">
					<div id="cropImgArea">
						<img src="" id="cropImg">
					</div>
					<div id="innerBtn" align="center">
						<a href="#" class="cropImgBtn">확인</a>
						<a href="#" class="closeCropImgModal">닫기</a>
					</div>
				</form>
			</div> <!-- end modalBody -->
		</div><!-- end CropImgModal -->
	</div><!-- end wsBody -->
</body>
</html>