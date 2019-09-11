<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채팅 메인</title>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/reset.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/base.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/chatMain.css"/>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script type="text/javascript" src="${contextPath}/js/stomp.js"></script>
<script type="text/javascript" src="${contextPath}/js/sockjs.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=38b5346cba2a9103101abc2c542a2d86&libraries=services"></script>

<script type="text/javascript" src="lib/codemirror/lib/codemirror.js"></script>
<link rel="stylesheet" type="text/css" href="lib/codemirror/lib/codemirror.css"/>
<link rel="stylesheet" type="text/css" href="lib/codemirror/theme/gruvbox-dark.css"/>
<script type="text/javascript" src="lib/codemirror/addon/edit/closetag.js"></script>
<script type="text/javascript" src="lib/codemirror/addon/hint/show-hint.js"></script>
<script type="text/javascript" src="lib/codemirror/addon/hint/css-hint.js"></script>
<script type="text/javascript" src="lib/codemirror/mode/javascript/javascript.js"></script>
<script type="text/javascript" src="lib/codemirror/mode/css/css.js"></script>
<script type="text/javascript" src="lib/codemirror/mode/clike/clike.js"></script>
<script type="text/javascript" src="lib/codemirror/mode/xml/xml.js"></script>
<script type="text/javascript" src="lib/codemirror/mode/sql/sql.js"></script>
<script type="text/javascript" src="lib/codemirror/mode/php/php.js"></script>
<script src="https://use.fontawesome.com/releases/v5.2.0/js/all.js"></script> <!-- font awsome -->
<!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.32.0/codemirror.min.js"></script> -->
<!-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.32.0/codemirror.min.css" /> -->

<script>
var chatArea = $(".chat");
var favoriteArea;
var chatNavContent;
var searchListDiv;
var editor;
// 마커를 담을 배열입니다
var markers = [];
var ps;
var map;
var area=null;
//var infowindow;
var overlay;
var clickedOverlay = null;
	$(function(){
		loadChatFromDB();
		favoriteArea = $("#favoriteArea");
		chatNavContent = $("#chatNavContent");
	
	//파일업로드 모달
	$(".openFileUploadModal").on("click",function(){
		$("#addFileModal").fadeIn(300);
	});
	$(".closeFileModal").on("click",function(){
		$("#addFileModal").fadeOut(300);
		return false;
	});
	
	
	//코드업로드 모달
	$(".openCodeModal").on("click",function(){
		$("#addCodeModal").fadeIn(300);
	});
	$(".closeCodeModal").on("click",function(){
		$("#addCodeModal").fadeOut(300);
		return false;
	});
	
	//지도업로드 모달
	$(".openLocationModal").on("click",function(){
		$("#addLocationModal").fadeIn(300);
		 showMap();
	});
	$(".closeLocationModal").on("click",function(){
		$("#addLocationModal").fadeOut(300);
		return false;
	});
	
	//모달 바깥쪽이 클릭되거나 다른 모달이 클릭될때 현재 모달 숨기기
	$("#wsBody").mouseup(function(e){
			$("#addCrMemberModal").fadeOut(300);
		if($("#addFileModal").has(e.target).length===0)
			$("#addFileModal").fadeOut(300);
		if($("#addCodeModal").has(e.target).length===0)
			$("#addCodeModal").fadeOut(300);
		if($("#addLocationModal").has(e.target).length===0)
			$("#addLocationModal").fadeOut(300);
		//return false;
	});
	//첨부파일Detail 숨기고 닫기
	$("#attachBtn").on("click",function(){
		$(".attachDetail").toggle(300);
		return false;
	});
	//select-box 값에 따라 codemirror mode를 바꾸는 과정
	$("#codeType").change(function(){
		type = $(this).val();
		editor.setOption("mode",type);
	});
	
	<%--채팅 연결 및 전송--%>
	chatArea = $(".chat");
	$("#sendChat").on("click",function(){
			sendMsg();
			chatArea.scrollTop($("#chatArea")[0].scrollHeight);
	});
	$("#chatInput").keydown(function(key){
		if(key.keyCode==13){
			sendMsg();
			chatArea.scrollTop($("#chatArea")[0].scrollHeight);
		}
	});
	//코드업로드 버튼 눌렸을 경우
	$(".codeUpload").on("click",function(){
		sendCode();
		chatArea.scrollTop($("#chatArea")[0].scrollHeight);
	});
	
	//파일업로드 버튼 눌렸을 경우
	$(".fileUploadBtn").on("click",function(){
		var addFileForm = $("#addFileForm")[0];
		var formData = new FormData(addFileForm);
		$.ajax({
			url : "${contextPath}/uploadFile",
			data : formData,
			processData : false,
			contentType : false,
			enctype: "multipart/form-data",
			type : "post",
			dataType : "json",
			success : function(jsonStr){
				var cmNum = jsonStr.cmNum;
				var fileName = jsonStr.fileName;
				var originName = jsonStr.originName;
				sendFile(fileName,originName,cmNum);
				$("#addFileModal").fadeOut(300);
			},
			error : function(){
				alert("파일전송 에러발생");
			}
		});
	});
	
	
	
});//onload-function end

//네비게이션의 검색 탭 누를경우
function showSearchChatInput(){
	var searchInputDiv = $("<div id='searchInput' align='center'></div>");
	var keywordSelect = $("<select name='keywordType' id='keywordType'></select>");
	var keywordOption1 = $("<option value='1'>내용</option>");
	var keywordOption2 = $("<option value='2'>작성자</option>");
	var searchChat = $("<input type='text' id='keyword' placeholder='검색어'>");
	var searchBtn = $("<button id='searchChatBtn' onclick='searchChatAndDraw();'>검색</button>");
	keywordSelect.append(keywordOption1);
	keywordSelect.append(keywordOption2);
	searchInputDiv.append(keywordSelect);
	searchInputDiv.append(searchChat);
	searchInputDiv.append(searchBtn);
	chatNavContent.append(searchInputDiv);
	searchListDiv = $("<div id='searchContent'></div>");
	chatNavContent.append(searchListDiv);
	var pageDiv = $("<div id='pageNav'></div>");
		
	chatNavContent.append(pageDiv);
	$("#keyword").keydown(function(key){
		if(key.keyCode==13){
			searchChatAndDraw();
		}
	})
}

//이 함수가 실행되면 검색된 키워드와 타입에 맞는 리스트와 페이징처리가 실행되야한다.
	function searchChatAndDraw(){
		searchListDiv.empty();
		var keywordType = $("#keywordType option:selected").val();
		var keyword = $("#keyword").val();
		var crNum = $("#crNum").val();
		$.ajax({
			url : "${contextPath}/searchChatList",
			dataType : "json",
			data : {"crNum":crNum,"keywordType":keywordType,"keyword":keyword},
			success : function(cm){
				var searchedInfo = cm.searchedCmList;
				$.each(searchedInfo,function(idx,item){
					addMsg(item,"searched");
				});
// 				var list = cm.searchedCmList;
// 				console.log(cm.searchedCmList);
// 				for(var i=0;i<searchedInfo.length;i++){
					
// 				}
			},
			error : function(){
				alert("페이징처리 에러발생");
			}
		});
}


//채팅방 안에 멤버리스트 보여주고 초대할수 있다
function showMemberList(){
	var inviteForm = $("<form id='inviteForm' action='inviteChatMember'></form>");
	var wsmListUL = $("<ul id='wsmListUL'></ul>");
	var hiddenTag = $("<input type='hidden' class='addCrNum' name='crNum' value='${chatRoom.crNum}'><input type='hidden' value='${wNum}' name='wNum' id='wNum'>");
	wsmListUL.append(hiddenTag);
	var wNum = $("#wNum").val();
	var crNum = $("#crNum").val();
	$.ajax({
		url : "showMemberListInChatRoom",
		data : {"wNum":wNum,"crNum":crNum},
		dataType : "json",
		success : function(jsonListMap){
			var wsmList = jsonListMap.wsmList;
			var crmList = jsonListMap.crmList;
			//채팅방에 있는사람
			$.each(crmList,function(idx,crmItem){
				var profileImgTag = "<div class='profileImg'><a href='#'><img alt='프로필사진' src='/Colla_project/showProfileImg?num="+crmItem.num+"'></a></div>";
				var crMemberLI = $("<li>"+profileImgTag+"<div class='memberNameInSlideMenu'>"+crmItem.name+"</div></li>");
				wsmListUL.append(crMemberLI);
				<%--가운데 hr 선 하나 넣자!--%>
			});
			//채팅방에 없는사람(ws멤버인사람)
			$.each(wsmList,function(idx,item){
				var profileImgTag = "<div class='profileImg'><a href='#'><img alt='프로필사진' src='/Colla_project/showProfileImg?num="+item.num+"'></a></div>";
				var wsMemberLI = $("<label><li>"+profileImgTag+"<div class='memberNameInSlideMenu'><input type='checkbox' value='"+item.num+"' name='wsmList'>"+item.name+"<div class='checked-member'><i class='fas fa-check'></i><div>"+"</div></li></label>");
				wsmListUL.append(wsMemberLI);
			});
			
			inviteForm.append(wsmListUL);
			var isDefault = $("#isDefault").val();
			if(isDefault==0){
				var inviteBtn = $("<div align='center'><button type='submit'>선택한 멤버 초대하기</button></div>");
				inviteForm.append(inviteBtn);	
			}
			chatNavContent.append(inviteForm);
			//체크박스에 클릭된 멤버들 클래스를 다르게 줘서 색깔바꾸기
			$("#wsmListUL label").on("click",function(){
				var checkedMember = $("input:checkbox[name='wsmList']:checked").next();
				checkedMember.css({display : 'inline-block'});
				var noneCheckedMember = $("input:checkbox[name='wsmList']:not(:checked)").next();
				noneCheckedMember.hide();
			});
		},
		error : function(){
			alert("멤버리스트 불러오기 에러발생");
		}
	});
}
	
	//code형태 메세지 보내기
	function sendCode(){
		var code = editor.getValue();
 		//alert("userEmail :"+$("#userEmail").val()+", crNum : "+$("#crNum").val()+", code : "+code+", type : "+type);
		if(type.includes('/')){
			type = 'java';
		}
		stompClient.send("/client/sendCode/"+$("#userEmail").val()+"/"+$("#crNum").val()+"/"+type,{},code);
		$("#addCodeModal").fadeOut(300);
	}

	//파일형태 메세지 보내기
	function sendFile(fileName,originName,cmNum){
		stompClient.send("/client/sendFile/"+$("#userEmail").val()+"/"+$("#crNum").val()+"/"+cmNum+"/"+originName,{},fileName);
	}
	
	//map형태 메세지 보내기 
	function sendMap(placePosition){
		stompClient.send("/client/sendMap/"+$("#userEmail").val()+"/"+$("#crNum").val(),{},placePosition);
	}
	
//과거메세지 불러오기
function loadChatFromDB(){
	var crNum = $("#crNum").val();
	$.ajax({
		url : "${contextPath}/loadPastMsg",
		data : {"crNum":crNum},
		dataType :"json",
		success : function(d){
			$.each(d,function(idx,item){
				addMsg(item);
				chatArea.scrollTop($("#chatArea")[0].scrollHeight);
			});
		},
		error : function(){
			alert("채팅내역 불러오기 실패");
		}
	});
}

	//일반 메세지 보내기
	function sendMsg(){
		var msg = $("#chatInput").val();
		stompClient.send("/client/send/"+$("#userEmail").val()+"/"+$("#crNum").val(),{},msg);
		$("#chatInput").val("");
	}
	
	//즐겨찾기 등록,해제
	var favoriteResult;
	var cmNum;
	function chatFavorite(e){ 
	   var favoriteClassName = $(e).attr('class');
	   cmNum = $(e).attr('value');
	   if(favoriteClassName == "chatFavorite"){
	   	  $(".chatFavorite[value='"+cmNum+"']").addClass('on');
	      favoriteResult = 1;
	   }else{
	   	  $(".chatFavorite[value='"+cmNum+"']").removeClass('on');
	      favoriteResult = 0;
	   }

	   $.ajax({
	      url : "${contextPath}/chatFavorite",
	      data : {"favoriteResult" : favoriteResult,"cmNum":cmNum},
	      type : "post"
	   });//end ajax
	   
	   
	}//end favoirte()
	
	//받은 메시지 화면에 추가
	function addMsg(msgInfo, area){
		var msgType;
		var isFavoriteClass=(msgInfo.isFavorite == 0)?"chatFavorite":"chatFavorite on";
		if(msgInfo.mName == $("#userName").val()){
			msgType="myMsg";
		} else {
			msgType = "chatMsg";
		}
		var chatMsg = $("<div class='"+msgType+"'></div>");
		var imgTag = "<img alt='"+msgInfo.mName+"님의 프로필 사진' src='${contextPath}/showProfileImg?num="+ msgInfo.mNum+ "'></a>";
		var favorite = "<div class='"+isFavoriteClass+"' onclick='chatFavorite(this)' value = '"+ msgInfo.cmNum +"'></div>"; //즐겨찾기 아이콘
		var originName = getOriginName(msgInfo.cmContent);
		var date = new Date(msgInfo.cmWriteDate);
		var writeTime = date.getFullYear()+"-"+date.getMonth()+"-"+date.getDay()+" "+date.getHours()+"시"+date.getMinutes()+"분";

		var contentStr;
		var codeType;
		if(msgInfo.cmType=='message'){
			contentStr = msgInfo.cmContent;
		}else if(msgInfo.cmType=='file'){
			contentStr = "<a href='${contextPath}/download?name="+msgInfo.cmContent+"'>"+originName+"</a>";
		}else if(msgInfo.cmType.includes('code')){
			var cmType = msgInfo.cmType;
			codeType = cmType.substring(cmType.indexOf("_")+1);
			var contentStr = "<textarea class='codeMsg' id='codeMsg'>"+msgInfo.cmContent+"</textarea>";
		}else if(msgInfo.cmType=='map'){
			var contentStr = "<div id='staticMap"+msgInfo.cmNum+"' class='staticMap'>"+
								"<div class='staticMapInfo'>" + 
									"<p id='placeName"+msgInfo.cmNum+"' class='placeName'></p>"+
									"<p id='placeAddr"+msgInfo.cmNum+"' class='placeAddr'></p>"+
								"</div>"+
							 "</div>";
		}
		
		chatMsg.append("<div class='profileImg'><a href='#' class='openMemberInfo'>"+imgTag+"</a></div>");
		chatMsg.append("<div class='onlyMsgBox'><div class='name'><p>"+msgInfo.mName
				+"<span class='date'>"+writeTime
				+"</span></p></div>"+favorite+"<br><p class='content'>"
				+ contentStr
				+"</p></div>");
		chatArea.append(chatMsg);
// 		console.log(chatArea);
		
		if(msgInfo.cmType.includes('code')){
			console.log(chatArea.find("textarea:last()"));
			var codeMsg = CodeMirror.fromTextArea( chatArea.find("textarea:last()")[0] ,{
				mode : codeType,
				theme : "gruvbox-dark",
				lineNumbers : true,
				autoCloseTags : true,
				readOnly : true
			});
			
			//줄 길이에 따른 codeMsg box height 조정
			var height;
			var lineCount = codeMsg.lineCount();
			if(lineCount == 1){
				height = 40 * lineCount;
			}
			else if(lineCount < 3 && lineCount >=2){
				height = 35 * lineCount;
			}
			else if(lineCount < 10 && lineCount >=3){
				height = 30 * lineCount;
			}
			else if(lineCount <= 20 && lineCount >=10) {
				height = 17 * lineCount;
			} else {
			    height = 350;
			}
			codeMsg.setSize("100%", height);
		}
		
		//static Map
		if(msgInfo.cmType == 'map'){
			var staticMapContainer;
			var positionArr = (msgInfo.cmContent).split("_");   
			var staticMapmarkerPosition = new kakao.maps.LatLng(positionArr[1], positionArr[0]); 
			var staticMapmarker = {
			    position: staticMapmarkerPosition
			};
			staticMapContainer  = document.getElementById('staticMap'+msgInfo.cmNum), // 이미지 지도를 표시할 div
			staticMapOption = { 
				center: new kakao.maps.LatLng(positionArr[1], positionArr[0]),	
				level: 3, // 이미지 지도의 확대 레벨
				marker: staticMapmarker
		    };
			// 이미지 지도를 표시할 div와 옵션으로 이미지 지도를 생성합니다
			//var staticMap = new kakao.maps.StaticMap(staticMapContainer, staticMapOption);
			//"<div class='staticMapInfo'><p class='placeName'></p><p class='placeAddr'></p></div>"+
			//"#placeAddr"+msgInfo.cmNum
			$("#placeName"+msgInfo.cmNum).text(positionArr[2]);
			$("#placeAddr"+msgInfo.cmNum).text(positionArr[3]);
			var staticMap = new kakao.maps.StaticMap(staticMapContainer, staticMapOption);
		}
		
		if(!area){
			chatArea.append(chatMsg);
		}else{
			if(area=="true"){
			chatNavContent.append(chatMsg[0]);				
			}else if(area=="searched"){
			searchListDiv.append(chatMsg[0]);	
			}
		}
		
	}
	
	//즐겨찾기 리스트 그리기
	function showFavoriteList(){
		var crNum = $("#crNum").val();
		$.ajax({
			url : "${contextPath}/showChatFavoriteList",
			data : {"crNum":crNum},
			type : "post",
			dataType :"json",
			success : function(messageList){
				console.log(messageList);
				for(var i=0; i<messageList.length; i++){
					addMsg(messageList[i], "true");
				}
			},
			error : function(){
				alert("즐겨찾기 리스트 불러오기 실패");
			}
		});//end ajax
	}//end function

	function getOriginName(fileName){
		var idx = (fileName.indexOf("_")) + 1;
		var originName= fileName.substring(idx);
		return originName;
	}
	
	//////////////////////////////////////////////////////////지도//////////////////////////////////////////////////////////////////
	function showMap(){

		var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
		    mapOption = {
		        center: new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표
		        level: 3
		    };  

		// 지도를 생성합니다    
		map = new kakao.maps.Map(mapContainer, mapOption);
		//map.setDraggable(false);

		// 장소 검색 객체를 생성합니다
		ps = new kakao.maps.services.Places();  

		// 검색 결과 목록이나 마커를 클릭했을 때 장소명을 표출할 인포윈도우를 생성합니다  //인포윈도우 생성	
/* 		infowindow = new kakao.maps.InfoWindow({
			content : content,
			removable : iwRemoveable,
			zIndex:1
			}); */

		// 키워드로 장소를 검색합니다
		searchPlaces();
		
	}
	// 키워드 검색을 요청하는 함수입니다
	function searchPlaces() {
	    var keyword = document.getElementById('keyword').value;

	    if (!keyword.replace(/^\s+|\s+$/g, '')) {
	        alert('키워드를 입력해주세요!');
	        return false;
	    }

	    // 장소검색 객체를 통해 키워드로 장소검색을 요청합니다
	    ps.keywordSearch( keyword, placesSearchCB); 
	}
	
	function placesSearchCB(data, status, pagination) {
	    if (status === kakao.maps.services.Status.OK) {

	        // 정상적으로 검색이 완료됐으면
	        // 검색 목록과 마커를 표출합니다
	        displayPlaces(data);

	        // 페이지 번호를 표출합니다
	        displayPagination(pagination);

	    } else if (status === kakao.maps.services.Status.ZERO_RESULT) {

	        alert('검색 결과가 존재하지 않습니다.');
	        return;

	    } else if (status === kakao.maps.services.Status.ERROR) {

	        alert('검색 결과 중 오류가 발생했습니다.');
	        return;

	    }
	}

	// 검색 결과 목록과 마커를 표출하는 함수입니다
	function displayPlaces(places) {

	    var listEl = document.getElementById('placesList'), 
	    menuEl = document.getElementById('menu_wrap'),
	    fragment = document.createDocumentFragment(), 
	    bounds = new kakao.maps.LatLngBounds(), 
	    listStr = '';
	    
	    // 검색 결과 목록에 추가된 항목들을 제거합니다
	    removeAllChildNods(listEl);

	    // 지도에 표시되고 있는 마커를 제거합니다
	    removeMarker();
	    
	    for ( var i=0; i<places.length; i++ ) {

	        // 마커를 생성하고 지도에 표시합니다
	        var placePosition = new kakao.maps.LatLng(places[i].y, places[i].x),
	            marker = addMarker(placePosition, i), 
	            itemEl = getListItem(i, places[i]); // 검색 결과 항목 Element를 생성합니다

	        // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
	        // LatLngBounds 객체에 좌표를 추가합니다
	        bounds.extend(placePosition);

	        // 마커와 검색결과 항목에 mouseover 했을때
	        // 해당 장소에 인포윈도우에 장소명을 표시합니다
	        // mouseout 했을 때는 인포윈도우를 닫습니다
	        (function(marker, places) {
	            kakao.maps.event.addListener(marker, 'click', function() {
	            	if(clickedOverlay!=null){
	            		console.log("null이 아닙니다");
	            		clickedOverlay.setMap(null);
	            	}
	            	map.setCenter(new kakao.maps.LatLng(places.y, places.x));
	            	displayOverlay(marker, places);
	                clickedOverlay = overlay;
	            });

	            itemEl.onclick =  function () {
	            	//displayInfowindow(marker, title);
	            	if(clickedOverlay!=null){
	            		console.log("null이 아닙니다");
	            		clickedOverlay.setMap(null);
	            	}
	            	map.setCenter(new kakao.maps.LatLng(places.y, places.x));
	            	displayOverlay(marker, places);
	                clickedOverlay = overlay;
	            };

	        })(marker, places[i]);

	        fragment.appendChild(itemEl);
	    }

	    // 검색결과 항목들을 검색결과 목록 Elemnet에 추가합니다
	    listEl.appendChild(fragment);
	    menuEl.scrollTop = 0;

	    // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
	    map.setBounds(bounds);
	}

	// 검색결과 항목을 Element로 반환하는 함수입니다
	function getListItem(index, places) {

	    var el = document.createElement('li'),
	    itemStr = '<span class="markerbg marker_' + (index+1) + '"></span>' +
	                '<div class="info">' +
	                '   <h5>' + places.place_name + '</h5>';

	    if (places.road_address_name) {
	        itemStr += '    <span>' + places.road_address_name + '</span>' +
	                    '   <span class="jibun gray">' +  places.address_name  + '</span>';
	    } else {
	        itemStr += '    <span>' +  places.address_name  + '</span>'; 
	    }
	                 
	      itemStr += '  <span class="tel">' + places.phone  + '</span>' +
	                '</div>';           

	    el.innerHTML = itemStr;
	    el.className = 'item';

	    return el;
	}

	// 마커를 생성하고 지도 위에 마커를 표시하는 함수입니다
	function addMarker(position, idx, title) {
	    var imageSrc = 'http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png', // 마커 이미지 url, 스프라이트 이미지를 씁니다
	        imageSize = new kakao.maps.Size(36, 37),  // 마커 이미지의 크기
	        imgOptions =  {
	            spriteSize : new kakao.maps.Size(36, 691), // 스프라이트 이미지의 크기
	            spriteOrigin : new kakao.maps.Point(0, (idx*46)+10), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
	            offset: new kakao.maps.Point(13, 37) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
	        },
	        markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions),
	            marker = new kakao.maps.Marker({
	            position: position, // 마커의 위치
	            image: markerImage,
	            clickable: true
	        });

	    marker.setMap(map); // 지도 위에 마커를 표출합니다
	    markers.push(marker);  // 배열에 생성된 마커를 추가합니다

	    return marker;
	}

	// 지도 위에 표시되고 있는 마커를 모두 제거합니다
	function removeMarker() {
	    for ( var i = 0; i < markers.length; i++ ) {
	        markers[i].setMap(null);
	    }   
	    markers = [];
	}

	// 검색결과 목록 하단에 페이지번호를 표시는 함수입니다
	function displayPagination(pagination) {
	    var paginationEl = document.getElementById('pagination'),
	        fragment = document.createDocumentFragment(),
	        i; 

	    // 기존에 추가된 페이지번호를 삭제합니다
	    while (paginationEl.hasChildNodes()) {
	        paginationEl.removeChild (paginationEl.lastChild);
	    }

	    for (i=1; i<=pagination.last; i++) {
	        var el = document.createElement('a');
	        el.href = "#";
	        el.innerHTML = i;

	        if (i===pagination.current) {
	            el.className = 'on';
	        } else {
	            el.onclick = (function(i) {
	                return function() {
	                    pagination.gotoPage(i);
	                }
	            })(i);
	        }

	        fragment.appendChild(el);
	    }
	    paginationEl.appendChild(fragment);
	}

	// 검색결과 목록 또는 마커를 클릭했을 때 호출되는 함수입니다
	// 인포윈도우에 장소명을 표시합니다
/* 	function displayInfowindow(marker, title) {
	    var content = '<div style="padding:5px;z-index:1;">' + title + '</div>',iwRemoveable = true;;
	    var iwContent = '<div style="padding:5px;z-index:1;">' + title + '</div>', // 인포윈도우에 표출될 내용으로 HTML 문자열이나 document element가 가능합니다
	    iwRemoveable = true; // removeable 속성을 ture 로 설정하면 인포윈도우를 닫을 수 있는 x버튼이 표시됩니다
		
	    infowindow = new kakao.maps.InfoWindow({
	    	 content : iwContent,
	    	 removable : iwRemoveable,
	    	 zIndex:1
			});
	    infowindow.open(map, marker);
	} */
	
	function displayOverlay(marker, places) {
		var overlayContent = 
			"<div class='overlayWrap'>" +
				"<div class='overlayInfo'>" +
					"<div class='placeName'>" + places.place_name + 
						"<div class='overlayClose' onclick='closeOverlay()' title='닫기'></div>" +
					"</div>" +
			
					"<div class='overlayBody'>" + 
						"<div class='desc'>"+
							"<div class='ellipsis'>" + places.road_address_name +
								"<div class='jibun ellipsis'>" + places.address_name +"</div>" +
								"<div class='phone'>" + places.phone +"</div>" +
								"<div id='mapUpload' class='link' onclick='mapUpload("+places.x+","+places.y+",\""+places.place_name+"\",\""+places.road_address_name+"\")'>공유하기</div>"+
							"</div>" +
						"</div>" +
					"</div>" +
				"</div>" +
			"</div>";


       overlay = new kakao.maps.CustomOverlay({
	    	 content : overlayContent,
	    	 map: map,
	    	 position: marker.getPosition()
			});
	    overlay.setMap(map);
	}
	
	
	function closeOverlay() {
	    overlay.setMap(null);     
	}

	 // 검색결과 목록의 자식 Element를 제거하는 함수입니다
	function removeAllChildNods(el) {   
	    while (el.hasChildNodes()) {
	        el.removeChild (el.lastChild);
	    }
	}

	
	//지도 공유하기 버튼 눌렸을 경우
	function mapUpload(placeX,placeY,placeName,placeAddress){
		
		sendMap(placeX+"_"+placeY+"_"+placeName+"_"+placeAddress); 
		$("#addLocationModal").fadeOut(300);
		return false;
	}
	
	
</script>

<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.5.0/styles/androidstudio.min.css">
<script src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.5.0/highlight.min.js"></script>
<script>hljs.initHighlightingOnLoad();</script>
</head>
<body>
<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp" %>
<%@ include file="/WEB-INF/jsp/inc/navWs.jsp" %>
	<div id="wsBody">
		<input type="hidden" value="chatroom" id="pageType">
		<input type="hidden" value="${chatRoom.crIsDefault}" id="isDefault">
		<input type="hidden" value="${chatRoom.crName}" id="crName">
		<input type="hidden" value="${sessionScope.user.name}" id="userName">
		<input type="hidden" value="${sessionScope.user.email}" id="userEmail">
		<input type="hidden" value="${chatRoom.crNum}" id="crNum">
		<input type="hidden" value="${wNum}" name="wNum" id="wNum">
		<div class="chatArea">
			
			<div class="chat" id="chatArea">
			<div id="chatNavBox">
				<div id="openChatNavBox"></div><!-- 슬라이드 메뉴 열 수 있는 띠 -->
				<div id="chatNav" align="center">
					<ul id="InnerBtns">
						<li class="navInnerBtn"><label class="clicked"><input type="radio" name="innerBtn" value="favorite" checked>즐겨찾기</label></li>
						<li class="navInnerBtn"><label class="none-clicked"><input type="radio" name="innerBtn" value="memberManagement">멤버관리</label></li>
						<li class="navInnerBtn"><label class="none-clicked"><input type="radio" name="innerBtn" value="search">검색</label></li>
						<li class="navInnerBtn"><label class="none-clicked"><input type="radio" name="innerBtn" value="canvas">캔버스</label></li>
					</ul>
				<div id="chatNavContent" align="left"></div>
				</div>
			</div>
			<script>
				var toggleVal = 0;
				$("#openChatNavBox").on("click",function(){
					//navBox 토글로 숨기고 열기
					if(toggleVal==0){
						$("#chatNavBox").animate({right: 0},200);
							toggleVal = 1;						
					}else{
						$("#chatNavBox").animate({right: -590},200);
							toggleVal = 0;						
					}
				});
				//navType에 맞는 액션
				$(function(){
					showFavoriteList();
					$("input[name='innerBtn']").click(function(){
						var navType = $('input:radio[name="innerBtn"]:checked').val();
						var labelType = $('input:radio[name="innerBtn"]:checked').parent();
						var anotherLabelType = $('input:radio[name="innerBtn"]:not(:checked)').parent();
						if(navType=='favorite'){
							chatNavContent.empty();
					 		showFavoriteList();		
						}else if(navType=='memberManagement'){
							chatNavContent.empty();
							chatNavContent.append("<p class='navInfoMsg'>채팅방에 멤버를 추가할 수 있습니다<br>현재 워크스페이스 멤버만 표시됩니다.</p>");
							showMemberList();
						}else if(navType=='search'){
							chatNavContent.empty();
							chatNavContent.append("<p class='navInfoMsg'>키워드로 채팅방내용을 검색하세요</p>");
							showSearchChatInput();
						}else if(navType=='canvas'){
							chatNavContent.empty();
							chatNavContent.append("<p class='navInfoMsg'>캔버스</p>");
							
						}else{
							chatNavContent.empty();
						}
						labelType.attr('class','clicked');
						anotherLabelType.attr('class','none-clicked');
					});
					
				});
				
			</script>
			</div>
			<div class="attachDetail">
				<div class="attach"><a href="#" class="openFileUploadModal">파일첨부</a></div>
				<div class="attach"><a href="#" class="openCodeModal">코드첨부</a></div>
				<div class="attach"><a href="#" class="openLocationModal">지도첨부</a></div>
			</div>
			<div id="inputBox">
				<div id="chatInputInstance">
				<a href="#" id="attachBtn">첨부파일</a>
				<textarea id="chatInput" placeholder="메세지 작성부분"></textarea>
				<a id="sendChat" href="#">전송</a>
				</div><!-- chatInputInstance end -->
			</div><!-- inputBox end -->
		</div>
		
		
		<%---------------------------------------------파일첨부 모달 ----------------------------------------------------%>
		<div id="addFileModal" class="attachModal">
			<div class="modalHead">
				<h3 style="font-weight: bolder; font-size: 30px">파일 업로드</h3>
			</div>
			<br><br>
			<div class="modalBody">
				<p>업로드 할 파일을 선택하세요</p>
				<form id="addFileForm" method="post" enctype="multipart/form-data">
					<input type="hidden" class="addCrNum" name="crNum" value="${chatRoom.crNum}">
					<input type="hidden" value="${wNum}" name="wNum">
					<input type="hidden" value="${sessionScope.user.num}" name="mNum">
					<input type="hidden" value="${_csrf.token}" name="${_csrf.parameterName}">
					<br><br>
					<div class="addFileInputWrap">
						<div class="row">
							<input type="file" class="btnFile" name="chatFile" value="파일 선택" accept="image/*" multiple>
						</div>
					</div> <!-- end addFileInputWrap -->

					<div id="innerBtn">
						<a href="#" class="fileUploadBtn">업로드</a><br> 
						<a href="#" class="closeFileModal">닫기</a>
					</div>
				</form>
			</div> <!-- end modalBody -->
		</div><!-- end addFileModal -->
		
		
		<%---------------------------------------------코드첨부 모달 ----------------------------------------------------%>
		<div id="addCodeModal" class="attachModal">
			<div class="modalHead" align="center">
				<h3 style="font-weight: bolder; font-size: 30px">코드 업로드</h3>
			</div>
			<br><br>
			<div class="modalBody">
					<div class="row">
						<select name="codeType" id="codeType">
							<option value="text/x-java">java</option>
							<option value="javascript">javascript</option>
							<option value="css">css</option>
							<option value="xml">xml</option>
							<option value="sql">sql</option>
							<option value="php">php</option>
						</select>
<!-- 						<div id="selectCodeType"> -->
<!-- 							<input type="radio" class="radioType" name="codeType" value="text/x-java" checked/>JAVA -->
<!-- 							<input type="radio" class="radioType" name="codeType" value="javascript"/> JAVA Script -->
<!-- 							<input type="radio" class="radioType" name="codeType" value="css"/>CSS -->
<!-- 							<input type="radio" class="radioType" name="codeType" value="xml"/>XML -->
<!-- 							<input type="radio" class="radioType" name="codeType" value="sql"/>SQL -->
<!-- 							<input type="radio" class="radioType" name="codeType" value="php"/>PHP -->
<!-- 						</div> -->
						<textarea id="editor"></textarea>
						<script>
							var type = $("#codeType option:selected").val();
// 							var type;
// 							$(function(){
// 								type = $('input:radio[name="codeType"]:checked').val();	
// 								$("input[name='codeType']").click(function(){
// 									type = $('input:radio[name="codeType"]:checked').val();
// 									editor.setOption("mode", type);
// 									console.log(type);
// 								});
// 								editor = CodeMirror.fromTextArea($('#editor')[0],{
// 									mode : type,
// 									theme : "gruvbox-dark",
// 									lineNumbers : true,
// 									autoCloseTags : true
// 								});
// 								editor.setSize("500", "300");
								
// 							});
							editor = CodeMirror.fromTextArea($('#editor')[0],{
								mode : type,
								theme : "gruvbox-dark",
								lineNumbers : true,
								autoCloseTags : true
							});
							editor.setSize("500", "300");
						</script>
					</div>
					<div id="innerBtn"  align="center">
					<a href="#" class="codeUpload">업로드</a><br> 
					<a href="#" class="closeCodeModal">닫기</a><br>
					</div>
			</div> <!-- end modalBody -->
		</div><!-- end addCodeModal -->
		
		
		<%---------------------------------------------지도첨부 모달 ----------------------------------------------------%>
		<div id="addLocationModal" class="attachModal">
			<div class="modalHead">
				<h3 style="font-weight: bolder; font-size: 30px">지도 업로드</h3>
			</div>
			<br><br>
			<div class="modalBody">
				<p>멤버들과 위치를 공유할 수 있습니다</p>
				<div class="map_wrap">
					<div id="map"></div>
					<div id="menu_wrap" class="bg_white">
						<div class="option">
							<div>
								<form onsubmit="searchPlaces(); return false;">
									키워드 : <input type="text" value="이태원 맛집" id="keyword" size="15">
									<button type="submit">검색하기</button>
								</form>
							</div>
						</div>
						<hr>
						<ul id="placesList"></ul>
						<div id="pagination"></div>
					</div>
				</div>
				<div id="innerBtn">
						<a href="#" class="closeLocationModal">닫기</a>
				</div>
			</div> <!-- end modalBody -->
		</div><!-- end addLocationModal -->
		<%---------------------------------------------회원정보 모달 ----------------------------------------------------%>
		<div id="memberInfoModal" class="attachModal">
			<div class="modalHead">
				<h3 style="font-weight: bolder; font-size: 30px">회원정보</h3>
			</div>
			<br><br>
			<div class="modalBody">
				<p>회원정보입니다</p>
					<div class="row">
					<p>내용~</p>
					</div>
					<a href="#" class="closeMemberInfo">닫기</a><br>
			</div> <!-- end modalBody -->
		</div><!-- end memberInfoModal -->
		
		
	</div><!-- end wsBody -->
</body>
</html>