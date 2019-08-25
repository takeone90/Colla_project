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
<title>calMonth</title>
<style type="text/css">
.addScheduleModal{display: none; border: 1px solid black; width: 300px; height: 250px; top: 10%; left: 10%; position: absolute; background-color: skyblue;}
</style>
<script src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous"></script>
<script type="text/javascript">
$(function() {
	thisMonthCalendar();
	
	$("#addScheduleButton").on("click", function() {
		$("#addScheduleForm").show("slow");
	});
	$("#close").on("click", function() {
		$("#addScheduleForm").hide("slow");
	});
	
	$("#addScheduleForm").on("submit", function(e) {
		e.preventDefault();
		var data = $(this).serialize();
// 		var mNum = $("").val();
// 		var yearCalendarInt = checkBoxYear();
// 		var annuallyInt = checkBoxAnnually();
// 		var monthlyInt = checkBoxMonthly();
// 		console.log(yearCalendarInt+" "+annuallyInt+" "+monthlyInt+" "+data);
		$.ajax({
			url: "addSchedule",
			data: data,
			type: "get",
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
});

function checkBoxYear() {
	var result = $("#1").is(":checked");
	alert(result);
	if(result) {
		return 1;
	} else {
		return 0;
	}
}
function checkBoxAnnually() {
	var result = $("#2").is(":checked");
	alert(result);
	if(result) {
		return 1;
	} else {
		return 0;
	}
}
function checkBoxMonthly() {
	var result = $("#3").is(":checked");
	alert(result);
	if(result) {
		return 1;
	} else {
		return 0;
	}
}

var today = new Date();
var date = new Date();
function preMonthCalendar() {
	today = new Date(today.getFullYear(), today.getMonth()-1, today.getDate());
	thisMonthCalendar();
}
function nextMonthCalendar() {
	today = new Date(today.getFullYear(), today.getMonth()+1, today.getDate());
	thisMonthCalendar();
}
function preYearCalendar() {
	today = new Date(today.getFullYear()-1, today.getMonth(), today.getDate());
	thisMonthCalendar();
}
function nextYearCalendar() {
	today = new Date(today.getFullYear()+1, today.getMonth(), today.getDate());
	thisMonthCalendar();
}
function thisMonthCalendar() {
	var firstDay = new Date(today.getFullYear(), today.getMonth(), 1);
	var lastDay = new Date(today.getFullYear(), today.getMonth()+1, 0);
	var calMonthTitle = $("#calMonthTitle");
	calMonthTitle.html(today.getFullYear()+"년 "+(today.getMonth()+1)+"월");
	var firstDayOfWeek = firstDay.getDay();
	var lastDayDate = lastDay.getDate();
	var numOfWeekRow = Math.ceil((lastDayDate+firstDayOfWeek)/7);
	var calendar = "<table border = '1'>";
	calendar += "<tr>";
	calendar += "<th>일</th>";
	calendar += "<th>월</th>";
	calendar += "<th>화</th>";
	calendar += "<th>수</th>";
	calendar += "<th>목</th>";
	calendar += "<th>금</th>";
	calendar += "<th>토</th>";
	calendar += "</tr>";
	var date = 1;
	for(var i=0; i<numOfWeekRow; i++) {
		calendar += "<tr>";
		for(var j=0; j<7; j++) {
			if(j<firstDayOfWeek && i==0 || date>lastDayDate) {
				calendar += "<td>&nbsp;</td>";
			} else {
				calendar += "<td>"+date+"</td>";
				date++;
			}
		}
		calendar += "</tr>";
	};
	calendar += "</table>";
	var calMonthBody = $("#calMonthBody");
	calMonthBody.html(calendar);	
}
</script>
</head>
<body>
	<form action="calSearchList">
		<input type="text" name="calSearch" placeholder="검색어를 입력해주세요.">
		<input type="submit" value="검색">
	</form>
	<button type="button" id="addScheduleButton" data-toggle="modal" data-target="#addScheduleForm">일정 추가</button>
	<label><input type="checkbox" name="calType" id="calType" value="project">프로젝트</label>
	<label><input type="checkbox" name="calType" id="calType" value="vacation">휴가</label>
	<label><input type="checkbox" name="calType" id="calType" value="event">행사</label>
	<button onclick="location.href='${contextPath}/calMonth'">월간</button>
	<button onclick="location.href='${contextPath}/calYear'">연간</button><br>
	
	<button onclick="preYearCalendar()">작년</button>
	<button onclick="preMonthCalendar()">이전 달</button>
	<h1 id="calMonthTitle"></h1>
	<button onclick="nextMonthCalendar()">다음 달</button>
	<button onclick="nextYearCalendar()">내년</button>
	<div id="calMonthBody"></div>
		<form id="addScheduleForm" class="addScheduleModal">
			<input type="hidden" name="mNum" id="mNum" value="1">
			<input type="hidden" name="wNum" id="wNum" value="1">
			제목<input type="text" name="title" id="title"><br>
			기간
			(시작날짜)<input type="date" name="startDate" id="startDate"><br>
			(시작날짜)<input type="date" name="endDate" id="endDate"><br>
			상세<textarea rows="5" cols="21" name="content" id="content"></textarea><br>
			타입<select name="type" id="">
				<option value="project">프로젝트</option>
				<option value="vacation">휴가</option>
				<option value="event">행사</option>
				</select><br>
			<label><input type="checkbox" name="yearCalendar" id="1">연간 달력 표시</label><br>
			<label><input type="checkbox" name="annually" id="2">매년 반복</label>
			<label><input type="checkbox" name="monthly" id="3">매월 반복</label><br>
			<input type="button" id="close" value="닫기">
			<input type="submit" id="add" value="추가">
		</form>
</body>
</html>
