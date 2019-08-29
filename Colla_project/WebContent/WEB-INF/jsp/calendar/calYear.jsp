<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
String contextPath = request.getContextPath();
request.setAttribute("contextPath", contextPath);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>calYear - test</title>
<style type="text/css">
.drawMonthCalendar{border-collapse: collapse; border: 0px;}
.addScheduleModal{display: none; width: 300px; height: 250px; top: 10%; left: 10%; position: absolute; background-color: #ffe8ea;}
.detailScheduleModalOfMonthCal{display: none; width: 300px; height: 250px; top: 10%; left: 10%; position: absolute; background-color: #ffd9dc;}
</style>
<script src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous"></script>
<script type="text/javascript">
var today = new Date();
var date = new Date();
$(function() {
	thisMonthCalendar(today);
	tmpShowSchedule();
	//추가 모달 열기
	$("#addScheduleButton").on("click", function() {
		$("#addScheduleForm").show("slow");
	});
	//추가 모달 닫기
	$("#addScheduleFormClose").on("click", function() {
		$("#addScheduleForm").hide("slow");
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
		tmpShowSchedule();
	});
	$("#calType2").on("change", function() {
		thisMonthCalendar(today);
		tmpShowSchedule();
	});
	$("#calType3").on("change", function() {
		thisMonthCalendar(today);
		tmpShowSchedule();
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
	console.log("thisMonthCalendar 실행");
	//달력 상단 날짜 그리기
	var firstDay = new Date(today.getFullYear(), today.getMonth(), 1);
	var lastDay = new Date(today.getFullYear(), today.getMonth()+1, 0);
	var calMonthTitle = $("#calMonthTitle");
	calMonthTitle.html(today.getFullYear()+"년 "+(today.getMonth()+1)+"월");
	//달력 상단 요일 그리기
	var month = today.getMonth()+1;
	if((today.getMonth()+1)<10) {
		var month = "0"+(today.getMonth()+1);
	}
	var calendar = "<table border = '0' class=\"drawMonthCalendar\">";
	calendar += "<tr>";
	calendar += "<th width=\"150\">일</th>";
	calendar += "<th width=\"150\">월</th>";
	calendar += "<th width=\"150\">화</th>";
	calendar += "<th width=\"150\">수</th>";
	calendar += "<th width=\"150\">목</th>";
	calendar += "<th width=\"150\">금</th>";
	calendar += "<th width=\"150\">토</th>";
	calendar += "</tr>";
	calendar += "</table>";
	//달력 하단 날짜 그리기
	var firstDayOfWeek = firstDay.getDay();
	var lastDayDate = lastDay.getDate();
	var numOfWeekRow = Math.ceil((lastDayDate+firstDayOfWeek)/7);
	var dateCount = 1;
	for(var i=0; i<numOfWeekRow; i++) {
		calendar += "<div>";
		calendar += "<table>";
		calendar += "<tr>";
		for(var j=0; j<7; j++) {
			if(j<firstDayOfWeek && i==0 || dateCount>lastDayDate) {
				calendar += "<td style=\"padding: 0px; height: 100px; position: relative; vertical-align: top;\">&nbsp;</td>";
			} else {
				if(dateCount<10) {
					calendar += "<td style=\"padding: 0px; height: 100px; position: relative; vertical-align: top;\" id="+today.getFullYear()+month+"0"+dateCount+">"+"<p style=\"margin: 0; background-color: #ffe8ef\">"+dateCount+"</p>"+"</td>";
				} else {
					calendar += "<td style=\"padding: 0px; height: 100px; position: relative; vertical-align: top;\" id="+today.getFullYear()+month+dateCount+">"+"<p style=\"margin: 0; background-color: #ffe8ef\">"+dateCount+"</p>"+"</td>";
				}
				dateCount++;
			}
		}
		calendar += "</tr>";
		calendar += "</table>";
		calendar += "</div>";
	}; //for문 끝
// 	calendar += "</table>";
	var calMonthBody = $("#calMonthBody"); 
	calMonthBody.html(calendar);	
}
function tmpShowSchedule() {
	console.log("tmpShowSchedule 실행");
	var t1 = $("#calType1").prop("checked");
	var t2 = $("#calType2").prop("checked");
	var t3 = $("#calType3").prop("checked");
	console.log(t1+" "+t2+" "+t3);
	$.ajax({ 
		url:"showAllCalendar",
		data: {"t1":t1, "t2":t2, "t3":t3},
		type:"get",
		dataType:"json",
		success: function(allCalendar) {
			for(var i in allCalendar) {
				var title = allCalendar[i].title;
				var p = $("<p style=\"margin-bottom: 1pt; margin-top: 1pt; background-color: "+randomColor()+"\">"+title+"</p>");			
				(function(ii) {
					var title = allCalendar[ii].title;
					var startDateStr = allCalendar[ii].startDate;
					var startDateYMD = startDateStr.substring(0, 10);
					var endDateStr = allCalendar[ii].endDate;
					var endDateYMD = endDateStr.substring(0, 10);
					var year = startDateStr.substring(0, 4);
					var month = startDateStr.substring(5, 7);
					var date = startDateStr.substring(8, 10);
					var dateNumber = year+month+date;
					$("#"+dateNumber).append(p);
					p.on("click", function() {
						$("#detailScheduleFormOfMonthCal").show("slow");
						$("#detailCNumOfMonthCal").val(allCalendar[ii].cNum);
						$("#modifyCNum").val(allCalendar[ii].cNum);
						$("#detailTitleOfMonthCal").val(title);
						$("#modifyTitle").val(title);
						$("#detailStartDateOfMonthCal").val(startDateYMD);
						$("#modifyStartDate").val(startDateYMD);
						$("#detailEndDateOfMonthCal").val(endDateYMD);
						$("#modifyEndDate").val(endDateYMD);
						$("#detailContentOfMonthCal").val(allCalendar[ii].content);
						$("#modifyContent").val(allCalendar[ii].content);
						$("#detailTypeOfMonthCal").val(allCalendar[ii].type);
						$("#modifyType").val(allCalendar[ii].type);
						
						var yearCalendarTmp = allCalendar[ii].yearCalendar;
						$("#detailYearCalendarOfMonthCal").prop("checked", change(yearCalendarTmp));
						$("#modifyYearCalendar").prop("checked", change(yearCalendarTmp));
						var annuallyTmp = allCalendar[ii].annually;
						$("#detailAnnuallyOfMonthCal").prop("checked", change(annuallyTmp));
						$("#modifyAnnually").prop("checked", change(annuallyTmp));
						var monthlyTmp = allCalendar[ii].monthly;
						$("#detailMonthlyOfMonthCal").prop("checked", change(monthlyTmp));
						$("#modifyMonthly").prop("checked", change(monthlyTmp));
					});	
				})(i)
			}
		}
	});
}
function moveToWantedCalendar(wantedYear, wantedMonth, wantedDate) {
	today = new Date(wantedYear, wantedMonth, wantedDate);
	thisMonthCalendar(today);
	tmpShowSchedule();
	console.log("moveToWantedCalendar 실행!!");
	$("#yearCalendar").hide();
	$("#monthCalendar").show();	
}
function preMonthOfMonthCal() {
	today = new Date(today.getFullYear(), today.getMonth()-1, today.getDate());
	thisMonthCalendar(today);
	tmpShowSchedule();
}
function nextMonthOfMonthCal() { 
	today = new Date(today.getFullYear(), today.getMonth()+1, today.getDate());
	thisMonthCalendar(today);
	tmpShowSchedule();
}
function preYearOfMonthCal() {
	today = new Date(today.getFullYear()-1, today.getMonth(), today.getDate());
	thisMonthCalendar(today);
	tmpShowSchedule();
}
function nextYearOfMonthCal() {
	today = new Date(today.getFullYear()+1, today.getMonth(), today.getDate());
	thisMonthCalendar(today);
	tmpShowSchedule();
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
</script>
</head>
<body>
	<button type="button" id="addScheduleButton">일정 추가</button>
	<label><input type="checkbox" name="calType" id="calType1" value="project" checked="checked">프로젝트</label>
	<label><input type="checkbox" name="calType" id="calType2" value="vacation" checked="checked">휴가</label>
	<label><input type="checkbox" name="calType" id="calType3" value="event" checked="checked">행사</label>
	<button id="changeYearCalToMonthCal">월간</button>
	<button id="changeMonthCalToYearCal">연간</button><br>
	<hr>
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
			<input type="hidden" name="mNum" id="mNum" value="1">
			<input type="hidden" name="wNum" id="wNum" value="1">
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
			<label><input type="checkbox" name="yearCalendar" id="1" value="yearCalendar">연간 달력 표시</label><br>
			<label><input type="checkbox" name="annually" id="2" value="annually">매년 반복</label>
			<label><input type="checkbox" name="monthly" id="3" value="monthly">매월 반복</label><br>
			<input type="button" id="addScheduleFormClose" value="닫기">
			<input type="submit" id="add" value="추가">
		</form>
		<!-- 일정 상세 모달 -->
		<form id="detailScheduleFormOfMonthCal" class="detailScheduleModalOfMonthCal">
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"> 
			<input type="hidden" name="cNum" id="detailCNumOfMonthCal">
			<input type="hidden" name="mNum" id="mNum" value="1">
			<input type="hidden" name="wNum" id="wNum" value="1">
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
	</div>	
</body>
</html>