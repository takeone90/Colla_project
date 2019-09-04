<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script>
<script>
var chatArea = $(".chat");
$(function(){
   //헤더에 채팅방과 워크스페이스 정보 바꾸기
   var isDefault = $("#isDefault").val();
   if(isDefault==1){ //기본채팅방이면
      $("#chatRoomInfo > p").text("기본채팅방");
      $(".addCrMember").hide();
   }else{
       var crName = $("#crName").val();
       $("#chatRoomInfo > p").text(crName);
   }
   
   //Chat Member추가 모달
   $(".openAddCrMemberModal").on("click",function(){
      $("#addCrMemberModal").fadeIn(300);
   });
   $("#closeCrMemberModal").on("click",function(){
      $("#addCrMemberModal").fadeOut(300);
      return false;
   });
   
   
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
   });
   $(".closeLocationModal").on("click",function(){
      $("#addLocationModal").fadeOut(300);
      return false;
   });
   
   //모달 바깥쪽이 클릭되거나 다른 모달이 클릭될때 현재 모달 숨기기
   $("#wsBody").mouseup(function(e){
      if($("#addCrMemberModal").has(e.target).length===0)
         $("#addCrMemberModal").fadeOut(300);
      if($("#addFileModal").has(e.target).length===0)
         $("#addFileModal").fadeOut(300);
      if($("#addCodeModal").has(e.target).length===0)
         $("#addCodeModal").fadeOut(300);
      if($("#addLocationModal").has(e.target).length===0)
         $("#addLocationModal").fadeOut(300);
      return false;
   });
   //첨부파일Detail 숨기고 닫기
   $("#attachBtn").on("click",function(){
      $(this).prev().toggle(300);
      return false;
   });
   
   <%--채팅 연결 및 전송--%>
   chatArea = $(".chat");
//    connect();
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
   
   //과거메세지 불러오기
   var crNum = $("#crNum").val();
   $.ajax({
      url : "${contextPath}/loadPastMsg",
      data : {"crNum":crNum},
      dataType :"json",
      success : function(d){
         $.each(d,function(idx,item){
            var originName; 
            if(item.cmType=='file'){
               originName = item.cmContent.substring(item.cmContent.indexOf("_")+1);
            }
            var writeDate = new Date(item.cmWriteDate);
            var writeTime = writeDate.getFullYear()+"-"+writeDate.getMonth()+"-"+writeDate.getDay()+" "+writeDate.getHours()+"시"+writeDate.getMinutes()+"분";
            //loadPastMsg(item.cmType,item.mName,item.cmContent,writeTime,originName);
            loadPastMsg(item.cmType,item.mName,item.cmContent,writeTime,originName,item.cmNum);//미경 시작 ~ 끝
            chatArea.scrollTop($("#chatArea")[0].scrollHeight);
         });
      },
      error : function(){
         alert("채팅내역 불러오기 실패");
      }
   });
   

   //파일업로드에서 업로드 <a>태그가 눌렸을때
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
//파일형태 메세지 보내기
function sendFile(fileName,originName,cmNum){
   stompClient.send("/client/sendFile/"+$("#userEmail").val()+"/"+$("#crNum").val()+"/"+cmNum+"/"+originName,{},fileName);
}
   
   <%-------------------------------------------------------WebSocket 연결부분은 headerWs로 넘어갔습니다.-----------------------------------------------------%>
   //일반 메세지 보내기
   function sendMsg(){
      var msg = $("#chatInput").val();
      stompClient.send("/client/send/"+$("#userEmail").val()+"/"+$("#crNum").val(),{},msg);
      $("#chatInput").val("");
   }
   
//미경 시작
//즐겨찾기 등록,해제를 하는 함수
var favoriteResult;
var favoriteCmNum;
function chatFavorite(e){
   var favoriteClassName = $(e).attr('class');
   if(favoriteClassName == "chatFavorite"){
      $(e).attr('class','chatFavoriteOn');
      favoriteCmNum = $(e).attr('value');
      favoriteResult = 1;
   }else{
      $(e).attr('class','chatFavorite');
      favoriteCmNum = $(e).attr('value');
      favoriteResult = 0;
   }
   console.log("cmNum :" + favoriteCmNum);
   console.log("결과 :" + favoriteResult);
   $.ajax({
      url : "${contextPath}/chatFavorite",
      data : {"favoriteResult" : favoriteResult,"favoriteCmNum":favoriteCmNum},
      type : "post",
      dataType : "json",
      success : function(result){
         if(result){
            alert("컨트롤 입성 성공!");
         }
      }
   });//end ajax
}//end favoirte()
//미경 끝
//    메시지 박스 태그를 생성하는 함수
   //function appendMsg(msgType,type,userId,msg,writeTime,originName){
   function appendMsg(msgType,type,userId,msg,writeTime,originName,cmNum){//미경 시작 ~ 끝
      var chatMsg = $("<div class='"+msgType+"'></div>");
      if(type=='message'){
         chatMsg.append("<div class='profileImg'><a href='#'><img alt='' src=''></a></div>");
         //미경 시작
         var favorite = "<div class='chatFavorite' onclick='chatFavorite(this)' value = '"+ cmNum +"'></div>"; //즐겨찾기 아이콘
         chatMsg.append("<div class='name'><p>"+userId+" <span class='date'>"+writeTime+"</span><span>"+favorite+"</span></p></div><br>");
         //미경 끝
         chatMsg.append("<p class='content'>"+msg+"</p>");
         chatArea.append(chatMsg);
      }else if(type=='file'){
         chatMsg.append("<div class='profileImg'><a href='#'><img alt='' src=''></a></div>");
         chatMsg.append("<div class='name'><p>"+userId+" <span class='date'>"+writeTime+"</span></p></div><br>");
         chatMsg.append("<p class='content'><a href='${contextPath}/download?name="+msg+"'>"+originName+"</a></p>");
         chatArea.append(chatMsg);
      }
      
      
   }
   //받은 메시지 화면에 추가
   function addMsg(type,userId,msg,writeTime,originName){
      var msgType = "chatMsg";
      appendMsg(msgType,type,userId,msg,writeTime,originName);
   }
   //내가 쓴 메시지 화면에 추가
   function addMyMsg(type,userId,msg,writeTime,originName){
      var msgType = "myMsg";
      appendMsg(msgType,type,userId,msg,writeTime,originName);
   }
   //과거 메시지 화면에 추가
   //function loadPastMsg(type,userId,msg,writeTime,originName){
   function loadPastMsg(type,userId,msg,writeTime,originName,cmNum){//미경 시작 ~ 끝
      var myId = $("#userName").val();
      var msgType;
      if(userId == myId){//지금은 불러온 메세지중에 작성자 이름이 현재 로그인되있는 이름과같으면 myMsg 로 처리함
         msgType = "myMsg";
      }else{
         msgType = "chatMsg";
      }
      //appendMsg(msgType,type,userId,msg,writeTime,originName);
      appendMsg(msgType,type,userId,msg,writeTime,originName,cmNum);//미경 시작 ~ 끝
   }   
   
   
</script>
</script>
</head>
<body>

</body>
</html>