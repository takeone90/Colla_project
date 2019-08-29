/**
 * boardReply.js
 */
function addReply(){
	let data = $("#addReplyDiv").serialize();
	$.ajax({
		url:"../reply/add/"+bNum,
		data: data,
		type:"post",
		dataType:"json",
		success: function(){
			alert("성공");
		}, error : function(){
			alert("실패");
		}
	});
}
function date_to_str(format) {
	var year = format.getFullYear();
	var month = format.getMonth() + 1;
	if (month < 10)
		month = '0' + month;
	var date = format.getDate();
	if (date < 10)
		date = '0' + date;
	var hour = format.getHours();
	if (hour < 10)
		hour = '0' + hour;
	var min = format.getMinutes();
	if (min < 10)
		min = '0' + min;
	var sec = format.getSeconds();
	if (sec < 10)
		sec = '0' + sec;

	return year + "/" + month + "/" + date + " " + hour + ":" + min
			+ ":" + sec;
}
function loadReply(){
	$.ajax({
		url:"../reply/all/"+bNum,
		type: "get",
		dataType:"json",
		success: function(list){
			$("#replyBox").empty();
			$.each(list, function(index,item){
				let date = new Date(item.regdate);
				let li = '<li class="clearFix">';
				li += '<div class="replyImg"><img src="'+item.imgPath+'"></div>';
				li += '<div class="replyDetail">';
				li += '<p class="replyAuthor">';
				li += '<span>'+item.mName+'</span> ';
				li += '<span class="regdate">'+date_to_str(date)+'</span>';
				if(item.mNum == mNum){
					li += ' <a href="#">삭제</a>';
				}
				li += '</p><p class="replyContent">'+item.content+'</p></div></li>';
				$("#replyBox").append(li);
			});
		},
		error: function(){
			alert("Ajax error");
		}
	});
}

$(function(){
	loadReply();
})