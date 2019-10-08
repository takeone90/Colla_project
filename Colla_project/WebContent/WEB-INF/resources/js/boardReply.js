/**
 * boardReply.js
 */

var beforeModifyReply;

function creatModifyForm(target){
	let $target = $(target);
	let $detail = $(target).parent().parent(".replyDetail");
	let $content = $target.parent().next(".replyContent");
	beforeModifyReply = $target.parent().next(".replyContent").text();
	$content.hide();
	let $form = '<form id="modifyReplyDiv"> ';
	$form += '<textarea rows="3" name="rContent">'+beforeModifyReply+'</textarea> ';
//	$form += '<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"> ';
	$form += '<button onclick="modifyReply(this); return false;" class="btn">수정</button> ';
	$form += '<button onclick="cancleModify(this); return false;" class="btn">취소</button> ';
	$form += '</form>';
	$detail.children('#modifyReplyDiv').remove();
	$detail.append($form);
}

function cancleModify(target){
	let $target = $(target);
	let $detail = $(target).parent().parent(".replyDetail");
	let $content = $detail.children(".replyContent");
	$target.parent().remove();
	$content.show();
}

function modifyReply(target){
	let $form = $(target).parent("form");
	let rNum = $form.prev().prev().attr("data-rnum");
	$.ajax({
		url:"../reply/modify/"+rNum,
		data: $form.serialize() ,
		type:"post", //csrf?
		dataType:"text",
		success: function(result){
			loadReply();
			alert(result);
		}, error : function(){
			alert("Ajax 오류");
		}
	});
	return false;
}

function removeReply(target){
	let rNum = $(target).parent().attr("data-rnum");
	let answer = confirm("댓글을 삭제하시겠습니까?");
	if(answer){
		$.ajax({
			url:"../reply/remove/"+rNum,
			type:"post",//csrf?
			dataType:"text",
			success: function(result){
				loadReply();
				alert(result);
			}, error : function(){
				alert("Ajax 오류");
			}
		});
	}
	return false;
}

function addReply(){
	let data = $("#addReplyDiv").serialize();
	$.ajax({
		url:"../reply/add/"+bNum,
		data: data,
		type:"post",
		dataType:"text",
		success: function(result){
			loadReply();
			alert(result);
		}, error : function(){
			alert("Ajax 오류");
		}
	});
	return false;
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

	return year + "-" + month + "-" + date + " " + hour + ":" + min
			+ ":" + sec;
}

function loadReply(){
	$.ajax({
		url:"../reply/all/"+bNum,
		type: "get",
		dataType:"json",
		success: function(list){
			$("#replyBox").empty();
			if(list.length>0){
				$.each(list, function(index,item){
					let date = new Date(item.regdate);
					let li = '<li class="clearFix">';
					li += '<div class="replyImg profileImg" onclick="showProfileInfoModal('+item.mNum+')"><img src="/showProfileImg?num='+item.mNum+'"></div>';
					li += '<div class="replyDetail">';
					li += '<p class="replyAuthor" data-rNum="'+item.rNum+'">';
					li += '<span class="replyName">'+item.mName+'</span> ';
					li += '<span class="regdate">'+date_to_str(date)+'</span>';
					if(item.mNum == mNum){
						li += ' <a href="javascript:void(0)" onclick="creatModifyForm(this)">수정</a>';
						li += ' <a href="javascript:void(0)" onclick="removeReply(this)">삭제</a>';
					}
					li += '</p><p class="replyContent">'+item.content+'</p></div></li>';
					$("#replyBox").append(li);
				});
				$("textarea[name='rContent']").val("");
			}
		},
		error: function(){
			alert("Ajax error");
		}
	});
}

$(function(){
	loadReply();
});