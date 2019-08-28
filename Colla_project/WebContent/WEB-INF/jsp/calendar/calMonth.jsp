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
/* .yearCalendar{display: none;} */
/* .monthCalendar{display: none; width: 1000px; height: 1000px;} */
.addScheduleModal{display: none; width: 300px; height: 250px; top: 10%; left: 10%; position: absolute; background-color: #ffe8ea;}
.detailScheduleModalOfYearCal{display: none; width: 300px; height: 250px; top: 10%; left: 10%; position: absolute; background-color: #ffd9dc;}
.modifyScheduleModal{display: none; width: 300px; height: 250px; top: 10%; left: 10%; position: absolute; background-color: #ffe8ea;}
.detailScheduleModalOfMonthCal{display: none; width: 300px; height: 250px; top: 10%; left: 10%; position: absolute; background-color: #ffd9dc;}
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

//----------------------------------------------------------------------------

	var today = new Date();
	var date = new Date();
	$(function() {
		thisMonthCalendar(today);
		tmpShowSchedule();
		//추가
		$("#addScheduleButton").on("click", function() {
			$("#addScheduleForm").show("slow");
		});
		$("#addScheduleFormClose").on("click", function() {
			$("#addScheduleForm").hide("slow");
		});
		//수정
		$("#modifyScheduleButton").on("click", function() {
			$("#detailScheduleFormOfMonthCal").show("slow");
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
		})
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
		})
		//상세모달 닫기
		$("#detailScheduleFormOfMonthCalClose").on("click", function() {
			$("#detailScheduleFormOfMonthCal").hide("slow");
			$("#addScheduleForm").hide("slow");
		});
		//수정모달 닫기
		$("#modifyScheduleFormClose").on("click", function() {
			$("#modifyScheduleForm").hide("slow");
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
		var firstDay = new Date(today.getFullYear(), today.getMonth(), 1);
		var lastDay = new Date(today.getFullYear(), today.getMonth()+1, 0);
		var calMonthTitle = $("#calMonthTitle");
		calMonthTitle.html(today.getFullYear()+"년 "+(today.getMonth()+1)+"월");
		var month = today.getMonth()+1;
		if((today.getMonth()+1)<10) {
			var month = "0"+(today.getMonth()+1);
		}
		var calendar = "<table border = '1'>";
		calendar += "<tr>";
		calendar += "<th width=\"150\">일</th>";
		calendar += "<th width=\"150\">월</th>";
		calendar += "<th width=\"150\">화</th>";
		calendar += "<th width=\"150\">수</th>";
		calendar += "<th width=\"150\">목</th>";
		calendar += "<th width=\"150\">금</th>";
		calendar += "<th width=\"150\">토</th>";
		calendar += "</tr>";
		var firstDayOfWeek = firstDay.getDay();
		var lastDayDate = lastDay.getDate();
		var numOfWeekRow = Math.ceil((lastDayDate+firstDayOfWeek)/7);
		var dateCount = 1;
		for(var i=0; i<numOfWeekRow; i++) {
			calendar += "<tr>";
			for(var j=0; j<7; j++) {
				if(j<firstDayOfWeek && i==0 || dateCount>lastDayDate) {
					calendar += "<td>&nbsp;</td>";
				} else {
					if(dateCount<10) {
						calendar += "<td id="+today.getFullYear()+month+"0"+dateCount+">"+dateCount+"</td>";
					} else {
						calendar += "<td id="+today.getFullYear()+month+dateCount+">"+dateCount+"</td>";
					}
					dateCount++;
				}
			}
			calendar += "</tr>";
		};
		calendar += "</table>";
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
					var btn = $("<button>"+title+"</button>");			
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
						$("#"+dateNumber).append(btn);
						btn.on("click", function() {
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

//----연간 달력------------------------------------------------------------------------------------------------


	$(function() {
		thisYearCalendar();
		showYearSchedule();
		//상세 닫기
		$("#detailScheduleFormOfYearCalClose").on("click", function() {
			$("#detailScheduleFormOfYearCal").hide("slow");
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

	function preYearOfYearCal() {
		today = new Date(today.getFullYear(), today.getMonth()-12);
		thisYearCalendar();
		showYearSchedule();
	}
	function nextYearOfYearCal() {
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
		calendar += "<th width=\"150\" id="+year+"01"+"><a onclick=\"moveToWantedCalendar("+year+", 0, 1)\">1월</a></th>";
		calendar += "<th width=\"150\" id="+year+"02"+"><a onclick=\"moveToWantedCalendar("+year+", 1, 1)\">2월</th>";
		calendar += "<th width=\"150\" id="+year+"03"+"><a onclick=\"moveToWantedCalendar("+year+", 2, 1)\">3월</th>";
		calendar += "<th width=\"150\" id="+year+"04"+"><a onclick=\"moveToWantedCalendar("+year+", 3, 1)\">4월</th>";
		calendar += "</tr>";
		calendar += "<tr>";
		calendar += "<th id="+year+"05"+"><a onclick=\"moveToWantedCalendar("+year+", 4, 1)\">5월</th>";
		calendar += "<th id="+year+"06"+"><a onclick=\"moveToWantedCalendar("+year+", 5, 1)\">6월</th>";
		calendar += "<th id="+year+"07"+"><a onclick=\"moveToWantedCalendar("+year+", 6, 1)\">7월</th>";
		calendar += "<th id="+year+"08"+"><a onclick=\"moveToWantedCalendar("+year+", 7, 1)\">8월</th>";
		calendar += "</tr>";
		calendar += "<tr>";
		calendar += "<th id="+year+"09"+"><a onclick=\"moveToWantedCalendar("+year+", 8, 1)\">9월</th>";
		calendar += "<th id="+year+"10"+"><a onclick=\"moveToWantedCalendar("+year+", 9, 1)\">10월</th>";
		calendar += "<th id="+year+"11"+"><a onclick=\"moveToWantedCalendar("+year+", 10, 1)\">11월</th>";
		calendar += "<th id="+year+"12"+"><a onclick=\"moveToWantedCalendar("+year+", 11, 1)\">12월</th>";
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
							$("#detailScheduleFormOfYearCal").show("slow");
							$("#detailCNumOfYearCal").val(allYearSchedule[ii].cNum);
							$("#detailTitleOfYearCal").val(title);
							$("#detailStartDateOfYearCal").val(startDateYMD);
							$("#detailEndDateOfYearCal").val(endDateYMD);
							$("#detailContentOfYearCal").val(allYearSchedule[ii].content);
							$("#detailTypeOfYearCal").val(allYearSchedule[ii].type);
							
							var yearCalendarTmp = allYearSchedule[ii].yearCalendar;						
							$("#detailYearCalendarOfYearCal").prop("checked", change(yearCalendarTmp));
							var annuallyTmp = allYearSchedule[ii].annually;
							$("#detailAnnuallyOfYearCal").prop("checked", change(annuallyTmp));
							var monthlyTmp = allYearSchedule[ii].monthly;
							$("#detailMonthlyOfYearCal").prop("checked", change(monthlyTmp));
							
						})
					})(i)
				}
			}
		});
	}	

</script>
</head>
<body>
<!-- 공통 부분 -->
<%-- <%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%> --%>
<%-- <%@ include file="/WEB-INF/jsp/inc/navWs.jsp"%> --%>
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
	<h1 id="calMonthTitle"></h1>
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
	<!-- 일정 수정 모달 -->
	<form id="modifyScheduleForm" class="modifyScheduleModal">
 		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
 		<input type="hidden" name="cNum" id="modifyCNum">
		<input type="hidden" name="mNum" id="mNum" value="1">
		<input type="hidden" name="wNum" id="wNum" value="1">
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
	<h1 id="calYearTitle"></h1>
	<button onclick="nextYearOfYearCal()">내년</button>
	<div id="calYearBody"></div>
	<!-- 일정 상세 모달 --> 
	<form id="detailScheduleFormOfYearCal" class="detailScheduleModalOfYearCal">
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
		<input type="hidden" name="cNum" id="detailCNumOfYearCal">
		<input type="hidden" name="mNum" id="mNum" value="1">
		<input type="hidden" name="wNum" id="wNum" value="1">
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
