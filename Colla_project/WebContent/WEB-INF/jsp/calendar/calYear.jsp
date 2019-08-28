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
<title>calYear</title>
<style type="text/css">
.detailScheduleModal{display: none; width: 300px; height: 250px; top: 10%; left: 10%; position: absolute; background-color: #ffd9dc;}
</style>
<script src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous"></script>
<script>
$(function() {
	thisYearCalendar();
	showYearSchedule();
	$("#detailScheduleFormClose").on("click", function() {
		$("#detailScheduleForm").hide("slow");
	});
	
	//타입 변경
	$("#calType1").on("change", function() {
		thisYearCalendar();
		showYearSchedule();
	});
	$("#calType2").on("change", function() {
		thisYearCalendar();
		showYearSchedule();
	});
	$("#calType3").on("change", function() {
		thisYearCalendar();
		showYearSchedule();
	});
});

var today = new Date();

function preYearCalendar() {
	today = new Date(today.getFullYear(), today.getMonth()-12);
	thisYearCalendar();
	showYearSchedule();
}
function nextYearCalendar() {
	today = new Date(today.getFullYear(), today.getMonth()+12);
	thisYearCalendar();
	showYearSchedule();
}
function thisYearCalendar() {
	
	var year = today.getFullYear();
	var calYearTitle = $("#calYearTitle");
	calYearTitle.html(year+"년 ");
	'${contextPath}/calMonth'
	var calendar = "<table border = '1'>";
	calendar += "<tr>";
	calendar += "<th width=\"150\" id="+year+"01"+"><a href=\"${contextPath}/calMonth?year=2019&month=1\">1월</a></th>";
	calendar += "<th width=\"150\" id="+year+"02"+">2월</th>";
	calendar += "<th width=\"150\" id="+year+"03"+">3월</th>";
	calendar += "<th width=\"150\" id="+year+"04"+">4월</th>";
	calendar += "</tr>";
	calendar += "<tr>";
	calendar += "<th id="+year+"05"+">5월</th>";
	calendar += "<th id="+year+"06"+">6월</th>";
	calendar += "<th id="+year+"07"+">7월</th>";
	calendar += "<th id="+year+"08"+">8월</th>";
	calendar += "</tr>";
	calendar += "<tr>";
	calendar += "<th id="+year+"09"+">9월</th>";
	calendar += "<th id="+year+"10"+">10월</th>";
	calendar += "<th id="+year+"11"+">11월</th>";
	calendar += "<th id="+year+"12"+">12월</th>";
	calendar += "</tr>";
	
	var calYearBody = $("#calYearBody");
	calYearBody.html(calendar);
}

function showYearSchedule() {
	var t1 = $("#calType1").prop("checked");
	var t2 = $("#calType2").prop("checked");
	var t3 = $("#calType3").prop("checked");
	console.log(t1+" "+t2+" "+t3);
	$.ajax({
		url:"showYearCheckedCalendar",
		data: {"t1":t1, "t2":t2, "t3":t3},
		type:"get",
		dataType:"json",
		success: function(allYearSchedule) {	
			for(var i in allYearSchedule) {
				var title = allYearSchedule[i].title;
				var btn = $("<button>"+title+"</button>");
				(function(ii) {
					var title = allYearSchedule[ii].title; 
					var startDateStr = allYearSchedule[ii].startDate;
					var startDateYMD = startDateStr.substring(0, 10);
					var endDateStr = allYearSchedule[ii].endDate;
					var endDateYMD = endDateStr.substring(0, 10);
					var year = startDateStr.substring(0, 4);
					var month = startDateStr.substring(5, 7);
					var dateNumber = year+month;
					$("#"+dateNumber).append(btn);
					btn.on("click", function() {
						$("#detailScheduleForm").show("slow");
						$("#detailCNum").val(allYearSchedule[ii].cNum);
						$("#detailTitle").val(title);
						$("#detailStartDate").val(startDateYMD);
						$("#detailEndDate").val(endDateYMD);
						$("#detailContent").val(allYearSchedule[ii].content);
					})
				})(i)
			}
		}
	});
}

</script>
</head>
<body>
<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%>
<%@ include file="/WEB-INF/jsp/inc/navWs.jsp"%>
	<form action="calSearchList">
		<input type="text" name="calSearch" placeholder="검색어를 입력해주세요.">
		<input type="submit" value="검색">
	</form>
	<label><input type="checkbox" name="calType" id="calType1" value="project" checked="checked">프로젝트</label>
	<label><input type="checkbox" name="calType" id="calType2" value="vacation" checked="checked">휴가</label>
	<label><input type="checkbox" name="calType" id="calType3" value="event" checked="checked">행사</label>
	<button onclick="location.href='${contextPath}/calMonth'">월간</button>
	<button onclick="location.href='${contextPath}/calYear'">연간</button><br>

	<button onclick="preYearCalendar()">작년</button>
	<h1 id="calYearTitle"></h1>
	<button onclick="nextYearCalendar()">내년</button>
	<div id="calYearBody"></div>
	
	<!-- 일정 상세 모달 -->
	<form id="detailScheduleForm" class="detailScheduleModal">
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
		<input type="text" name="cNum" id="detailCNum">
		<input type="hidden" name="mNum" id="mNum" value="1">
		<input type="hidden" name="wNum" id="wNum" value="1">
		제목<input type="text" name="title" id="detailTitle" readonly="readonly"><br>
		기간
		(시작날짜)<input type="date" name="startDate" id="detailStartDate" readonly="readonly"><br>
 		(시작날짜)<input type="date" name="endDate" id="detailEndDate" readonly="readonly"><br>	
		상세<textarea rows="5" cols="21" name="content" id="detailContent" readonly="readonly"></textarea><br>
		타입<select name="type" id="detailType">
			<option value="project">프로젝트</option>
			<option value="vacation">휴가</option>
			<option value="event">행사</option>
			</select><br>
		<label><input type="checkbox" name="yearCalendar" value="yearCalendar">연간 달력 표시</label><br>
		<label><input type="checkbox" name="annually" value="annually">매년 반복</label>
		<label><input type="checkbox" name="monthly" value="monthly">매월 반복</label><br>
		<input type="button" id="detailScheduleFormClose" value="닫기">
	</form>
</body>
</html>