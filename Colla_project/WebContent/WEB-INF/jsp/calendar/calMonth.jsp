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
<style type="text/css">

td{border: 0px; padding: 0px;}
.drawMonthCalendarUpper{border-collapse: collapse; border: 0px;}
.drawMonthCalendarLower{border-collapse: collapse; border: 0px;}
.drawYearCalendar{border-collapse: collapse; border: 0px;}

.detailScheduleModalOfMonthCal{display: none; width: 300px; height: 250px; top: 10%; left: 10%; position: absolute; background-color: #ffd9dc;} 
.detailScheduleModalOfYearCal{display: none; width: 300px; height: 250px; top: 10%; left: 10%; position: absolute; background-color: #ffd9dc;}

.addScheduleModal{display: none; width: 300px; height: 250px; top: 10%; left: 10%; position: absolute; background-color: #ffe8ea;}
.modifyScheduleModal{display: none; width: 300px; height: 250px; top: 10%; left: 10%; position: absolute; background-color: #ffe8ea;}

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
	//추가 모달 열기
	$("#addScheduleButton").on("click", function() {
		$("#addScheduleForm").show("slow");
	});
	//추가 모달 닫기
	$("#addScheduleFormClose").on("click", function() {
		$("#addScheduleForm").hide("slow");
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
		$("#addScheduleForm").hide("slow");
	});
	//수정 모달 열기
	$("#modifyScheduleButton").on("click", function() {
		$("#detailScheduleFormOfMonthCal").show("slow");
	});
	//수정 모달 닫기
	$("#modifyScheduleFormClose").on("click", function() {
		$("#modifyScheduleForm").hide("slow");
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
		console.log(wantedYear+" "+wantedMonth+" "+wantedDate);
		moveToWantedCalendar(wantedYear, wantedMonth-1, wantedDate);
	});
});	
function thisMonthCalendar(today) {
	console.log("today? "+today);
	//달력 상단 날짜 그리기
	var calMonthTitle = $("#calMonthTitle");
	calMonthTitle.html(today.getFullYear()+"년 "+(today.getMonth()+1)+"월");
	//달력 상단 요일 그리기
	var month = today.getMonth()+1;
	if((today.getMonth()+1)<10) {
		var month = "0"+(today.getMonth()+1);
	}
	var calendar = "<table border = '1' class=\"drawMonthCalendarUpper\">";
	calendar += "<tr>";
	calendar += "<th width=\"150\" style=\"padding: 0px;\">일</th>";
	calendar += "<th width=\"150\" style=\"padding: 0px;\">월</th>";
	calendar += "<th width=\"150\" style=\"padding: 0px;\">화</th>";
	calendar += "<th width=\"150\" style=\"padding: 0px;\">수</th>";
	calendar += "<th width=\"150\" style=\"padding: 0px;\">목</th>";
	calendar += "<th width=\"150\" style=\"padding: 0px;\">금</th>";
	calendar += "<th width=\"150\" style=\"padding: 0px;\">토</th>";
	calendar += "</tr>";
	calendar += "</table>";
	//달력 하단 날짜 그리기
	var firstDay = new Date(today.getFullYear(), today.getMonth(), 1);
	var lastDay = new Date(today.getFullYear(), today.getMonth()+1, 0);
	var firstDayOfWeek = firstDay.getDay();
	var lastDayDate = lastDay.getDate();
	var numOfWeekRow = Math.ceil((lastDayDate+firstDayOfWeek)/7);
	var dateCount = 1;
	
	for(var i=0; i<numOfWeekRow; i++) { //줄
		calendar += "<div>";
		calendar += "<table height=\"120px\" border = '1' class=\"drawMonthCalendarLower\" style=\"\">";
		calendar += "<tr height=\"15px\" class="+today.getFullYear()+"-"+month+"-"+i+">";
		for(var j=0; j<7; j++) { //날짜 칸
			if(j<firstDayOfWeek && i==0 || dateCount>lastDayDate) { //날짜 없는 부분
				calendar += "<th width=\"150\" style=\"padding: 0px; height: 20px; position: relative; text-align: left; background-color: #ffe8ef\">&nbsp;</th>";
			} else {
				if(dateCount<10) { //10일 전
					calendar += "<th onclick=\"clickOnDate("+today.getFullYear()+month+"0"+dateCount+")\" width=\"150\" style=\"padding: 0px; height: 20px; position: relative; text-align: left; background-color: #ffe8ef\" id="+today.getFullYear()+month+"0"+dateCount+">"+dateCount+"</th>";
					
				} else { //10일 후
					calendar += "<th onclick=\"clickOnDate("+today.getFullYear()+month+dateCount+")\" width=\"150\" style=\"padding: 0px; height: 20px; position: relative; text-align: left; background-color: #ffe8ef\" id="+today.getFullYear()+month+dateCount+">"+dateCount+"</th>";
				}
				dateCount++;
			}
		}
		calendar += "</tr>";
		for(var k=0; k<3; k++) {
			calendar += "<tr style=\"border: 0px white;\"><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>";
		}
	 	calendar += "</table>";	
	 	calendar += "</div>";	
	}; //for문 끝
	var calMonthBody = $("#calMonthBody"); 
	calMonthBody.html(calendar);	
}
function showSchedule() {
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
					
					if(startDateMonth==endDateMonth) { //월 안 넘어가는 경우
						var dateDiff = Math.abs(weekCountOfLastDate-weekCountOfFirstDate);
						if(dateDiff == 0) { //줄 안 넘어가는 경우
							var gap = Number(endDateStrDate.getTime()-startDateStrDate.getTime())/(1000*60*60*24)+Number(1); //시작일부터 종료일까지 기간 구하기
							var tr = trMakerFullLine(startDayOfThisSchedule, endDayOfThisSchedule, gap, title, randomColor());
							$("."+trClassWhereIWantToAppend).after(tr);
							tr.children('.tdClass').on("click", function() {
								putContentIntoTd(allCalendar[ii]);
							});
						} else if(dateDiff >= 1) { //줄 넘어가는 경우
							var randomColorRandom = randomColor();
							var repeatGapFirstRow = Number(7)-Number(startDayOfThisSchedule); //첫 줄
							var tr = trMakerFirstLine(startDayOfThisSchedule, repeatGapFirstRow, title, randomColorRandom);
							$("."+trClassWhereIWantToAppend).after(tr);
							tr.children('.tdClass').on("click", function() {
								putContentIntoTd(allCalendar[ii]);
							});	
							if(dateDiff>1) { //중간 줄
								for(var i=weekCountOfFirstDate; i<weekCountOfLastDate-1; i++) {
									var tr = trMakerMiddleLine(7, title, randomColorRandom);
									$("."+startDateYearMonth+"-"+i).after(tr);
									tr.children('.tdClass').on("click", function() {
										putContentIntoTd(allCalendar[ii]);
									});
								}
							}
							var repeatGapLastRow = (Number(endDayOfThisSchedule)+Number(1)); //마지막 줄
							var tr = trMakerLastLine(endDayOfThisSchedule, repeatGapLastRow, title, randomColorRandom);
							$("."+trClassWhereIWantToAppendLast).after(tr);
							tr.children('.tdClass').on("click", function() {
								putContentIntoTd(allCalendar[ii]);
							});
						}
					} else { //월 넘어가는 경우											
						var randomColorRandom = randomColor();
						var repeatGapFirstRow = Number(7)-Number(startDayOfThisSchedule); //첫 줄
						var tr = trMakerFirstLine(startDayOfThisSchedule, repeatGapFirstRow, title, randomColorRandom);
						$("."+trClassWhereIWantToAppend).after(tr);
						tr.children('.tdClass').on("click", function() {
							putContentIntoTd(allCalendar[ii]);
						});							
						for(var i=weekCountOfFirstDate; i<=findOutNumOfWeekRow(startDateStrDate); i++) {
							var tr = trMakerMiddleLine(7, title, randomColorRandom);
							var tmpid = startDateYearMonth+"-"+i;
							$("."+tmpid).after(tr);							
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
							var tr = trMakerMiddleLine(7, title, randomColorRandom);
							$("."+endDateYearMonth+"-"+i).after(tr);							
							tr.children('.tdClass').on("click", function() {
								putContentIntoTd(allCalendar[ii]);
							});
						}							
						var repeatGapLastRow = (Number(endDayOfThisSchedule)+Number(1)); //마지막 줄
						var tr = trMakerLastLine(endDayOfThisSchedule, repeatGapLastRow, title, randomColorRandom);
						$("."+trClassWhereIWantToAppendLast).after(tr);
						tr.children('.tdClass').on("click", function() {
							putContentIntoTd(allCalendar[ii]);
						});
					}					
				})(i)
			}
		}
	});
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
	today = new Date(wantedYear, wantedMonth, wantedDate);
	thisMonthCalendar(today);
	showSchedule();
	$("#yearCalendar").hide();
	$("#monthCalendar").show();	
}
function preMonthOfMonthCal() {
	today = new Date(today.getFullYear(), today.getMonth()-1, today.getDate());
	thisMonthCalendar(today);
	showSchedule();
}
function nextMonthOfMonthCal() { 
	today = new Date(today.getFullYear(), today.getMonth()+1, today.getDate());
	thisMonthCalendar(today);
	showSchedule();
}
function preYearOfMonthCal() {
	today = new Date(today.getFullYear()-1, today.getMonth(), today.getDate());
	thisMonthCalendar(today);
	showSchedule();
}
function nextYearOfMonthCal() {
	today = new Date(today.getFullYear()+1, today.getMonth(), today.getDate());
	thisMonthCalendar(today);
	showSchedule();
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
	console.log("year today? "+today);
	//달력 상단 날짜 그리기
	var year = today.getFullYear();
	var calYearTitle = $("#calYearTitle");
	calYearTitle.html(year+"년 ");
	//달력 날짜 그리기
	var monthCount = 1;
	var calendar = "<div></div>";
	for(var i=0; i<3; i++) { //줄
		calendar += "<div>"
		calendar += "<table height=\"120px\" border = '1' class=\"drawYearCalendar\" style=\"\">";
		calendar += "<tr height=\"15px\" class="+today.getFullYear()+"-"+i+">";
		for(var j=0; j<4; j++) { //날짜 칸
			if(monthCount<10) { //10일 전
				calendar += "<th onclick=\"moveToWantedCalendar("+year+", "+(monthCount-1)+", 1)\" width=\"260\" style=\"padding: 0px; height: 20px; position: relative; text-align: center; background-color: #ffe8ef\" id="+year+"0"+monthCount+">"+monthCount+"</th>";				
			} else { //10일 후
				calendar += "<th onclick=\"moveToWantedCalendar("+year+", "+(monthCount-1)+", 1)\" width=\"260\" style=\"padding: 0px; height: 20px; position: relative; text-align: center; background-color: #ffe8ef\" id="+year+monthCount+">"+monthCount+"</th>";
			}
			monthCount++;
		}
		calendar += "</tr>";
	 	for(var k=0; k<3; k++) {
			calendar += "<tr style=\"border: 0px white;\"><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>";
		}
		calendar += "</table>";	
		calendar += "</div>";
	}
	var calYearBody = $("#calYearBody");
	calYearBody.html(calendar);
} //for문 끝
function showYearSchedule() {
	var type1 = $("#calType1").prop("checked");
	var type2 = $("#calType2").prop("checked");
	var type3 = $("#calType3").prop("checked");
	console.log(type1+" "+type2+" "+type3);
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
					var randomColorRandom = randomColor();
					if(sMonthRow == eMonthRow) {
						var dateNumber = startDateYear+"-"+sMonthRow;
						var tr = trMakerFullLineOfYearCal(startDateMonth, (endDateMonth-startDateMonth)+1, title, randomColorRandom, 1);
						$("."+dateNumber).after(tr);
						tr.children('.tdClass').on("click", function() {
							putContentIntoTdOfYearCal(allYearSchedule[ii]);
						})
					} else {
						var sDateNumber = startDateYear+"-"+sMonthRow;
						var tr = trMakerFullLineOfYearCal(startDateMonth, (endDateMonth-startDateMonth)+1, title, randomColorRandom, 2);
						$("."+sDateNumber).after(tr);
						tr.children('.tdClass').on("click", function() {
							putContentIntoTdOfYearCal(allYearSchedule[ii]);
						})
						var eDateNumber = endDateYear+"-"+eMonthRow;
						var tr = trMakerFullLineOfYearCal(endDateMonth, (endDateMonth-startDateMonth), title, randomColorRandom, 3);
						$("."+eDateNumber).after(tr);
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
	for(var l=0; l<tmp; l++) { 
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
}
function preYearOfYearCal() {
	today = new Date(today.getFullYear(), today.getMonth()-12);
	thisYearCalendar(today);
	showYearSchedule();
}
function nextYearOfYearCal() {
	today = new Date(today.getFullYear(), today.getMonth()+12);
	thisYearCalendar(today);
	showYearSchedule();
}
</script>
</head>
<body>
<!-- 공통 부분 -->
<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%>
<%@ include file="/WEB-INF/jsp/inc/navWs.jsp"%>
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
			<input type="button" id="detailScheduleFormOfYearCalClose" value="닫기">
		</form>
	</div>	
</body>
</html>
