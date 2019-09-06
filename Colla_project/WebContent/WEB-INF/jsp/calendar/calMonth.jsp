<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<% 
String contextPath = request.getContextPath();
request.setAttribute("contextPath", contextPath);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>calMonth</title>
<link rel="stylesheet" type="text/css" href="css/reset.css"/>
<link rel="stylesheet" type="text/css" href="css/base.css"/>
<link rel="stylesheet" type="text/css" href="css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="css/workspace.css"/>
<style type="text/css">

td{border: 0px; padding: 0px;}
/* th{} */

/* 월 달력 */
.drawMonthCalendarUpper{width: 100%; border-collapse: collapse; border: 0px; table-layout: fixed;}
.drawMonthCalendarUpper th{height:25px; width: 150px; padding: 0px; margin: 0px; background-color: #ffcac7; vertical-align: center;} /* 요일 */

.drawMonthCalDiv{position: relative;}

.drawMonthCalendarLowerForClick{height: 120px; width: 100%; position: absolute; border-collapse: collapse; border: 0px; table-layout: fixed;} /* table1(클릭) */
.drawMonthCalendarLowerForClick th{height: 20px; width: 150px; position: relative; padding: 0px;} 

.drawMonthCalendarLower{height: 120px; width: 100%; position: relative; border-collapse: collapse; border: 0px; table-layout: fixed;} /* table2(날짜) */
.drawMonthCalendarLowerDate{height: 15px;}
.drawMonthCalendarLower th{height: 20px; width: 150px; position: relative; padding: 0px; text-align: left;}

/* 연 달력 */
.drawYearCalDiv{position: relative;}

.drawYearCalendarForClick{height: 120px; width: 100%; position: absolute; border-collapse: collapse; border: 0px; table-layout: fixed;} /* table1(클릭) */
.drawYearCalendarForClick th{height: 20px; width: 150px; position: relative; padding: 0px;} 

.drawYearCalendar{height: 120px; width: 100%; position: relative; border-collapse: collapse; border: 0px; table-layout: fixed;} /* table2(날짜) */
.drawYearCalendarDate{height: 15px; padding: 0px; background-color: #a37f82;}
.drawYearCalendar tr{position: relative;}
.drawYearCalendar th{height: 20px; position: relative; padding: 0px; text-align: center;}

/* 모달 */
.detailScheduleModalOfMonthCal{display: none; width: 300px; height: 300px; top: 10%; left: 10%; position: absolute; background-color: #a37f82;} 
.detailScheduleModalOfYearCal{display: none; width: 300px; height: 300px; top: 10%; left: 10%; position: absolute; background-color: #a37f82;}

.addScheduleModal{display: none; width: 300px; height: 300px; top: 10%; left: 10%; position: absolute; background-color: #a37f82;}
.modifyScheduleModal{display: none; width: 300px; height: 300px; top: 10%; left: 10%; position: absolute; background-color: #a37f82;}

</style>
<script src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous"></script>
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
	markingOnDate(dateFormatChange2(today));
	//추가 모달 열기
	$("#addScheduleButton").on("click", function() {
		$("#addScheduleForm").show("slow");
		var todayForAddScheduleForm = new Date(); //고민 좀..
		$("#startDate").val(dateFormatChange1(todayForAddScheduleForm));
	});
	//추가 모달 닫기
	$("#addScheduleFormClose").on("click", function() {
		$("#addScheduleForm").hide("slow");
		$("#addScheduleForm").each(function() {
			this.reset();
		});
	});
	//추가 모달에서 연 반복 버튼 눌렀을 때 
	$("#addAnnually").on("change", function() {
		if($("#addAnnually").is(":checked")) {
			var startDateTmp = $("#startDate").val();
			$("#endDate").val(startDateTmp); //종료일=시작일
			$("#endDate").prop("readonly", true); //종료일 입력 못하게 	
		} else {
			$("#endDate").prop("readonly", false);
		}
	});
	//추가 모달에서 월 반복 버튼 눌렀을 때 
	$("#addMonthly").on("change", function() {
		if($("#addMonthly").is(":checked")) {
			var startDateTmp = $("#startDate").val();
			console.log(startDateTmp);
			$("#endDate").val(startDateTmp); //종료일=시작일
			$("#endDate").prop("readonly", true); //종료일 입력 못하게 	
		} else {
			$("#endDate").prop("readonly", false);
		}
	});
	//상세 모달 닫기
	$("#detailScheduleFormOfMonthCalClose").on("click", function() {
		$("#detailScheduleFormOfMonthCal").hide("slow");
	});
	//수정 모달 열기
	$("#modifyScheduleButton").on("click", function() {
		$("#detailScheduleFormOfMonthCal").show("slow");
	});
	//수정 모달 닫기
	$("#modifyScheduleFormClose").on("click", function() {
		$("#modifyScheduleForm").hide("slow");
	});
	//수정 모달에서 연 반복 버튼 눌렀을 때 
	$("#modifyAnnually").on("change", function() {
		if($("#modifyAnnually").is(":checked")) {
			var startDateTmp = $("#modifyStartDate").val();
			$("#modifyEndDate").val(startDateTmp); //종료일=시작일
			$("#modifyEndDate").prop("readonly", true); //종료일 입력 못하게 	
		} else {
			$("#modifyEndDate").prop("readonly", false);
		}
	});
	//수정 모달에서 월 반복 버튼 눌렀을 때 
	$("#modifyMonthly").on("change", function() {
		if($("#modifyMonthly").is(":checked")) {
			var startDateTmp = $("#modifyStartDate").val();
			$("#modifyEndDate").val(startDateTmp); //종료일=시작일
			$("#modifyEndDate").prop("readonly", true); //종료일 입력 못하게 	
		} else {
			$("#modifyEndDate").prop("readonly", false);
		}
	});
	//상세 모달에서 수정 버튼을 눌렀을 때
	$("#detailModifyButton").on("click", function() {
		var data = $("#detailScheduleFormOfMonthCal").serialize();
		$("#detailScheduleFormOfMonthCal").hide("fast");
		$("#modifyScheduleForm").show("slow");
	});
	//수정 모달에서 수정 버튼을 눌렀을 때
	$("#modifyButton").on("click", function() {
		var data = $("#modifyScheduleForm").serialize();
		$.ajax({
			url: "modifySchedule",
			data: data,
			type: "post",
			dataType: "json",
			success: function(result) {
				if(result) {
					alert("수정 성공");
					$("#modifyScheduleForm").hide("slow");
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
	});
	//추가
	$("#addScheduleForm").on("submit", function() {
		var data = $(this).serialize();
		$.ajax({
			url: "addSchedule",
			data: data,
			type: "post",
			dataType: "json",
			success: function(result) {
				if(result) {
					alert("성공!");
					$("#addScheduleForm").hide("slow");
					thisMonthCalendar(today);
					showSchedule();
					thisYearCalendar(today);
					showYearSchedule();
					$("#addScheduleForm").each(function() {
						this.reset();
					});
				} else {
					alert("실패..");
				}
			},
			error: function(request, status, error) {
				alert("request:"+request+"\n"
						+"status:"+status+"\n"
						+"error:"+error+"\n");
			}
		}); //end ajax
		return false;
	});
	//삭제
	$("#delete").on("click", function() {
		var data = $("#detailScheduleFormOfMonthCal").serialize();
		$.ajax({
			url: "removeSchedule",
			data: data,
			type: "post",
			dataType: "json",
			success: function(result) {
				if(result) {
					alert("삭제 성공");
					$("#detailScheduleFormOfMonthCal").hide("slow");
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
		var wantedYear = $("#wantedYear").val();
		var wantedMonth = $("#wantedMonth").val();
		var wantedDate = $("#wantedDate").val();
		moveToWantedCalendar(wantedYear, wantedMonth-1, wantedDate);
	});
});	
function thisMonthCalendar(today) {
	console.log(today+"의 월 달력을 그렸습니다.");
	//달력 상단 날짜 그리기
	var calMonthTitle = $("#calMonthTitle");
	calMonthTitle.html(today.getFullYear()+"년 "+(today.getMonth()+1)+"월");
	//달력 상단 요일 그리기
	var month = today.getMonth()+1;
	if((today.getMonth()+1)<10) {
		var month = "0"+(today.getMonth()+1);
	}
	var calendar = "<table class=\"drawMonthCalendarUpper\">";
	calendar += "<tr>";
	calendar += "<th>일</th>";
	calendar += "<th>월</th>";
	calendar += "<th>화</th>";
	calendar += "<th>수</th>";
	calendar += "<th>목</th>";
	calendar += "<th>금</th>";
	calendar += "<th>토</th>";
	calendar += "</tr>";
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
		calendar += "<table class=\"drawMonthCalendarLowerForClick\"><tr>";
		for(var n=0; n<7; n++) {
			if(n<firstDayOfWeek && i==0 || dateCount1>lastDayDate) { //날짜 없는 부분
				calendar += "<th>&nbsp;</th>";
			} else {
				if(dateCount1<10) { //10일 전
					calendar += "<th id="+today.getFullYear()+month+"0"+dateCount1+"></th>";
				} else { //10일 후
					calendar += "<th id="+today.getFullYear()+month+dateCount1+"></th>";
				}
				dateCount1++;
			}
		}
		calendar += "</tr></table>";
		//table2 시작
		calendar += "<table class=\"drawMonthCalendarLower\">";
		calendar += "<tr class='drawMonthCalendarLowerDate' id="+today.getFullYear()+"-"+month+"-"+i+">";
		for(var j=0; j<7; j++) { //날짜 칸
			if(j<firstDayOfWeek && i==0 || dateCount2>lastDayDate) { //날짜 없는 부분
				calendar += "<th>&nbsp;</th>";
			} else {
				if(dateCount2<10) { //10일 전
					calendar += "<th onclick=\"clickOnDate("+today.getFullYear()+month+"0"+dateCount2+")\">"+dateCount2+"</th>";
					
				} else { //10일 후
					calendar += "<th onclick=\"clickOnDate("+today.getFullYear()+month+dateCount2+")\">"+dateCount2+"</th>";
				}
				dateCount2++;
			}
		}
		calendar += "</tr><tr>";
		for(var j=0; j<7; j++) { //빈 칸
			if(j<firstDayOfWeek && i==0 || dateCount3>lastDayDate) { //날짜 없는 부분
				calendar += "<td>&nbsp;</td>";
			} else {
				if(dateCount3<10) { //10일 전
					calendar += "<td onclick=\"clickOnDate("+today.getFullYear()+month+"0"+dateCount3+")\"></td>";

				} else { //10일 후
					calendar += "<td onclick=\"clickOnDate("+today.getFullYear()+month+dateCount3+")\"></td>";
				}
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
							var gap = Number(endDateStrDate.getTime()-startDateStrDate.getTime())/(1000*60*60*24)+Number(1); //시작일부터 종료일까지 기간 구하기
							var tr = trMakerFullLine(startDayOfThisSchedule, endDayOfThisSchedule, gap, title, color);
							$("#"+trClassWhereIWantToAppend).after(tr);
							tr.children('.tdClass').on("click", function() {
								putContentIntoTd(allCalendar[ii]);
							});
						} else if(dateDiff >= 1) { //줄 넘어가는 경우
							var repeatGapFirstRow = Number(7)-Number(startDayOfThisSchedule); //첫 줄
							var tr = trMakerFirstLine(startDayOfThisSchedule, repeatGapFirstRow, title, color);
							$("#"+trClassWhereIWantToAppend).after(tr);
							tr.children('.tdClass').on("click", function() {
								putContentIntoTd(allCalendar[ii]);
							});	
							if(dateDiff>1) { //중간 줄
								for(var i=weekCountOfFirstDate; i<weekCountOfLastDate-1; i++) {
									var tr = trMakerMiddleLine(7, title, color);
									$("#"+startDateYearMonth+"-"+i).after(tr);
									tr.children('.tdClass').on("click", function() {
										putContentIntoTd(allCalendar[ii]);
									});
								}
							}
							var repeatGapLastRow = (Number(endDayOfThisSchedule)+Number(1)); //마지막 줄
							var tr = trMakerLastLine(endDayOfThisSchedule, repeatGapLastRow, title, color);
							$("#"+trClassWhereIWantToAppendLast).after(tr);
							tr.children('.tdClass').on("click", function() {
								putContentIntoTd(allCalendar[ii]);
							});
						}
					} else { //월 넘어가는 경우											
						var repeatGapFirstRow = Number(7)-Number(startDayOfThisSchedule); //첫 줄
						var tr = trMakerFirstLine(startDayOfThisSchedule, repeatGapFirstRow, title, color);
						$("#"+trClassWhereIWantToAppend).after(tr);
						tr.children('.tdClass').on("click", function() {
							putContentIntoTd(allCalendar[ii]);
						});							
						for(var i=weekCountOfFirstDate; i<=findOutNumOfWeekRow(startDateStrDate); i++) {
							var tr = trMakerMiddleLine(7, title, color);
							var tmpid = startDateYearMonth+"-"+i;
							$("#"+tmpid).after(tr);							
							tr.children('.tdClass').on("click", function() {
								putContentIntoTd(allCalendar[ii]);
							});
						}
// 						if((endDateStrDate.getMonth()-startDateStrDate.getMonth())>1) { ???????????????????? 세 달 이상
// 							var nextMonthTmp = new Date(startDateStrDate.getFullYear(), (Number(startDateStrDate.getMonth())+Number(1)), 1);
// 							var tr = trMaker4(startDayOfThisSchedule, endDayOfThisSchedule, 7, title, randomColorRandom);
// 							for(var i=0; i<=findOutNumOfWeekRow(nextMonthTmp); i++) {						
// 								$("."+nextMonthTmp.getFullYear()+"-"+(Number(nextMonthTmp.getMonth())+Number(1))+"-"+i).after(tr);							
// 								tr.children('.tdClass').on("click", function() {
// 									putContentIntoTd(allCalendar[ii]);
// 								});
// 							}
// 						} 	
						for(var i=0; i<weekCountOfLastDate-1; i++) {
							var tr = trMakerMiddleLine(7, title, color);
							$("#"+endDateYearMonth+"-"+i).after(tr);							
							tr.children('.tdClass').on("click", function() {
								putContentIntoTd(allCalendar[ii]);
							});
						}							
						var repeatGapLastRow = (Number(endDayOfThisSchedule)+Number(1)); //마지막 줄
						var tr = trMakerLastLine(endDayOfThisSchedule, repeatGapLastRow, title, color);
						$("#"+trClassWhereIWantToAppendLast).after(tr);
						tr.children('.tdClass').on("click", function() {
							putContentIntoTd(allCalendar[ii]);
						});
					}					
				})(i)
			}
		}
	});
}
function markingOnDate(dateOrigin) {
	console.log(dateOrigin+"를 표시합니다.");
	$("#"+dateOrigin).css({"background-color": "#ffd6d4", "border": "1px solid #fcb4b1"});
}
function dateFormatChange1(dateOrigin) { //2019-09-04
	var month = dateOrigin.getMonth()+1;
	if(month<10) {
		month = "0"+month;
	}
	var date = dateOrigin.getDate();
	if(date<10) {
		date = "0"+date;
	}
	var tmp = dateOrigin.getFullYear()+"-"+month+"-"+date;
	return tmp;
}
function dateFormatChange2(dateOrigin) { //20190904
	var month = dateOrigin.getMonth()+1;
	if(month<10) {
		month = "0"+month;
	} else {
		month = ""+month;
	}
	var date = dateOrigin.getDate();
	if(date<10) {
		date = "0"+date;
	} else {
		date = ""+date;
	}
	var tmp = dateOrigin.getFullYear()+month+date;
	return tmp;
}
function clickOnDate(dateTmp) { //날짜 클릭 시 추가 모달 열기
	$("#addScheduleForm").show("slow");
	var dateReformed = String(dateTmp).substring(0, 4)+"-"+String(dateTmp).substring(4, 6)+"-"+String(dateTmp).substring(6, 8);
	$("#startDate").val(dateReformed);	
}
function putContentIntoTd(allCalendarr) {
	$("#detailScheduleFormOfMonthCal").show("slow");
	$("#detailCNumOfMonthCal").val(allCalendarr.cNum);
	$("#modifyCNum").val(allCalendarr.cNum);
	$("#detailTitleOfMonthCal").val(allCalendarr.title);
	$("#modifyTitle").val(allCalendarr.title);
	$("#detailStartDateOfMonthCal").val(allCalendarr.startDate.substring(0, 10));
	$("#modifyStartDate").val(allCalendarr.startDate.substring(0, 10));
	$("#detailEndDateOfMonthCal").val(allCalendarr.endDate.substring(0, 10));
	$("#modifyEndDate").val(allCalendarr.endDate.substring(0, 10));
	$("#detailContentOfMonthCal").val(allCalendarr.content);
	$("#modifyContent").val(allCalendarr.content);
	$("#detailTypeOfMonthCal").val(allCalendarr.type);
	$("#modifyType").val(allCalendarr.type);
	var yearCalendarTmp = allCalendarr.yearCalendar;
	$("#detailYearCalendarOfMonthCal").prop("checked", change(yearCalendarTmp));
	$("#modifyYearCalendar").prop("checked", change(yearCalendarTmp));
	var annuallyTmp = allCalendarr.annually;
	$("#detailAnnuallyOfMonthCal").prop("checked", change(annuallyTmp));
	$("#modifyAnnually").prop("checked", change(annuallyTmp));
	var monthlyTmp = allCalendarr.monthly;
	$("#detailMonthlyOfMonthCal").prop("checked", change(monthlyTmp));
	$("#modifyMonthly").prop("checked", change(monthlyTmp));
	$("#detailColor").val(allCalendarr.color);
	$("#modifyColor").val(allCalendarr.color);
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
function trMakerFullLine(startDayOfThisSchedule, endDayOfThisSchedule, gap, title, color) { //앞,중간,뒤
	var tr = $("<tr style=\"border: 0px white;\" height=\"20\">");
	for(var l=0; l<startDayOfThisSchedule; l++) { 
		let tdEtc = $("<td colspan=\"1\"; style=\"margin-bottom: 1pt; margin-top: 1pt;\"></td>");
		tr.append(tdEtc);
	}
	var td = $("<td class=\"tdClass\" colspan="+gap+"><div style=\"border: 1px; margin-bottom: 1pt; margin-top: 1pt; border-radius: 10px; background-color: "+color+"\">"+"&nbsp;&nbsp;"+title+"</div></td>");
	tr.append(td);
	var numberOfTdEtc = Number(6)-Number(endDayOfThisSchedule);
	for(var l=0; l<numberOfTdEtc; l++) {
		let tdEtc = $("<td colspan=\"1\"; style=\"margin-bottom: 1pt; margin-top: 1pt;\"></td>");
		tr.append(tdEtc);
	}
	return tr;
}
function trMakerFirstLine(startDayOfThisSchedule, gap, title, color) { //앞,중간
	var tr = $("<tr style=\"border: 0px white;\" height=\"20\">");
	for(var l=0; l<startDayOfThisSchedule; l++) {
		let tdEtc = $("<td colspan=\"1\"; style=\"margin-bottom: 1pt; margin-top: 1pt;\"></td>");
		tr.append(tdEtc);
	}
	var td = $("<td class=\"tdClass\" colspan="+gap+"><div style=\"border: 1px; margin-bottom: 1pt; margin-top: 1pt; border-bottom-left-radius: 10px; border-top-left-radius: 10px; background-color: "+color+"\">"+"&nbsp;&nbsp;"+title+"</div></td>");
	tr.append(td);
	return tr;
}
function trMakerLastLine(endDayOfThisSchedule, gap, title, color) { //중간,뒤
	var tr = $("<tr style=\"border: 0px white;\" height=\"20\">");
	var td = $("<td class=\"tdClass\" colspan="+gap+"><div style=\"border: 1px; margin-bottom: 1pt; margin-top: 1pt; border-bottom-right-radius: 10px; border-top-right-radius: 10px; background-color: "+color+"\">"+"&nbsp;&nbsp;"+title+"</div></td>");
	tr.append(td);
	var numberOfTdEtc = Number(6)-Number(endDayOfThisSchedule);
	for(var l=0; l<numberOfTdEtc; l++) {
		let tdEtc = $("<td colspan=\"1\"; style=\"margin-bottom: 1pt; margin-top: 1pt;\"></td>");
		tr.append(tdEtc);
	}
	return tr;
}
function trMakerMiddleLine(gap, title, color) { //중간
	var tr = $("<tr style=\"border: 0px white;\" height=\"20\">");
	var td = $("<td class=\"tdClass\" colspan="+gap+"><div style=\"border: 1px; margin-bottom: 1pt; margin-top: 1pt; background-color: "+color+"\">"+"&nbsp;&nbsp;"+title+"</div></td>");
	tr.append(td);
	return tr;
}
function moveToWantedCalendar(wantedYear, wantedMonth, wantedDate) {
	console.log("moveToWantedCalendar");
	today = new Date(wantedYear, wantedMonth, wantedDate);
	thisMonthCalendar(today);
	showSchedule();
	markingOnDate(dateFormatChange2(today));
	$("#yearCalendar").hide();
	$("#monthCalendar").show();	
}
var todayTmp = new Date();
function preMonthOfMonthCal() {
	today = new Date(today.getFullYear(), today.getMonth()-1, 1);
	thisMonthCalendar(today);
	showSchedule();
	markingOnDate(dateFormatChange2(todayTmp));
}
function nextMonthOfMonthCal() { 
	today = new Date(today.getFullYear(), today.getMonth()+1, 1);
	thisMonthCalendar(today);
	showSchedule();
	markingOnDate(dateFormatChange2(todayTmp));
}
function preYearOfMonthCal() {
	today = new Date(today.getFullYear()-1, today.getMonth(), 1);
	thisMonthCalendar(today);
	showSchedule();
	markingOnDate(dateFormatChange2(todayTmp));
}
function nextYearOfMonthCal() {
	today = new Date(today.getFullYear()+1, today.getMonth(), 1);
	thisMonthCalendar(today);
	showSchedule();
	markingOnDate(dateFormatChange2(todayTmp));
}
function change(param) {
	if(param == "1") {
		param = true;
	} else {
		param = false;
	}
	return param;
}
function randomColor() {
	var colorCode = "#"+Math.round(Math.random()*0xffffff).toString(16);
	return colorCode;
}
//----------------------------------------------------------------------------연간 달력
$(function() {
	thisYearCalendar(today);
	showYearSchedule();
	markingOnDateOfYearCal(dateFormatChange2(today).substring(0, 6));
	//상세 모달 닫기
	$("#detailScheduleFormOfYearCalClose").on("click", function() {
		$("#detailScheduleFormOfYearCal").hide("slow");
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
	var calYearTitle = $("#calYearTitle");
	calYearTitle.html(year+"년 ");
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
					
					var sMonthRow = monthChange(startDateMonth); 
					var eMonthRow = monthChange(endDateMonth);
					var color = allYearSchedule[ii].color;
					
					if(sMonthRow == eMonthRow) {
						var dateNumber = startDateYear+"-"+sMonthRow;
						var tr = trMakerFullLineOfYearCal(startDateMonth, (endDateMonth-startDateMonth)+1, title, color, 1);
						$("#"+dateNumber).after(tr);
						tr.children('.tdClass').on("click", function() {
							putContentIntoTdOfYearCal(allYearSchedule[ii]);
						})
					} else {
						var sDateNumber = startDateYear+"-"+sMonthRow; //첫줄
						var tr = trMakerFullLineOfYearCal(startDateMonth, (endDateMonth-startDateMonth), title, color, 2);
						$("#"+sDateNumber).after(tr);
						tr.children('.tdClass').on("click", function() {
							putContentIntoTdOfYearCal(allYearSchedule[ii]);
						})
						var eDateNumber = endDateYear+"-"+eMonthRow; //막줄
						var tr = trMakerFullLineOfYearCal(endDateMonth, (endDateMonth-startDateMonth), title, color, 3);
						$("#"+eDateNumber).after(tr);
						tr.children('.tdClass').on("click", function() {
							putContentIntoTdOfYearCal(allYearSchedule[ii]);
						})		
					}
				})(i)
			}
		}
	});
}
function trMakerFullLineOfYearCal(month, gap, title, color, type) { //앞,중간,뒤
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
		td = $("<td class=\"tdClass\" colspan="+gap+"><div style=\"border: 1px; margin-bottom: 1pt; margin-top: 1pt; border-radius: 10px; background-color: "+color+"\">"+"&nbsp;&nbsp;"+title+"</div></td>");
	} else if(type == 2) {
		td = $("<td class=\"tdClass\" colspan="+gap+"><div style=\"border: 1px; margin-bottom: 1pt; margin-top: 1pt; border-bottom-left-radius: 10px; border-top-left-radius: 10px; background-color: "+color+"\">"+"&nbsp;&nbsp;"+title+"</div></td>");
	} else if(type == 3) {
		td = $("<td class=\"tdClass\" colspan="+gap+"><div style=\"border: 1px; margin-bottom: 1pt; margin-top: 1pt; border-bottom-right-radius: 10px; border-top-right-radius: 10px; background-color: "+color+"\">"+"&nbsp;&nbsp;"+title+"</div></td>");
	} else if(type == 4) {
		td = $("<td class=\"tdClass\" colspan="+gap+"><div style=\"border: 1px; margin-bottom: 1pt; margin-top: 1pt; background-color: "+color+"\">"+"&nbsp;&nbsp;"+title+"</div></td>");
	}
	tr.append(td);
	var numberOfTdEtc = 4-tmp-gap;
	for(var l=0; l<numberOfTdEtc; l++) {
		let tdEtc = $("<td colspan=\"1\"; style=\"margin-bottom: 1pt; margin-top: 1pt;\"></td>");
		tr.append(tdEtc);
	}
	return tr;
}
function markingOnDateOfYearCal(dateOrigin) {
	$("#"+dateOrigin).css({"background-color": "#ffd6d4", "border": "1px solid #fcb4b1"});
}
function monthChange(monthTmp) {
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
function putContentIntoTdOfYearCal(allCalendarr) {
	$("#detailScheduleFormOfYearCal").show("slow");
	$("#detailCNumOfYearCal").val(allCalendarr.cNum);
	$("#detailTitleOfYearCal").val(allCalendarr.title);
	$("#detailStartDateOfYearCal").val(allCalendarr.startDate.substring(0, 10));
	$("#detailEndDateOfYearCal").val(allCalendarr.endDate.substring(0, 10));
	$("#detailContentOfYearCal").val(allCalendarr.content);
	$("#detailTypeOfYearCal").val(allCalendarr.type);
	var yearCalendarTmp = allCalendarr.yearCalendar;						
	$("#detailYearCalendarOfYearCal").prop("checked", change(yearCalendarTmp));
	var annuallyTmp = allCalendarr.annually;
	$("#detailAnnuallyOfYearCal").prop("checked", change(annuallyTmp));
	var monthlyTmp = allCalendarr.monthly;
	$("#detailMonthlyOfYearCal").prop("checked", change(monthlyTmp));	
	$("#detailColorOfYearCal").val(allCalendarr.color);
}
var todayTmp = new Date();
function preYearOfYearCal() {
	today = new Date(today.getFullYear(), today.getMonth()-12);
	thisYearCalendar(today);
	showYearSchedule();
	markingOnDateOfYearCal(dateFormatChange2(todayTmp).substring(0, 6));
}
function nextYearOfYearCal() {
	today = new Date(today.getFullYear(), today.getMonth()+12);
	thisYearCalendar(today);
	showYearSchedule();
	markingOnDateOfYearCal(dateFormatChange2(todayTmp).substring(0, 6));
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
		<div id="wsBodyContainer">
	<form action="calSearchList">
		<select name="searchType">
			<option value="1">제목</option>
			<option value="2">상세</option>
			<option value="3">작성자</option>
		</select>
		<input type="text" name="searchKeyword" placeholder="검색어를 입력해주세요.">
		<input type="submit" value="검색">
	</form>
	<button type="button" id="addScheduleButton">일정 추가</button>
	<label><input type="checkbox" name="calType" id="calType1" value="project" checked="checked">프로젝트</label>
	<label><input type="checkbox" name="calType" id="calType2" value="vacation" checked="checked">휴가</label>
	<label><input type="checkbox" name="calType" id="calType3" value="event" checked="checked">행사</label>
	<button id="changeYearCalToMonthCal">월간</button>
	<button id="changeMonthCalToYearCal">연간</button><br>
	<hr>	
<!-- 월 달력 -->
	<div id="monthCalendar" class="monthCalendar">
		<button onclick="preYearOfMonthCal()">작년</button>
		<button onclick="preMonthOfMonthCal()">이전 달</button>
		<span id="calMonthTitle" style="font-size: 20pt"></span>
		<button onclick="nextMonthOfMonthCal()">다음 달</button>
		<button onclick="nextYearOfMonthCal()">내년</button><br>
		<input type="text" id="wantedYear">년
		<input type="text" id="wantedMonth">월
		<input type="text" id="wantedDate">일
		<input type="button" id="wantedCalendarButton" value="이동">	
		<div id="calMonthBody"></div>
		<!-- 일정 추가 모달 -->
		<form id="addScheduleForm" class="addScheduleModal">
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
			<input type="hidden" name="mNum" id="mNum" value="${userData.mNum}">
			<input type="hidden" name="wNum" id="wNum" value="${userData.wNum}">
			제목<input type="text" name="title" id="title"><br>
			기간
			(시작날짜)<input type="date" name="startDate" id="startDate"><br>
	 		(종료날짜)<input type="date" name="endDate" id="endDate"><br>
			상세<textarea rows="5" cols="21" name="content" id="content"></textarea><br>
			타입<select name="type">
				<option value="project">프로젝트</option>
				<option value="vacation">휴가</option>
				<option value="event">행사</option>
				</select><br>
			<label><input type="checkbox" name="yearCalendar" id="addYearCalendar" value="yearCalendar">연간 달력 표시</label><br> 
			<label><input type="checkbox" name="annually" id="addAnnually" value="annually">매년 반복</label>
			<label><input type="checkbox" name="monthly" id="addMonthly" value="monthly">매월 반복</label><br>
			색깔<input type="color" name="color" id="addColor" value="#fffde8"><br>
			<input type="button" id="addScheduleFormClose" value="닫기">
			<input type="submit" id="add" value="추가">
		</form>
		<!-- 일정 상세 모달 -->
		<form id="detailScheduleFormOfMonthCal" class="detailScheduleModalOfMonthCal">
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"> 
			<input type="hidden" name="cNum" id="detailCNumOfMonthCal">
			<input type="hidden" name="mNum" id="mNum" value="${userData.mNum}">
			<input type="hidden" name="wNum" id="wNum" value="${userData.wNum}">
			제목<input type="text" name="title" id="detailTitleOfMonthCal" readonly="readonly"><br>
			기간
			(시작날짜)<input type="date" name="startDate" id="detailStartDateOfMonthCal" readonly="readonly"><br>
	 		(종료날짜)<input type="date" name="endDate" id="detailEndDateOfMonthCal" readonly="readonly"><br>	
			상세<textarea rows="5" cols="21" name="content" id="detailContentOfMonthCal" readonly="readonly"></textarea><br>
			타입<select name="type" id="detailTypeOfMonthCal">
				<option value="project">프로젝트</option>
				<option value="vacation">휴가</option>
				<option value="event">행사</option>
				</select><br>
			<label><input type="checkbox" name="yearCalendar" id="detailYearCalendarOfMonthCal" value="yearCalendar">연간 달력 표시</label><br>
			<label><input type="checkbox" name="annually" id="detailAnnuallyOfMonthCal" value="annually">매년 반복</label>
			<label><input type="checkbox" name="monthly" id="detailMonthlyOfMonthCal" value="monthly">매월 반복</label><br>
			색깔<input type="color" name="color" id="detailColor" value="#fffde8"><br>
			<input type="button" id="detailScheduleFormOfMonthCalClose" value="닫기">
			<input type="button" id="delete" value="삭제">
			<input type="button" id="detailModifyButton" value="수정">
		</form>
	<!-- 일정 수정 모달 -->
		<form id="modifyScheduleForm" class="modifyScheduleModal">
 			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
 			<input type="hidden" name="cNum" id="modifyCNum">
			<input type="hidden" name="mNum" id="mNum" value="${userData.mNum}">
			<input type="hidden" name="wNum" id="wNum" value="${userData.wNum}">
			제목<input type="text" name="title" id="modifyTitle"><br>
			기간
			(시작날짜)<input type="date" name="startDate" id="modifyStartDate"><br>
 			(종료날짜)<input type="date" name="endDate" id="modifyEndDate"><br>	
			상세<textarea rows="5" cols="21" name="content" id="modifyContent"></textarea><br>
			타입<select name="type" id="modifyType">
				<option value="project">프로젝트</option>
				<option value="vacation">휴가</option>
				<option value="event">행사</option>
				</select><br>
			<label><input type="checkbox" name="yearCalendar" id="modifyYearCalendar" value="yearCalendar">연간 달력 표시</label><br>
			<label><input type="checkbox" name="annually" id="modifyAnnually" value="annually">매년 반복</label>
			<label><input type="checkbox" name="monthly" id="modifyMonthly" value="monthly">매월 반복</label><br>
			색깔<input type="color" name="color" id="modifyColor" value="#fffde8"><br>
			<input type="button" id="modifyScheduleFormClose" value="닫기">
			<input type="button" id="modifyButton" value="수정">
		</form>
	</div>	
<!-- 연간 달력 -->
	<div id="yearCalendar" class="yearCalendar">
		<button onclick="preYearOfYearCal()">작년</button>
		<span id="calYearTitle" style="font-size: 20pt"></span>
		<button onclick="nextYearOfYearCal()">내년</button>
		<div id="calYearBody"></div>
		<!-- 일정 상세 모달 --> 
		<form id="detailScheduleFormOfYearCal" class="detailScheduleModalOfYearCal">
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
			<input type="hidden" name="cNum" id="detailCNumOfYearCal">
			<input type="hidden" name="mNum" id="mNum" value="${userData.mNum}">
			<input type="hidden" name="wNum" id="wNum" value="${userData.wNum}">
			제목<input type="text" name="title" id="detailTitleOfYearCal" readonly="readonly"><br>
			기간
			(시작날짜)<input type="date" name="startDate" id="detailStartDateOfYearCal" readonly="readonly"><br>
	 		(종료날짜)<input type="date" name="endDate" id="detailEndDateOfYearCal" readonly="readonly"><br>	
			상세<textarea rows="5" cols="21" name="content" id="detailContentOfYearCal" readonly="readonly"></textarea><br>
			타입<select name="type" id="detailTypeOfYearCal">
				<option value="project">프로젝트</option>
				<option value="vacation">휴가</option>
				<option value="event">행사</option>
				</select><br>
			<label><input type="checkbox" name="yearCalendar" id="detailYearCalendarOfYearCal" value="yearCalendar">연간 달력 표시</label><br>
			<label><input type="checkbox" name="annually" id="detailAnnuallyOfYearCal" value="annually">매년 반복</label>
			<label><input type="checkbox" name="monthly" id="detailMonthlyOfYearCal" value="monthly">매월 반복</label><br>
			색깔<input type="color" name="color" id="detailColorOfYearCal" value="#fffde8"><br>
			<input type="button" id="detailScheduleFormOfYearCalClose" value="닫기">
		</form>
	</div>	
	</div>
	</div>
</body>
</html>
