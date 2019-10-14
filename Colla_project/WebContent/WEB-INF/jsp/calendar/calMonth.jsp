<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>calMonth</title>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/calMonth.css"/>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script type="text/javascript">
$(function() {
	$("#yearCalendar").hide();
	$("#changeYearCalToMonthCal").on("click", function() {
		$("#monthCalendar").show();
		$("#yearCalendar").hide();
	});
	$("#changeMonthCalToYearCal").on("click", function() {
		$("#yearCalendar").show();
		$("#monthCalendar").hide();
	});
});
//----------------------------------------------------------------------------월간 달력
var today = new Date();
var date = new Date();
var numOfWeekRow = 0;
$(function() {
	thisMonthCalendar(today);
	showSchedule(today);
	markingOnDate(formatChange(today));
	//모달 바깥 클릭 시 모달 닫기
	$("#wsBody").on("mousedown", function(e) {
		if(!$("#addForm").is(e.target) && $("#addForm").has(e.target).length===0)
			$("#addForm").fadeOut(1);
		if(!$("#detailForm").is(e.target) && $("#detailForm").has(e.target).length===0)
			$("#detailForm").fadeOut(1);
		if(!$("#modifyForm").is(e.target) && $("#modifyForm").has(e.target).length===0)
			$("#modifyForm").fadeOut(1);
	});
	
	//추가 모달 열기
	$("#addFormOpen").on("click", function() {
		$("#addForm").fadeIn(300);
		$("#startDate").val(formatChangeHyphen(new Date())); //오늘 날짜로 고정
		$("#endDate").val(formatChangeHyphen(new Date())); //오늘 날짜로 고정
	});
	//추가 모달 닫기
	$("#addFormClose").on("click", function() {
		$("#addForm").fadeOut(1);
		$(".addModal")[0].reset();
	});
	//추가 모달에서 연 반복 버튼 눌렀을 때 
	$("#addAnnually").on("change", function() {
		if($("#addAnnually").is(":checked")) {
			$("#endDate").val($("#startDate").val()); //종료일=시작일
			$("#endDate").prop("readonly", true); //종료일 입력 못하게 	
		} else {
			$("#endDate").prop("readonly", false);
		}
	});
	//추가 모달에서 월 반복 버튼 눌렀을 때 
	$("#addMonthly").on("change", function() {
		if($("#addMonthly").is(":checked")) {
			$("#endDate").val($("#startDate").val()); //종료일=시작일
			$("#endDate").prop("readonly", true); //종료일 입력 못하게 	
		} else {
			$("#endDate").prop("readonly", false);
		}
	});
	//추가
	$("#addSchedule").on("click", function() {
		var data = $(".addModal").serialize();
		$.ajax({
			url: "addSchedule",
			data: data,
			type: "post",
			dataType: "json",
			success: function(result) {
				if(result) {
					alert("추가 성공했습니다.");
					$("#addForm").fadeOut(1);
					thisMonthCalendar(today);
					showSchedule(today);
					thisYearCalendar(today);
					showYearSchedule(today);
					$(".addModal")[0].reset();
				} else {
					alert("추가 실패했습니다.");
				}
			}
		});
		return false;
	});
	//수정 모달 닫기
	$("#modifyFormClose").on("click", function() {
		$("#modifyForm").fadeOut(1);
		$(".modifyModal")[0].reset();
	});
	//수정 모달에서 연 반복 버튼 눌렀을 때 
	$("#modifyAnnually").on("change", function() {
		if($("#modifyAnnually").is(":checked")) {
			$("#modifyEndDate").val($("#modifyStartDate").val());
			$("#modifyEndDate").prop("readonly", true);
		} else {
			$("#modifyEndDate").prop("readonly", false);
		}
	});
	//수정 모달에서 월 반복 버튼 눌렀을 때 
	$("#modifyMonthly").on("change", function() {
		if($("#modifyMonthly").is(":checked")) {
			$("#modifyEndDate").val($("#modifyStartDate").val());
			$("#modifyEndDate").prop("readonly", true);
		} else {
			$("#modifyEndDate").prop("readonly", false);
		}
	});
	//수정
	$("#modifySchedule").on("click", function() {
		var data = $(".modifyModal").serialize();
		$.ajax({
			url: "modifySchedule",
			data: data,
			type: "post",
			dataType: "json",
			success: function(result) {
				if(result) {
					alert("수정 성공했습니다.");
					$("#modifyForm").fadeOut(1);
					thisMonthCalendar(today);
					showSchedule(today);
					thisYearCalendar(today);
					showYearSchedule(today);
					$(".modifyModal")[0].reset();
				} else {
					alert("수정 실패했습니다.");
				}
			}
		});
		return false;
	});
	//타입 지정
	$("#calType1").on("change", function() {
		thisMonthCalendar(today);
		showSchedule(today);
	});
	$("#calType2").on("change", function() {
		thisMonthCalendar(today);
		showSchedule(today);
	});
	$("#calType3").on("change", function() {
		thisMonthCalendar(today);
		showSchedule(today);
	});
	$("#calType4").on("change", function() {
		thisMonthCalendar(today);
		showSchedule(today);
	});
	//원하는 날짜로 달력 이동 - 월 달력
	$("#wantedCalendarButton").on("click", function() {
		moveToWantedCalendar($("#wantedYear").val(), $("#wantedMonth").val()-1, dateCalcul($("#wantedDate").val()));
	});
	//원하는 날짜로 달력 이동 - 연 달력
	$("#wantedCalendarButtonYear").on("click", function() {
		moveToWantedCalendarYear($("#wantedYearYear").val(), 0, 1); //해당년도의 1월 1일로 이동
	});
    $( ".datepicker" ).datepicker({
    	dateFormat: 'yy-mm-dd',
        changeMonth: true,
        changeYear: true
    });
});
function dateCalcul(date) {
	if(date == null || date == 0) {
		date = 1;
	} else if(date < 0) {
		date = Number(date)+1;
	}
	return date;
}
//드래그로 추가 모달 열기
function drag() {
	var startDate = 0;
	$(".drawMonthCalendarLower th, .drawMonthCalendarLower td:not(.middleTd)").on("mousedown", function(e) { 
		if(e.which === 1) { //마우스 왼쪽 클릭			
			startDate = $(this).attr("class");
		}
	});
	$(".drawMonthCalendarLower th, .drawMonthCalendarLower td:not(.middleTd)").on("mouseup", function(e) {
		if(e.which === 1) {				
			$("#addForm").fadeIn(300);
			$("#startDate").val(startDate);	
			$("#endDate").val($(this).attr("class"));
		}
	});	
}
function thisMonthCalendar(today) {
	console.log(formatChangeHyphen(today)+" 월 달력을 그렸습니다.");
	//달력 상단 날짜 그리기
	$("#YearTitle").html("<p style='font-size: 17px; margin-bottom: 6px;'>"+today.getFullYear()+"<p>");
	$("#MonthTitle").html((today.getMonth()+1)+"월");
	//달력 상단 요일 그리기
	var month = monthChange(today.getMonth()+1);
	var calendar = "<table class='drawMonthCalendarUpper'>";
	calendar += "<tr><th>일</th><th>월</th><th>화</th><th>수</th><th>목</th><th>금</th><th>토</th></tr>";
	calendar += "</table>";
	//달력 하단 날짜 그리기
	var numOfWeekRow = getNumOfWeekRow(today); //9월은 5줄
	var realStartDate = getRealStartDate(today); //9월은 190901
	var realLastDate = getRealLastDate(today); //9월은 191005
	for(var i=0; i<numOfWeekRow; i++) { //줄
		calendar += "<div class='drawMonthCalDiv'>";
		//table1
		calendar += "<table class='drawMonthCalendarLowerForClick'><tr>";
		for(var n=0; n<7; n++) {
			calendar += "<th id="+formatChange(realStartDate)+"></th>";
			realStartDate.setDate(realStartDate.getDate()+1);
		}
		realStartDate.setDate(realStartDate.getDate()-7);
		calendar += "</tr></table>";
		//table2 시작
		calendar += "<table class='drawMonthCalendarLower'>";
		calendar += "<tr class='drawMonthCalendarLowerDate' id="+today.getFullYear()+"-"+month+"-"+i+">";
		for(var j=0; j<7; j++) { //날짜 칸
			if(today.getMonth() != realStartDate.getMonth()) { //월 일치X
				calendar += "<th onclick='clickOnDate("+formatChange(realStartDate)+")' class="+formatChangeHyphen(realStartDate)+" id='inactivation'>"+realStartDate.getDate()+"</th>";
				realStartDate.setDate(realStartDate.getDate()+1);
			} else if(today.getMonth() == realStartDate.getMonth()) { //월 일치O
				calendar += "<th onclick='clickOnDate("+formatChange(realStartDate)+")' class="+formatChangeHyphen(realStartDate)+">"+realStartDate.getDate()+"</th>";
				realStartDate.setDate(realStartDate.getDate()+1);	
			}
		}
		realStartDate.setDate(realStartDate.getDate()-7);
		calendar += "</tr><tr>";
		for(var j=0; j<7; j++) { //아래 칸
			if(today.getMonth() != realStartDate.getMonth()) { //월 일치X
				calendar += "<td onclick='clickOnDate("+formatChange(realStartDate)+")' class="+formatChangeHyphen(realStartDate)+"></td>";
				realStartDate.setDate(realStartDate.getDate()+1);
			} else if(today.getMonth() == realStartDate.getMonth()) { //월 일치O
				calendar += "<td onclick='clickOnDate("+formatChange(realStartDate)+")' class="+formatChangeHyphen(realStartDate)+"></td>";
				realStartDate.setDate(realStartDate.getDate()+1);
			}
		}
		calendar += "</tr></table>";	
	 	//table2 끝
	 	calendar += "</div>";	
	}; //for문 끝
	var calMonthBody = $("#calMonthBody"); 
	calMonthBody.html(calendar);
}
function getNumOfWeekRow(today) {
	var firstDate = new Date(today.getFullYear(), today.getMonth(), 1); //해당 월의 첫날
	var firstDayOW = firstDate.getDay(); //해당 월의 첫날 요일(firstDayOfWeek - firstDayOW)
	var lastDate = new Date(today.getFullYear(), today.getMonth()+1, 0); //해당 월의 막날
	var lastDay = lastDate.getDate(); //해당 월의 막날 일자(lastDayDate - lastDay)
	var numOfWeekRow = Math.ceil((lastDay+firstDayOW)/7);
	return numOfWeekRow; //(1~6)
}
function getRealStartDate(today) {
	var firstDate = new Date(today.getFullYear(), today.getMonth(), 1); //해당 월의 첫날
	var firstDayOW = firstDate.getDay(); //해당 월의 첫날 요일(firstDayOfWeek - firstDayOW)
	var lastDatePreMonth = new Date(today.getFullYear(), today.getMonth(), 0); //이전 월의 막날
	var lastDayPreMonth = lastDatePreMonth.getDate(); //이전 월의 막날 일자	
	var realStartDay = lastDayPreMonth - (firstDayOW-1); //진짜 시작 일자
	var realStartDate = new Date(today.getFullYear(), today.getMonth()-1, realStartDay); //진짜 시작 날짜
	return realStartDate;	
}
function getRealLastDate(today) {
	var lastDate = new Date(today.getFullYear(), today.getMonth()+1, 0); //해당 월의 막날	
	var realLastDay = 6 - lastDate.getDay(); //진짜 막날 일자
	var realLastDate = new Date(today.getFullYear(), today.getMonth()+1, realLastDay); //진짜 막날 날짜	
	return realLastDate;	
}
function showSchedule(today) {
	console.log(formatChangeHyphen(today)+" 월 달력 일정을 그렸습니다.");
	
	var type1 = $("#calType1").prop("checked");
	var type2 = $("#calType2").prop("checked");
	var type3 = $("#calType3").prop("checked");
	var type4 = $("#calType4").prop("checked");
	$.ajax({ 
		url:"/showAllCalendar",
		data: {"type1":type1, "type2":type2, "type3":type3, "type4":type4, "today":formatChange(new Date(today.getFullYear(), today.getMonth()+1, 0))},
		type:"get",
		dataType:"json",
		success: function(allCalendar) { //모든 스케쥴을 가져옴
			for(var i in allCalendar) {
				(function(ii) {
					var title = allCalendar[ii].title;
					//시작일
					var startDateStr = allCalendar[ii].startDate; //String 형식
					var startDateStrDate = new Date(allCalendar[ii].startDate);	//Date 형식
					//시작 년 월 일
					var startDateYMD = startDateStr.substring(0, 10); //2019-08-30
					var startDateYear = startDateStr.substring(0, 4); //2019
					var startDateMonth = startDateStr.substring(5, 7); //08
					var startDateYearMonth = startDateStr.substring(0, 7); //2019-08
					var startDateDay = startDateStr.substring(8, 10); //30
					//종료일
					var endDateStr = allCalendar[ii].endDate;
					var endDateStrDate = new Date(allCalendar[ii].endDate);
					//종료 년 월 일
					var endDateYMD = endDateStr.substring(0, 10); //2019-09-25
					var endDateYear = endDateStr.substring(0, 4); //2019
					var endDateMonth = endDateStr.substring(5, 7); //09
					var endDateYearMonth = endDateStr.substring(0, 7); //2019-09
					var endDateDay = endDateStr.substring(8, 10); //25
					//오늘 날짜 기준
					var todayYearMonth = formatChangeHyphen(today).substring(0, 7);
					
					var weekCountOfFirstDate = whichWeek(startDateStrDate); //시작일이 몇 번째 주인지 구하기(0~5)
					if(startDateStrDate < getRealStartDate(today)) { //일정시작일이 진짜시작일보다 전일 경우
						weekCountOfFirstDate = 0; 
					} //일정시작일이 진짜시작일 전이면 0번째 주로 설정
					
					var weekCountOfLastDate = whichWeek(endDateStrDate); //종료일이 몇 번째 주인지 구하기(0~5)
					if(endDateStrDate > getRealLastDate(today)) {
						weekCountOfLastDate = getNumOfWeekRow(today)-1;
					} //일정종료일이 진짜종료일 후면 마지막 주로 설정
					
					var trClassWhereIWantToAppend = todayYearMonth+"-"+weekCountOfFirstDate; //tr 클래스 //첫번째 줄		
					var trClassWhereIWantToAppendLast = todayYearMonth+"-"+weekCountOfLastDate; //tr 클래스 //마지막 줄
				
					var startDateOfThisSchedule = new Date(startDateYear, startDateMonth-1, startDateDay); //해당 일정 시작 날짜 구하기
					var startDayOfThisSchedule = startDateOfThisSchedule.getDay(); //해당 일정 시작 요일 구하기(0~6)
					
					var endDateOfThisSchedule = new Date(endDateYear, endDateMonth-1, endDateDay); //해당 일정 마지막 날짜 구하기
					var endDayOfThisSchedule = endDateOfThisSchedule.getDay(); //해당 일정 마지막 요일 구하기(0~6)
					
					var color = allCalendar[ii].color;

					if(getRealStartDate(today) <= startDateStrDate && getRealLastDate(today) >= endDateStrDate) { //월 안 넘어가는 경우
						var dateDiff = weekCountOfLastDate-weekCountOfFirstDate; //첫날 주와 막날 주 간의 주 차이
						if(dateDiff <= 0) { //1줄 //시작일부터 종료일까지 기간
							var gap = Number(endDateStrDate.getTime()-startDateStrDate.getTime()) / (1000*60*60*24)+Number(1); 
							var tr = trMaker(startDateStrDate, endDateStrDate, startDayOfThisSchedule, 6-endDayOfThisSchedule, 1, gap, title, color); //앞빈칸 뒷빈칸 링크 전부 포함 
							$("#"+trClassWhereIWantToAppend).after(tr);
							tr.children('.middleTd').on("click", function() { putContentIntoTd(allCalendar[ii]); }); //모달 내용 입력
						} else if(dateDiff >= 1) { //2줄 이상
							var repeatGapFirstRow = Number(7)-Number(startDayOfThisSchedule); //첫 줄
							var tr = trMaker(startDateStrDate, endDateStrDate, startDayOfThisSchedule, 0, 2, repeatGapFirstRow, title, color);
							$("#"+trClassWhereIWantToAppend).after(tr);
							tr.children('.middleTd').on("click", function() { putContentIntoTd(allCalendar[ii]); });	
							if(dateDiff>1) { //중간 줄
								for(var i=weekCountOfFirstDate+1; i<weekCountOfLastDate; i++) {
									var tr = trMaker(startDateStrDate, endDateStrDate, 0, 0, 4, 7, title, color);
									$("#"+todayYearMonth+"-"+i).after(tr);
									tr.children('.middleTd').on("click", function() { putContentIntoTd(allCalendar[ii]); });
								}
							}
							var repeatGapLastRow = (Number(endDayOfThisSchedule)+Number(1)); //마지막 줄
							var tr = trMaker(startDateStrDate, endDateStrDate, 0, 6-endDayOfThisSchedule, 3, repeatGapLastRow, title, color);
							$("#"+trClassWhereIWantToAppendLast).after(tr);
							tr.children('.middleTd').on("click", function() { putContentIntoTd(allCalendar[ii]); });
						}
					} else { //월 넘어가는 경우
						var dateDiff = Math.abs(weekCountOfLastDate-weekCountOfFirstDate); //첫날 주와 막날 주 간의 주 차이
						if(dateDiff <= 0) {
							if(getRealStartDate(today) > startDateStrDate) { //이전달과 걸침
								var repeatGapLastRow = (Number(endDayOfThisSchedule)+Number(1)); //마지막 줄
								var tr = trMaker(startDateStrDate, endDateStrDate, 0, 6-endDayOfThisSchedule, 3, repeatGapLastRow, title, color);
								$("#"+trClassWhereIWantToAppendLast).after(tr);
								tr.children('.middleTd').on("click", function() { putContentIntoTd(allCalendar[ii]); });
							} else if(getRealLastDate(today) < endDateStrDate) { //이후달과 걸침
								var repeatGapFirstRow = Number(7)-Number(startDayOfThisSchedule); //첫 줄
								var tr = trMaker(startDateStrDate, endDateStrDate, startDayOfThisSchedule, 0, 2, repeatGapFirstRow, title, color);
								$("#"+trClassWhereIWantToAppend).after(tr);
								tr.children('.middleTd').on("click", function() { putContentIntoTd(allCalendar[ii]); });
							}
						} else if(dateDiff >= 1) {
							if(getRealStartDate(today) > startDateStrDate && getRealLastDate(today) >= endDateStrDate) { //이전달~이번달
								for(var i=weekCountOfFirstDate; i<weekCountOfLastDate; i++) {
									var tr = trMaker(startDateStrDate, endDateStrDate, 0, 0, 4, 7, title, color);
									$("#"+todayYearMonth+"-"+i).after(tr);
									tr.children('.middleTd').on("click", function() { putContentIntoTd(allCalendar[ii]); });
								}
								var repeatGapLastRow = (Number(endDayOfThisSchedule)+Number(1)); //마지막 줄
								var tr = trMaker(startDateStrDate, endDateStrDate, 0, 6-endDayOfThisSchedule, 3, repeatGapLastRow, title, color);
								$("#"+trClassWhereIWantToAppendLast).after(tr);
								tr.children('.middleTd').on("click", function() { putContentIntoTd(allCalendar[ii]); });
							} else if(getRealStartDate(today) <= startDateStrDate && getRealLastDate(today) < endDateStrDate) { //이번달~이후달
								var repeatGapFirstRow = Number(7)-Number(startDayOfThisSchedule); //첫 줄
								var tr = trMaker(startDateStrDate, endDateStrDate, startDayOfThisSchedule, 0, 2, repeatGapFirstRow, title, color);
								$("#"+trClassWhereIWantToAppend).after(tr);
								tr.children('.middleTd').on("click", function() { putContentIntoTd(allCalendar[ii]); });
								for(var i=weekCountOfFirstDate+1; i<weekCountOfLastDate+1; i++) {
									var tr = trMaker(startDateStrDate, endDateStrDate, 0, 0, 4, 7, title, color);
									$("#"+todayYearMonth+"-"+i).after(tr);
									tr.children('.middleTd').on("click", function() { putContentIntoTd(allCalendar[ii]); });
								}
							} else if(getRealStartDate(today) > startDateStrDate && getRealLastDate(today) < endDateStrDate) { //이전달~이후달
								for(var i=weekCountOfFirstDate; i<weekCountOfLastDate+1; i++) {
									var tr = trMaker(startDateStrDate, endDateStrDate, 0, 0, 4, 7, title, color);
									$("#"+todayYearMonth+"-"+i).after(tr);
									tr.children('.middleTd').on("click", function() { putContentIntoTd(allCalendar[ii]); });
								}
							}
						}
					}					
				})(i)
			}
			drag();
		}
	});
}
function changeToBoolean(param) {
	if(param == "1") {
		param = true;
	} else {
		param = false;
	}
	return param;
}
function markingOnDate(dateOrigin) {
	$("#"+dateOrigin).css({"background-color": "#f5f5f5"});
}
function dateChange(d) {
	if(d<10) { return "0"+d; }
	return d;
}
function monthChange(m) {
	if(m<10) { return "0"+m; }
	return m;
}
function formatChangeHyphen(dateOrigin) { //2019-09-04
	return dateOrigin.getFullYear()+"-"+monthChange(dateOrigin.getMonth()+1)+"-"+dateChange(dateOrigin.getDate());
}
function formatChange(dateOrigin) { //20190904
	return dateOrigin.getFullYear()+String(monthChange(dateOrigin.getMonth()+1))+String(dateChange(dateOrigin.getDate()));
}
function formatChangeSimple(dateOrigin) { //20190904 -> 2019-09-04
	return String(dateOrigin).substring(0, 4)+"-"+String(dateOrigin).substring(4, 6)+"-"+String(dateOrigin).substring(6, 8);
}
function clickOnDate(dateOrigin) { //날짜 클릭 시 추가 모달 열기
	$("#addForm").fadeIn(300);
	$("#startDate").val(formatChangeSimple(dateOrigin));	
	$("#endDate").val(formatChangeSimple(dateOrigin));	
}
function putContentIntoTd(a) {
	$("#detailForm").fadeIn(300);
	$("#detailCNum").val(a.cNum);
	$("#modifyCNum").val(a.cNum);
	$("#detailTitle").text(a.title);
	$("#modifyTitle").val(a.title);
	$("#detailStartDate").text(a.startDate.substring(0, 10));
	$("#modifyStartDate").val(a.startDate.substring(0, 10));
	$("#detailEndDate").text(a.endDate.substring(0, 10));
	$("#modifyEndDate").val(a.endDate.substring(0, 10));
	$("#detailContent").text(a.content);
	$("#modifyContent").val(a.content);
	$("#detailType").text(a.type);
	$("#modifyType").val(a.type);
	$("#detailYearCalendar").prop("checked", changeToBoolean(a.yearCalendar));
	$("#modifyYearCalendar").prop("checked", changeToBoolean(a.yearCalendar));
	$("#detailAnnually").prop("checked", changeToBoolean(a.annually));
	$("#modifyAnnually").prop("checked", changeToBoolean(a.annually));
	$("#detailMonthly").prop("checked", changeToBoolean(a.monthly));
	$("#modifyMonthly").prop("checked", changeToBoolean(a.monthly));
	$("#detailColor").css("backgroundColor", a.color);
	$("#modifyColor").val(a.color);
	makeButton(a.type, a.cNum, a.mNum);
}
function makeButton(type, cNum, mNum) {
	var innerBtn = $("#innerBtnDetail");
	innerBtn.empty();
	if(type == "project") {
		if(isMyProject(cNum)) {
			var btn = $("<a onclick='moveTodo("+cNum+")'>To do List</a> <a onclick='detailFormClose()'>닫기</a>");
			innerBtn.append(btn);
		} else {			
			var btn = $("<a onclick='detailFormClose()'>닫기</a>");
			innerBtn.append(btn);
		}
	} else {
		var btn = $("<a onclick='modifyFormOpen()'>수정</a> <a onclick='deleteSchedule()'>삭제</a> <a onclick='detailFormClose()'>닫기</a>");
		innerBtn.append(btn);
	}
}
function moveTodo(cNum) {
	$.ajax({
		url: "getPnum",
		data: {"cNum":cNum},
		type: "post",
		dataType: "json",
		success: function(pNum) {
			if(pNum) {
				location.href = "${contextPath}/todoMain?pNum="+pNum;
			} else {
				alert("실패");
			}
		}
	});
	return false;	
}
function isMyProject(cNum) {
	var tmp = true;
	$.ajax({
		url: "isMyProject",
		async: false,
		data: {"cNum":cNum},
		type: "post",
		dataType: "json",
		success: function(result) {
			tmp = result;
		}
	});	
	return tmp;
}
function detailFormClose() {
	$("#detailForm").fadeOut(1);
}
function modifyFormOpen() {
	var data = $(".detailModal").serialize();
	$("#detailForm").fadeOut(1);
	$("#modifyForm").fadeIn(300);
}
function deleteSchedule() {
	var data = $(".detailModal").serialize();
	$.ajax({
		url: "removeSchedule",
		data: data,
		type: "post",
		dataType: "json",
		success: function(result) {
			if(result) {
				alert("삭제 성공");
				$("#detailForm").fadeOut(1);
				thisMonthCalendar(today);
				showSchedule(today);
				thisYearCalendar(today);
				showYearSchedule(today);
			} else {
				alert("삭제 실패");
			}
		},
		error: function(request, status, error) {
			alert("request:"+request+"\n"
					+"status:"+status+"\n"
					+"error:"+error+"\n");
		}
	});
	return false;
}
function putContentIntoVacantTd(startDate, endDate) { //2019-09-26
	$("#addForm").fadeIn(300);
	$("#startDate").val(formatChangeSimple(startDate));
	$("#endDate").val(formatChangeSimple(endDate));	
}
function whichWeek(date) { //몇번째 주?
	var gap = (date.getTime() - getRealStartDate(today).getTime())/1000/60/60/24;
	var weekNumber = parseInt(gap/7); 
	return weekNumber;
}
function findOutNumOfWeekRow(thisDay) {
	var firstDay = new Date(thisDay.getFullYear(), thisDay.getMonth(), 1);
	var lastDay = new Date(thisDay.getFullYear(), thisDay.getMonth()+1, 0);
	var firstDayOfWeek = firstDay.getDay();
	var lastDayDate = lastDay.getDate();
	var numOfWeekRow = Math.ceil((lastDayDate+firstDayOfWeek)/7);
	return numOfWeekRow;
}
function trMaker(startDate, endDate, front, back, type, gap, title, color) { //시작일, 종료일, 앞빈칸 반복, 뒷빈칸 반복, 중간칸 종류, 중간칸 너비, 제목, 색깔 
	var tr = $("<tr class='scheduleTr'>");
	startDate.setDate(startDate.getDate()-startDate.getDay());
	for(var l=0; l<front; l++) { 
		let tdEtc = $("<td class='"+formatChangeHyphen(startDate)+"' onclick='putContentIntoVacantTd("+formatChange(startDate)+", "+formatChange(startDate)+")'></td>");
		tr.append(tdEtc);
		startDate.setDate(startDate.getDate()+1);
	}	
	if(type==1) {
		var td = $("<td class='middleTd' colspan="+gap+"><div class='middleDiv complete' style='background-color: "+color+"'>"+"&nbsp;&nbsp;"+title+"</div></td>");
	} else if(type==2) {
		var td = $("<td class='middleTd' colspan="+gap+"><div class='middleDiv left' style='background-color: "+color+"'>"+"&nbsp;&nbsp;"+title+"</div></td>");
	} else if(type==3) {
		var td = $("<td class='middleTd' colspan="+gap+"><div class='middleDiv right' style='background-color: "+color+"'>"+"&nbsp;&nbsp;"+title+"</div></td>");
	} else if(type==4) {
		var td = $("<td class='middleTd' colspan="+gap+"><div class='middleDiv full' style='background-color: "+color+"'>"+"&nbsp;&nbsp;"+title+"</div></td>");
	}
	tr.append(td);
	for(var l=0; l<back; l++) {
		endDate.setDate(endDate.getDate()+1);
		let tdEtc = $("<td class='"+formatChangeHyphen(endDate)+"' onclick='putContentIntoVacantTd("+formatChange(endDate)+", "+formatChange(endDate)+")'></td>");
		tr.append(tdEtc);
	}
	return tr;
}
function moveToWantedCalendar(wantedYear, wantedMonth, wantedDate) {
	today = new Date(wantedYear, wantedMonth, wantedDate);
	thisMonthCalendar(today);
	showSchedule(today);
	markingOnDate(formatChange(today));
	$("#yearCalendar").hide();
	$("#monthCalendar").show();	
}
function moveToWantedCalendarYear(wantedYear, wantedMonth, wantedDate) {
	today = new Date(wantedYear, wantedMonth, wantedDate);
	thisYearCalendar(today);
	showSchedule(today);
	$("#monthCalendar").hide();
	$("#yearCalendar").show();
}
function moveMonth(today) {
	thisMonthCalendar(today);
	showSchedule(today);
	markingOnDate(formatChange(new Date()));
}
function preMonth() {
	today = new Date(today.getFullYear(), today.getMonth()-1, 1);
	moveMonth(today);
}
function nextMonth() { 
	today = new Date(today.getFullYear(), today.getMonth()+1, 1);
	moveMonth(today);
}
function preYear() {
	today = new Date(today.getFullYear()-1, today.getMonth(), 1);
	moveMonth(today);
}
function nextYear() {
	today = new Date(today.getFullYear()+1, today.getMonth(), 1);
	moveMonth(today);
}
//----------------------------------------------------------------------------연간 달력----------------------------------------------------------------------------
$(function() {
	thisYearCalendar(today);
	showYearSchedule(today);
	markingOnDateYear(formatChange(today).substring(0, 6));
	//상세 모달 닫기
	$("#detailFormYearClose").on("click", function() {
		$("#detailFormYear").fadeOut(1);
	});
	//타입 변경
	$("#calType1").on("change", function() {
		thisYearCalendar(today);
		showYearSchedule(today);
	});
	$("#calType2").on("change", function() {
		thisYearCalendar(today);
		showYearSchedule(today);
	});
	$("#calType3").on("change", function() {
		thisYearCalendar(today);
		showYearSchedule(today);
	});
	$("#calType4").on("change", function() {
		thisYearCalendar(today);
		showYearSchedule(today);
	});
});
function thisYearCalendar(today) {
	console.log(formatChangeHyphen(today)+" 연 달력을 그렸습니다.");
	//달력 상단 날짜 그리기
	var year = today.getFullYear();
	$("#calYearTitle").html(year+"년");
	//달력 날짜 그리기
	var monthCount1 = 1;
	var monthCount2 = 1;
	var monthCount3 = 1;
	var calendar = "<div></div>";
	for(var i=0; i<3; i++) { //줄
		calendar += "<div class='drawYearCalDiv'>";
		
		//table1
		calendar += "<table class='drawYearCalendarForClick'><tr>";
		for(var j=0; j<4; j++) {
			if(monthCount2<10) { //10일 전
				calendar += "<td id="+year+"0"+monthCount1+"></td>";				
			} else { //10일 후
				calendar += "<td id="+year+monthCount1+"></td>";
			}
			monthCount1++;
		}
		calendar += "</tr></table>";
		//table2
		calendar += "<table class='drawYearCalendar'>";
		calendar += "<tr class='drawYearCalendarDate' id="+today.getFullYear()+"-"+i+">";
		for(var j=0; j<4; j++) { //날짜 칸
			calendar += "<th onclick=\"moveToWantedCalendar("+year+", "+(monthCount2-1)+", 1)\">"+monthCount2+"</th>";				
			monthCount2++;
		}
		calendar += "</tr><tr>";
		for(var j=0; j<4; j++) { //빈 칸
			calendar += "<td onclick=\"moveToWantedCalendar("+year+", "+(monthCount3-1)+", 1)\"></td>";							
			monthCount3++;
		}
		calendar += "</tr>";
		calendar += "</table>";	
		//table2 끝
		calendar += "</div>";
	}
	var calYearBody = $("#calYearBody");
	calYearBody.html(calendar);
} //for문 끝
function showYearSchedule(today) {
	console.log(formatChangeHyphen(today)+" 연 달력 일정을 그렸습니다.");
	var type1 = $("#calType1").prop("checked");
	var type2 = $("#calType2").prop("checked");
	var type3 = $("#calType3").prop("checked");
	var type4 = $("#calType4").prop("checked");
	$.ajax({
		url:"showYearCheckedCalendar",
		data: {"type1":type1, "type2":type2, "type3":type3, "type4":type4, "today":formatChange(new Date(today.getFullYear(), today.getMonth()+1, 0))},
		type:"get",
		dataType:"json",
		success: function(allYearSchedule) { //리스트 반환	
			for(var i in allYearSchedule) {
				(function(ii) {
					var title = allYearSchedule[ii].title;
					
					var startDateStr = allYearSchedule[ii].startDate; //String 형식 
					var startDateYear = startDateStr.substring(0, 4); //2019
					var startDateMonth = startDateStr.substring(5, 7); //10
					
					var endDateStr = allYearSchedule[ii].endDate; 
					var endDateYear = endDateStr.substring(0, 4); //2019
					var endDateMonth = endDateStr.substring(5, 7); //11
					
					var todayYear = startDateStr.substring(0, 4);
					
					var sMonthRow = monthChangeYear(startDateMonth); //0, 1, 2
					var eMonthRow = monthChangeYear(endDateMonth); //0, 1, 2
					
					var color = allYearSchedule[ii].color;
					
					if(sMonthRow == eMonthRow) { //시작일의 줄과 종료일의 줄이 같은 경우 
						var dateNumber = startDateYear+"-"+sMonthRow;
						var tr = trMakerFullLineYear(startDateMonth, (endDateMonth-startDateMonth)+1, title, color, 1);
						$("#"+dateNumber).after(tr);
						tr.children('.middleTdYear').on("click", function() { putContentIntoTdYear(allYearSchedule[ii]); });			
					} else { //시작일의 줄과 종료일의 줄이 다른 경우
						var sDateNumber = startDateYear+"-"+sMonthRow;
						var tr = trMakerLeftLineYear(startDateMonth, title, color);
						$("#"+sDateNumber).after(tr);
						tr.children('.middleTdYear').on("click", function() { putContentIntoTdYear(allYearSchedule[ii]); });
						if((eMonthRow-sMonthRow)>1) {
							var dateNumber = todayYear+"-"+1;
							var tr = trMakerFullLineYear(5, 4, title, color, 4);	
							$("#"+dateNumber).after(tr);
							tr.children('.middleTdYear').on("click", function() { putContentIntoTdYear(allYearSchedule[ii]); });
						}
						var eDateNumber = endDateYear+"-"+eMonthRow;
						var tr = trMakerRightLineYear(endDateMonth, title, color);
						$("#"+eDateNumber).after(tr);
						tr.children('.middleTdYear').on("click", function() { putContentIntoTdYear(allYearSchedule[ii]); });
					}
				})(i)
			}
		}
	});
}
function trMakerFullLineYear(month, gap, title, color, type) { //앞,중간,뒤
	var tr = $("<tr style='border: 0px white;' height='20'>");
	var tmp = ((month%4)-1); //0, 1, 2, -1 	
	if(tmp == -1) {	
		tmp = 3; 
	} //0, 1, 2, 3
	for(var l=0; l<tmp; l++) { //앞 빈 칸
		let tdEtc = $("<td colspan='1'; style='margin-bottom: 1pt; margin-top: 1pt;'></td>");
		tr.append(tdEtc);
	}
	var td = "";
	if(type == 1) {
		td = $("<td class='middleTdYear' colspan="+gap+"><div class='middleDivYear complete' style=\"background-color: "+color+"\">"+"&nbsp;&nbsp;"+title+"</div></td>");
	} else if(type == 4) {
		td = $("<td class='middleTdYear' colspan="+gap+"><div class='middleDivYear full' style=\"background-color: "+color+"\">"+"&nbsp;&nbsp;"+title+"</div></td>");
	}
	tr.append(td);
	var numberOfTdEtc = 4-tmp-gap;
	for(var l=0; l<numberOfTdEtc; l++) { //뒤 빈 칸
		let tdEtc = $("<td colspan='1'; style='margin-bottom: 1pt; margin-top: 1pt;'></td>");
		tr.append(tdEtc);
	}
	return tr;
}
function trMakerLeftLineYear(month, title, color) {
	var tr = $("<tr style='border: 0px white;' height='20'>");
	var lastMonth = Number(monthChangeYear(month)+1)*4;
	var gap = lastMonth-month+1;
	var tmp = ((month%4)-1); //앞 빈 칸 몇 번 반복?
	if(tmp == -1) {	
		tmp = 3; 
	}
	for(var l=0; l<tmp; l++) { //앞 빈 칸
		let tdEtc = $("<td colspan='1'; style='margin-bottom: 1pt; margin-top: 1pt;'></td>");
		tr.append(tdEtc);
	}
	var td = "";
	td = $("<td class='middleTdYear' colspan="+gap+"><div class='middleDivYear left' style=\"background-color: "+color+"\">"+"&nbsp;&nbsp;"+title+"</div></td>");
	tr.append(td);
	return tr;
}
function trMakerRightLineYear(month, title, color) {
	var tr = $("<tr style='border: 0px white;' height='20'>");
	var lastMonth = Number(monthChangeYear(month))*4; 
	var gap = month-lastMonth;	
	var tmp = ((month%4)-1); //뒤 빈 칸 몇 번 반복?
	if(tmp == -1) {	
		tmp = 3; 
	}
	var td = "";
	td = $("<td class='middleTdYear' colspan="+gap+"><div class='middleDivYear right' style=\"background-color: "+color+"\">"+"&nbsp;&nbsp;"+title+"</div></td>");
	tr.append(td);
	var numberOfTdEtc = 4-tmp-gap;
	for(var l=0; l<numberOfTdEtc; l++) { //뒤 빈 칸
		let tdEtc = $("<td colspan='1'; style='margin-bottom: 1pt; margin-top: 1pt;'></td>");
		tr.append(tdEtc);
	}
	return tr;
}
function markingOnDateYear(dateOrigin) {
	$("#"+dateOrigin).css({"background-color": "#E6E2E1"});
}
function monthChangeYear(monthTmp) { //몇번째 줄?
	var rowNum = 0; 
	if(monthTmp >=1 && monthTmp <= 4) {
		rowNum = 0;
	} else if(monthTmp >=5 && monthTmp <= 8) {
		rowNum = 1;
	} else if(monthTmp >=9 && monthTmp <= 12) {
		rowNum = 2;
	}
	return rowNum; //0, 1, 2
}
function putContentIntoTdYear(a) {
	$("#detailFormYear").fadeIn(300);
	$("#detailCNumYear").val(a.cNum);
	$("#detailTitleYear").text(a.title);
	$("#detailStartDateYear").text(a.startDate.substring(0, 10));
	$("#detailEndDateYear").text(a.endDate.substring(0, 10));
	$("#detailContentYear").text(a.content);
	$("#detailTypeYear").text(a.type);
	$("#detailYearCalendarYear").prop("checked", changeToBoolean(a.yearCalendar));
	$("#detailAnnuallyYear").prop("checked", changeToBoolean(a.annually));
	$("#detailMonthlyYear").prop("checked", changeToBoolean(a.monthly));	
	$("#detailColorYear").val(a.color);
}
var realToday = new Date();
function preYearYear() {
	today = new Date(today.getFullYear(), today.getMonth()-12);
	thisYearCalendar(today);
	showYearSchedule(today);
	markingOnDateYear(formatChange(realToday).substring(0, 6));
}
function nextYearYear() {
	today = new Date(today.getFullYear(), today.getMonth()+12);
	thisYearCalendar(today);
	showYearSchedule(today);
	markingOnDateYear(formatChange(realToday).substring(0, 6));
}
</script>
</head>
<body>
<!-- 공통 부분 -->
<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%>
<%@ include file="/WEB-INF/jsp/inc/navWs.jsp"%>
<div id="wsBody">
	<input type="hidden" value="calendar" id="pageType">
	<input type="hidden" value="${sessionScope.currWnum}" id="currWnum">
	<input type="hidden" value="calendar" id="calendar">
	<div id="wsBodyContainer" class="calendarContainer">
	<div class="calHeader">
		<div>
			<form action="calSearchList" class="calSearch">
				<select name="searchType">
					<option value="1">제목</option>
					<option value="2">내용</option>
					<option value="3">제목+내용</option>
					<option value="4">작성자</option>
				</select>
				<input type="text" id="searchKeyword" name="searchKeyword" placeholder="검색어를 입력해주세요."> 
				<button type="submit" class="btn" id="searchBtn">
					<i class="fas fa-search"></i>
				</button>
			</form>
		</div>
		<div>
			<button type="button" id="addFormOpen" class="btn">일정 추가</button>
		</div>
		<div class="headerCheckboxDiv">
			<input type="checkbox" name="calType" id="calType1" value="project" checked="checked">
			<label for="calType1">프로젝트</label>		
			<input type="checkbox" name="calType" id="calType2" value="vacation" checked="checked">
			<label for="calType2">휴가</label>		
			<input type="checkbox" name="calType" id="calType3" value="event" checked="checked">
			<label for="calType3">행사</label>
			<input type="checkbox" name="calType" id="calType4" value="etc" checked="checked">
			<label for="calType4">기타</label>
		</div>
		<div class="headerChangeCal">
			<button id="changeYearCalToMonthCal" class="btn">월간</button>
			<button id="changeMonthCalToYearCal" class="btn">연간</button>
		</div>
	</div><!-- calHeader 끝 -->	
<!-- 월간 달력 -->
	<div id="monthCalendar" class="monthCalendar no-drag">
		<div class="dateDisplay">
			<span id="YearTitle"></span>
			<button onclick="preYear()"><i class="fas fa-angle-double-left"></i></button>
			<button onclick="preMonth()"><i class="fas fa-angle-left"></i></button>
			<span id="MonthTitle"></span>
			<button onclick="nextMonth()"><i class="fas fa-angle-right"></i></button>
			<button onclick="nextYear()"><i class="fas fa-angle-double-right"></i></button>
		</div>
		<div class="dateDisplayInput">
			<input type="text" id="wantedYear"> 년 
			<input type="text" id="wantedMonth"> 월 
			<input type="text" id="wantedDate"> 일 
			<input type="button" class="btn" id="wantedCalendarButton" value="이동">	
		</div>
		<div id="calMonthBody"></div>
		<!-- 일정 추가 모달 -->
		<div id="addForm" class="attachModal ui-widget-content">
			<div class="header">
				<!--파도 위 내용-->
				<div class="inner-header flex">
					<g><path fill="#fff"
					d="M250.4,0.8C112.7,0.8,1,112.4,1,250.2c0,137.7,111.7,249.4,249.4,249.4c137.7,0,249.4-111.7,249.4-249.4
					C499.8,112.4,388.1,0.8,250.4,0.8z M383.8,326.3c-62,0-101.4-14.1-117.6-46.3c-17.1-34.1-2.3-75.4,13.2-104.1
					c-22.4,3-38.4,9.2-47.8,18.3c-11.2,10.9-13.6,26.7-16.3,45c-3.1,20.8-6.6,44.4-25.3,62.4c-19.8,19.1-51.6,26.9-100.2,24.6l1.8-39.7		
					c35.9,1.6,59.7-2.9,70.8-13.6c8.9-8.6,11.1-22.9,13.5-39.6c6.3-42,14.8-99.4,141.4-99.4h41L333,166c-12.6,16-45.4,68.2-31.2,96.2	
					c9.2,18.3,41.5,25.6,91.2,24.2l1.1,39.8C390.5,326.2,387.1,326.3,383.8,326.3z" /></g>
					</svg>
					<div class="modalHead">
						<h3 style='font-weight: bolder; font-size: 30px; color: white'>일정 추가</h3>
						<p>일정을 추가하고 멤버들과 공유하세요.</p>
					</div>
				</div>			
				<!--파도 시작-->
				<div>
					<svg class="waves" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
					viewBox="0 24 150 28" preserveAspectRatio="none" shape-rendering="auto">
					<defs>
					<path id="gentle-wave" d="M-160 44c30 0 58-18 88-18s 58 18 88 18 58-18 88-18 58 18 88 18 v44h-352z" />
					</defs>
						<g class="parallax">
						<use xlink:href="#gentle-wave" x="48" y="0" fill="rgba(255,255,255,0.7" />
						<use xlink:href="#gentle-wave" x="48" y="3" fill="rgba(255,255,255,0.5)" />
						<use xlink:href="#gentle-wave" x="48" y="7" fill="#fff" />
						</g>
					</svg>
				</div><!--파도 end-->
			</div><!--header end-->
<!-- 			<div class="content"> -->
				<div class="modalBody">
					<form class="addModal">
						<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
						<input type="hidden" name="mNum" id="mNum" value="${userData.mNum}">
						<input type="hidden" name="wNum" id="wNum" value="${userData.wNum}">
						<div class="firstRow">
							<div class="titleDiv">
								<h4>일정</h4>
								<input type="text" name="title" class="modalTitle" id="title">
							</div>
							<div class="selectDiv">
								<h4>종류</h4>
								<select name="type">
									<option value="vacation">휴가</option>
									<option value="event">행사</option>
									<option value="etc">기타</option>
								</select>
							</div>
							<div class="colorDiv">
								<h4>색</h4>
								<input type="color" name="color" id="addColor" value="#ffffff">
							</div>
						</div>
						<div class="middleRow">
							<div class="dateDiv">
								<h4>기간</h4>
								<div><input type="text" name="startDate" id="startDate" class="datepicker"></div>
								<span>~</span>
								<div><input type="text" name="endDate" id="endDate" class="datepicker"></div>
							</div>
							<div class="checkboxDiv">
								<input type="checkbox" name="yearCalendar" id="addYearCalendar" value="yearCalendar">
								<label class="checkboxbtn" for="addYearCalendar">연간 달력</label> 	
								<input type="checkbox" name="annually" id="addAnnually" value="annually">
								<label class="checkboxbtn" for="addAnnually">매년 반복</label>				
								<input type="checkbox" name="monthly" id="addMonthly" value="monthly">
								<label class="checkboxbtn" for="addMonthly">매월 반복</label>
							</div>
						</div>
						<div class="lastRow">
							<h4>내용</h4>
							<textarea rows="3" cols="21" name="content" class="modalContent" id="content"></textarea>
						</div>
						<div id="innerBtn">
							<a href="#" id="addSchedule">추가</a>
							<a href="#" id="addFormClose">닫기</a>
						</div>
					</form>
				</div>
<!-- 			</div> -->
		</div>
		<!-- 일정 상세 모달 -->
		<div id="detailForm" class="attachModal ui-widget-content">
			<div class="header">
				<!--파도 위 내용-->
				<div class="inner-header flex">
					<g><path fill="#fff"
					d="M250.4,0.8C112.7,0.8,1,112.4,1,250.2c0,137.7,111.7,249.4,249.4,249.4c137.7,0,249.4-111.7,249.4-249.4
					C499.8,112.4,388.1,0.8,250.4,0.8z M383.8,326.3c-62,0-101.4-14.1-117.6-46.3c-17.1-34.1-2.3-75.4,13.2-104.1
					c-22.4,3-38.4,9.2-47.8,18.3c-11.2,10.9-13.6,26.7-16.3,45c-3.1,20.8-6.6,44.4-25.3,62.4c-19.8,19.1-51.6,26.9-100.2,24.6l1.8-39.7		
					c35.9,1.6,59.7-2.9,70.8-13.6c8.9-8.6,11.1-22.9,13.5-39.6c6.3-42,14.8-99.4,141.4-99.4h41L333,166c-12.6,16-45.4,68.2-31.2,96.2	
					c9.2,18.3,41.5,25.6,91.2,24.2l1.1,39.8C390.5,326.2,387.1,326.3,383.8,326.3z" /></g>
					</svg>
					<div class="joinBox-Head">
						<h3 style='font-weight: bolder; font-size: 30px; color: white'>일정 상세</h3>
						<p>일정을 자세하게 보여드릴게요.</p>
					</div>
				</div>			
				<!--파도 시작-->
				<div>
					<svg class="waves" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
					viewBox="0 24 150 28" preserveAspectRatio="none" shape-rendering="auto">
					<defs>
					<path id="gentle-wave" d="M-160 44c30 0 58-18 88-18s 58 18 88 18 58-18 88-18 58 18 88 18 v44h-352z" />
					</defs>
						<g class="parallax">
						<use xlink:href="#gentle-wave" x="48" y="0" fill="rgba(255,255,255,0.7" />
						<use xlink:href="#gentle-wave" x="48" y="3" fill="rgba(255,255,255,0.5)" />
						<use xlink:href="#gentle-wave" x="48" y="7" fill="#fff" />
						</g>
					</svg>
				</div><!--파도 end-->
			</div><!--header end-->
			<div class="modalBody">
				<form class="detailModal">
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"> 
					<input type="hidden" name="cNum" id="detailCNum">
					<input type="hidden" name="mNum" id="mNum" value="${userData.mNum}">
					<input type="hidden" name="wNum" id="wNum" value="${userData.wNum}">
					<div class="firstRow">
						<div class="titleDiv">						
							<h4>일정</h4>
							<p class="modalTitle" id="detailTitle"></p>
						</div>
						<div class="selectDiv">
							<h4>종류</h4>
							<p id="detailType"></p>
						</div>
					</div>
					<div class="middleRow">
						<div class="dateDiv">
							<h4>기간</h4>
							<p id="detailDate">
								<span id="detailStartDate"></span>
								<span>~</span>
								<span id="detailEndDate"></span>
							</p>
						</div>
						<div class="checkboxDiv">
							<input type="checkbox" name="yearCalendar" id="detailYearCalendar" value="yearCalendar" onclick="return false;">
							<label class="checkboxbtn" for="detailYearCalendar">연간 달력</label> 	
							<input type="checkbox" name="annually" id="detailAnnually" value="annually" onclick="return false;">
							<label class="checkboxbtn" for="detailAnnually">매년 반복</label>				
							<input type="checkbox" name="monthly" id="detailMonthly" value="monthly" onclick="return false;">
							<label class="checkboxbtn" for="detailMonthly">매월 반복</label>
						</div>	
					</div>					
					<div class="lastRow">
						<h4>내용</h4>
						<p class="modalContent" id="detailContent"></p>
					</div>
					<div id="innerBtnDetail"></div>
				</form>
			</div>
		</div>
		<!-- 일정 수정 모달 -->
		<div id="modifyForm" class="attachModal ui-widget-content">
			<div class="header">
				<!--파도 위 내용-->
				<div class="inner-header flex">
					<g><path fill="#fff"
					d="M250.4,0.8C112.7,0.8,1,112.4,1,250.2c0,137.7,111.7,249.4,249.4,249.4c137.7,0,249.4-111.7,249.4-249.4
					C499.8,112.4,388.1,0.8,250.4,0.8z M383.8,326.3c-62,0-101.4-14.1-117.6-46.3c-17.1-34.1-2.3-75.4,13.2-104.1
					c-22.4,3-38.4,9.2-47.8,18.3c-11.2,10.9-13.6,26.7-16.3,45c-3.1,20.8-6.6,44.4-25.3,62.4c-19.8,19.1-51.6,26.9-100.2,24.6l1.8-39.7		
					c35.9,1.6,59.7-2.9,70.8-13.6c8.9-8.6,11.1-22.9,13.5-39.6c6.3-42,14.8-99.4,141.4-99.4h41L333,166c-12.6,16-45.4,68.2-31.2,96.2	
					c9.2,18.3,41.5,25.6,91.2,24.2l1.1,39.8C390.5,326.2,387.1,326.3,383.8,326.3z" /></g>
					</svg>
					<div class="joinBox-Head">
						<h3 style='font-weight: bolder; font-size: 30px; color: white'>일정 수정</h3>
						<p>일정을 조금 바꿔볼까요?</p>
					</div>
				</div>			
				<!--파도 시작-->
				<div>
					<svg class="waves" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
					viewBox="0 24 150 28" preserveAspectRatio="none" shape-rendering="auto">
					<defs>
					<path id="gentle-wave" d="M-160 44c30 0 58-18 88-18s 58 18 88 18 58-18 88-18 58 18 88 18 v44h-352z" />
					</defs>
						<g class="parallax">
						<use xlink:href="#gentle-wave" x="48" y="0" fill="rgba(255,255,255,0.7" />
						<use xlink:href="#gentle-wave" x="48" y="3" fill="rgba(255,255,255,0.5)" />
						<use xlink:href="#gentle-wave" x="48" y="7" fill="#fff" />
						</g>
					</svg>
				</div><!--파도 end-->
			</div><!--header end-->
			<div class="modalBody">
				<form class="modifyModal">
		 			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
		 			<input type="hidden" name="cNum" id="modifyCNum">
					<input type="hidden" name="mNum" id="mNum" value="${userData.mNum}">
					<input type="hidden" name="wNum" id="wNum" value="${userData.wNum}">
					<div class="firstRow">
						<div class="titleDiv">						
							<h4>일정</h4>
							<input type="text" name="title" class="modalTitle" id="modifyTitle">
						</div>
						<div class="selectDiv">
							<h4>종류</h4>
							<select name="type" id="modifyType">
								<option value="vacation">휴가</option>
								<option value="event">행사</option>
								<option value="etc">기타</option>
							</select>
						</div>
						<div class="colorDiv">
							<h4>색</h4>
							<input type="color" name="color" id="modifyColor" value="#ffffff">
						</div>
					</div>
					<div class="middleRow">
						<div class="dateDiv">
							<h4>기간</h4>
							<div><input type="text" name="startDate" id="modifyStartDate" class="datepicker"></div>
							<span>~</span>
							<div><input type="text" name="endDate" id="modifyEndDate" class="datepicker"></div>
						</div>
						<div class="checkboxDiv">
							<input type="checkbox" name="yearCalendar" id="modifyYearCalendar" value="yearCalendar">
							<label class="checkboxbtn" for="modifyYearCalendar">연간 달력</label> 	
							<input type="checkbox" name="annually" id="modifyAnnually" value="annually">
							<label class="checkboxbtn" for="modifyAnnually">매년 반복</label>				
							<input type="checkbox" name="monthly" id="modifyMonthly" value="monthly">
							<label class="checkboxbtn" for="modifyMonthly">매월 반복</label>
						</div>
					</div>
					<div class="lastRow">
						<h4>내용</h4>
						<textarea rows="3" cols="21" name="content" class="modalContent" id="modifyContent"></textarea>
					</div>
					<div id="innerBtn">
						<a href="#" id="modifySchedule">수정</a>
						<a href="#" id="modifyFormClose">닫기</a>
					</div>
				</form>
			</div>
			
		</div>
	</div>	
<!-- 연간 달력 -->
	<div id="yearCalendar" class="yearCalendar">
		<div class="dateDisplay">
			<button onclick="preYearYear()"><i class="fas fa-angle-left"></i></button>
			<span id="calYearTitle"></span>
			<button onclick="nextYearYear()"><i class="fas fa-angle-right"></i></button>
		</div>
		<div class="dateDisplayInput">
			<input type="text" id="wantedYearYear"> 년
			<input type="button" class="btn" id="wantedCalendarButtonYear" value="이동">	
		</div>
		<div id="calYearBody"></div>
		<!-- 일정 상세 모달 --> 
		<div id="detailFormYear" class="attachModal ui-widget-content">
			<div class="header">
				<!--파도 위 내용-->
				<div class="inner-header flex">
					<g><path fill="#fff"
					d="M250.4,0.8C112.7,0.8,1,112.4,1,250.2c0,137.7,111.7,249.4,249.4,249.4c137.7,0,249.4-111.7,249.4-249.4
					C499.8,112.4,388.1,0.8,250.4,0.8z M383.8,326.3c-62,0-101.4-14.1-117.6-46.3c-17.1-34.1-2.3-75.4,13.2-104.1
					c-22.4,3-38.4,9.2-47.8,18.3c-11.2,10.9-13.6,26.7-16.3,45c-3.1,20.8-6.6,44.4-25.3,62.4c-19.8,19.1-51.6,26.9-100.2,24.6l1.8-39.7		
					c35.9,1.6,59.7-2.9,70.8-13.6c8.9-8.6,11.1-22.9,13.5-39.6c6.3-42,14.8-99.4,141.4-99.4h41L333,166c-12.6,16-45.4,68.2-31.2,96.2	
					c9.2,18.3,41.5,25.6,91.2,24.2l1.1,39.8C390.5,326.2,387.1,326.3,383.8,326.3z" /></g>
					</svg>
					<div class="joinBox-Head">
						<h3 style='font-weight: bolder; font-size: 30px; color: white'>일정 상세</h3>
						<p>일정을 자세하게 보여드릴게요.</p>
					</div>
				</div>			
				<!--파도 시작-->
				<div>
					<svg class="waves" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
					viewBox="0 24 150 28" preserveAspectRatio="none" shape-rendering="auto">
					<defs>
					<path id="gentle-wave" d="M-160 44c30 0 58-18 88-18s 58 18 88 18 58-18 88-18 58 18 88 18 v44h-352z" />
					</defs>
						<g class="parallax">
						<use xlink:href="#gentle-wave" x="48" y="0" fill="rgba(255,255,255,0.7" />
						<use xlink:href="#gentle-wave" x="48" y="3" fill="rgba(255,255,255,0.5)" />
						<use xlink:href="#gentle-wave" x="48" y="7" fill="#fff" />
						</g>
					</svg>
				</div><!--파도 end-->
			</div><!--header end-->
			<div class="modalBody">
				<form class="detailModal">
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"> 
					<input type="hidden" name="cNum" id="detailCNum">
					<input type="hidden" name="mNum" id="mNum" value="${userData.mNum}">
					<input type="hidden" name="wNum" id="wNum" value="${userData.wNum}">
					<div class="firstRow">
						<div class="titleDiv">						
							<h4>일정</h4>
							<p class="modalTitle" id="detailTitleYear"></p>
						</div>
						<div class="selectDiv">
							<h4>종류</h4>
							<p id="detailTypeYear"></p>
						</div>
					</div>
					<div class="middleRow">
						<div class="dateDiv">
							<h4>기간</h4>
							<p id="detailDate">
								<span id="detailStartDateYear"></span>
								<span>~</span>
								<span id="detailEndDateYear"></span>
							</p>
						</div>
						<div class="checkboxDiv">
							<input type="checkbox" name="yearCalendar" id="detailYearCalendarYear" value="yearCalendar" onclick="return false;">
							<label class="checkboxbtn" for="detailYearCalendar">연간 달력</label> 	
							<input type="checkbox" name="annually" id="detailAnnuallyYear" value="annually" onclick="return false;">
							<label class="checkboxbtn" for="detailAnnually">매년 반복</label>				
							<input type="checkbox" name="monthly" id="detailMonthlyYear" value="monthly" onclick="return false;">
							<label class="checkboxbtn" for="detailMonthly">매월 반복</label>
						</div>	
					</div>					
					<div class="lastRow">
						<h4>내용</h4>
						<p class="modalContent" id="detailContentYear"></p>
					</div>
					<div id="innerBtn">
						<a href="#" id="detailFormYearClose">닫기</a>
					</div>
				</form>
			</div>
		</div>
	</div>	
	</div>
	</div>
</body>
</html>