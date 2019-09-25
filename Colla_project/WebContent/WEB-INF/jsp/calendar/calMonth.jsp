<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>

<title>calMonth</title>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/calMonth.css"/>
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
	showSchedule();
	markingOnDate(formatChange(today));
	
	//모달 바깥 클릭 시 모달 닫기
	$("#wsBody").on("mouseup", function(e) {
		if($("#addForm").has(e.target).length===0)
			$("#addForm").fadeOut(1);
		if($("#detailForm").has(e.target).length===0)
			$("#detailForm").fadeOut(1);
		if($("#modifyForm").has(e.target).length===0)
			$("#modifyForm").fadeOut(1);
		return false;
	});
	//추가 모달 열기
	$("#addFormOpen").on("click", function() {
		$(".addModal")[0].reset();
		$("#addForm").fadeIn(300);
		$("#startDate").val(formatChangeHyphen(new Date())); //오늘 날짜로 고정
	});
	//추가 모달 닫기
	$("#addFormClose").on("click", function() {
		$("#addForm").fadeOut(1);
		$("#addForm").each(function() {
			this.reset();
		});
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
					alert("추가 성공");
					$("#addForm").fadeOut(1);
					thisMonthCalendar(today);
					showSchedule();
					thisYearCalendar(today);
					showYearSchedule();
					$("#addForm").each(function() {
						this.reset();
					});
				} else {
					alert("추가 실패");
				}
			},
			error: function(request, status, error) {
				alert("request:"+request+"\n"
						+"status:"+status+"\n"
						+"error:"+error+"\n");
			}
		});
		return false;
	});
	//상세 모달 닫기
	$("#detailFormClose").on("click", function() {
		$("#detailForm").fadeOut(1);
	});
	//삭제
	$("#deleteSchedule").on("click", function() {
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
					showSchedule();
					thisYearCalendar(today);
					showYearSchedule();
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
	});
	//수정 모달 열기
	$("#modifyFormOpen").on("click", function() {
		var data = $(".detailModal").serialize();
		$("#detailForm").fadeOut(1);
		$("#modifyForm").fadeIn(300);
	});	
	//수정 모달 닫기
	$("#modifyFormClose").on("click", function() {
		$("#modifyForm").fadeOut(1);
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
					alert("수정 성공");
					$("#modifyForm").fadeOut(1);
					thisMonthCalendar(today);
					showSchedule();
					thisYearCalendar(today);
					showYearSchedule();
				} else {
					alert("수정 실패");
				}
			},
			error: function(request, status, error) {
				alert("request:"+request+"\n"
						+"status:"+status+"\n"
						+"error:"+error+"\n");
			}
		});
		return false;
	});
	//타입 지정
	$("#calType1").on("change", function() {
		thisMonthCalendar(today);
		showSchedule();
	});
	$("#calType2").on("change", function() {
		thisMonthCalendar(today);
		showSchedule();
	});
	$("#calType3").on("change", function() {
		thisMonthCalendar(today);
		showSchedule();
	});
	//원하는 날짜로 달력 이동
	$("#wantedCalendarButton").on("click", function() {
		moveToWantedCalendar($("#wantedYear").val(), $("#wantedMonth").val()-1, $("#wantedDate").val());
	});
});

function thisMonthCalendar(today) {
	console.log(today+"의 월 달력을 그렸습니다.");
	//달력 상단 날짜 그리기
	$("#YearTitle").html("<p>"+today.getFullYear()+"년<p>");
	$("#MonthTitle").html((today.getMonth()+1)+"월");
	//달력 상단 요일 그리기
	var month = monthChange(today.getMonth()+1);
	var calendar = "<table class='drawMonthCalendarUpper'>";
	calendar += "<tr><th>일</th><th>월</th><th>화</th><th>수</th><th>목</th><th>금</th><th>토</th></tr>";
	calendar += "</table>";
	//달력 하단 날짜 그리기
	var firstDay = new Date(today.getFullYear(), today.getMonth(), 1);
	var lastDay = new Date(today.getFullYear(), today.getMonth()+1, 0);
	var firstDayOfWeek = firstDay.getDay();
	var lastDayDate = lastDay.getDate();
	var numOfWeekRow = Math.ceil((lastDayDate+firstDayOfWeek)/7);
	
	var dateCount1 = 1;
	var dateCount2 = 1;
	var dateCount3 = 1;
	for(var i=0; i<numOfWeekRow; i++) { //줄
		calendar += "<div class='drawMonthCalDiv'>";
		//table1
		calendar += "<table class='drawMonthCalendarLowerForClick'><tr>";
		for(var n=0; n<7; n++) {
			if(n<firstDayOfWeek && i==0 || dateCount1>lastDayDate) { //날짜 없는 부분
				calendar += "<th>&nbsp;</th>";
			} else {
				calendar += "<th id="+today.getFullYear()+month+dateChange(dateCount1)+"></th>";
				dateCount1++;
			}
		}
		calendar += "</tr></table>";
		//table2 시작
		calendar += "<table class='drawMonthCalendarLower'>";
		calendar += "<tr class='drawMonthCalendarLowerDate' id="+today.getFullYear()+"-"+month+"-"+i+">";
		for(var j=0; j<7; j++) { //날짜 칸
			if(j<firstDayOfWeek && i==0 || dateCount2>lastDayDate) { //날짜 없는 부분
				calendar += "<th>&nbsp;</th>";
			} else {
				calendar += "<th onclick='clickOnDate("+today.getFullYear()+month+dateChange(dateCount2)+")'>"+dateCount2+"</th>";
				dateCount2++;			
			}
		}
		calendar += "</tr><tr>";
		for(var j=0; j<7; j++) { //빈 칸
			if(j<firstDayOfWeek && i==0 || dateCount3>lastDayDate) { //날짜 없는 부분
				calendar += "<td>&nbsp;</td>";
			} else {
				calendar += "<td onclick='clickOnDate("+today.getFullYear()+month+dateChange(dateCount3)+")'></td>";
				dateCount3++;
			}
		}
		calendar += "</tr></table>";	
	 	//table2 끝
	 	calendar += "</div>";	
	}; //for문 끝
	var calMonthBody = $("#calMonthBody"); 
	calMonthBody.html(calendar);	
}
function showSchedule() {
	console.log("월 달력 일정을 그렸습니다.");
	var type1 = $("#calType1").prop("checked");
	var type2 = $("#calType2").prop("checked");
	var type3 = $("#calType3").prop("checked");
	$.ajax({ 
		url:"showAllCalendar",
		data: {"type1":type1, "type2":type2, "type3":type3},
		type:"get",
		dataType:"json",
		success: function(allCalendar) { //모든 스케쥴을 가져옴
			for(var i in allCalendar) {
				(function(ii) {
					var title = allCalendar[ii].title;
					//시작일
					var startDateStr = allCalendar[ii].startDate;
					var startDateStrDate = new Date(allCalendar[ii].startDate);	
					//시작 년 월 일
					var startDateYMD = startDateStr.substring(0, 10); //2019-08-30
					var startDateYear = startDateStr.substring(0, 4);
					var startDateMonth = startDateStr.substring(5, 7);
					var startDateYearMonth = startDateStr.substring(0, 7);
					var startDateDate = startDateStr.substring(8, 10);
					//종료일
					var endDateStr = allCalendar[ii].endDate;
					var endDateStrDate = new Date(allCalendar[ii].endDate);
					//종료 년 월 일
					var endDateYMD = endDateStr.substring(0, 10);
					var endDateYear = endDateStr.substring(0, 4);
					var endDateMonth = endDateStr.substring(5, 7);
					var endDateYearMonth = endDateStr.substring(0, 7);
					var endDateDate = endDateStr.substring(8, 10);
					
					var weekCountOfFirstDate = whichWeek(startDateStr); //시작일이 몇 번째 주인지 구하기(0~5)
					var weekCountOfLastDate = whichWeek(endDateStr); //종료일이 몇 번째 주인지 구하기(0~5)
					
					var trClassWhereIWantToAppend = startDateYearMonth+"-"+(Number(weekCountOfFirstDate)-1); //tr 클래스 //첫번째 줄
					var trClassWhereIWantToAppendLast = endDateYearMonth+"-"+(Number(weekCountOfLastDate)-1); //tr 클래스 //마지막 줄
				
					var startDateOfThisSchedule = new Date(startDateYear, startDateMonth-1, startDateDate); //해당 일정 시작 날짜 구하기
					var startDayOfThisSchedule = startDateOfThisSchedule.getDay(); //해당 일정 시작 요일 구하기(0~6)
					
					var endDateOfThisSchedule = new Date(endDateYear, endDateMonth-1, endDateDate); //해당 일정 마지막 날짜 구하기
					var endDayOfThisSchedule = endDateOfThisSchedule.getDay(); //해당 일정 마지막 요일 구하기(0~6)
					
					var color = allCalendar[ii].color;
					if(startDateMonth==endDateMonth) { //월 안 넘어가는 경우
						var dateDiff = Math.abs(weekCountOfLastDate-weekCountOfFirstDate);
						if(dateDiff == 0) { //줄 안 넘어가는 경우
							var gap = Number(endDateStrDate.getTime()-startDateStrDate.getTime())/(1000*60*60*24)+Number(1); //시작일부터 종료일까지 기간
							var tr = trMaker(startDayOfThisSchedule, 6-endDayOfThisSchedule, 1, gap, title, color);
							$("#"+trClassWhereIWantToAppend).after(tr);
							tr.children('.middleTd').on("click", function() {
								putContentIntoTd(allCalendar[ii]);
							});
						} else if(dateDiff >= 1) { //줄 넘어가는 경우
							var repeatGapFirstRow = Number(7)-Number(startDayOfThisSchedule); //첫 줄
							var tr = trMaker(startDayOfThisSchedule, 0, 2, repeatGapFirstRow, title, color);
							$("#"+trClassWhereIWantToAppend).after(tr);
							tr.children('.middleTd').on("click", function() {
								putContentIntoTd(allCalendar[ii]);
							});	
							if(dateDiff>1) { //중간 줄
								for(var i=weekCountOfFirstDate; i<weekCountOfLastDate-1; i++) {
									var tr = trMaker(0, 0, 4, 7, title, color);
									$("#"+startDateYearMonth+"-"+i).after(tr);
									tr.children('.middleTd').on("click", function() {
										putContentIntoTd(allCalendar[ii]);
									});
								}
							}
							var repeatGapLastRow = (Number(endDayOfThisSchedule)+Number(1)); //마지막 줄
							var tr = trMaker(0, 6-endDayOfThisSchedule, 3, repeatGapLastRow, title, color);
							$("#"+trClassWhereIWantToAppendLast).after(tr);
							tr.children('.middleTd').on("click", function() {
								putContentIntoTd(allCalendar[ii]);
							});
						}
					} else { //월 넘어가는 경우											
						var repeatGapFirstRow = Number(7)-Number(startDayOfThisSchedule); //첫 줄
						var tr = trMaker(startDayOfThisSchedule, 0, 2, repeatGapFirstRow, title, color);
						$("#"+trClassWhereIWantToAppend).after(tr);
						tr.children('.middleTd').on("click", function() {
							putContentIntoTd(allCalendar[ii]);
						});							
						for(var i=weekCountOfFirstDate; i<=findOutNumOfWeekRow(startDateStrDate); i++) {
							var tr = trMaker(0, 0, 4, 7, title, color);
							var tmpid = startDateYearMonth+"-"+i;
							$("#"+tmpid).after(tr);							
							tr.children('.middleTd').on("click", function() {
								putContentIntoTd(allCalendar[ii]);
							});
						}
// 						if((endDateStrDate.getMonth()-startDateStrDate.getMonth())>1) { ???????????????????? 세 달 이상
// 							var nextMonthTmp = new Date(startDateStrDate.getFullYear(), (Number(startDateStrDate.getMonth())+Number(1)), 1);
// 							var tr = trMaker4(startDayOfThisSchedule, endDayOfThisSchedule, 7, title, randomColorRandom);
// 							for(var i=0; i<=findOutNumOfWeekRow(nextMonthTmp); i++) {						
// 								$("."+nextMonthTmp.getFullYear()+"-"+(Number(nextMonthTmp.getMonth())+Number(1))+"-"+i).after(tr);							
// 								tr.children('.middleTd').on("click", function() {
// 									putContentIntoTd(allCalendar[ii]);
// 								});
// 							}
// 						} 	
						for(var i=0; i<weekCountOfLastDate-1; i++) {
							var tr = trMaker(0, 0, 4, 7, title, color);
							$("#"+endDateYearMonth+"-"+i).after(tr);							
							tr.children('.middleTd').on("click", function() {
								putContentIntoTd(allCalendar[ii]);
							});
						}							
						var repeatGapLastRow = (Number(endDayOfThisSchedule)+Number(1)); //마지막 줄
						var tr = trMaker(0, 6-endDayOfThisSchedule, 3, repeatGapLastRow, title, color);
						$("#"+trClassWhereIWantToAppendLast).after(tr);
						tr.children('.middleTd').on("click", function() {
							putContentIntoTd(allCalendar[ii]);
						});
					}					
				})(i)
			}
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
	$("#"+dateOrigin).css({"background-color": "#E6E2E1"});
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
	return dateOrigin.getFullYear()+monthChange(dateOrigin.getMonth()+1)+dateChange(dateOrigin.getDate());
}
function clickOnDate(dateTmp) { //날짜 클릭 시 추가 모달 열기 //20190904 -> 2019-09-04
	$("#addForm").fadeIn(300);
	$("#startDate").val(String(dateTmp).substring(0, 4)+"-"+String(dateTmp).substring(4, 6)+"-"+String(dateTmp).substring(6, 8));	
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
	$("#detailColor").css("backgroundColor",a.color);
	$("#modifyColor").val(a.color);
}
function whichWeek(dateStr) { //달(1~12)
	var dateStrDate = new Date(dateStr);
	var dateYMD = dateStr.substring(0, 10);
	var dateYear = dateStr.substring(0, 4);
	var dateMonth = dateStr.substring(5, 7);
	var dateDate = dateStr.substring(8, 10);
	var firstDateOfDate = new Date(dateYear, dateMonth-1, 1); //종료일이 있는 월의 첫날 구하기
	var firstDayOfDate = firstDateOfDate.getDay(); //종료일 첫날 요일 구하기
	var weekCount = Math.ceil((Number(firstDayOfDate)+Number(dateDate))/7); //종료일이 몇 번째 주인지 구하기(0~5)
	return weekCount;
}
function findOutNumOfWeekRow(thisDay) {
	var firstDay = new Date(thisDay.getFullYear(), thisDay.getMonth(), 1);
	var lastDay = new Date(thisDay.getFullYear(), thisDay.getMonth()+1, 0);
	var firstDayOfWeek = firstDay.getDay();
	var lastDayDate = lastDay.getDate();
	var numOfWeekRow = Math.ceil((lastDayDate+firstDayOfWeek)/7);
	return numOfWeekRow;
}
function trMaker(front, back, type, gap, title, color) { //앞빈칸 반복, 뒷빈칸 반복, 중간칸 종류, 중간칸 너비, 제목, 색깔 
	var tr = $("<tr class='scheduleTr'>");
	for(var l=0; l<front; l++) { 
		let tdEtc = $("<td class='frontVacantTd'></td>");
		tr.append(tdEtc);
		console.log( "TEST : ", tr.parent() );
	}	
	if(type==1) {
		var td = $("<td class='middleTd' colspan="+gap+"><div class='middleDiv' style='border-radius: 10px; background-color: "+color+"'>"+"&nbsp;&nbsp;"+title+"</div></td>");
	} else if(type==2) {
		var td = $("<td class='middleTd' colspan="+gap+"><div class='middleDiv' style='border-bottom-left-radius: 10px; border-top-left-radius: 10px; background-color: "+color+"'>"+"&nbsp;&nbsp;"+title+"</div></td>");
	} else if(type==3) {
		var td = $("<td class='middleTd' colspan="+gap+"><div class='middleDiv' style='border-bottom-right-radius: 10px; border-top-right-radius: 10px; background-color: "+color+"'>"+"&nbsp;&nbsp;"+title+"</div></td>");
	} else if(type==4) {
		var td = $("<td class='middleTd' colspan="+gap+"><div class='middleDiv' style='background-color: "+color+"'>"+"&nbsp;&nbsp;"+title+"</div></td>");
	}
	tr.append(td);
	for(var l=0; l<back; l++) {
		let tdEtc = $("<td class='backVacantTd'></td>");
		tr.append(tdEtc);
	}
	return tr;
}
function moveToWantedCalendar(wantedYear, wantedMonth, wantedDate) {
	today = new Date(wantedYear, wantedMonth, wantedDate);
	thisMonthCalendar(today);
	showSchedule();
	markingOnDate(formatChange(today));
	$("#yearCalendar").hide();
	$("#monthCalendar").show();	
}
function moveMonth(today) {
	thisMonthCalendar(today);
	showSchedule();
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
//----------------------------------------------------------------------------연간 달력
$(function() {
	thisYearCalendar(today);
	showYearSchedule();
	markingOnDateYear(formatChange(today).substring(0, 6));
	//상세 모달 닫기
	$("#detailFormYearClose").on("click", function() {
		$("#detailFormYear").fadeOut(1);
	});
	//타입 변경
	$("#calType1").on("change", function() {
		thisYearCalendar(today);
		showYearSchedule();
	});
	$("#calType2").on("change", function() {
		thisYearCalendar(today);
		showYearSchedule();
	});
	$("#calType3").on("change", function() {
		thisYearCalendar(today);
		showYearSchedule();
	});
});
function thisYearCalendar(today) {
	console.log(today+"의 연 달력을 그렸습니다.");
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
function showYearSchedule() {
	console.log("연 달력 일정을 그렸습니다.");
	var type1 = $("#calType1").prop("checked");
	var type2 = $("#calType2").prop("checked");
	var type3 = $("#calType3").prop("checked");
	$.ajax({
		url:"showYearCheckedCalendar",
		data: {"type1":type1, "type2":type2, "type3":type3},
		type:"get",
		dataType:"json",
		success: function(allYearSchedule) {	
			for(var i in allYearSchedule) {
				(function(ii) {
					var title = allYearSchedule[ii].title;
					
					var startDateStr = allYearSchedule[ii].startDate;
					var startDateYear = startDateStr.substring(0, 4);
					var startDateMonth = startDateStr.substring(5, 7);	
					
					var endDateStr = allYearSchedule[ii].endDate;
					var endDateYear = endDateStr.substring(0, 4);
					var endDateMonth = endDateStr.substring(5, 7);
					
					var sMonthRow = monthChangeYear(startDateMonth); 
					var eMonthRow = monthChangeYear(endDateMonth);
					var color = allYearSchedule[ii].color;
					
					if(sMonthRow == eMonthRow) {
						var dateNumber = startDateYear+"-"+sMonthRow;
						var tr = trMakerFullLineYear(startDateMonth, (endDateMonth-startDateMonth)+1, title, color, 1);
						$("#"+dateNumber).after(tr);
						tr.children('.middleTd').on("click", function() {
							putContentIntoTdYear(allYearSchedule[ii]);
						})
					} else {
						var sDateNumber = startDateYear+"-"+sMonthRow; //첫줄
						var tr = trMakerFullLineYear(startDateMonth, (endDateMonth-startDateMonth), title, color, 2);
						$("#"+sDateNumber).after(tr);
						tr.children('.middleTd').on("click", function() {
							putContentIntoTdYear(allYearSchedule[ii]);
						})
						var eDateNumber = endDateYear+"-"+eMonthRow; //막줄
						var tr = trMakerFullLineYear(endDateMonth, (endDateMonth-startDateMonth), title, color, 3);
						$("#"+eDateNumber).after(tr);
						tr.children('.middleTd').on("click", function() {
							putContentIntoTdYear(allYearSchedule[ii]);
						})		
					}
				})(i)
			}
		}
	});
}
function trMakerFullLineYear(month, gap, title, color, type) { //앞,중간,뒤
	var tr = $("<tr style=\"border: 0px white;\" height=\"20\">");
	var tmp = ((month%4)-1); //0, 1, 2, -1 	
	if(tmp == -1) {	
		tmp = 3; 
	} //0, 1, 2, 3
	for(var l=0; l<tmp; l++) { //빈 칸
		let tdEtc = $("<td colspan=\"1\"; style=\"margin-bottom: 1pt; margin-top: 1pt;\"></td>");
		tr.append(tdEtc);
	}
	var td = "";
	if(type == 1) {
		td = $("<td class=\"middleTdYear\" colspan="+gap+"><div style=\"border-radius: 10px; background-color: "+color+"\">"+"&nbsp;&nbsp;"+title+"</div></td>");
	} else if(type == 2) {
		td = $("<td class=\"middleTdYear\" colspan="+gap+"><div style=\"border-bottom-left-radius: 10px; border-top-left-radius: 10px; background-color: "+color+"\">"+"&nbsp;&nbsp;"+title+"</div></td>");
	} else if(type == 3) {
		td = $("<td class=\"middleTdYear\" colspan="+gap+"><div style=\"border-bottom-right-radius: 10px; border-top-right-radius: 10px; background-color: "+color+"\">"+"&nbsp;&nbsp;"+title+"</div></td>");
	} else if(type == 4) {
		td = $("<td class=\"middleTdYear\" colspan="+gap+"><div style=\"background-color: "+color+"\">"+"&nbsp;&nbsp;"+title+"</div></td>");
	}
	tr.append(td);
	var numberOfTdEtc = 4-tmp-gap;
	for(var l=0; l<numberOfTdEtc; l++) {
		let tdEtc = $("<td colspan=\"1\"; style=\"margin-bottom: 1pt; margin-top: 1pt;\"></td>");
		tr.append(tdEtc);
	}
	return tr;
}
function markingOnDateYear(dateOrigin) {
	$("#"+dateOrigin).css({"background-color": "#E6E2E1"});
}
function monthChangeYear(monthTmp) {
	var rowNum = 0; 
	if(monthTmp >=1 && monthTmp <= 4) {
		rowNum = 0;
	} else if(monthTmp >=5 && monthTmp <= 8) {
		rowNum = 1;
	} else if(monthTmp >=9 && monthTmp <= 12) {
		rowNum = 2;
	}
	return rowNum;
}
function putContentIntoTdYear(a) {
	$("#detailFormYear").fadeIn(300);
	$("#detailCNumYear").val(a.cNum);
	$("#detailTitleYear").val(a.title);
	$("#detailStartDateYear").val(a.startDate.substring(0, 10));
	$("#detailEndDateYear").val(a.endDate.substring(0, 10));
	$("#detailContentYear").val(a.content);
	$("#detailTypeYear").val(a.type);
	$("#detailYearCalendarYear").prop("checked", changeToBoolean(a.yearCalendar));
	$("#detailAnnuallyYear").prop("checked", changeToBoolean(a.annually));
	$("#detailMonthlyYear").prop("checked", changeToBoolean(a.monthly));	
	$("#detailColorYear").val(a.color);
}
var realToday = new Date();
function preYearYear() {
	today = new Date(today.getFullYear(), today.getMonth()-12);
	thisYearCalendar(today);
	showYearSchedule();
	markingOnDateYear(formatChange(realToday).substring(0, 6));
}
function nextYearYear() {
	today = new Date(today.getFullYear(), today.getMonth()+12);
	thisYearCalendar(today);
	showYearSchedule();
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
		<div>
			<label><input type="checkbox" name="calType" id="calType1" value="project" checked="checked">프로젝트</label>
			<label><input type="checkbox" name="calType" id="calType2" value="vacation" checked="checked">휴가</label>
			<label><input type="checkbox" name="calType" id="calType3" value="event" checked="checked">행사</label>
		</div>
		<div style="float: right">
			<button id="changeYearCalToMonthCal" class="btn">월간</button>
			<button id="changeMonthCalToYearCal" class="btn">연간</button>
		</div>
	</div><!-- calHeader 끝 -->	
<!-- 월간 달력 -->
	<div id="monthCalendar" class="monthCalendar">
		<div class="dateDisplay">
			<span id="YearTitle"></span>
			<button onclick="preYear()">작년</button>
			<button onclick="preMonth()">이전 달</button>
			<span id="MonthTitle"></span>
			<button onclick="nextMonth()">다음 달</button>
			<button onclick="nextYear()">내년</button>
		</div>
		<div class="dateDisplayInput">
			<input type="text" id="wantedYear"> 년 
			<input type="text" id="wantedMonth"> 월 
			<input type="text" id="wantedDate"> 일 
			<input type="button" class="btn" id="wantedCalendarButton" value="이동">	
		</div>
		<div id="calMonthBody"></div>
		<!-- 일정 추가 모달 -->
		<div id="addForm" class="attachModal">
			<div class="modalHead">
				<h3 style='font-weight: bolder; font-size: 30px'>일정 추가</h3>
				<p>일정을 추가하고 멤버들과 공유하세요.</p>
			</div>
			<div class="modalBody">
				<form class="addModal">
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
					<input type="hidden" name="mNum" id="mNum" value="${userData.mNum}">
					<input type="hidden" name="wNum" id="wNum" value="${userData.wNum}">
					<div>
						<h4>일정</h4>
						<input type="text" name="title" class="modalTitle" id="title">
					</div>
					<div>
						<h4>기간</h4>
						<span><input type="date" name="startDate" id="startDate">부터</span> <span><input type="date" name="endDate" id="endDate">까지</span>
					</div>
					<div>
						<h4>내용</h4>
						<textarea rows="1" cols="21" name="content" class="modalContent" id="content"></textarea>
					</div>
					<div>
						<h4>타입</h4>
						<select name="type">
							<option value="project">프로젝트</option>
							<option value="vacation">휴가</option>
							<option value="event">행사</option>
							</select>
						<label><input type="checkbox" name="yearCalendar" id="addYearCalendar" value="yearCalendar">연간 달력 표시</label> 
						<label><input type="checkbox" name="annually" id="addAnnually" value="annually">매년 반복</label>
						<label><input type="checkbox" name="monthly" id="addMonthly" value="monthly">매월 반복</label>
					</div>
					<div>
						<h4>색</h4>
						<input type="color" name="color" id="addColor" value="#fffde8">
					</div>
					<div id="innerBtn">
						<a href="#" id="addSchedule">추가</a>
						<a href="#" id="addFormClose">닫기</a><br>
					</div>
				</form>
			</div>
		</div>
		<!-- 일정 상세 모달 -->
		<div id="detailForm" class="attachModal">
			<div class="modalHead">
				<h3 style='font-weight: bolder; font-size: 30px'>일정 상세</h3>
				<p>일정을 자세하게 보여드릴게요.</p>
			</div>
			<div class="modalBody">
				<form class="detailModal">
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"> 
					<input type="hidden" name="cNum" id="detailCNum">
					<input type="hidden" name="mNum" id="mNum" value="${userData.mNum}">
					<input type="hidden" name="wNum" id="wNum" value="${userData.wNum}">
					<div>
						<h4>일정 이름</h4>
						<p class="modalTitle" id="detailTitle" >
					</div>
					<div>
						<h4>기간</h4>
						<p>
							<span id="detailStartDate" ></span>부터 
							<span id="detailEndDate" ></span>까지
						</p>
					</div>
					<div>
						<h4>내용</h4>
						<p class="modalContent" id="detailContent"></p>
					</div>
					<div>
						<h4>타입</h4>
						<p id="detailType">
						</p>
						<label><input type="checkbox" name="yearCalendar" id="detailYearCalendar" value="yearCalendar">연간 달력 표시</label>
						<label><input type="checkbox" name="annually" id="detailAnnually" value="annually">매년 반복</label>
						<label><input type="checkbox" name="monthly" id="detailMonthly" value="monthly">매월 반복</label>
					</div>
					<div>
						<h4>색</h4>
						<p id="detailColor">&nbsp;</p>
					</div>
					<div id="innerBtn">
						<a href="#" id="modifyFormOpen">수정</a>
						<a href="#" id="deleteSchedule">삭제</a>
						<a href="#" id="detailFormClose">닫기</a>
					</div>
				</form>
			</div>
		</div>
		<!-- 일정 수정 모달 -->
		<div id="modifyForm" class="attachModal">
			<div class="modalHead">
				<h3 style='font-weight: bolder; font-size: 30px'>일정 수정</h3>
				<p>일정을 조금 바꿔볼까요?</p>
			</div>
			<div class="modalBody">
				<form class="modifyModal">
		 			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
		 			<input type="hidden" name="cNum" id="modifyCNum">
					<input type="hidden" name="mNum" id="mNum" value="${userData.mNum}">
					<input type="hidden" name="wNum" id="wNum" value="${userData.wNum}">
					<div>
						<h4>일정</h4>
						<input type="text" name="title" class="modalTitle" id="modifyTitle">
					</div>
					<div>
						<h4>기간</h4>
						<input type="date" name="startDate" id="modifyStartDate">부터 <input type="date" name="endDate" id="modifyEndDate">까지
					</div>
					<div>
						<h4>내용</h4>
						<textarea rows="5" cols="21" name="content" class="modalContent" id="modifyContent"></textarea>
					</div>
					<div>
						<h4>타입</h4>
						<select name="type" id="modifyType">
							<option value="project">프로젝트</option>
							<option value="vacation">휴가</option>
							<option value="event">행사</option>
						</select>
						<label><input type="checkbox" name="yearCalendar" id="modifyYearCalendar" value="yearCalendar">연간 달력 표시</label>
						<label><input type="checkbox" name="annually" id="modifyAnnually" value="annually">매년 반복</label>
						<label><input type="checkbox" name="monthly" id="modifyMonthly" value="monthly">매월 반복</label>
					</div>
					<div>
						<h4>색</h4>
						<input type="color" name="color" id="modifyColor" value="#fffde8">
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
			<button onclick="preYearYear()">작년</button>
			<span id="calYearTitle"></span>
			<button onclick="nextYearYear()">내년</button>
		</div>
		<div id="calYearBody"></div>
		<!-- 일정 상세 모달 --> 
		<div id="detailFormYear" class="attachModal">
			<div class="modalHead">
				<h3 style='font-weight: bolder; font-size: 30px'>일정 상세</h3>
				<p>일정을 자세하게 보여드릴게요.</p>
			</div>
			<div class="modalBody">
				<form class="detailModalYear">
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
					<input type="hidden" name="cNum" id="detailCNumYear">
					<input type="hidden" name="mNum" id="mNum" value="${userData.mNum}">
					<input type="hidden" name="wNum" id="wNum" value="${userData.wNum}">
					
					<div>
						<h4>일정</h4>
						<input type="text" name="title" class="modalTitle" id="detailTitleYear" readonly="readonly">
					</div>
					<div>
						<h4>기간</h4>
						<input type="date" name="startDate" id="detailStartDateYear" readonly="readonly">부터 <input type="date" name="endDate" id="detailEndDateYear" readonly="readonly">까지
					</div>
					<div>
						<h4>내용</h4>
						<textarea rows="1" cols="21" name="content" class="modalContent" id="detailContentYear" readonly="readonly"></textarea>
					</div>
					<div>
						<h4>타입</h4>
						<select name="type" id="detailTypeYear">
							<option value="project">프로젝트</option>
							<option value="vacation">휴가</option>
							<option value="event">행사</option>
						</select>
						<label><input type="checkbox" name="yearCalendar" id="detailYearCalendarYear" value="yearCalendar">연간 달력 표시</label>
						<label><input type="checkbox" name="annually" id="detailAnnuallyYear" value="annually">매년 반복</label>
						<label><input type="checkbox" name="monthly" id="detailMonthlyYear" value="monthly">매월 반복</label>
					</div>
					<div>
						<h4>색</h4>
						<input type="color" name="color" id="detailColorYear" value="#fffde8">
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